// lib/services/past_paper_service.dart
import 'dart:io';
import 'package:cui_companion_app/models/past_paper.dart';
import 'package:cui_companion_app/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:mime/mime.dart'; // <--- NEW IMPORT

class PastPaperService {
final _supabase = Supabase.instance.client;

/// 1. Uploads the file to Supabase Storage and records metadata in the database (FR5, FR9).
Future<void> uploadPastPaper({
 required File file,
 required String userId,
 required Map<String, dynamic> metadata,
 }) async {
  // 1. Generate unique file path/name
 final fileExtension = p.extension(file.path);
 final fileName = '${DateTime.now().toIso8601String()}-$userId$fileExtension';
 final storagePath = 'public/$userId/$fileName';
 
 // 2. Calculate File Hash to prevent duplicates (FR8 - RLS Policy Check)
 final fileBytes = await file.readAsBytes();
 final fileHash = sha256.convert(fileBytes).toString();

 // 3. Check for Duplicates via Hash in DB (FR8)
 final existingPaper = await _supabase
 .from(kPastPapersTable)
 .select('id')
 .eq('file_hash', fileHash)
 .limit(1)
 .maybeSingle();

 if (existingPaper != null) {
 throw Exception('Duplicate file detected. This paper has already been uploaded.');
 }

    // Determine the MIME type (needed for web uploads)
    final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
    
 // 4. Upload file to Supabase Storage
    // FIX: Switched to uploadBinary for cross-platform compatibility (mobile/desktop/web)
 await _supabase.storage 
 .from(kPastPapersBucket)
 .uploadBinary( // <--- USE UPLOADBINARY
            storagePath, 
            fileBytes, // <--- USE THE BYTES YOU ALREADY READ
            fileOptions: FileOptions(
                cacheControl: '3600', 
                upsert: false,
                contentType: mimeType, // <--- PROVIDE CONTENT TYPE
            )
        );
 
 final fileUrl = _supabase.storage.from(kPastPapersBucket).getPublicUrl(storagePath);
 
 // 5. Insert metadata into the database
 final newPaper = PastPaper(
 id: 'placeholder', // Will be ignored, DB generates UUID
 uploadedBy: userId,
 courseCode: metadata['course_code'],
 courseName: metadata['course_name'],
 year: metadata['year'],
 semester: metadata['semester'],
 examType: metadata['exam_type'],
 fileUrl: fileUrl,
 fileName: p.basename(file.path),
 fileSize: file.lengthSync(),
 downloadCount: 0,
 createdAt: DateTime.now(),
 );

 await _supabase.from(kPastPapersTable).insert({
 ...newPaper.toInsertMap(),
 'file_hash': fileHash,
 });
 }

 /// 2. Fetches a stream of past papers for viewing (FR7).
 Stream<List<PastPaper>> getPastPapersStream() {
 return _supabase
 .from(kPastPapersTable)
 .stream(primaryKey: ['id'])
 .order('created_at', ascending: false)
 .map((maps) => maps.map(PastPaper.fromMap).toList()); } 
}