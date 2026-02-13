import 'package:governance_portal/features/records/data/repositories/records_repository.provider.dart';

import '../../../records/data/datasources/records_remote_datasource.provider.dart';

/// Query Providers
///
/// This file only contains infrastructure providers.
/// Use cases should be constructed directly in widgets using the repository.
///
/// Example in a widget:
/// ```dart
/// final repository = ref.watch(recordsRepositoryProvider);
/// final executeQueryUseCase = ExecuteQueryUseCase(repository);
/// final result = await executeQueryUseCase(queryInput);
/// ```

// Re-export the records repository provider for convenience
// This is the only infrastructure dependency needed for query use cases
final queryRecordsRepositoryProvider = recordsRepositoryProvider;
