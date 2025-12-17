// // // lib/services/past_paper_service.dart
// // import 'dart:io';
// // import 'package:cui_companion_app/models/past_paper.dart';
// // import 'package:cui_companion_app/utils/constants.dart';
// // import 'package:supabase_flutter/supabase_flutter.dart';
// // import 'package:path/path.dart' as p;
// // import 'package:crypto/crypto.dart';
// // import 'dart:convert';
// // import 'package:mime/mime.dart'; // <--- NEW IMPORT

// // class PastPaperService {
// // final _supabase = Supabase.instance.client;

// // /// 1. Uploads the file to Supabase Storage and records metadata in the database (FR5, FR9).
// // Future<void> uploadPastPaper({
// //  required File file,
// //  required String userId,
// //  required Map<String, dynamic> metadata, required List<int> fileData, required String fileName,
// //  }) async {
// //   // 1. Generate unique file path/name
// //  final fileExtension = p.extension(file.path);
// //  final fileName = '${DateTime.now().toIso8601String()}-$userId$fileExtension';
// //  final storagePath = 'public/$userId/$fileName';
 
// //  // 2. Calculate File Hash to prevent duplicates (FR8 - RLS Policy Check)
// //  final fileBytes = await file.readAsBytes();
// //  final fileHash = sha256.convert(fileBytes).toString();

// //  // 3. Check for Duplicates via Hash in DB (FR8)
// //  final existingPaper = await _supabase
// //  .from(kPastPapersTable)
// //  .select('id')
// //  .eq('file_hash', fileHash)
// //  .limit(1)
// //  .maybeSingle();

// //  if (existingPaper != null) {
// //  throw Exception('Duplicate file detected. This paper has already been uploaded.');
// //  }

// //     // Determine the MIME type (needed for web uploads)
// //     final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
    
// //  // 4. Upload file to Supabase Storage
// //     // FIX: Switched to uploadBinary for cross-platform compatibility (mobile/desktop/web)
// //  await _supabase.storage 
// //  .from(kPastPapersBucket)
// //  .uploadBinary( // <--- USE UPLOADBINARY
// //             storagePath, 
// //             fileBytes, // <--- USE THE BYTES YOU ALREADY READ
// //             fileOptions: FileOptions(
// //                 cacheControl: '3600', 
// //                 upsert: false,
// //                 contentType: mimeType, // <--- PROVIDE CONTENT TYPE
// //             )
// //         );
 
// //  final fileUrl = _supabase.storage.from(kPastPapersBucket).getPublicUrl(storagePath);
 
// //  // 5. Insert metadata into the database
// //  final newPaper = PastPaper(
// //  id: 'placeholder', // Will be ignored, DB generates UUID
// //  uploadedBy: userId,
// //  courseCode: metadata['course_code'],
// //  courseName: metadata['course_name'],
// //  year: metadata['year'],
// //  semester: metadata['semester'],
// //  examType: metadata['exam_type'],
// //  fileUrl: fileUrl,
// //  fileName: p.basename(file.path),
// //  fileSize: file.lengthSync(),
// //  downloadCount: 0,
// //  createdAt: DateTime.now(),
// //  );

// //  await _supabase.from(kPastPapersTable).insert({
// //  ...newPaper.toInsertMap(),
// //  'file_hash': fileHash,
// //  });
// //  }

// //  /// 2. Fetches a stream of past papers for viewing (FR7).
// //  Stream<List<PastPaper>> getPastPapersStream() {
// //  return _supabase
// //  .from(kPastPapersTable)
// //  .stream(primaryKey: ['id'])
// //  .order('created_at', ascending: false)
// //  .map((maps) => maps.map(PastPaper.fromMap).toList()); } 
// // }

// // lib/services/past_paper_service.dart
// import 'dart:typed_data'; // We need Uint8List for uploadBinary
// // import 'dart:io'; // REMOVED: No longer needed, use fileData (bytes)
// import 'package:cui_companion_app/models/past_paper.dart';
// import 'package:cui_companion_app/utils/constants.dart'; // Assuming kPastPapersTable, kPastPapersBucket are here
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:path/path.dart' as p;
// import 'package:crypto/crypto.dart';
// import 'dart:convert';
// import 'package:mime/mime.dart'; 

// class PastPaperService {
//   final _supabase = Supabase.instance.client;

