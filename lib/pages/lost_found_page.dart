// // lib/pages/lost_found_page.dart
// import 'package:flutter/material.dart';

// class LostFoundPage extends StatelessWidget {
//   const LostFoundPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // UI based on image_b739d2.png
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Lost & Found"),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.add),
//             onPressed: () {
//               // TODO: Implement 'Create Post' logic (FR10)
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Filter Buttons
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//             child: Row(
//               children: [
//                 _buildFilterChip("All", true),
//                 const SizedBox(width: 10),
//                 _buildFilterChip("Lost", false),
//                 const SizedBox(width: 10),
//                 _buildFilterChip("Found", false),
//               ],
//             ),
//           ),
//           const SizedBox(height: 50),
//           // Content (No Posts Yet)
//           Expanded(
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.location_searching_outlined,
//                     size: 80,
//                     color: Colors.white30,
//                   ),
//                   const SizedBox(height: 20),
//                   const Text(
//                     "No Posts Yet",
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 10),
//                   const Text(
//                     "Help the community by posting lost or found items",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(color: Colors.white70),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildFilterChip(String label, bool isSelected) {
//     return Chip(
//       label: Text(label),
//       backgroundColor: isSelected ? const Color(0xFF4A90E2) : const Color(0xFF2E3A59),
//       labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.white70),
//     );
//   }
// }

// // lib/pages/lost_found_page.dart
// import 'package:cui_companion_app/models/lost_found_post.dart';
// import 'package:cui_companion_app/pages/lost_found_create_post_page.dart'; // New Import
// // import 'package:cui_companion_app/services/lost_found_service.dart'; // Will be created next
// import 'package:cui_companion_app/utils/constants.dart';
// import 'package:flutter/material.dart';


// class LostFoundPage extends StatefulWidget { // <--- CHANGE: Convert to StatefulWidget
//   const LostFoundPage({super.key});

//   @override
//   State<LostFoundPage> createState() => _LostFoundPageState();
// }

// class _LostFoundPageState extends State<LostFoundPage> { // <--- New State Class
//   String _currentFilter = 'All'; // 'All', 'Lost', or 'Found'
  
//   // final _service = LostFoundService(); // Uncomment when service is created

//   // This is the function to mark an ACTIVE 'Lost' post as 'Resolved'

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Lost & Found"),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.add),
//             onPressed: () {
//               // Navigate to the new creation page
//               Navigator.push(context, MaterialPageRoute(builder: (context) => const LostFoundCreatePostPage()));
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Filter Buttons
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//             child: Row(
//               children: [
//                 _buildFilterChip("All"),
//                 const SizedBox(width: 10),
//                 _buildFilterChip("Lost"),
//                 const SizedBox(width: 10),
//                 _buildFilterChip("Found"),
//               ],
//             ),
//           ),
          
//           Expanded(
//             // TODO: Replace with StreamBuilder from LostFoundService
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Icon(
//                     Icons.location_searching_outlined,
//                     size: 80,
//                     color: Colors.white30,
//                   ),
//                   const SizedBox(height: 20),
//                   const Text(
//                     "No Posts Yet",
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 10),
//                   const Text(
//                     "Help the community by posting lost or found items",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(color: Colors.white70),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildFilterChip(String label) {
//     final isSelected = _currentFilter == label;
//     return ActionChip( // <--- CHANGE: Use ActionChip for interaction
//       label: Text(label),
//       onPressed: () {
//         setState(() {
//           _currentFilter = label; // Update the filter state
//         });
//         // TODO: Call your StreamBuilder's refresh logic here 
//       },
//       backgroundColor: isSelected ? const Color(0xFF4A90E2) : const Color(0xFF2E3A59),
//       labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.white70),
//     );
//   }
// }





import 'package:cui_companion_app/models/lost_found_post.dart';
import 'package:cui_companion_app/pages/lost_found_create_post_page.dart';
import 'package:cui_companion_app/services/lost_and_found_service.dart'; // Ensure correct import
import 'package:cui_companion_app/utils/constants.dart';
import 'package:flutter/material.dart';

class LostFoundPage extends StatefulWidget {
  const LostFoundPage({super.key});

  @override
  State<LostFoundPage> createState() => _LostFoundPageState();
}

class _LostFoundPageState extends State<LostFoundPage> {
  String _currentFilter = 'All';
  final _service = LostFoundService(); // Initialized service

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lost & Found"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LostFoundCreatePostPage()),
              );
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
                _buildFilterChip("All"),
                const SizedBox(width: 10),
                _buildFilterChip("Lost"),
                const SizedBox(width: 10),
                _buildFilterChip("Found"),
              ],
            ),
          ),

          // --- DYNAMIC CONTENT STARTS HERE ---
          Expanded(
            child: StreamBuilder<List<LostFoundPost>>(
              stream: _service.getPostsStream(filterType: _currentFilter),
              builder: (context, snapshot) {
                // 1. Show Loading Indicator
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // 2. Show Error if any
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                final posts = snapshot.data ?? [];

                // 3. Show "No Posts Yet" ONLY if the list is empty
                if (posts.isEmpty) {
                  return _buildNoPostsView();
                }

                // 4. Show the actual list of posts
                return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return Card(
                      color: const Color(0xFF2E3A59),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: post.imageUrl != null 
                          ? Image.network(post.imageUrl!, width: 50, height: 50, fit: BoxFit.cover)
                          : const Icon(Icons.image_not_supported),
                        title: Text(post.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("${post.postType.toUpperCase()} - ${post.location ?? 'No location'}"),
                        trailing: const Icon(Icons.chevron_right, color: Colors.white54),
                        onTap: () {
                          // TODO: Navigate to detail page
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _currentFilter == label;
    return ActionChip(
      label: Text(label),
      onPressed: () => setState(() => _currentFilter = label),
      backgroundColor: isSelected ? const Color(0xFF4A90E2) : const Color(0xFF2E3A59),
      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.white70),
    );
  }

  Widget _buildNoPostsView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.location_searching_outlined, size: 80, color: Colors.white30),
          const SizedBox(height: 20),
          const Text("No Posts Found", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text(
            "No $_currentFilter items reported yet.",
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}