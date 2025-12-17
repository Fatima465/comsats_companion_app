import 'package:flutter/material.dart';
import '../models/lost_found_post.dart';
import '../utils/constants.dart';

class LostFoundDetailPage extends StatelessWidget {
  final LostFoundPost post;
  const LostFoundDetailPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(post.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Container(
              width: double.infinity,
              height: 300,
              color: kSecondaryColor,
              child: post.imageUrl != null
                  ? Image.network(post.imageUrl!, fit: BoxFit.cover)
                  : const Icon(Icons.image_not_supported, size: 100, color: Colors.white24),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Type Tag
                  Chip(
                    label: Text(post.postType.toUpperCase()),
                    backgroundColor: post.postType.toLowerCase() == 'lost' ? Colors.red : Colors.green,
                  ),
                  const SizedBox(height: 10),
                  Text(post.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const Divider(color: Colors.white24, height: 30),
                  
                  _buildDetailRow(Icons.location_on, "Location", post.location ?? "Not specified"),
                  _buildDetailRow(Icons.contact_phone, "Contact", post.contactInfo ?? "Check description"),
                  _buildDetailRow(Icons.calendar_today, "Posted on", post.createdAt.toString().split('.')[0]),
                  
                  const SizedBox(height: 20),
                  const Text("Description", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(post.description, style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.white70)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: kPrimaryColor, size: 20),
          const SizedBox(width: 10),
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}