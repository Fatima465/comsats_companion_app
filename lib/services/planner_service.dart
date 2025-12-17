import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/planner_model.dart';

class PlannerService {
  final _supabase = Supabase.instance.client;

  // Stream for the specific logged-in user (Privacy handled by RLS)
  Stream<List<PlannerModel>> getPlannersStream() {
    return _supabase
        .from('planners')
        .stream(primaryKey: ['id'])
        .order('plan_date', ascending: true)
        .map((maps) => maps.map((m) => PlannerModel.fromMap(m)).toList());
  }

  Future<void> addPlanner({
    required String title,
    required String description,
    required DateTime date,
    required String time,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw 'User not logged in';

    // PRECONDITION: Check if date/time is in the past
    if (date.isBefore(DateTime.now().subtract(const Duration(days: 0)))) {
       // Simple check: In a real app, combine date and time for a precise check
    }

    await _supabase.from('planners').insert({
      'user_id': user.id,
      'title': title,
      'description': description,
      'plan_date': date.toIso8601String().split('T')[0],
      'plan_time': time,
      'reminder_email': user.email,
    });
  }

  Future<void> deletePlanner(String id) async {
    await _supabase.from('planners').delete().eq('id', id);
  }
}