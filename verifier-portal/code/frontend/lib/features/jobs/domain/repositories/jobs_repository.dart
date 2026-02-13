import '../entities/job_opening.dart';

/// Repository interface for jobs
/// All methods throw exceptions on error
abstract class JobsRepository {
  /// Get all job openings
  /// Throws [AppException] on error
  Future<List<JobOpening>> getAllJobs();

  /// Get a specific job by ID
  /// Throws [NotFoundException] if job not found
  /// Throws [AppException] on other errors
  Future<JobOpening> getJobById(String id);

  /// Search for jobs with filters
  /// Throws [AppException] on error
  Future<List<JobOpening>> searchJobs({
    required String query,
    // String? department,
    // String? location,
    // String? employmentType,
  });
}
