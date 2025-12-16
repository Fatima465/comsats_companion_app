// lib/services/lost_and_found_service.dart

import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class LostAndFoundService {
  final _supabase = Supabase.instance.client;
  static const String kBucket = 'lost_and_found_images';
  static const String kTable = 'lost_and_found';

  Future<void> reportItem({
    required File imageFile,
    required String userId,
    required Map<String, dynamic> metadata,
  }) async {
    // 1. Generate unique file path/name
    final fileName = 'item_${DateTime.now().millisecondsSinceEpoch}.png';
    final storagePath = '$userId/$fileName';
    
    // 2. Upload image to Storage Bucket
    await _supabase.storage
        .from(kBucket)
        .upload(storagePath, imageFile);
    
    // 3. Get public URL for the image
    final imageUrl = _supabase.storage.from(kBucket).getPublicUrl(storagePath);
    
    // 4. Insert metadata into the database
    await _supabase.from(kTable).insert({
      'item_type': metadata['item_type'],
      'item_name': metadata['item_name'],
      'description': metadata['description'],
      'location': metadata['location'],
      'image_url': imageUrl, // The link to the image
      'reported_by': userId,
      'status': 'pending',
    });
  }

  // TODO: Add methods for fetching items and updating status (e.g., markAsClaimed)
}