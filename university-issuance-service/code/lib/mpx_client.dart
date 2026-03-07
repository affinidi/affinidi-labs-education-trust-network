import 'dart:async';
import 'dart:io';
import 'package:affinidi_tdk_didcomm_mediator_client/affinidi_tdk_didcomm_mediator_client.dart';
import 'package:affinidi_tdk_vdip/affinidi_tdk_vdip.dart';
import 'package:meeting_place_core/meeting_place_core.dart';
import 'package:ssi/ssi.dart';
// ignore: implementation_imports
// import 'package:ssi/src/credentials/models/field_types/context.dart';
import 'package:uuid/uuid.dart';
import 'package:university_issuance_service/messages/credential_prepare_request.dart';
import 'package:university_issuance_service/messages/problem_data.dart';
import 'env.dart';
import 'repository/channel_repository_impl.dart';
import 'repository/connection_offer_repository_impl.dart';
import 'repository/key_repository_impl.dart';
import 'helper.dart';
import 'storage/storage_factory.dart';
import 'package:http/http.dart' as http;

class MpxClient {
  static String get _dirPath {
    // Use UNIVERSITY_DOMAIN to create unique data directory for each issuer
    final universityDomain = Env.get('UNIVERSITY_DOMAIN', '');
    if (universityDomain.isNotEmpty) {
      // Convert domain like "localhost:3000/hongkong-university" to "hongkong-university"
      final parts = universityDomain.split('/');
      final issuerName = parts.length > 1
          ? parts.last
          : parts.first.replaceAll(':', '_');
      return Env.get('DATA_DIR', 'data/issuer-$issuerName');
    }
    return Env.get('DATA_DIR', 'data/issuer');
  }

  static String get _keyStorePath => '$_dirPath/key-store.json';
  static MpxClient? _instance;
  final MeetingPlaceCoreSDK mpxSDK;

  final String permanentDid;
  static late VdipIssuer issuerClient;
  static late MeetingPlaceCoreSDK sdk;
  static late RepositoryConfig repositoryConfig;

  // Private constructor
  MpxClient._(this.mpxSDK, this.permanentDid);

  /// Test if a did:web DID is accessible by attempting to fetch its DID document
  static Future<void> _testDidAccessibility(String did) async {
    if (!did.startsWith('did:web:')) {
      print('[testDidAccessibility] Skipping test for non-did:web DID: $did');
      return;
    }

    try {
      // Convert did:web to HTTPS URL
      // did:web:example.com -> https://example.com/.well-known/did.json
      // did:web:example.com:path -> https://example.com/path/did.json
      // did:web:example.com:.well-known -> https://example.com/.well-known/did.json

      final didParts = did.substring('did:web:'.length).split(':');
      final domain = Uri.decodeComponent(didParts[0].replaceAll('%3A', ':'));
      final path = didParts.length > 1
          ? didParts.sublist(1).join('/')
          : '.well-known';
      final url = 'https://$domain/$path/did.json';

      print('[testDidAccessibility] Testing DID: $did');
      print('[testDidAccessibility] Fetching: $url');

      final response = await http
          .get(Uri.parse(url))
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw TimeoutException('Request timed out after 10 seconds');
            },
          );

