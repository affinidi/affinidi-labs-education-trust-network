import 'package:flutter/foundation.dart';

/// Job opening domain entity
@immutable
class JobOpening {
  final String id;
  final String title;
  final String department;
  final String location;
  final String employmentType;
  final String description;
  final List<String> responsibilities;
  final List<String> requirements;
  final List<String> preferredQualifications;
  final String salaryRange;
  final DateTime postedDate;
  final DateTime closingDate;
  final bool isActive;
  final int applicantsCount;

  const JobOpening({
    required this.id,
    required this.title,
    required this.department,
    required this.location,
    required this.employmentType,
    required this.description,
    required this.responsibilities,
    required this.requirements,
    required this.preferredQualifications,
    required this.salaryRange,
    required this.postedDate,
    required this.closingDate,
    required this.isActive,
    required this.applicantsCount,
  });
}
