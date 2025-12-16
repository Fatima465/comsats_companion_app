// lib/auth/auth_gate.dart

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// These imports use your project's correct package name (cui_companion_app)
import 'package:cui_companion_app/pages/home_page.dart';
import 'package:cui_companion_app/pages/login_page.dart';

class AuthGate extends StatelessWidget {
const AuthGate({super.key});

 @override
 Widget build(BuildContext context) {
 // This listens to Supabase's authentication state changes
 return StreamBuilder<AuthState>(
 stream: Supabase.instance.client.auth.onAuthStateChange,
builder: (context, snapshot) {
 // Loading...
 if (snapshot.connectionState == ConnectionState.waiting) {
 return const Scaffold(
 body: Center(child: CircularProgressIndicator()),
 );
 }
 
 final session = snapshot.data?.session;

 // If a valid session exists, the user is authenticated.
 if (session != null) {
 return const HomePage(); // The main dashboard screen
 } else {
 // If no session, go to the Login page.
 return const Loginpage();
 }
},
 );
 }    
}