// lib/pages/lost_found_page.dart
import 'package:flutter/material.dart';

class LostFoundPage extends StatelessWidget {
  const LostFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    // UI based on image_b739d2.png
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lost & Found"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Implement 'Create Post' logic (FR10)
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                _buildFilterChip("All", true),
                const SizedBox(width: 10),
                _buildFilterChip("Lost", false),
                const SizedBox(width: 10),
                _buildFilterChip("Found", false),
              ],
            ),
          ),
          const SizedBox(height: 50),
          // Content (No Posts Yet)
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_searching_outlined,
                    size: 80,
                    color: Colors.white30,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "No Posts Yet",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Help the community by posting lost or found items",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Chip(
      label: Text(label),
      backgroundColor: isSelected ? const Color(0xFF4A90E2) : const Color(0xFF2E3A59),
      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.white70),
    );
  }
}