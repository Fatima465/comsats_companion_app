// lib/pages/past_papers_page.dart
import 'package:cui_companion_app/models/past_paper.dart';
import 'package:cui_companion_app/pages/past_papers_upload_page.dart';
import 'package:cui_companion_app/services/past_paper_service.dart';
import 'package:cui_companion_app/utils/constants.dart';
import 'package:flutter/material.dart';

// ignore: depend_on_referenced_packages
import 'package:url_launcher/url_launcher.dart';

class PastPapersPage extends StatelessWidget {
  const PastPapersPage({super.key});
  
  void _downloadPaper(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      // NOTE: Incrementing download_count requires a separate Supabase RPC or function call
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    // UI based on image_b73a0d.png
    return Scaffold(
      appBar: AppBar(
        title: const Text("Past Papers"),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const PastPapersUploadPage()));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(kDefaultPadding / 2),
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search courses, codes, or year...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (query) {
                  // TODO: Implement search/filtering logic here
                },
              ),
            ),
            const SizedBox(height: 8),

            Expanded(
              child: StreamBuilder<List<PastPaper>>(
                stream: PastPaperService().getPastPapersStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text("Error loading papers: ${snapshot.error}"));
                  }

                  final papers = snapshot.data ?? [];

                  if (papers.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.description_outlined, size: 80, color: Colors.white30),
                          const SizedBox(height: 20),
                          const Text("No Past Papers", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          const Text("Upload past papers to help your fellow students", textAlign: TextAlign.center, style: TextStyle(color: Colors.white70)),
                        ],
                      ),
                    );
                  }

                  // FR7: Display the list of past papers
                  return ListView.builder(
                    itemCount: papers.length,
                    itemBuilder: (context, index) {
                      final paper = papers[index];
                      return Card(
                        color: kSecondaryColor,
                        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                        child: ListTile(
                          leading: const Icon(Icons.picture_as_pdf, color: kPrimaryColor, size: 40),
                          title: Text("${paper.courseCode}: ${paper.courseName}"),
                          subtitle: Text("${paper.examType} - ${paper.semester} ${paper.year}\nUploaded: ${paper.createdAt.toString().split(' ').first}"),
                          isThreeLine: true,
                          trailing: IconButton(
                            icon: const Icon(Icons.download, color: kSuccessColor),
                            onPressed: () => _downloadPaper(paper.fileUrl),
                          ),
                          onTap: () => _downloadPaper(paper.fileUrl),
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