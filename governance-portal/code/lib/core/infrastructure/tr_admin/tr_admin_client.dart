import 'dart:async';

import 'package:affinidi_tdk_didcomm_mediator_client/affinidi_tdk_didcomm_mediator_client.dart';
import 'package:logger/logger.dart';
import 'package:ssi/ssi.dart';
import 'package:uuid/uuid.dart';

import '../didcomm/message_types.dart';

/// Trust Registry Admin Protocol client for request-response communication.
///
/// Implements a single-role admin client that sends requests to a Trust Registry
/// service and waits for responses using message correlation.
class TrAdminClient {
  /// Underlying DIDComm mediator client for message transport
  final DidcommMediatorClient mediatorClient;

  /// DID manager for signing and encryption operations
  final DidManager didManager;

  /// Trust Registry DID (message recipient)
  final String trustRegistryDid;

  /// Admin DID (message sender)
  final String adminDid;

  /// Logger instance
  final Logger _logger;

  /// Response timeout in seconds (matching Rust implementation)
  static const int responseTimeoutSeconds = 30;

  /// Pending requests map for message correlation (messageId -> completer)
  final Map<String, Completer<Map<String, dynamic>>> _pendingRequests = {};

  /// Message listener subscription
  StreamSubscription? _messageSubscription;

  /// Stream controller for incoming response messages
  final StreamController<PlainTextMessage> _messageStreamController =
      StreamController<PlainTextMessage>.broadcast();

  /// Timer for polling messages every 1 second
  Timer? _pollingTimer;

  /// Flag to track if polling has started
  bool _isPollingStarted = false;

  /// Stream of incoming response messages
  Stream<PlainTextMessage> get messageStream => _messageStreamController.stream;

  /// Creates a new [TrAdminClient] with the provided dependencies.
  TrAdminClient({
    required this.mediatorClient,
    required this.didManager,
    required this.trustRegistryDid,
    required this.adminDid,
    Logger? logger,
  }) : _logger = logger ?? Logger();

  /// Convenience initializer that creates the underlying [DidcommMediatorClient]
  /// prior to constructing the admin client instance.
  static Future<TrAdminClient> init({
    required DidDocument mediatorDidDocument,
    required DidManager didManager,
    required String trustRegistryDid,
    AuthorizationProvider? authorizationProvider,
    ClientOptions clientOptions = const ClientOptions(),
    required Logger logger,
  }) async {
    final didDoc = await didManager.getDidDocument();
    final adminDid = didDoc.id;

    final client = TrAdminClient(
      mediatorClient: await DidcommMediatorClient.init(
        didManager: didManager,
        mediatorDidDocument: mediatorDidDocument,
        authorizationProvider: authorizationProvider,
        clientOptions: clientOptions,
      ),
      didManager: didManager,
      trustRegistryDid: trustRegistryDid,
      adminDid: adminDid,
      logger: logger,
    );

    return client;
  }

