import '../entities/trust_record.dart';

/// Repository interface for Trust Record operations
/// All methods throw exceptions on error
abstract class RecordsRepository {
  /// Create a new trust record
  /// Throws [RecordException] on error
  Future<TrustRecord> createRecord(TrustRecord record);

  /// Update an existing trust record
  /// Throws [RecordException] on error
  Future<TrustRecord> updateRecord(TrustRecord record);

  /// Delete a trust record
  /// Throws [RecordException] on error
  Future<void> deleteRecord({
    required String entityId,
    required String authorityId,
    required String action,
    required String resource,
  });

  /// Read a specific trust record
  /// Throws [NotFoundException] if not found
  /// Throws [RecordException] on other errors
  Future<TrustRecord> readRecord({
    required String entityId,
    required String authorityId,
    required String action,
    required String resource,
  });

  /// List all trust records
  /// Throws [RecordException] on error
  Future<List<TrustRecord>> listRecords();

  /// Search records by entity ID
  Future<List<TrustRecord>> searchByEntityId(String entityId);

  /// Search records by authority ID
  Future<List<TrustRecord>> searchByAuthorityId(String authorityId);
}
