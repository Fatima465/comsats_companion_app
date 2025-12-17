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
import 'dart:typed_data';
import 'package:cui_companion_app/models/past_paper.dart';
import 'package:cui_companion_app/utils/constants.dart'; 
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:crypto/crypto.dart';
import 'package:mime/mime.dart'; 

class PastPaperService {
  final _supabase = Supabase.instance.client;

  Future<void> uploadPastPaper({
    required List<int> fileData, 
    required String fileName,    
    required String userId,
    required Map<String, dynamic> metadata,
  }) async {
    final fileBytes = Uint8List.fromList(fileData);
    
    // 1. Calculate File Hash for duplicate detection
    final fileHash = sha256.convert(fileBytes).toString();

    // 2. Check for Duplicates
    final existingPaper = await _supabase
        .from(kPastPapersTable)
        .select('id')
        .eq('file_hash', fileHash)
        .maybeSingle();

    if (existingPaper != null) {
      throw Exception('Duplicate file! This paper has already been uploaded.');
    }

    // 3. Setup Storage Path
    final fileExtension = p.extension(fileName);
    final storageFileName = '${DateTime.now().millisecondsSinceEpoch}-$userId$fileExtension';
    final storagePath = 'public/$userId/$storageFileName';
    final mimeType = lookupMimeType(fileName) ?? 'application/pdf';
    
    // 4. Upload to Supabase Storage
    await _supabase.storage 
        .from(kPastPapersBucket)
        .uploadBinary(
            storagePath, 
            fileBytes, 
            fileOptions: FileOptions(
                cacheControl: '3600', 
                upsert: false,
                contentType: mimeType, 
            )
        );
    
    // 5. Get the Public URL
    final fileUrl = _supabase.storage.from(kPastPapersBucket).getPublicUrl(storagePath);
    
    // 6. Insert into PostgreSQL
    final newPaper = PastPaper(
        id: '', // Generated by DB
        uploadedBy: userId,
        courseCode: metadata['course_code'],
        courseName: metadata['course_name'],
        year: metadata['year'],
        semester: metadata['semester'],
        examType: metadata['exam_type'],
        fileUrl: fileUrl,
        fileName: fileName,
        fileSize: fileBytes.length,
        downloadCount: 0,
        createdAt: DateTime.now(),
    );

    await _supabase.from(kPastPapersTable).insert({
        ...newPaper.toInsertMap(),
        'file_hash': fileHash,
    });
  }

  Stream<List<PastPaper>> getPastPapersStream() {
    return _supabase
        .from(kPastPapersTable)
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map((maps) => maps.map(PastPaper.fromMap).toList()); 
  } 
}