//   /// 1. Uploads the file to Supabase Storage and records metadata in the database (FR5, FR9).
//   Future<void> uploadPastPaper({
//     // --- CORRECTED PARAMETERS FOR CROSS-PLATFORM COMPATIBILITY ---
//     required List<int> fileData, // The actual file bytes (List<int> from PlatformFile.bytes)
//     required String fileName,    // The original file name
//     required String userId,
//     required Map<String, dynamic> metadata,
//     // The File file argument was removed to resolve the compilation conflict.
//   }) async {
//     // 1. Convert List<int> to Uint8List for Supabase uploadBinary
//     final fileBytes = Uint8List.fromList(fileData);
    
//     // 2. Calculate File Hash to prevent duplicates (FR8 - RLS Policy Check)
//     final fileHash = sha256.convert(fileBytes).toString();

//     // 3. Check for Duplicates via Hash in DB (FR8)
//     final existingPaper = await _supabase
//         .from(kPastPapersTable)
//         .select('id')
//         .eq('file_hash', fileHash)
//         .limit(1)
//         .maybeSingle();

//     if (existingPaper != null) {
//       throw Exception('Duplicate file detected. This paper has already been uploaded.');
//     }

//     // 4. Generate unique storage path/name
//     final fileExtension = p.extension(fileName);
//     final storageFileName = '${DateTime.now().toIso8601String()}-$userId$fileExtension';
//     final storagePath = 'public/$userId/$storageFileName';
    
//     // 5. Determine the MIME type
//     final mimeType = lookupMimeType(fileName) ?? 'application/pdf'; // Default to PDF as per FR5
    
//     // 6. Upload file to Supabase Storage
//     await _supabase.storage 
//         .from(kPastPapersBucket)
//         .uploadBinary(
//             storagePath, 
//             fileBytes, 
//             fileOptions: FileOptions(
//                 cacheControl: '3600', 
//                 upsert: false,
//                 contentType: mimeType, 
//             )
//         );
    
//     final fileUrl = _supabase.storage.from(kPastPapersBucket).getPublicUrl(storagePath);
    
//     // 7. Insert metadata into the database
//     final newPaper = PastPaper(
//         id: 'placeholder', 
//         uploadedBy: userId,
//         courseCode: metadata['course_code'],
//         courseName: metadata['course_name'],
//         year: metadata['year'],
//         semester: metadata['semester'],
//         examType: metadata['exam_type'],
//         fileUrl: fileUrl,
//         fileName: fileName, // Use the original file name
//         fileSize: fileBytes.length, // Use the size of the bytes
//         downloadCount: 0,
//         createdAt: DateTime.now(),
//     );

//     await _supabase.from(kPastPapersTable).insert({
//         ...newPaper.toInsertMap(),
//         'file_hash': fileHash,
//     });
//   }

//   /// 2. Fetches a stream of past papers for viewing (FR7).
//   Stream<List<PastPaper>> getPastPapersStream() {
//     return _supabase
//         .from(kPastPapersTable)
//         .stream(primaryKey: ['id'])
//         .order('created_at', ascending: false)
//         .map((maps) => maps.map(PastPaper.fromMap).toList()); 
//   } 
// }
// lib/services/past_paper_service.dart
// import 'dart:typed_data';
// import 'package:cui_companion_app/models/past_paper.dart';
// import 'package:cui_companion_app/utils/constants.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:path/path.dart' as p;
// import 'package:crypto/crypto.dart';
// import 'package:mime/mime.dart'; 

// class PastPaperService {
//   final _supabase = Supabase.instance.client;

//   // This provides the data for your PastPapersPage
//   Stream<List<PastPaper>> getPastPapersStream() {
//     return _supabase
//         .from(kPastPapersTable)
//         .stream(primaryKey: ['id'])
//         .order('created_at', ascending: false)
//         .map((maps) => maps.map((map) => PastPaper.fromMap(map)).toList());
//   }

//   Future<void> uploadPastPaper({
//     required List<int> fileData, 
//     required String fileName,    
//     required String userId,
//     required Map<String, dynamic> metadata,
//   }) async {
//     try {
//       final fileBytes = Uint8List.fromList(fileData);
//       final fileHash = sha256.convert(fileBytes).toString();

//       // 1. Check if file exists (Duplicate Check)
//       final existing = await _supabase
//           .from(kPastPapersTable)
//           .select('id')
//           .eq('file_hash', fileHash)
//           .maybeSingle();

//       if (existing != null) throw 'This paper has already been uploaded.';

//       // 2. Upload Binary to Storage
//       final storagePath = 'public/$userId/${DateTime.now().millisecondsSinceEpoch}${p.extension(fileName)}';
//       await _supabase.storage.from(kPastPapersBucket).uploadBinary(
//         storagePath, 
//         fileBytes,
//         fileOptions: FileOptions(contentType: lookupMimeType(fileName) ?? 'application/pdf'),
//       );
      
