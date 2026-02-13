import '../entities/trust_record.dart';
import '../repositories/records_repository.dart';

/// Use case for searching records by entity ID
class SearchRecordsByEntityUseCase {
  final RecordsRepository repository;

  const SearchRecordsByEntityUseCase(this.repository);

  /// Execute the use case
  /// Throws [RecordException] on error
  Future<List<TrustRecord>> call(String entityId) async {
    if (entityId.isEmpty) {
      throw Exception('Entity ID cannot be empty');
    }

    return await repository.searchByEntityId(entityId);
  }
}
