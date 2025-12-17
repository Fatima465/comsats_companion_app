// // lib/services/event_service.dart
// import 'package:cui_companion_app/models/event.dart';
// import 'package:cui_companion_app/utils/constants.dart';

// import 'package:supabase_flutter/supabase_flutter.dart';

// class EventService {
//   final _supabase = Supabase.instance.client;

//   /// Fetches a stream of upcoming events (FR15).
//   /// RLS policy ensures everyone can SELECT.
//   Stream<List<Event>> getUpcomingEventsStream() {
//     return _supabase
//         .from(kEventsTable)
//         .stream(primaryKey: ['id'])
//         // Filter for upcoming/ongoing events and sort by date
//         .eq('status', 'Upcoming') 
//         .order('event_date', ascending: true)
//         .map((maps) => maps.map(Event.fromMap).toList());
//   }

//   /// Creates a new event (FR14).
//   /// RLS policy ensures only admins can INSERT.
//   Future<void> createEvent(Event event) async {
//     try {
//       await _supabase.from(kEventsTable).insert(event.toInsertMap());
//     } catch (e) {
//       // If the user is not an admin, Supabase RLS will throw a permission error here.
//       throw Exception('Failed to create event. Permission denied or invalid data.');
//     }
//   }

//   // TODO: Add updateEvent and deleteEvent (Admin only)
// }




// lib/services/event_service.dart
import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/event.dart';

class EventService {
  final _supabase = Supabase.instance.client;
  final String tableName = 'events'; // Matches the SQL table we just created

  /// Listens to the events table in real-time
  Stream<List<Event>> getUpcomingEventsStream() {
    return _supabase
        .from(tableName)
        .stream(primaryKey: ['id'])
        .order('event_date', ascending: true)
        .map((maps) => maps.map(Event.fromMap).toList());
  }

  /// Handles Image Upload + Row Insertion
  Future<void> createEvent(Map<String, dynamic> eventData, Uint8List? imageBytes) async {
    String? imageUrl;

    // 1. Upload to Storage if a photo was picked
    if (imageBytes != null) {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
      
      // Make sure you have a bucket named 'event_images' in Supabase Storage
      await _supabase.storage.from('event_images').uploadBinary(
            fileName,
            imageBytes,
            fileOptions: const FileOptions(contentType: 'image/png'),
          );

      imageUrl = _supabase.storage.from('event_images').getPublicUrl(fileName);
    }

    // 2. Insert into the 'events' table
    await _supabase.from('events').insert({
      ...eventData,
      'image_url': imageUrl,
      'created_by': _supabase.auth.currentUser?.id,
    });
  }
}