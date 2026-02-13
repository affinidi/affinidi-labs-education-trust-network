import '../entities/trust_record.dart';
import '../repositories/records_repository.dart';

/// Use case for reading a trust record
class ReadRecordUseCase {
  final RecordsRepository repository;

  const ReadRecordUseCase(this.repository);

  /// Execute the use case
  /// Throws [NotFoundException] if not found
  /// Throws [RecordException] on other errors
  Future<TrustRecord> call({
    required String entityId,
    required String authorityId,
    required String action,
    required String resource,
  }) async {
    if (entityId.isEmpty ||
        authorityId.isEmpty ||
        action.isEmpty ||
        resource.isEmpty) {
      throw Exception('All identifier fields are required');
    }

    return await repository.readRecord(
      entityId: entityId,
      authorityId: authorityId,
      action: action,
      resource: resource,
    );
  }
}