//       final url = _supabase.storage.from(kPastPapersBucket).getPublicUrl(storagePath);
      
//       // 3. Insert into Table
//       // Ensure these keys match your Supabase column names EXACTLY
//       await _supabase.from(kPastPapersTable).insert({
//         'uploaded_by': userId,
//         'course_code': metadata['course_code'],
//         'course_name': metadata['course_name'],
//         'course_instructor': metadata['course_instructor'],
//         'year': metadata['year'],
//         'semester': metadata['semester'],
//         'exam_type': metadata['exam_type'],
//         'file_url': url,
//         'file_name': fileName,
//         'file_size': fileBytes.length,
//         'download_count': 0,
//         'file_hash': fileHash,
//       });
//     } catch (e) {
//       // This will catch Storage or Postgrest errors
//       throw e.toString();
//     }
//   }
// }

import 'dart:typed_data';
import 'package:cui_companion_app/models/past_paper.dart';
import 'package:cui_companion_app/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:crypto/crypto.dart';
import 'package:mime/mime.dart'; 

class PastPaperService {
  final _supabase = Supabase.instance.client;

  /// Listens to the past papers table with optional search filtering
  Stream<List<PastPaper>> getPastPapersStream({String? searchQuery}) {
    var query = _supabase.from(kPastPapersTable).stream(primaryKey: ['id']);

    if (searchQuery != null && searchQuery.isNotEmpty) {
      final search = searchQuery.toLowerCase();
      return query.map((list) => list
          .map((map) => PastPaper.fromMap(map))
          .where((paper) =>
              paper.courseName.toLowerCase().contains(search) ||
              paper.courseCode.toLowerCase().contains(search) ||
              (paper.courseInstructor?.toLowerCase().contains(search) ?? false))
          .toList());
    }

    return query
        .order('created_at', ascending: false)
        .map((maps) => maps.map((map) => PastPaper.fromMap(map)).toList());
  }

  /// Uploads file to Storage and creates DB record
  Future<void> uploadPastPaper({
    required List<int> fileData, 
    required String fileName,    
    required String userId,
    required Map<String, dynamic> metadata,
  }) async {
    try {
      final fileBytes = Uint8List.fromList(fileData);
      final fileHash = sha256.convert(fileBytes).toString();

      final existing = await _supabase
          .from(kPastPapersTable)
          .select('id')
          .eq('file_hash', fileHash)
          .maybeSingle();

      if (existing != null) throw 'This paper has already been uploaded.';

      final storagePath = 'public/$userId/${DateTime.now().millisecondsSinceEpoch}${p.extension(fileName)}';
      await _supabase.storage.from(kPastPapersBucket).uploadBinary(
        storagePath, 
        fileBytes,
        fileOptions: FileOptions(contentType: lookupMimeType(fileName) ?? 'application/pdf'),
      );
      
      final url = _supabase.storage.from(kPastPapersBucket).getPublicUrl(storagePath);
      
      await _supabase.from(kPastPapersTable).insert({
        'uploaded_by': userId,
        'course_code': metadata['course_code'],
        'course_name': metadata['course_name'],
        'course_instructor': metadata['course_instructor'],
        'year': metadata['year'],
        'semester': metadata['semester'],
        'exam_type': metadata['exam_type'],
        'file_url': url,
        'file_name': fileName,
        'file_size': fileBytes.length,
        'download_count': 0,
        'file_hash': fileHash,
      });
    } catch (e) {
      throw e.toString();
    }
  }

  /// Deletes paper from DB and removes file from Storage
  Future<void> deletePastPaper(String id, String fileUrl) async {
    try {
      // 1. Extract the storage path from the full URL
      // Logic: Get everything after the bucket name in the URL path
      final uri = Uri.parse(fileUrl);
      final pathSegments = uri.pathSegments;
      final bucketIndex = pathSegments.indexOf(kPastPapersBucket);
      
      if (bucketIndex != -1 && bucketIndex + 1 < pathSegments.length) {
        final storagePath = pathSegments.sublist(bucketIndex + 1).join('/');
        // Remove from Storage
        await _supabase.storage.from(kPastPapersBucket).remove([storagePath]);
      }

      // 2. Delete from Database
      await _supabase.from(kPastPapersTable).delete().eq('id', id);
    } catch (e) {
      throw 'Delete failed: $e';
    }
  }

  /// Updates paper metadata
  Future<void> updatePastPaper(String id, Map<String, dynamic> updates) async {
    try {
      await _supabase.from(kPastPapersTable).update(updates).eq('id', id);
    } catch (e) {
      throw 'Update failed: $e';
    }
  }
}