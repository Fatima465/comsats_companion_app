// lib/services/profile_service.dart
import 'package:cui_companion_app/models/user_profile.dart';
import 'package:cui_companion_app/utils/constants.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileService {
  final _supabase = Supabase.instance.client;

  /// Fetches the current user's profile data.
  Future<UserProfile> getCurrentUserProfile(String userId) async {
    final response = await _supabase
        .from(kProfilesTable)
        .select()
        .eq('id', userId)
        .single();

    return UserProfile.fromMap(response);
  }

  /// Checks if the current user has administrative privileges.
  Future<bool> isAdmin(String userId) async {
    try {
      final profile = await getCurrentUserProfile(userId);
      return profile.isAdmin;
    } catch (e) {
      // Handle case where profile might not exist yet or connection error
      print('Error checking admin status: $e');
      return false;
    }
  }
  
  /// Updates selected fields on the user's profile.
  Future<void> updateProfile({
    required String userId,
    String? fullName,
    String? rollNo,
    String? department,
    String? batch,
  }) async {
    final updates = <String, dynamic>{};
    if (fullName != null) updates['full_name'] = fullName;
    if (rollNo != null) updates['university_roll_no'] = rollNo;
    if (department != null) updates['department'] = department;
    if (batch != null) updates['batch'] = batch;

    if (updates.isNotEmpty) {
      await _supabase
          .from(kProfilesTable)
          .update(updates)
          .eq('id', userId);
    }
  }
}