import '../../../../core/infrastructure/tr_admin/tr_admin_client.dart';
import '../../../../core/domain/exceptions/trust_registry_exceptions.dart';
import '../models/trust_record_model.dart';

/// Remote data source for trust records
/// Communicates with Trust Registry via DIDComm
class RecordsRemoteDataSource {
  final TrAdminClient _adminClient;

  const RecordsRemoteDataSource(this._adminClient);

  /// Create a new record via DIDComm
  Future<TrustRecordModel> createRecord(TrustRecordModel record) async {
    try {
      final response = await _adminClient.createRecord(
        entity_id: record.entityId, // Map entityId to issuerDid
        authority_id: record.authorityId, // Map authorityId to accreditedBy
        action: record.action, // Map action to credentialTypeId
        resource: record.resource, // Map resource to schemaId
        recognized: record.recognized,
        authorized: record.authorized,
        validFrom: record.context?['validFrom']?.toString(),
        validUntil: record.context?['validUntil']?.toString(),
      );

      // Parse response and return created record
      if (response['record'] != null) {
        return TrustRecordModel.fromJson(
            response['record'] as Map<String, dynamic>);
      }

      // If no record in response, return the input with timestamp
      return record.copyWith(
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    } catch (e) {
      if (e is TimeoutException) {
        throw DIDCommException('Request timeout: $e');
      }
      throw RecordException('Failed to create record: $e');
    }
  }

  /// Update an existing record via DIDComm
  Future<TrustRecordModel> updateRecord(TrustRecordModel record) async {
    try {
      // Assuming we have an ID in context or need to derive it
      final id = record.context?['id']?.toString() ??
          '${record.entityId}-${record.authorityId}-${record.action}';

      final response = await _adminClient.updateRecord(
        id: id,
        entity_id: record.entityId,
        authority_id: record.authorityId,
        action: record.action,
        resource: record.resource,
        recognized: record.recognized,
        authorized: record.authorized,
        validFrom: record.context?['validFrom']?.toString(),
        validUntil: record.context?['validUntil']?.toString(),
      );

      // Parse response and return updated record
      if (response['record'] != null) {
        return TrustRecordModel.fromJson(
            response['record'] as Map<String, dynamic>);
      }

      // If no record in response, return the input with updated timestamp
      return record.copyWith(updatedAt: DateTime.now());
    } catch (e) {
      if (e is TimeoutException) {
        throw DIDCommException('Request timeout: $e');
      }
      throw RecordException('Failed to update record: $e');
    }
  }

  /// Delete a record via DIDComm
  Future<void> deleteRecord({
    required String entityId,
    required String authorityId,
    required String action,
    required String resource,
  }) async {
    try {
      // Derive ID from composite key
      await _adminClient.deleteRecord(
        entity_id: entityId, // Map entityId to issuerDid
        authority_id: authorityId, // Map authorityId to accreditedBy
        action: action, // Map action to credentialTypeId
        resource: resource, // Map resource to schemaId
      );
    } catch (e) {
      if (e is TimeoutException) {
        throw DIDCommException('Request timeout: $e');
      }
      throw RecordException('Failed to delete record: $e');
    }
  }

  /// Read a specific record via DIDComm
  Future<TrustRecordModel> readRecord({
    required String entityId,
    required String authorityId,
    required String action,
    required String resource,
  }) async {
    try {
      // Derive ID from composite key
      final id = '$entityId-$authorityId-$action';

      final response = await _adminClient.readRecord(id: id);

      // Parse response
      if (response['record'] != null) {
        return TrustRecordModel.fromJson(
            response['record'] as Map<String, dynamic>);
      }

      // If direct response is the record
      if (response['entity_id'] != null ||
          response['entityId'] != null ||
          response['issuer_did'] != null) {
        return TrustRecordModel.fromJson(response);
      }

      throw NotFoundException('Record not found');
    } catch (e) {
      if (e is TimeoutException) {
        throw DIDCommException('Request timeout: $e');
      }
      if (e is NotFoundException) {
        rethrow;
      }
      throw RecordException('Failed to read record: $e');
    }
  }

  /// List all records via DIDComm
  Future<List<TrustRecordModel>> listRecords() async {
    try {
      final response = await _adminClient.listRecords();

      // Response could be a list directly or wrapped in 'records' key
      List<dynamic> recordsList;
      if (response['records'] != null && response['records'] is List) {
        recordsList = response['records'] as List;
      } else {
        // Assume the entire response is a map representing a single record
        recordsList = [response];
      }

      return recordsList
          .map(
              (json) => TrustRecordModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is TimeoutException) {
        throw DIDCommException('Request timeout: $e');
      }
      throw RecordException('Failed to list records: $e');
    }
  }
}
