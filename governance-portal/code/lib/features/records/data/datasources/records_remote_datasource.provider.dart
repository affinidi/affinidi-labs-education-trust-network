import 'package:governance_portal/core/infrastructure/tr_admin/tr_admin_client.provider.dart';
import 'records_remote_datasource.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'records_remote_datasource.provider.g.dart';

/// Infrastructure Providers
/// These providers manage the core dependencies like TrAdminClient,
/// data sources, and repositories that are shared across the application.

// TrAdminClient Provider

// Data Source Provider
@Riverpod(keepAlive: true)
Future<RecordsRemoteDataSource> recordsRemoteDataSource(ref) async {
  final adminClient = await ref.read(trAdminClientProvider.future);
  if (adminClient == null) {
    throw Exception('TrAdminClient not initialized');
  }
  return RecordsRemoteDataSource(adminClient);
}

// Repository Provider
