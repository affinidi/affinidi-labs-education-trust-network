import '../../domain/entities/trust_record.dart';
import '../../domain/repositories/records_repository.dart';
import '../datasources/records_remote_datasource.dart';
import '../models/trust_record_model.dart';
import '../../../../core/domain/exceptions/trust_registry_exceptions.dart';

/// Implementation of Records Repository
/// Handles all trust record operations via DIDComm
class RecordsRepositoryImpl implements RecordsRepository {
  final RecordsRemoteDataSource _remoteDataSource;

  const RecordsRepositoryImpl(this._remoteDataSource);

  @override
  Future<TrustRecord> createRecord(TrustRecord record) async {
    try {
      final model = TrustRecordModel.fromEntity(record);
      final createdModel = await _remoteDataSource.createRecord(model);
      return createdModel.toEntity();
    } catch (e) {
      if (e is RecordException ||
          e is DIDCommException ||
          e is TimeoutException) {
        rethrow;
      }
      throw RecordException('Repository: Failed to create record: $e');
    }
  }

  @override
  Future<TrustRecord> updateRecord(TrustRecord record) async {
    try {
      final model = TrustRecordModel.fromEntity(record);
      final updatedModel = await _remoteDataSource.updateRecord(model);
      return updatedModel.toEntity();
    } catch (e) {
      if (e is RecordException ||
          e is DIDCommException ||
          e is TimeoutException) {
        rethrow;
      }
      throw RecordException('Repository: Failed to update record: $e');
    }
  }

  @override
  Future<void> deleteRecord({
    required String entityId,
    required String authorityId,
    required String action,
    required String resource,
  }) async {
    try {
      await _remoteDataSource.deleteRecord(
        entityId: entityId,
        authorityId: authorityId,
        action: action,
        resource: resource,
      );
    } catch (e) {
      if (e is RecordException ||
          e is DIDCommException ||
          e is TimeoutException) {
        rethrow;
      }
      throw RecordException('Repository: Failed to delete record: $e');
    }
  }

  @override
  Future<TrustRecord> readRecord({
    required String entityId,
    required String authorityId,
    required String action,
    required String resource,
  }) async {
    try {
      final model = await _remoteDataSource.readRecord(
        entityId: entityId,
        authorityId: authorityId,
        action: action,
        resource: resource,
      );
      return model.toEntity();
    } catch (e) {
      if (e is NotFoundException ||
          e is RecordException ||
          e is DIDCommException ||
          e is TimeoutException) {
        rethrow;
      }
      throw RecordException('Repository: Failed to read record: $e');
    }
  }

  @override
  Future<List<TrustRecord>> listRecords() async {
    try {
      final models = await _remoteDataSource.listRecords();
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      if (e is RecordException ||
          e is DIDCommException ||
          e is TimeoutException) {
        rethrow;
      }
      throw RecordException('Repository: Failed to list records: $e');
    }
  }

  @override
  Future<List<TrustRecord>> searchByEntityId(String entityId) async {
    try {
      // Get all records and filter by entity ID
      final allRecords = await listRecords();
      return allRecords
          .where((record) =>
              record.entityId.toLowerCase().contains(entityId.toLowerCase()))
          .toList();
    } catch (e) {
      if (e is RecordException ||
          e is DIDCommException ||
          e is TimeoutException) {
        rethrow;
      }
      throw RecordException('Repository: Failed to search by entity ID: $e');
    }
  }

  @override
  Future<List<TrustRecord>> searchByAuthorityId(String authorityId) async {
    try {
      // Get all records and filter by authority ID
      final allRecords = await listRecords();
      return allRecords
          .where((record) => record.authorityId
              .toLowerCase()
              .contains(authorityId.toLowerCase()))
          .toList();
    } catch (e) {
      if (e is RecordException ||
          e is DIDCommException ||
          e is TimeoutException) {
        rethrow;
      }
      throw RecordException('Repository: Failed to search by authority ID: $e');
    }
  }
}
