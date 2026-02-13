import '../entities/trust_record.dart';
import '../repositories/records_repository.dart';

/// Use case for listing all trust records
class ListRecordsUseCase {
  final RecordsRepository repository;

  const ListRecordsUseCase(this.repository);

  /// Execute the use case
  /// Throws [RecordException] on error
  Future<List<TrustRecord>> call() async {
    return await repository.listRecords();
  }
}
