import '../repositories/records_repository.dart';

/// Use case for deleting a trust record
class DeleteRecordUseCase {
  final RecordsRepository repository;

  const DeleteRecordUseCase(this.repository);

  /// Execute the use case
  /// Throws [RecordException] on error
  Future<void> call({
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

    return await repository.deleteRecord(
      entityId: entityId,
      authorityId: authorityId,
      action: action,
      resource: resource,
    );
  }
}
