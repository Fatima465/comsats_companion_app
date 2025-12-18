// // lib/pages/past_papers_page.dart
// import 'package:cui_companion_app/models/past_paper.dart';
// import 'package:cui_companion_app/pages/past_papers_upload_page.dart';
// import 'package:cui_companion_app/services/past_paper_service.dart';
// import 'package:cui_companion_app/utils/constants.dart';
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';

// class PastPapersPage extends StatelessWidget {
//   const PastPapersPage({super.key});

//   void _downloadPaper(String url) async {
//     final uri = Uri.parse(url);
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri, mode: LaunchMode.externalApplication);
//     } else {
//       // You can replace this with a SnackBar if preferred
//       debugPrint('Could not launch $url');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Past Papers"),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.upload_file),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const PastPapersUploadPage())
//               );
//             },
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(kDefaultPadding / 2),
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: TextField(
//                 decoration: InputDecoration(
//                   hintText: "Search courses, codes, or year...",
//                   prefixIcon: const Icon(Icons.search),
//                   filled: true,
//                   fillColor: kSecondaryColor,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10.0),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//                 onChanged: (query) {
//                   // Search logic can be added here later
//                 },
//               ),
//             ),
//             const SizedBox(height: 8),

//             Expanded(
//               child: StreamBuilder<List<PastPaper>>(
//                 // Uses the corrected service method
//                 stream: PastPaperService().getPastPapersStream(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(child: CircularProgressIndicator());
//                   }

//                   if (snapshot.hasError) {
//                     return Center(child: Text("Error: ${snapshot.error}"));
//                   }

//                   final papers = snapshot.data ?? [];

//                   if (papers.isEmpty) {
//                     return Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Icon(Icons.description_outlined, size: 80, color: Colors.white30),
//                           const SizedBox(height: 20),
//                           const Text("No Past Papers",
//                             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//                           const SizedBox(height: 10),
//                           const Text("Upload past papers to help your fellow students",
//                             textAlign: TextAlign.center, style: TextStyle(color: Colors.white70)),
//                         ],
//                       ),
//                     );
//                   }

//                   return ListView.builder(
//                     itemCount: papers.length,
//                     itemBuilder: (context, index) {
//                       final paper = papers[index];
//                       return Card(
//                         color: kSecondaryColor,
//                         margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
//                         child: ListTile(
//                           leading: const Icon(Icons.picture_as_pdf, color: kPrimaryColor, size: 40),
//                           title: Text("${paper.courseCode}: ${paper.courseName}"),
//                           subtitle: Text(
//                             "${paper.examType} - ${paper.semester} ${paper.year}\n"
//                             "Instructor: ${paper.courseInstructor ?? 'N/A'}\n" // <--- Add this
//                             "Uploaded: ${paper.createdAt.toString().split(' ').first}"
//                           ),
//                           isThreeLine: true,
//                           trailing: IconButton(
//                             icon: const Icon(Icons.download, color: kSuccessColor),
//                             onPressed: () => _downloadPaper(paper.fileUrl),
//                           ),
//                           onTap: () => _downloadPaper(paper.fileUrl),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// lib/pages/past_papers_page.dart
import 'package:cui_companion_app/models/past_paper.dart';
import 'package:cui_companion_app/pages/past_papers_upload_page.dart';
import 'package:cui_companion_app/services/past_paper_service.dart';
import 'package:cui_companion_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PastPapersPage extends StatefulWidget {
  const PastPapersPage({super.key});

  @override
  State<PastPapersPage> createState() => _PastPapersPageState();
}

class _PastPapersPageState extends State<PastPapersPage> {
  final PastPaperService _service = PastPaperService();
  String _searchQuery = '';
  final String? _currentUserId = Supabase.instance.client.auth.currentUser?.id;

  void _downloadPaper(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  // UPDATED: Implementation with SnackBar feedback and Confirmation Dialog
  Future<void> _confirmDelete(BuildContext context, PastPaper paper) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Paper?"),
        content: Text("Are you sure you want to delete ${paper.courseCode}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        // Extracts the path from the URL for storage deletion if needed
        // Assuming your service handles both DB and Storage deletion
        print("Attempting to delete ID: ${paper.id}"); // Debug Log
        await _service.deletePastPaper(paper.id, paper.fileUrl);
        print("Delete successful");
      } catch (e) {
        if (mounted) {
          print("DELETE ERROR: $e"); // This will tell us if it's an RLS issue
          // ... rest of your code
        }
      }
    }
  }

  void _showEditDialog(BuildContext context, PastPaper paper) {
    final nameController = TextEditingController(text: paper.courseName);
    // Assuming courseInstructor is a field in your model
    final instructorController = TextEditingController(
      text: paper.courseInstructor,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Paper Details"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Course Name"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: instructorController,
              decoration: const InputDecoration(labelText: "Instructor"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                print("Attempting to update ID: ${paper.id}"); // Debug Log
                await _service.updatePastPaper(paper.id, {
                  'course_name': nameController.text,
                  'course_instructor': instructorController.text,
                });
                // ignore: use_build_context_synchronously
                print("Update successful");
                if (mounted) Navigator.pop(context);
              } catch (e) {
                print(
                  "UPDATE ERROR: $e",
                ); // This will tell us if it's an RLS issue
                if (mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Update failed: $e")));
                }
              }
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Past Papers"),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PastPapersUploadPage(),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(kDefaultPadding / 2),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) => setState(() => _searchQuery = value),
                decoration: InputDecoration(
                  hintText: "Search courses, codes, or year...",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: kSecondaryColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: StreamBuilder<List<PastPaper>>(
                stream: _service.getPastPapersStream(searchQuery: _searchQuery),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final papers = snapshot.data ?? [];
                  if (papers.isEmpty) {
                    return const Center(child: Text("No papers found."));
                  }

                  return ListView.builder(
                    itemCount: papers.length,
                    itemBuilder: (context, index) {
                      final paper = papers[index];
                      return Card(
                        color: kSecondaryColor,
                        margin: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 8.0,
                        ),
                        child: ListTile(
                          leading: const Icon(
                            Icons.picture_as_pdf,
                            color: kPrimaryColor,
                            size: 40,
                          ),
                          title: Text(
                            "${paper.courseCode}: ${paper.courseName}",
                          ),
                          subtitle: Text(
                            "${paper.examType} - ${paper.semester} ${paper.year}\n"
                            "Instructor: ${paper.courseInstructor ?? 'N/A'}",
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize
                                .min, // Prevents row from taking full width
                            children: [
                              if (paper.uploadedBy == _currentUserId) ...[
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                    size: 20,
                                  ),
                                  onPressed: () => _showEditDialog(
                                    context,
                                    paper,
                                  ), // Linked to correct method
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                  onPressed: () =>
                                      _confirmDelete(context, paper),
                                ),
                              ],
                              IconButton(
                                icon: const Icon(
                                  Icons.download,
                                  color: kSuccessColor,
                                ),
                                onPressed: () => _downloadPaper(paper.fileUrl),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
