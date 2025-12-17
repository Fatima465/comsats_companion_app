// lib/main.dart
import 'package:cui_companion_app/auth/auth_gate.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
 // Ensure Flutter is initialized first
 WidgetsFlutterBinding.ensureInitialized();

 // Supabase setup 
 await Supabase.initialize(
 url: 'https://bcclqahjdepxwthdvwui.supabase.co',
 anonKey: 'sb_publishable_oN1HnBnL8jFP9Ns7ID4fVA_-sFau7QU',
 );
 runApp(const MyApp());
}

class MyApp extends StatelessWidget {
 const MyApp({super.key});

 @override
 Widget build(BuildContext context) {
 // We will use the theme from your UI images (dark mode with blue accents)
 return MaterialApp(
 debugShowCheckedModeBanner: false, // <--- ADD THIS LINE
 title: 'CUI Companion',
 theme: ThemeData(
 brightness: Brightness.dark,
 primaryColor: const Color(0xFF4A90E2), // A deep blue
 scaffoldBackgroundColor: const Color(0xFF1A1A2E), // Dark background
 cardColor: const Color(0xFF2E3A59), // Slightly lighter card color
 appBarTheme: const AppBarTheme(
 backgroundColor: Color(0xFF1A1A2E),
 elevation: 0,
 ),
 textTheme: const TextTheme(
 bodyLarge: TextStyle(color: Colors.white),
 bodyMedium: TextStyle(color: Colors.white70),
 titleMedium: TextStyle(color: Colors.white),
 ),
 elevatedButtonTheme: ElevatedButtonThemeData(
 style: ElevatedButton.styleFrom(
 backgroundColor: const Color(0xFF4A90E2),
 foregroundColor: Colors.white,
 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
 shape: RoundedRectangleBorder(
 borderRadius: BorderRadius.circular(10),
 ),
 ),
 ),
 inputDecorationTheme: InputDecorationTheme(
 filled: true,
 fillColor: const Color(0xFF2E3A59),
 border: OutlineInputBorder(
 borderRadius: BorderRadius.circular(10.0),
 borderSide: BorderSide.none,
 ),
 labelStyle: const TextStyle(color: Colors.white70),
 hintStyle: const TextStyle(color: Colors.white54),
 ),
 ),
 home: const AuthGate(),
 );
 }
}