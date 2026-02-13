import '../../../../core/domain/failures.dart';
import '../../domain/entities/job_opening.dart';
import '../../domain/repositories/jobs_repository.dart';
import '../datasources/jobs_local_datasource.dart';

class JobsRepositoryImpl implements JobsRepository {
  final JobsLocalDataSource dataSource;

  const JobsRepositoryImpl(this.dataSource);

  @override
  Future<List<JobOpening>> getAllJobs() async {
    try {
      return await dataSource.getAllJobs();
    } catch (e) {
      throw CacheException('Failed to load job listings: ${e.toString()}');
    }
  }

  @override
  Future<JobOpening> getJobById(String id) async {
    try {
      final job = await dataSource.getJobById(id);
      if (job == null) {
        throw NotFoundException('Job with id $id not found');
      }
      return job;
    } catch (e) {
      if (e is NotFoundException) rethrow;
      throw CacheException('Failed to load job details: ${e.toString()}');
    }
  }

  @override
  Future<List<JobOpening>> searchJobs({
    required String query,
    // String? department,
    // String? location,
    // String? employmentType,
  }) async {
    try {
      return await dataSource.searchJobs(
        query,
        // department: department,
        // location: location,
        // employmentType: employmentType,
      );
    } catch (e) {
      throw CacheException('Failed to search jobs: ${e.toString()}');
    }
  }
}
