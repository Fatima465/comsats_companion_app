// lib/models/course.dart
class Course {
  final String id;
  final String semesterId;
  final String userId;
  final String courseCode;
  final String courseName;
  final int creditHours;
  final String? grade; // 'A', 'B+', 'F', etc.
  final double? gradePoints;
  final DateTime createdAt;

  Course({
    required this.id,
    required this.semesterId,
    required this.userId,
    required this.courseCode,
    required this.courseName,
    required this.creditHours,
    this.grade,
    this.gradePoints,
    required this.createdAt,
  });

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      id: map['id'] as String,
      semesterId: map['semester_id'] as String,
      userId: map['user_id'] as String,
      courseCode: map['course_code'] as String,
      courseName: map['course_name'] as String,
      creditHours: map['credit_hours'] as int,
      grade: map['grade'] as String?,
      gradePoints: (map['grade_points'] as num?)?.toDouble(),
      createdAt: DateTime.parse(map['created_at'] as String).toLocal(),
    );
  }
  // toMap implementation goes here...
}