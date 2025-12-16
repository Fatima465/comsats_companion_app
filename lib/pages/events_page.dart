// lib/pages/events_page.dart
import 'package:flutter/material.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  // In a real scenario, you'd check the current user's is_admin status
  // For now, we assume this logic will be implemented in the ProfileService
  final bool _isAdmin = false; // Placeholder for admin check

  @override
  Widget build(BuildContext context) {
    // UI based on image_b73a47.png
    return Scaffold(
      appBar: AppBar(
        title: const Text("Campus Events"),
        actions: [
          if (_isAdmin)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                // TODO: Implement 'Add Event' logic (Admin only - FR14)
              },
            ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_note_outlined,
              size: 80,
              color: Colors.white30,
            ),
            const SizedBox(height: 20),
            const Text(
              "No Upcoming Events",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Check back later for campus events",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}