  /// Starts the polling timer (called automatically on first request)
  void _startPolling() {
    if (_isPollingStarted) return;

    _logger.i('Starting message polling (every 1 second)...');
    _isPollingStarted = true;

    _pollingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _fetchMessages();
    });
  }

  /// Fetches messages from mediator and processes them
  Future<void> _fetchMessages() async {
    try {
      final messages = await mediatorClient.fetchMessages();

      if (messages.isEmpty) return;

      _logger.d('Fetched ${messages.length} message(s) from mediator');

      for (final message in messages) {
        final unpacked = await DidcommMessage.unpackToPlainTextMessage(
          message: message,
          recipientDidManager: didManager,
          expectedMessageWrappingTypes: [
            MessageWrappingType.authcryptPlaintext,
            MessageWrappingType.anoncryptSignPlaintext,
            MessageWrappingType.authcryptSignPlaintext,
          ],
        );

        _logger.i('Received message type: ${unpacked.type}');
        _logger
            .d('Message ID: ${unpacked.id}, Thread ID: ${unpacked.threadId}');
        _logger.d('Message from: ${unpacked.from}, to: ${unpacked.to}');

        // Check if this is a response message
        if (_isResponseMessage(unpacked.type)) {
          // Add to stream
          _messageStreamController.add(unpacked);
          // Handle response for pending requests
          await _handleResponseMessage(unpacked);
        } else {
          _logger.w('Received unexpected message type: ${unpacked.type}');
        }
      }
    } catch (e, stackTrace) {
      _logger.e('Error fetching messages', error: e, stackTrace: stackTrace);
      // Continue polling despite errors
    }
  }

  /// Checks if a message type is a response message
  bool _isResponseMessage(Uri messageType) {
    final typeString = messageType.toString();
    return typeString == TrAdminMessageTypes.createRecordResponse ||
        typeString == TrAdminMessageTypes.updateRecordResponse ||
        typeString == TrAdminMessageTypes.deleteRecordResponse ||
        typeString == TrAdminMessageTypes.readRecordResponse ||
        typeString == TrAdminMessageTypes.listRecordsResponse;
  }

  /// Handles an incoming response message by completing the corresponding request
  Future<void> _handleResponseMessage(PlainTextMessage message) async {
    // Get thread ID to correlate with request
    final threadId = message.threadId ?? message.id;

    _logger.i('Handling response for thread: $threadId');
    _logger.d('Pending requests: ${_pendingRequests.keys.join(", ")}');

    // Find pending request
    final completer = _pendingRequests.remove(threadId);

    if (completer != null && !completer.isCompleted) {
      final body = message.body;
      _logger.i('Completing request with body: $body');
      if (body is Map<String, dynamic>) {
        completer.complete(body);
      } else {
        completer.complete(<String, dynamic>{});
      }
    } else {
      _logger.w('No pending request found for thread: $threadId');
      _logger
          .w('Available pending requests: ${_pendingRequests.keys.join(", ")}');
    }
  }

  /// Sends a message and waits for response with timeout
  Future<Map<String, dynamic>> _sendAndWaitForResponse({
    required String messageType,
    required Map<String, dynamic> body,
  }) async {
    final messageId = const Uuid().v4();

    _logger
        .d('Sending message: ${messageType.split('/').last} (ID: $messageId)');

    // Start polling if not already started
    _startPolling();

    // Create completer for response
    final completer = Completer<Map<String, dynamic>>();
    _pendingRequests[messageId] = completer;

    try {
      // Build message
      final message = PlainTextMessage(
        id: messageId,
        type: Uri.parse(messageType),
        from: null,
        to: [trustRegistryDid],
        body: body,
        createdTime: DateTime.now(),
        expiresTime: DateTime.now().add(const Duration(minutes: 5)),
      );

      _logger.d('Message details: type=${messageType}, to=${trustRegistryDid}');
      _logger.d('Message body: $body');

      // Pack and send
      await mediatorClient.packAndSendMessage(message);

      _logger.i('Message sent successfully: $messageId');
      _logger
          .d('Waiting for response (timeout: ${responseTimeoutSeconds}s)...');

      // Wait for response with timeout (polling will handle fetching)
      final response = await completer.future.timeout(
        Duration(seconds: responseTimeoutSeconds),
        onTimeout: () {
          _pendingRequests.remove(messageId);
          throw TimeoutException(
            'Timeout waiting for response after $responseTimeoutSeconds seconds',
          );
        },
      );

      _logger.i('Response received for message: $messageId');
      return response;
    } catch (e) {
      _pendingRequests.remove(messageId);
      _logger.e('Error in sendAndWaitForResponse', error: e);
      rethrow;
    }
  }

  /// Creates a new record in the Trust Registry
  Future<Map<String, dynamic>> createRecord({
    required String entity_id,
    required String authority_id,
    required String action,
    required String resource,
    required bool recognized,
    required bool authorized,
    String? validFrom,
    String? validUntil,
  }) async {
    final body = {
      'entity_id': entity_id,
      'authority_id': authority_id,
      'action': action,
      'resource': resource,
      'recognized': recognized,
      'authorized': authorized,
      'record_type':
          !authorized ? 'recognition' : 'assertion', // Hardcoded record type
      if (validFrom != null) 'valid_from': validFrom,
      if (validUntil != null) 'valid_until': validUntil,
    };

    return _sendAndWaitForResponse(
      messageType: TrAdminMessageTypes.createRecord,
      body: body,
    );
  }

  /// Updates an existing record in the Trust Registry
  Future<Map<String, dynamic>> updateRecord({
    required String id,
    String? entity_id,
    String? authority_id,
    String? action,
    String? resource,
    bool? recognized,
    bool? authorized,
    String? validFrom,
    String? validUntil,
  }) async {
    final body = {
      'id': id,
      if (entity_id != null) 'entity_id': entity_id,
      if (authority_id != null) 'authority_id': authority_id,
      if (action != null) 'action': action,
      if (resource != null) 'resource': resource,
      if (recognized != null) 'recognized': recognized,
      if (authorized != null) 'authorized': authorized,
      if (validFrom != null) 'valid_from': validFrom,
      if (validUntil != null) 'valid_until': validUntil,
      if (authorized != null)
        'record_type': !authorized ? 'recognition' : 'assertion',
    };

    return _sendAndWaitForResponse(
      messageType: TrAdminMessageTypes.updateRecord,
      body: body,
    );
  }

  /// Deletes a record from the Trust Registry
  Future<Map<String, dynamic>> deleteRecord({
    required String entity_id,
    required String authority_id,
    required String action,
    required String resource,
  }) async {
    final body = {
      "entity_id": entity_id,
      "authority_id": authority_id,
      "action": action,
      "resource": resource
    };

    return _sendAndWaitForResponse(
      messageType: TrAdminMessageTypes.deleteRecord,
      body: body,
    );
  }

  /// Reads a single record from the Trust Registry
  Future<Map<String, dynamic>> readRecord({required String id}) async {
    final body = {'id': id};

    return _sendAndWaitForResponse(
      messageType: TrAdminMessageTypes.readRecord,
      body: body,
    );
  }

  /// Lists all records from the Trust Registry
  Future<Map<String, dynamic>> listRecords() async {
    final body = <String, dynamic>{};

    return _sendAndWaitForResponse(
      messageType: TrAdminMessageTypes.listRecords,
      body: body,
    );
  }

  /// Disposes the client and cleans up resources
  Future<void> dispose() async {
    await _messageSubscription?.cancel();

    _logger.i('Disposing TrAdminClient...');

    // Stop polling
    _pollingTimer?.cancel();
    _pollingTimer = null;
    _isPollingStarted = false;

    // Close stream
    await _messageStreamController.close();

    await _messageSubscription?.cancel();

    // Complete all pending requests with error
    for (final completer in _pendingRequests.values) {
      if (!completer.isCompleted) {
        completer.completeError(
          Exception('TrAdminClient disposed while request was pending'),
        );
      }
    }
    _pendingRequests.clear();

    _logger.i('TrAdminClient disposed');
  }
}
