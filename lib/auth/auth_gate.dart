import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:cui_companion_app/pages/home_page.dart';
import 'package:cui_companion_app/pages/login_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;

    return StreamBuilder<AuthState>(
      stream: supabase.auth.onAuthStateChange,
      builder: (context, snapshot) {
        print('================ AUTH GATE =================');
        print('ConnectionState : ${snapshot.connectionState}');
        print('Snapshot hasData: ${snapshot.hasData}');
        print('Auth Event      : ${snapshot.data?.event}');
        print('Session (stream): ${snapshot.data?.session}');
        print('Session (local) : ${supabase.auth.currentSession}');
        print('============================================');

        final session = supabase.auth.currentSession;

        if (session != null) {
          print('User authenticated → HomePage');
          return const HomePage();
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          print('Auth waiting → LoginPage');
          return const Loginpage();
        }

        print('No session → LoginPage');
        return const Loginpage();
      },
    );
  }
}
