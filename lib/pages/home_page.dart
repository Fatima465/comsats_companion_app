// lib/pages/home_page.dart
import 'package:cui_companion_app/pages/events_page.dart';
import 'package:cui_companion_app/pages/lost_found_page.dart';
import 'package:cui_companion_app/pages/past_papers_page.dart';
import 'package:cui_companion_app/pages/planner_page.dart';
import 'package:cui_companion_app/pages/profile_page.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // List of screens for the Bottom Navigation Bar
  final List<Widget> _pages = [
    const PastPapersPage(),
    const LostFoundPage(),
    const EventsPage(),
    const PlannerPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.description_outlined),
            activeIcon: Icon(Icons.description),
            label: 'Papers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_searching_outlined),
            activeIcon: Icon(Icons.location_searching),
            label: 'Lost & Found',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_note_outlined),
            activeIcon: Icon(Icons.event_note),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'Planner',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF4A90E2), // Blue from UI
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // Ensure all items are visible
        backgroundColor: const Color(0xFF2E3A59), // Dark card background
      ),
    );
  }
}