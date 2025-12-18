// lib/pages/register_page.dart
import 'package:cui_companion_app/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Registerpage extends StatefulWidget {
  const Registerpage({super.key});

  @override
  State<Registerpage> createState() => _RegisterpageState();
}

class _RegisterpageState extends State<Registerpage> {
  final authService = AuthService();
  final _nameController = TextEditingController(); // New
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void signUp() async {
    final fullName = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    // 1. Basic Validation
    if (fullName.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showErrorSnackBar("All fields must be filled.");
      return;
    }

    // 2. Password Match Check
    if (password != confirmPassword) {
      _showErrorSnackBar("Passwords don't match.");
      return;
    }

    // 3. Password Strength Check (6 characters with a number)
    if (password.length < 6 || !password.contains(RegExp(r'[0-9]'))) {
      _showErrorSnackBar(
        "Password must be at least 6 characters and contain a number.",
      );
      return;
    }

    try {
      // Supabase handles the email confirmation logic
      await authService.signUpWithEmailPassword(
        email,
        password,
        fullName,
        "N/A", // Roll No placeholder
      );

      // If sign-up is successful, Supabase has sent a confirmation email.
      if (mounted) {
        _showSuccessSnackBar(
          "Successfully registered! Please check your email to confirm your account.",
        );
        // After successful registration/email sent, go back to login page
        Navigator.pop(context);
      }
    } on AuthException catch (e) {
      _showErrorSnackBar("Sign Up Failed: ${e.message}");
    } catch (e) {
      _showErrorSnackBar("An unexpected error occurred: $e");
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  void _showSuccessSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message, style: const TextStyle(color: Colors.white)),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // UI based on image_b73aa4.png
    return Scaffold(
      appBar: AppBar(title: const Text("Create Account")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            // Display Name (Full Name)
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Name",
                hintText: "Your Name",
              ),
            ),
            const SizedBox(height: 20),

            // University Email
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "Email",
                hintText: "student@gmail.com",
              ),
            ),
            // const Padding(
            //   padding: EdgeInsets.only(top: 8.0, bottom: 20.0),
            //   child: Align(
            //     alignment: Alignment.centerLeft,
            //     child: Text(
            //       "Use your official university email address",
            //       style: TextStyle(color: Colors.white54, fontSize: 12),
            //     ),
            //   ),
            // ),

            // Password
            const SizedBox(height: 20),

            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: "Password",
                hintText: "Create a password",
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),

            // Confirm Password
            TextField(
              controller: _confirmPasswordController,
              decoration: const InputDecoration(
                labelText: "Confirm Password",
                hintText: "Confirm your password",
              ),
              obscureText: true,
            ),
            const SizedBox(height: 30),

            // Create Account Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: signUp,
                child: const Text(
                  "Create Account",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 50),

            // Already have an account? Sign In
            GestureDetector(
              onTap: () => Navigator.pop(context), // Go back to login
              child: const Text.rich(
                TextSpan(
                  text: "Already have an account? ",
                  style: TextStyle(color: Colors.white70),
                  children: [
                    TextSpan(
                      text: "Sign In",
                      style: TextStyle(
                        color: Color(0xFF4A90E2),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
