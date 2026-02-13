// User profile entity
class UserProfile {
  const UserProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.profilePicPath,
    this.currentCompany,
    this.currentJobTitle,
    this.totalExperienceMonths,
    required this.createdAt,
    required this.updatedAt,
  });
  final String id;
  final String firstName;
  final String lastName;
  final String? profilePicPath;
  final String? currentCompany;
  final String? currentJobTitle;
  final int? totalExperienceMonths;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? profilePicPath,
    String? currentCompany,
    String? currentJobTitle,
    int? totalExperienceMonths,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      profilePicPath: profilePicPath ?? this.profilePicPath,
      currentCompany: currentCompany ?? this.currentCompany,
      currentJobTitle: currentJobTitle ?? this.currentJobTitle,
      totalExperienceMonths:
          totalExperienceMonths ?? this.totalExperienceMonths,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get fullName => '$firstName $lastName';

  String get experienceText {
    if (totalExperienceMonths == null) return 'Not specified';
    final years = totalExperienceMonths! ~/ 12;
    final months = totalExperienceMonths! % 12;
    if (years == 0) return '$months months';
    if (months == 0) return '$years years';
    return '$years years $months months';
  }
}
