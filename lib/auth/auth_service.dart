// lib/auth/auth_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // 1. SIGN IN (Login) - FR2, FR3
  Future<AuthResponse> signInWithEmailPassword(String email, String password) async {
    return await _supabase.auth.signInWithPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  // 2. SIGN UP (Register) - FR1, Email Confirmation
  Future<void> signUpWithEmailPassword(
    String email, 
    String password,
    String fullName, // New parameter for profile creation
    String rollNo,    // New parameter for profile creation
  ) async {
    final response = await _supabase.auth.signUp(
      email: email.trim(),
      password: password.trim(),
      // Supabase sends a confirmation email by default
      emailRedirectTo: 'io.supabase.flutter://login-callback/', 
    );

    // After successful sign-up, create the initial profile entry.
    // This will only work once the user confirms their email!
    // For now, we will handle the profile creation upon *successful* sign-in
    // after email confirmation, but we will store the initial data in the
    // `user_metadata` for later use.

    if (response.user != null) {
      // Create initial profile data - we'll update this to be more robust later
      // The actual insertion into the `profiles` table happens after login.
      // We will skip this metadata for simplicity in the current flow
    }
  }

  // 3. SIGN OUT
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // 4. GET CURRENT USER EMAIL
  String? getCurrentUserEmail() {
    return _supabase.auth.currentUser?.email;
  }

  // 5. GET CURRENT USER ID (UUID)
  String? getCurrentUserId() {
    return _supabase.auth.currentUser?.id;
  }

  // 6. CHECK FOR EXISTING PROFILE and CREATE IF NOT EXISTS (Crucial for sign-up flow)
  Future<void> ensureProfileExists(String userId, String email, String fullName, String rollNo) async {
    final response = await _supabase.from('profiles')
      .select('id')
      .eq('id', userId)
      .limit(1)
      .maybeSingle();

    if (response == null) {
      // Profile does not exist, create it.
      await _supabase.from('profiles').insert({
        'id': userId,
        'email': email,
        'full_name': fullName,
        'university_roll_no': rollNo,
        // is_admin defaults to FALSE in the DB schema
      });
    }
  }
}