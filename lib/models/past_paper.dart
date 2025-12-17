// // lib/models/past_paper.dart
// class PastPaper {
//   final String id;
//   final String? uploadedBy; // UUID of the user who uploaded it
//   final String courseCode;
//   final String courseName;
//   final int year;
//   final String? semester;
//   final String examType;
//   final String fileUrl;
//   final String fileName;
//   final int? fileSize; // in bytes
//   final int downloadCount;
//   final DateTime createdAt;

//   PastPaper({
//     required this.id,
//     this.uploadedBy,
//     required this.courseCode,
//     required this.courseName,
//     required this.year,
//     this.semester,
//     required this.examType,
//     required this.fileUrl,
//     required this.fileName,
//     this.fileSize,
//     required this.downloadCount,
//     required this.createdAt,
//   });

//   factory PastPaper.fromMap(Map<String, dynamic> map) {
//     return PastPaper(
//       id: map['id'] as String,
//       uploadedBy: map['uploaded_by'] as String?,
//       courseCode: map['course_code'] as String,
//       courseName: map['course_name'] as String,
//       year: map['year'] as int,
//       semester: map['semester'] as String?,
//       examType: map['exam_type'] as String,
//       fileUrl: map['file_url'] as String,
//       fileName: map['file_name'] as String,
//       fileSize: map['file_size'] as int?,
//       downloadCount: map['download_count'] as int,
//       createdAt: DateTime.parse(map['created_at'] as String).toLocal(),
//     );
//   }

//   Map<String, dynamic> toInsertMap() {
//     return {
//       // id is auto-generated
//       'uploaded_by': uploadedBy,
//       'course_code': courseCode,
//       'course_name': courseName,
//       'year': year,
//       'semester': semester,
//       'exam_type': examType,
//       'file_url': fileUrl,
//       'file_name': fileName,
//       'file_size': fileSize,
//     };
//   }
// }

// lib/models/past_paper.dart
class PastPaper {
  final String id;
  final String? uploadedBy;
  final String courseCode;
  final String courseName;
  final int year;
  final String? semester;
  final String examType;
  final String fileUrl;
  final String fileName;
  final int? fileSize;
  final int downloadCount;
  final DateTime createdAt;

  PastPaper({
    required this.id,
    this.uploadedBy,
    required this.courseCode,
    required this.courseName,
    required this.year,
    this.semester,
    required this.examType,
    required this.fileUrl,
    required this.fileName,
    this.fileSize,
    required this.downloadCount,
    required this.createdAt,
  });

  factory PastPaper.fromMap(Map<String, dynamic> map) {
    return PastPaper(
      id: map['id']?.toString() ?? '',
      uploadedBy: map['uploaded_by'] as String?,
      courseCode: map['course_code'] as String,
      courseName: map['course_name'] as String,
      year: map['year'] as int,
      semester: map['semester'] as String?,
      examType: map['exam_type'] as String,
      fileUrl: map['file_url'] as String,
      fileName: map['file_name'] as String,
      fileSize: map['file_size'] as int?,
      downloadCount: map['download_count'] as int? ?? 0,
      createdAt: DateTime.parse(map['created_at'] as String).toLocal(),
    );
  }

  Map<String, dynamic> toInsertMap() {
    return {
      'uploaded_by': uploadedBy,
      'course_code': courseCode,
      'course_name': courseName,
      'year': year,
      'semester': semester,
      'exam_type': examType,
      'file_url': fileUrl,
      'file_name': fileName,
      'file_size': fileSize,
      'download_count': downloadCount, // Added this back
    };
  }
}