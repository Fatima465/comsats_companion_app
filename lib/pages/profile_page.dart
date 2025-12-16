// lib/pages/profile_page.dart
import 'package:cui_companion_app/auth/auth_service.dart';
import 'package:cui_companion_app/pages/cgpa_calculator_page.dart';
import 'package:flutter/material.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final authService = AuthService();
  
  void logout() async {
    await authService.signOut();
    // AuthGate handles navigation back to Loginpage
  }
  
  // Placeholder for user details
  String _currentEmail = "loading...";
  String _fullName = "Loading User";
  
  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  // In a real app, this should fetch data from the `profiles` table
  void _loadUserProfile() async {
    final email = authService.getCurrentUserEmail();
    setState(() {
      _currentEmail = email ?? "No Email Found";
      // We will assume a simple parsing for now until we build the service
      _fullName = email?.split('@').first ?? "User";
    });
    // TODO: Implement fetching actual profile data from Supabase
  }

  @override
  Widget build(BuildContext context) {
    // UI based on image_b73309.png
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // User Header Card
            Container(
              padding: const EdgeInsets.all(20.0),
              margin: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Color(0xFF4A90E2),
                    child: Icon(Icons.school, size: 40, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Text(_fullName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text(_currentEmail, style: const TextStyle(color: Colors.white70)),
                  const SizedBox(height: 5),
                  const Chip(
                    label: Text("Student", style: TextStyle(color: Colors.white)),
                    backgroundColor: Color(0xFF4A90E2),
                  ),
                ],
              ),
            ),

            // CGPA Calculator Tile
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              tileColor: Theme.of(context).cardColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              leading: const Icon(Icons.calculate, color: Color(0xFF4A90E2)),
              title: const Text("CGPA Calculator"),
              subtitle: const Text("Calculate your semester and cumulative GPA"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CGPACalculatorPage()),
                );
              },
            ),
            const SizedBox(height: 20),

            // Settings Header
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("SETTINGS", style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 10),

            // Settings List Tiles
            _buildSettingsTile(context, "Notifications", Icons.notifications_none),
            _buildSettingsTile(context, "Appearance", Icons.palette_outlined),
            _buildSettingsTile(context, "Help & Support", Icons.help_outline),

            const SizedBox(height: 20),

            // Log Out Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListTile(
                tileColor: Theme.of(context).cardColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                title: const Center(
                  child: Text(
                    "Log Out",
                    style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                  ),
                ),
                onTap: logout,
              ),
            ),
            const SizedBox(height: 20),
            
            // Version Text
            const Text(
              "CUI Companion v1.0.0",
              style: TextStyle(color: Colors.white54, fontSize: 12),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile(BuildContext context, String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 16.0, right: 16.0),
      child: ListTile(
        tileColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        leading: Icon(icon, color: Colors.white70),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white70),
        onTap: () {
          // TODO: Implement navigation for settings
        },
      ),
    );
  }
}