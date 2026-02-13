import 'package:governance_portal/features/records/data/datasources/records_remote_datasource.provider.dart';

import '../../domain/repositories/records_repository.dart';
import '../repositories/records_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'records_repository.provider.g.dart';

/// Infrastructure Providers
/// These providers manage the core dependencies like TrAdminClient,
/// data sources, and repositories that are shared across the application.

// TrAdminClient Provider

// Data Source Provider
@Riverpod(keepAlive: true)
Future<RecordsRepository> recordsRepository(ref) async {
  final dataSource = await ref.read(recordsRemoteDataSourceProvider.future);
  return RecordsRepositoryImpl(dataSource);
}
