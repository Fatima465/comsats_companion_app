// lib/pages/past_papers_upload_page.dart
import 'dart:io';
import 'package:cui_companion_app/auth/auth_service.dart';
import 'package:cui_companion_app/services/past_paper_service.dart';
import 'package:cui_companion_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';


class PastPapersUploadPage extends StatefulWidget {
  const PastPapersUploadPage({super.key});

  @override
  State<PastPapersUploadPage> createState() => _PastPapersUploadPageState();
}

class _PastPapersUploadPageState extends State<PastPapersUploadPage> {
  final _service = PastPaperService();
  final _formKey = GlobalKey<FormState>();
  
  // Form fields
  File? _selectedFile;
  String _courseCode = '';
  String _courseName = '';
  int _year = DateTime.now().year;
  String _semester = 'Fall';
  String _examType = 'Mid-Term';

  final List<String> semesters = ['Fall', 'Spring', 'Summer'];
  final List<String> examTypes = ['Mid-Term', 'Final', 'Quiz', 'Assignment'];

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'], // FR5: PDF format
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
        if (_courseName.isEmpty) {
          _courseName = result.files.single.name.split('.').first;
        }
      });
    }
  }

  void _uploadPaper() async {
    if (!_formKey.currentState!.validate() || _selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a PDF and fill all fields.')),
      );
      return;
    }
    
    _formKey.currentState!.save();
    
    final userId = AuthService().getCurrentUserId();
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: User not logged in.')),
      );
      return;
    }

    try {
      await _service.uploadPastPaper(
        file: _selectedFile!,
        userId: userId,
        metadata: {
          'course_code': _courseCode,
          'course_name': _courseName,
          'year': _year,
          'semester': _semester,
          'exam_type': _examType,
        },
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Past Paper uploaded successfully!', style: TextStyle(color: Colors.white)), backgroundColor: kSuccessColor),
        );
        Navigator.pop(context); // Go back to the papers list
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: kErrorColor),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Past Paper')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // File Picker Section
              ElevatedButton.icon(
                onPressed: _pickFile,
                icon: const Icon(Icons.picture_as_pdf),
                label: Text(_selectedFile == null ? 'Select PDF File (FR5)' : 'Change File'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor.withOpacity(0.8),
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
              if (_selectedFile != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'File: ${_selectedFile!.path.split('/').last}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
              const SizedBox(height: 20),

              // Course Code Field
              TextFormField(
                decoration: const InputDecoration(labelText: 'Course Code (e.g., CS-305)'),
                onSaved: (val) => _courseCode = val!,
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 20),

              // Course Name Field
              TextFormField(
                initialValue: _courseName,
                decoration: const InputDecoration(labelText: 'Course Name'),
                onSaved: (val) => _courseName = val!,
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 20),

              // Year Selector
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: 'Year'),
                value: _year,
                items: List.generate(10, (index) => DateTime.now().year - index)
                    .map((year) => DropdownMenuItem(value: year, child: Text(year.toString())))
                    .toList(),
                onChanged: (val) => setState(() => _year = val!),
                onSaved: (val) => _year = val!,
              ),
              const SizedBox(height: 20),

              // Semester Selector
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Semester'),
                value: _semester,
                items: semesters.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (val) => setState(() => _semester = val!),
                onSaved: (val) => _semester = val!,
              ),
              const SizedBox(height: 20),

              // Exam Type Selector
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Exam Type'),
                value: _examType,
                items: examTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (val) => setState(() => _examType = val!),
                onSaved: (val) => _examType = val!,
              ),
              const SizedBox(height: 40),

              // Upload Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _uploadPaper,
                  child: const Text('Upload Paper', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}