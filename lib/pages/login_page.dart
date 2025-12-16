// lib/pages/login_page.dart
import 'package:cui_companion_app/auth/auth_service.dart';
import 'package:cui_companion_app/pages/register_page.dart';
import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void login() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    
    // Simple validation (can be improved)
    if (email.isEmpty || password.isEmpty) {
      _showErrorSnackBar("Please enter both email and password.");
      return;
    }

    try {
      await authService.signInWithEmailPassword(email, password);
      
      // ********** CRUCIAL: After successful login, ensure the profile exists **********
      // This handles the case where the user signed up but the profile was not
      // created because they had to confirm their email first.
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        // Note: For a proper implementation, you should fetch the user's full_name
        // and roll_no from a storage mechanism (e.g., local shared preferences) 
        // set during registration, or prompt the user for it if missing.
        // For now, we will use placeholders.
        // **A better flow: Prompt user for full_name/roll_no on first login/after email verify**
        await authService.ensureProfileExists(
          user.id, 
          user.email!, 
          "Placeholder Name", // Placeholder
          "N/A",               // Placeholder
        );
      }
      // AuthGate will detect the successful login and navigate to HomePage

    } on AuthException catch (e) {
      _showErrorSnackBar("Login failed: ${e.message}");
    } catch (e) {
      _showErrorSnackBar("An unexpected error occurred: $e");
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // UI based on image_b73d70.png
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/app_icon.png', height: 100), // Placeholder for your icon
              const SizedBox(height: 10),
              const Text(
                "CUI Companion",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Text("Your academic companion at CUI Wah", style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 40),

              // University Email Field
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "University Email",
                  hintText: "student@cuilahore.edu.pk",
                ),
              ),
              const SizedBox(height: 20),

              // Password Field
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: "Password",
                  hintText: "Enter your password",
                ),
                obscureText: true,
              ),
              const SizedBox(height: 10),

              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // TODO: Implement Forgot Password logic
                  },
                  child: const Text("Forgot Password?", style: TextStyle(color: Color(0xFF4A90E2))),
                ),
              ),
              const SizedBox(height: 30),

              // Sign In Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: login,
                  child: const Text("Sign In", style: TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(height: 50),

              // Don't have an account? Create Account
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Registerpage()),
                ),
                child: const Text.rich(
                  TextSpan(
                    text: "Don't have an account? ",
                    style: TextStyle(color: Colors.white70),
                    children: [
                      TextSpan(
                        text: "Create Account",
                        style: TextStyle(
                          color: Color(0xFF4A90E2),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}