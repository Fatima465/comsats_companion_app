// lib/models/semester.dart
class Semester {
  final String id;
  final String userId;
  final String semesterName;
  final int? semesterNumber;
  final int? year;
  final String? semesterType; // 'Fall', 'Spring', 'Summer'
  final double? gpa;
  final DateTime createdAt;
  
  Semester({
    required this.id,
    required this.userId,
    required this.semesterName,
    this.semesterNumber,
    this.year,
    this.semesterType,
    this.gpa,
    required this.createdAt,
  });

  factory Semester.fromMap(Map<String, dynamic> map) {
    return Semester(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      semesterName: map['semester_name'] as String,
      semesterNumber: map['semester_number'] as int?,
      year: map['year'] as int?,
      semesterType: map['semester_type'] as String?,
      gpa: (map['gpa'] as num?)?.toDouble(),
      createdAt: DateTime.parse(map['created_at'] as String).toLocal(),
    );
  }
  // toMap implementation goes here...
}