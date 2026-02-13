import '../../../records/domain/repositories/records_repository.dart';
import '../../../records/domain/usecases/read_record_usecase.dart';
import '../entities/query_input.dart';
import '../entities/query_result.dart';

/// Use case for executing a trust registry query
class ExecuteQueryUseCase {
  final RecordsRepository repository;

  const ExecuteQueryUseCase(this.repository);

  /// Execute the query use case
  /// Throws [RecordException] on error
  Future<QueryResult> call(QueryInput input) async {
    // Validate input
    if (!input.isValid) {
      throw Exception('All query fields are required');
    }

    // Create ReadRecordUseCase and execute
    final readRecordUseCase = ReadRecordUseCase(repository);

    // For now, we'll use readRecord to simulate a query
    // In a real implementation, you'd have a dedicated TRQP query message
    final record = await readRecordUseCase(
      entityId: input.entityId,
      authorityId: input.authorityId,
      action: input.action,
      resource: input.resource,
    );

    return QueryResult(
      recognized: record.recognized,
      authorized: record.authorized,
      timestamp: DateTime.now(),
      rawResponse: {
        'entity_id': record.entityId,
        'authority_id': record.authorityId,
        'action': record.action,
        'resource': record.resource,
        'recognized': record.recognized,
        'authorized': record.authorized,
      },
    );
  }
}
