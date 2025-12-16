// lib/models/user_profile.dart
class UserProfile {
  final String id;
  final String email;
  final String? fullName;
  final String? universityRollNo;
  final String? department;
  final String? batch;
  final bool isAdmin;
  final DateTime createdAt;

  UserProfile({
    required this.id,
    required this.email,
    this.fullName,
    this.universityRollNo,
    this.department,
    this.batch,
    required this.isAdmin,
    required this.createdAt,
  });

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] as String,
      email: map['email'] as String,
      fullName: map['full_name'] as String?,
      universityRollNo: map['university_roll_no'] as String?,
      department: map['department'] as String?,
      batch: map['batch'] as String?,
      isAdmin: map['is_admin'] as bool,
      createdAt: DateTime.parse(map['created_at'] as String).toLocal(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'university_roll_no': universityRollNo,
      'department': department,
      'batch': batch,
      'is_admin': isAdmin,
    };
  }
}