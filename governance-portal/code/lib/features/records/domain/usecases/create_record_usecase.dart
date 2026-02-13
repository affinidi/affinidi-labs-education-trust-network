import '../entities/trust_record.dart';
import '../repositories/records_repository.dart';

/// Use case for creating a trust record
class CreateRecordUseCase {
  final RecordsRepository repository;

  const CreateRecordUseCase(this.repository);

  /// Execute the use case
  /// Throws [RecordException] on error
  /// Throws [ValidationException] if record data is invalid
  Future<TrustRecord> call(TrustRecord record) async {
    // Validate record data
    _validateRecord(record);

    return await repository.createRecord(record);
  }

  void _validateRecord(TrustRecord record) {
    if (record.entityId.isEmpty) {
      throw Exception('Entity ID cannot be empty');
    }
    if (record.authorityId.isEmpty) {
      throw Exception('Authority ID cannot be empty');
    }
    if (record.action.isEmpty) {
      throw Exception('Action cannot be empty');
    }
    if (record.resource.isEmpty) {
      throw Exception('Resource cannot be empty');
    }
  }
}
