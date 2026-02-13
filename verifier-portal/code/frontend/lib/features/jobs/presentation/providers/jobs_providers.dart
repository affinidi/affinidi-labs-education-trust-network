import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/jobs_local_datasource.dart';
import '../../data/repositories/jobs_repository_impl.dart';
import '../../domain/entities/job_opening.dart';
import '../../domain/repositories/jobs_repository.dart';
import '../../domain/usecases/jobs_usecases.dart';

// Data Source Provider
final jobsDataSourceProvider = Provider<JobsLocalDataSource>((ref) {
  return JobsLocalDataSource();
});

// Repository Provider
final jobsRepositoryProvider = Provider<JobsRepository>((ref) {
  final dataSource = ref.watch(jobsDataSourceProvider);
  return JobsRepositoryImpl(dataSource);
});

// Jobs List State Provider - Construct UseCase directly from repository
// DO NOT create UseCase providers - construct them on-demand
final jobsListProvider = FutureProvider<List<JobOpening>>((ref) async {
  final repository = ref.watch(jobsRepositoryProvider);
  final useCase = GetJobsUseCase(repository);
  return await useCase();
});

// Selected Job Provider - Construct UseCase directly from repository
final selectedJobProvider = FutureProvider.family<JobOpening, String>((
  ref,
  jobId,
) async {
  final repository = ref.watch(jobsRepositoryProvider);
  final useCase = GetJobByIdUseCase(repository);
  return await useCase(jobId);
});

// Search Query Provider
final searchQueryProvider = StateProvider<String>((ref) => '');

// Filtered Jobs Provider
final filteredJobsProvider = Provider<AsyncValue<List<JobOpening>>>((ref) {
  final query = ref.watch(searchQueryProvider);
  final jobsAsync = ref.watch(jobsListProvider);

  return jobsAsync.whenData((jobs) {
    if (query.isEmpty) return jobs;

    final lowerQuery = query.toLowerCase();
    return jobs.where((job) {
      return job.title.toLowerCase().contains(lowerQuery) ||
          job.department.toLowerCase().contains(lowerQuery) ||
          job.location.toLowerCase().contains(lowerQuery);
    }).toList();
  });
});
