import '../entities/job_opening.dart';
import '../repositories/jobs_repository.dart';

class GetJobsUseCase {
  final JobsRepository repository;

  const GetJobsUseCase(this.repository);

  /// Get all job openings
  /// Throws [AppException] on error
  Future<List<JobOpening>> call() {
    return repository.getAllJobs();
  }
}

class GetJobByIdUseCase {
  final JobsRepository repository;

  const GetJobByIdUseCase(this.repository);

  /// Get job by ID
  /// Throws [NotFoundException] if job not found
  /// Throws [AppException] on other errors
  Future<JobOpening> call(String id) {
    return repository.getJobById(id);
  }
}

class SearchJobsUseCase {
  final JobsRepository repository;

  const SearchJobsUseCase(this.repository);

  /// Search jobs by query
  /// Throws [AppException] on error
  Future<List<JobOpening>> call(String query) {
    return repository.searchJobs(query: query);
  }
}
