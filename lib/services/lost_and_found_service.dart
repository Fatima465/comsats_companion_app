// // lib/services/lost_and_found_service.dart

// import 'dart:io';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class LostAndFoundService {
//   final _supabase = Supabase.instance.client;
//   static const String kBucket = 'lost_and_found_images';
//   static const String kTable = 'lost_and_found';

//   Future<void> reportItem({
//     required File imageFile,
//     required String userId,
//     required Map<String, dynamic> metadata,
//   }) async {
//     // 1. Generate unique file path/name
//     final fileName = 'item_${DateTime.now().millisecondsSinceEpoch}.png';
//     final storagePath = '$userId/$fileName';

//     // 2. Upload image to Storage Bucket
//     await _supabase.storage
//         .from(kBucket)
//         .upload(storagePath, imageFile);

//     // 3. Get public URL for the image
//     final imageUrl = _supabase.storage.from(kBucket).getPublicUrl(storagePath);

//     // 4. Insert metadata into the database
//     await _supabase.from(kTable).insert({
//       'item_type': metadata['item_type'],
//       'item_name': metadata['item_name'],
//       'description': metadata['description'],
//       'location': metadata['location'],
//       'image_url': imageUrl, // The link to the image
//       'reported_by': userId,
//       'status': 'pending',
//     });
//   }

//   // TODO: Add methods for fetching items and updating status (e.g., markAsClaimed)
// }

// lib/services/lost_found_service.dart

// import 'dart:io'; // REMOVED for web compatibility
import 'dart:typed_data';
import 'package:cui_companion_app/models/lost_found_post.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LostFoundService {
  final _supabase = Supabase.instance.client;
  static const String kBucket = 'lost_and_found_images';
  static const String kTable = 'lost_and_found'; // Use a clear table name

  // --- UPDATED METHOD FOR WEB/MOBILE COMPATIBLE UPLOAD ---
  Future<void> createPost({
    required List<int> fileData, // <--- Accepts file bytes
    required String fileName, // <--- Accepts file name
    required String userId,
    required String postType,
    required String title,
    required String description,
    String? location,
    String? contactInfo,
  }) async {
    final fileBytes = Uint8List.fromList(fileData);

    // 1. Generate unique file path/name
    final storagePath =
        '$userId/${DateTime.now().millisecondsSinceEpoch}_$fileName';

    // 2. Upload image to Storage Bucket using uploadBinary
    await _supabase.storage
        .from(kBucket)
        .uploadBinary(
          storagePath,
          fileBytes,
          fileOptions: const FileOptions(
            contentType: 'image/jpeg',
          ), // Adjust based on picker
        );

    // 3. Get public URL for the image
    final imageUrl = _supabase.storage.from(kBucket).getPublicUrl(storagePath);

    // 4. Insert metadata into the database
    await _supabase.from(kTable).insert({
      'posted_by': userId,
      'post_type': postType.toLowerCase(),
      'title': title,
      'description': description,
      'location': location,
      'contact_info': contactInfo,
      'image_url': imageUrl,
      'status': 'Active', // Default status for new posts
    });
  }

  // Method to fetch posts (for LostFoundPage)
  Stream<List<LostFoundPost>> getPostsStream({String filterType = 'All'}) {
    var query = _supabase
        .from(kTable)
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false);

    if (filterType != 'All') {
      query = query.eq('post_type', filterType.toLowerCase());
    }
    query = query.eq('status', 'Active'); // Only show active posts

    return query.map((maps) => maps.map(LostFoundPost.fromMap).toList());
  }

  // Method to mark a post as resolved (Lost item was Found, etc.)
  Future<void> updatePostStatus(String postId, String newStatus) async {
    await _supabase
        .from(kTable)
        .update({
          'status': newStatus, // e.g., 'Resolved'
          'resolved_at': DateTime.now().toIso8601String(),
        })
        .eq('id', postId);
  }
}
