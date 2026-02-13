import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/credential.dart';
import '../../../vault/data/vault_service/vault_service.dart';

/// Provider that watches the vault service and converts DigitalCredentials to Credential entities
final credentialsProvider = Provider<List<Credential>>((ref) {
  final vaultState = ref.watch(vaultServiceProvider);
  final digitalCredentials = vaultState.claimedCredentials ?? [];

  return digitalCredentials.map((digitalCredential) {
    final vc = digitalCredential.verifiableCredential;

    // Extract credential type (excluding 'VerifiableCredential')
    final types =
        (vc.type as List<dynamic>?)
            ?.where((type) => type != 'VerifiableCredential')
            .map((e) => e.toString())
            .toList() ??
        [];
    final credentialType = types.isNotEmpty
        ? types.first
        : 'Unknown Credential';

    // Extract issuer - the issuer is an object with an 'id' property
    final issuer = vc.issuer.id.toString();

    // Extract issuance date from the raw data if available
    // The VerifiableCredential doesn't expose issuanceDate directly
    DateTime issuanceDate = DateTime.now();
    try {
      // Try to get from raw data if available
      final vcData = vc.toJson();
      if (vcData['issuanceDate'] != null) {
        issuanceDate = DateTime.parse(vcData['issuanceDate'] as String);
      }
    } catch (e) {
      // If parsing fails, keep the default
    }

    // Extract credential subject
    final credentialSubject = vc.credentialSubject.isNotEmpty
        ? vc.credentialSubject[0].toJson()
        : <String, dynamic>{};

    return Credential(
      id: digitalCredential.id,
      type: credentialType,
      issuer: issuer,
      issuanceDate: issuanceDate,
      credentialSubject: credentialSubject,
    );
  }).toList();
});
