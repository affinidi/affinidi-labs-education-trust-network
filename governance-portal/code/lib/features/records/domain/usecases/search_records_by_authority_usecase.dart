import '../entities/trust_record.dart';
import '../repositories/records_repository.dart';

/// Use case for searching records by authority ID
class SearchRecordsByAuthorityUseCase {
  final RecordsRepository repository;

  const SearchRecordsByAuthorityUseCase(this.repository);

  /// Execute the use case
  /// Throws [RecordException] on error
  Future<List<TrustRecord>> call(String authorityId) async {
    if (authorityId.isEmpty) {
      throw Exception('Authority ID cannot be empty');
    }

    return await repository.searchByAuthorityId(authorityId);
  }
}