      if (response.statusCode == 200) {
        print(
          '[testDidAccessibility] ✅ DID document accessible (HTTP ${response.statusCode})',
        );
        print(
          '[testDidAccessibility] Response length: ${response.body.length} bytes',
        );
      } else {
        print(
          '[testDidAccessibility] ⚠️  DID document returned HTTP ${response.statusCode}',
        );
        print(
          '[testDidAccessibility] Response: ${response.body.substring(0, response.body.length > 200 ? 200 : response.body.length)}',
        );
      }
    } catch (e) {
      print('[testDidAccessibility] ❌ Failed to fetch DID document for $did');
      print('[testDidAccessibility] Error: $e');
      print('[testDidAccessibility] This may cause DID resolution to fail');
    }
  }

  static Future<MpxClient> init() async {
    try {
      if (_instance != null) {
        print('MpxClient already initialized');
        return _instance!;
      }

      // Test DID accessibility before initialization
      print('');
      print('========================================');
      print('Testing DID accessibility...');
      print('========================================');
      await _testDidAccessibility(Env.get('SERVICE_DID'));
      await _testDidAccessibility(Env.get('MEDIATOR_DID'));
      print('========================================');
      print('');

      print('Initializing MpxSDK...');
      sdk = await _initSdk();

      final storage = await StorageFactory.createStorage(
        '$_dirPath/issuer-data.json',
      );

      // Generate issuer DID:web (university)
      print('');
      print('========================================');
      print('Generating Issuer (University) DID:web');
      print('========================================');
      await generateDIDWebForEntity(storage, entity: 'issuer');
      print('========================================');
      print('');

      DidManager didManager;
      var permanentDid = await storage.get("issuer_permanent_did");
      if (permanentDid == null) {
        print('Generating new permanent channel DID for issuer');
        didManager = await sdk.generateDid();
        final didDoc = await didManager.getDidDocument();
        permanentDid = didDoc.id;
        await storage.put("issuer_permanent_did", permanentDid);
      } else {
        print('Using existing permanent channel DID for issuer');
        didManager = await getDidManagerForDid(permanentDid);
      }
      print('Permanent DID: $permanentDid');

      print('Creating VDIP Client');
      issuerClient = await createVDIPClient(didManager);

      await subscribeForVDIPRequests();

      _instance = MpxClient._(sdk, permanentDid);
      print('MpxClient ready with permanent DID: $permanentDid');
      return _instance!;
    } catch (e, stackTrace) {
      print('FATAL ERROR: Failed to initialize MpxClient: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  static MpxClient get instance {
    if (_instance == null) {
      throw StateError(
        'MpxClient not initialized. Call MpxClient.init() first.',
      );
    }
    return _instance!;
  }

  // ---------------- INTERNAL METHODS ----------------

  static Future<MeetingPlaceCoreSDK> _initSdk() async {
    final dir = Directory(_dirPath);
    if (!await dir.exists()) await dir.create(recursive: true);

    final keyStore = await StorageFactory.createKeyStore(_keyStorePath);
    final keyRepStorage = await StorageFactory.createStorage(
      '$_dirPath/keys-storage.json',
    );
    final channelRepoStorage = await StorageFactory.createStorage(
      '$_dirPath/channels.json',
    );
    final connectionRepoStorage = await StorageFactory.createStorage(
      '$_dirPath/connections.json',
    );

    final wallet = PersistentWallet(keyStore);

    final serviceDid = Env.get('SERVICE_DID');
    final mediatorDid = Env.get('MEDIATOR_DID');

    print('[_initSdk] ========================================');
    print('[_initSdk] SERVICE_DID: $serviceDid');
    print('[_initSdk] MEDIATOR_DID: $mediatorDid');
    print('[_initSdk] ========================================');

    repositoryConfig = RepositoryConfig(
      connectionOfferRepository: ConnectionOfferRepositoryImpl(
        storage: connectionRepoStorage,
      ),
      channelRepository: ChannelRepositoryImpl(storage: channelRepoStorage),
      keyRepository: KeyRepositoryImpl(storage: keyRepStorage),
    );

    print('[_initSdk] Creating MeetingPlaceCoreSDK...');
    print('[_initSdk] This will resolve SERVICE_DID and MEDIATOR_DID');

    try {
      final sdk = await MeetingPlaceCoreSDK.create(
        wallet: wallet,
        repositoryConfig: repositoryConfig,
        controlPlaneDid: serviceDid,
        mediatorDid: mediatorDid,
      );
      print('[_initSdk] ✅ MeetingPlaceCoreSDK created successfully');
      return sdk;
    } catch (e, stackTrace) {
      print('[_initSdk] ❌ ERROR creating MeetingPlaceCoreSDK: $e');
      print('[_initSdk] SERVICE_DID that failed: $serviceDid');
      print('[_initSdk] MEDIATOR_DID that failed: $mediatorDid');
      print('[_initSdk] Stack trace: $stackTrace');
      rethrow;
    }
  }

  static Future<DidManager> getDidManagerForDid(String did) async {
    final wallet = sdk.wallet;
    final keyId = await repositoryConfig.keyRepository.getKeyIdByDid(did: did);
    if (keyId == null) {
      throw Exception('KeyPair not found for DID: $did');
    }
    await wallet.generateKey(keyId: keyId);
    final didManager = DidKeyManager(store: InMemoryDidStore(), wallet: wallet);
    await didManager.addVerificationMethod(keyId);
    return didManager;
  }

  static Future<DidDocument> getMediatorDidDocument() async {
    final mediatorDid = Env.get(
      'MEDIATOR_DID',
      'did:web:apse1.mediator.affinidi.io:.well-known',
    );
    print('[getMediatorDidDocument] Resolving MEDIATOR_DID: $mediatorDid');

    try {
      final mediatorDidDocument = await UniversalDIDResolver.defaultResolver
          .resolveDid(mediatorDid);
      print('[getMediatorDidDocument] ✅ Successfully resolved mediator DID');
      print('[getMediatorDidDocument] Document ID: ${mediatorDidDocument.id}');
      return mediatorDidDocument;
    } catch (e, stackTrace) {
      print('[getMediatorDidDocument] ❌ ERROR resolving mediator DID: $e');
      print('[getMediatorDidDocument] Failed DID: $mediatorDid');
      print('[getMediatorDidDocument] Stack trace: $stackTrace');
      rethrow;
    }
  }

  static Future<VdipIssuer> createVDIPClient(DidManager manager) async {
    final mediatorDidDocument = await getMediatorDidDocument();
    final issuerClient = await VdipIssuer.init(
      mediatorDidDocument: mediatorDidDocument,
      didManager: manager,
      featureDisclosures: FeatureDiscoveryHelper.vdipIssuerDisclosures,
      clientOptions: const AffinidiClientOptions(),
      authorizationProvider: await AffinidiAuthorizationProvider.init(
        mediatorDidDocument: mediatorDidDocument,
        didManager: manager,
      ),
    );

    return issuerClient;
  }

  static Future<void> subscribeForVDIPRequests() async {
    print('Subscribing for VDIP Requests');

    issuerClient.listenForIncomingMessages(
      onFeatureQuery: (message) async {
        prettyPrint('Issuer received Feature Query Message', object: message);
      },
      onRequestToIssueCredential:
          ({
            required message,
            holderDidFromAssertion,
            assertionValidationResult,
            challenge,
          }) async {
            try {
              prettyPrint(
                'Issuer received Request to Issue Credential Message',
                //object: message,
              );

              if (assertionValidationResult?.isValid != true) {
                await _sendProblemReport(
                  sdk,
                  message,
                  ProblemData(
                    code: "invalid-assertion",
                    description: "Holder assertion is invalid",
                  ),
                );
                return;
              }

              if (message.from == null) {
                throw ArgumentError.notNull('from');
              }
              final channel = await sdk.getChannelByOtherPartyPermanentDid(
                message.from!,
              );
              if (channel == null) {
                print('Unkown holder, No channel found for ${message.from}');
                await _sendProblemReport(
                  sdk,
                  message,
                  ProblemData(
                    code: "Unknown-holder",
                    description: "No channel found for ${message.from}",
                  ),
                );
                return;
              }

              //Preparing VC Data based on the proposal
              final holderDid = holderDidFromAssertion ?? message.from!;

              //Adding holder DID to credential subject
              print('[VDIP] Holder DID: $holderDid');

              //Issuing VC
              final issuedCredential = await _createVC(holderDid);

              //Sending VC
              await issuerClient.sendIssuedCredentials(
                holderDid: message.from!,
                verifiableCredential: issuedCredential,
              );
            } catch (e, stackTrace) {
              print('Error onRequestToIssueCredential: $e');
              print('Stack trace: $stackTrace');
              await _sendProblemReport(
                sdk,
                message,
                ProblemData(
                  code: "Exception on Issuing VC",
                  description: e.toString(),
                ),
              );
            }
          },
      onProblemReport: (msg) async {
        prettyPrint('A problem has occurred', object: msg);
      },
    );

    await ConnectionPool.instance.startConnections();
  }

  static Future<CredentialPrepareRequest> getEmailVCRequest(
    PlainTextMessage message,
    VdipRequestIssuanceMessageBody vdipRequestBody,
  ) async {
    final credentialSubject = vdipRequestBody.credentialMeta?.data;
    if (credentialSubject == null) {
      throw ArgumentError.notNull('body.credentialMeta.data');
    }
    if (credentialSubject['email'] == null) {
      throw ArgumentError.notNull('body.credentialMeta.data.email');
    }

    return CredentialPrepareRequest(
      credentialTypeId: 'Email',
      jsonSchemaUrl: 'https://schema.affinidi.io/TEmailV1R0.json',
      jsonLdContextUrl: 'https://schema.affinidi.io/TEmailV1R0.jsonld',
      credentialData: credentialSubject,
    );
  }

  static Future<VerifiableCredential> _createVC(String holderDid) async {
    final issuerSigner = await getDidWebSignerFor('issuer');
    final educationMinistryDid = Env.get('EDUCATION_ECOSYSTEM_ID');
    if (educationMinistryDid.isEmpty) {
      throw Exception("EDUCATION_ECOSYSTEM_ID is missing in .env file");
    }
    final universityName = Env.get('UNIVERSITY_NAME', 'University');
    final programName = Env.get('PROGRAM_NAME', 'Bachelor of Science');
    final studentFirstName = Env.get('STUDENT_FIRST_NAME', 'Sample');
    final studentLastName = Env.get('STUDENT_LAST_NAME', 'Student');
    final studentEmail = Env.get('STUDENT_EMAIL', 'student@example.com');

    // Determine accreditor name based on education ministry DID
    String accreditedBy;
    if (educationMinistryDid.contains('hongkong')) {
      accreditedBy = 'Hong Kong Education Ministry';
    } else if (educationMinistryDid.contains('macau')) {
      accreditedBy = 'Macau Education Ministry';
    } else if (educationMinistryDid.contains('singapore')) {
      accreditedBy = 'Singapore Education Ministry';
    } else {
      accreditedBy = 'Education Ministry';
    }

    final unsignedCredential = VcDataModelV2(
      context: [
        dmV2ContextUrl,
        'https://schema.affinidi.io/AnyTCertizenPOCEdCertV1R0V1R0.jsonld',
      ],
      credentialSchema: [
        CredentialSchema(
          id: Uri.parse(
            'https://schema.affinidi.io/AnyTCertizenPOCEdCertV1R0V1R0.json',
          ),
          type: 'JsonSchemaValidator2018',
        ),
      ],
      id: Uri.parse('claimId:${Uuid().v4()}'),
      issuer: Issuer.uri(issuerSigner.did),
      type: {'VerifiableCredential', 'EducationCredential'},
      validFrom: DateTime.now().toUtc(),
      validUntil: DateTime.now().toUtc().add(const Duration(days: 364)),
      credentialSubject: [
        CredentialSubject.fromJson({
          'id': holderDid,
          'student': {
            'givenName': studentFirstName,
            'familyName': studentLastName,
            'email': studentEmail,
          },
          'institute': {
            'legalName': universityName,
            'accreditedBy': accreditedBy,
          },
          'accreditation': {'ecosystemId': educationMinistryDid},
          'programNCourse': {'program': programName},
        }),
      ],
    );
    try {
      final suite = LdVcDm2Suite();
      final issuedCredential = await suite.issue(
        unsignedData: unsignedCredential,
        proofGenerator: Secp256k1Signature2019Generator(signer: issuerSigner),
      );

      print(
        '[_createVC] ✅ Credential Issued Successfully, id:${issuedCredential.id.toString()}',
      );
      print('[_createVC] ========================================');
      return issuedCredential;
    } catch (e, stackTrace) {
      print('[_createVC] ❌ Error during credential signing:');
      print('[_createVC] Error: $e');
      print('[_createVC] Stack trace: $stackTrace');
      print('[_createVC] ========================================');
      rethrow;
    }
  }

  static Future<void> _sendProblemReport(
    MeetingPlaceCoreSDK sdk,
    PlainTextMessage message,
    ProblemData problem,
  ) async {
    final problemMessage = ProblemReportMessage(
      id: const Uuid().v4(),
      to: [message.from!],
      parentThreadId: message.threadId ?? message.id,
      body: ProblemReportBody(
        comment: '${problem.code}: ${problem.description}',
        code: ProblemCode(
          sorter: SorterType.warning,
          scope: Scope(scope: ScopeType.message),
          descriptors: ['vdip', problem.code],
        ),
      ),
    );

    await issuerClient.mediatorClient.packAndSendMessage(problemMessage);
  }

  // ---------------- END OF INTERNAL METHODS ----------------

  /// Public method for OOB invite creation

  Future<String> createOobInvite() async {
    print('[createOobInvite] ========================================');
    print('[createOobInvite] Starting OOB invite creation');
    print('[createOobInvite] Permanent DID: $permanentDid');
    print('[createOobInvite] ========================================');

    final contactCard = ContactCard(
      did: permanentDid,
      type: 'individual',
      contactInfo: {"firstName": "Credulon Bank", "lastName": "Issuer"},
    );

    print('[createOobInvite] Calling mpxSDK.createOobFlow...');

    try {
      final result = await mpxSDK.createOobFlow(
        did: permanentDid,
        contactCard: contactCard,
      );
      print('[createOobInvite] ✅ OOB flow created successfully');
      print('[createOobInvite] OOB URL: ${result.oobUrl}');

      final completer = Completer<void>();
      result.streamSubscription.listen(
        (data) {
          try {
            print('OOB onDone channel id: ${data.channel.id}');
            print('Holder DID: ${data.channel.otherPartyPermanentChannelDid}');
            if (!completer.isCompleted) {
              completer.complete();
            }
          } catch (e, stackTrace) {
            print('ERROR: Exception in OOB stream listener: $e');
            print('Stack trace: $stackTrace');
            if (!completer.isCompleted) {
              completer.completeError(e, stackTrace);
            }
          }
        },
        onError: (error, stackTrace) {
          print('ERROR: OOB stream error: $error');
          print('Stack trace: $stackTrace');
          if (!completer.isCompleted) {
            completer.completeError(error, stackTrace);
          }
        },
        onDone: () {
          print('OOB stream completed');
          if (!completer.isCompleted) {
            completer.complete();
          }
        },
      );

      // result.streamSubscription.timeout(const Duration(seconds: 60), () {
      //   print('OOB flow timed out.');
      //   completer.complete();
      // });

      completer.future.then((value) async {
        //Closing as its only 1 time use
        print('Closing the createOobFlow mediator');
        await result.streamSubscription.dispose();
      });

      print('[createOobInvite] Final OOB URL: ${result.oobUrl}');
      return result.oobUrl.toString();
    } catch (e, stackTrace) {
      print('[createOobInvite] ❌ ERROR creating OOB flow: $e');
      print('[createOobInvite] Permanent DID: $permanentDid');
      print('[createOobInvite] Stack trace: $stackTrace');
      rethrow;
    }
  }
}
