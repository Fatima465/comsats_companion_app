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
  static const String kTable = 'lost_and_found';

  // Compatible with both Mobile and Web
  Future<void> createPost({
    required List<int> fileData,
    required String fileName,
    required String userId,
    required String postType,
    required String title,
    required String description,
    String? location,
    String? contactInfo,
  }) async {
    final fileBytes = Uint8List.fromList(fileData);
    final storagePath = '$userId/${DateTime.now().millisecondsSinceEpoch}_$fileName';

    // 1. Upload Image
    await _supabase.storage.from(kBucket).uploadBinary(
          storagePath,
          fileBytes,
          fileOptions: const FileOptions(contentType: 'image/jpeg'),
        );

    final imageUrl = _supabase.storage.from(kBucket).getPublicUrl(storagePath);

    // 2. Insert Record (Force lowercase post_type for database consistency)
    await _supabase.from(kTable).insert({
      'posted_by': userId,
      'post_type': postType.toLowerCase(), 
      'title': title,
      'description': description,
      'location': location,
      'contact_info': contactInfo,
      'image_url': imageUrl,
      'status': 'Active',
    });
  }

  Stream<List<LostFoundPost>> getPostsStream({String filterType = 'All'}) {
    return _supabase.from(kTable).stream(primaryKey: ['id']).map((maps) {
      // Convert all maps to objects safely
      List<LostFoundPost> allPosts = maps.map((m) => LostFoundPost.fromMap(m)).toList();
      
      // Sort: Newest first
      allPosts.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      // Filter logic
      if (filterType == 'All') {
        return allPosts.where((post) => post.status == 'Active').toList();
      } else {
        return allPosts.where((post) => 
          post.postType.toLowerCase() == filterType.toLowerCase() && 
          post.status == 'Active'
        ).toList();
      }
    });
  }

  Future<void> updatePostStatus(String postId, String newStatus) async {
    await _supabase.from(kTable).update({
      'status': newStatus,
      'resolved_at': DateTime.now().toIso8601String(),
    }).eq('id', postId);
  }
}