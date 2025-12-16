// lib/services/event_service.dart
import 'package:cui_companion_app/models/event.dart';
import 'package:cui_companion_app/utils/constants.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class EventService {
  final _supabase = Supabase.instance.client;

  /// Fetches a stream of upcoming events (FR15).
  /// RLS policy ensures everyone can SELECT.
  Stream<List<Event>> getUpcomingEventsStream() {
    return _supabase
        .from(kEventsTable)
        .stream(primaryKey: ['id'])
        // Filter for upcoming/ongoing events and sort by date
        .eq('status', 'Upcoming') 
        .order('event_date', ascending: true)
        .map((maps) => maps.map(Event.fromMap).toList());
  }

  /// Creates a new event (FR14).
  /// RLS policy ensures only admins can INSERT.
  Future<void> createEvent(Event event) async {
    try {
      await _supabase.from(kEventsTable).insert(event.toInsertMap());
    } catch (e) {
      // If the user is not an admin, Supabase RLS will throw a permission error here.
      throw Exception('Failed to create event. Permission denied or invalid data.');
    }
  }

  // TODO: Add updateEvent and deleteEvent (Admin only)
}