// // // // lib/pages/past_papers_upload_page.dart
// // // import 'dart:io';
// // // import 'package:cui_companion_app/auth/auth_service.dart';
// // // import 'package:cui_companion_app/services/past_paper_service.dart';
// // // import 'package:cui_companion_app/utils/constants.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:file_picker/file_picker.dart';

// // // class PastPapersUploadPage extends StatefulWidget {
// // //   const PastPapersUploadPage({super.key});

// // //   @override
// // //   State<PastPapersUploadPage> createState() => _PastPapersUploadPageState();
// // // }

// // // class _PastPapersUploadPageState extends State<PastPapersUploadPage> {
// // //   final _service = PastPaperService();
// // //   final _formKey = GlobalKey<FormState>();

// // //   // Form fields
// // //   File? _selectedFile;
// // //   String _courseCode = '';
// // //   String _courseName = '';
// // //   int _year = DateTime.now().year;
// // //   String _semester = 'Fall';
// // //   String _examType = 'Mid-Term';

// // //   final List<String> semesters = ['Fall', 'Spring', 'Summer'];
// // //   final List<String> examTypes = ['Mid-Term', 'Final', 'Quiz', 'Assignment'];

// // //   Future<void> _pickFile() async {
// // //     final result = await FilePicker.platform.pickFiles(
// // //       type: FileType.custom,
// // //       allowedExtensions: ['pdf'], // FR5: PDF format
// // //     );

// // //     if (result != null && result.files.single.path != null) {
// // //       setState(() {
// // //         _selectedFile = File(result.files.single.path!);
// // //         if (_courseName.isEmpty) {
// // //           _courseName = result.files.single.name.split('.').first;
// // //         }
// // //       });
// // //     }
// // //   }

// // //   void _uploadPaper() async {
// // //     if (!_formKey.currentState!.validate() || _selectedFile == null) {
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         const SnackBar(content: Text('Please select a PDF and fill all fields.')),
// // //       );
// // //       return;
// // //     }

// // //     _formKey.currentState!.save();

// // //     final userId = AuthService().getCurrentUserId();
// // //     if (userId == null) {
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         const SnackBar(content: Text('Error: User not logged in.')),
// // //       );
// // //       return;
// // //     }

// // //     try {
// // //       await _service.uploadPastPaper(
// // //         file: _selectedFile!,
// // //         userId: userId,
// // //         metadata: {
// // //           'course_code': _courseCode,
// // //           'course_name': _courseName,
// // //           'year': _year,
// // //           'semester': _semester,
// // //           'exam_type': _examType,
// // //         },
// // //       );

// // //       if (mounted) {
// // //         ScaffoldMessenger.of(context).showSnackBar(
// // //           const SnackBar(content: Text('Past Paper uploaded successfully!', style: TextStyle(color: Colors.white)), backgroundColor: kSuccessColor),
// // //         );
// // //         Navigator.pop(context); // Go back to the papers list
// // //       }
// // //     } catch (e) {
// // //       if (mounted) {
// // //         ScaffoldMessenger.of(context).showSnackBar(
// // //           SnackBar(content: Text(e.toString()), backgroundColor: kErrorColor),
// // //         );
// // //       }
// // //     }
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(title: const Text('Upload Past Paper')),
// // //       body: SingleChildScrollView(
// // //         padding: const EdgeInsets.all(kDefaultPadding),
// // //         child: Form(
// // //           key: _formKey,
// // //           child: Column(
// // //             crossAxisAlignment: CrossAxisAlignment.start,
// // //             children: [
// // //               // File Picker Section
// // //               ElevatedButton.icon(
// // //                 onPressed: _pickFile,
// // //                 icon: const Icon(Icons.picture_as_pdf),
// // //                 label: Text(_selectedFile == null ? 'Select PDF File (FR5)' : 'Change File'),
// // //                 style: ElevatedButton.styleFrom(
// // //                   backgroundColor: kPrimaryColor.withOpacity(0.8),
// // //                   minimumSize: const Size(double.infinity, 50),
// // //                 ),
// // //               ),
// // //               if (_selectedFile != null)
// // //                 Padding(
// // //                   padding: const EdgeInsets.only(top: 8.0),
// // //                   child: Text(
// // //                     'File: ${_selectedFile!.path.split('/').last}',
// // //                     style: const TextStyle(color: Colors.white70),
// // //                   ),
// // //                 ),
// // //               const SizedBox(height: 20),

// // //               // Course Code Field
// // //               TextFormField(
// // //                 decoration: const InputDecoration(labelText: 'Course Code (e.g., CS-305)'),
// // //                 onSaved: (val) => _courseCode = val!,
// // //                 validator: (val) => val!.isEmpty ? 'Required' : null,
// // //               ),
// // //               const SizedBox(height: 20),

// // //               // Course Name Field
// // //               TextFormField(
// // //                 initialValue: _courseName,
// // //                 decoration: const InputDecoration(labelText: 'Course Name'),
// // //                 onSaved: (val) => _courseName = val!,
// // //                 validator: (val) => val!.isEmpty ? 'Required' : null,
// // //               ),
// // //               const SizedBox(height: 20),

// // //               // Year Selector
// // //               DropdownButtonFormField<int>(
// // //                 decoration: const InputDecoration(labelText: 'Year'),
// // //                 value: _year,
// // //                 items: List.generate(10, (index) => DateTime.now().year - index)
// // //                     .map((year) => DropdownMenuItem(value: year, child: Text(year.toString())))
// // //                     .toList(),
// // //                 onChanged: (val) => setState(() => _year = val!),
// // //                 onSaved: (val) => _year = val!,
// // //               ),
// // //               const SizedBox(height: 20),

// // //               // Semester Selector
// // //               DropdownButtonFormField<String>(
// // //                 decoration: const InputDecoration(labelText: 'Semester'),
// // //                 value: _semester,
// // //                 items: semesters.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
// // //                 onChanged: (val) => setState(() => _semester = val!),
// // //                 onSaved: (val) => _semester = val!,
// // //               ),
// // //               const SizedBox(height: 20),

// // //               // Exam Type Selector
// // //               DropdownButtonFormField<String>(
// // //                 decoration: const InputDecoration(labelText: 'Exam Type'),
// // //                 value: _examType,
// // //                 items: examTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
// // //                 onChanged: (val) => setState(() => _examType = val!),
// // //                 onSaved: (val) => _examType = val!,
// // //               ),
// // //               const SizedBox(height: 40),

// // //               // Upload Button
// // //               SizedBox(
// // //                 width: double.infinity,
// // //                 child: ElevatedButton(
// // //                   onPressed: _uploadPaper,
// // //                   child: const Text('Upload Paper', style: TextStyle(fontSize: 18)),
// // //                 ),
// // //               ),
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }

// // lib/pages/past_papers_upload_page.dart

// import 'dart:typed_data';
// import 'package:cui_companion_app/auth/auth_service.dart';
// import 'package:cui_companion_app/services/past_paper_service.dart'; // Ensure this service is updated!
// import 'package:cui_companion_app/utils/constants.dart';
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';

// class PastPapersUploadPage extends StatefulWidget {
//   const PastPapersUploadPage({super.key});

//   @override
//   State<PastPapersUploadPage> createState() => _PastPapersUploadPageState();
// }

// class _PastPapersUploadPageState extends State<PastPapersUploadPage> {
//   final _service = PastPaperService();
//   final _formKey = GlobalKey<FormState>();

//   // Form fields
//   PlatformFile? _selectedFile;
//   String _courseCode = '';
//   String _courseName = '';
//   String _courseInstructor = '';
//   int _year = DateTime.now().year;
//   String _semester = 'Fall';
//   String _examType = 'Mid-Term';

//   final List<String> semesters = ['Fall', 'Spring', 'Summer'];
//   final List<String> examTypes = ['Mid-Term', 'Final', 'Quiz', 'Assignment'];

//   Future<void> _pickFile() async {
//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf'],
//       withData: true, // CRITICAL: Get file bytes for web upload
//     );

//     if (result != null) {
//       setState(() {
//         _selectedFile = result.files.single;
//         if (_courseName.isEmpty) {
//           _courseName = _selectedFile!.name.split('.').first;
//         }
//       });
//     }
//   }

//   void _uploadPaper() async {
//     if (!_formKey.currentState!.validate() || _selectedFile == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please select a PDF and fill all fields.')),
//       );
//       return;
//     }

//     final fileBytes = _selectedFile!.bytes;
//     if (fileBytes == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Error: Could not read file data.')),
//       );
//       return;
//     }

//     _formKey.currentState!.save();

//     final userId = AuthService().getCurrentUserId();
//     if (userId == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Error: User not logged in.')),
//       );
//       return;
//     }

//     try {
//       // 🐛 FIX HERE: Changed 'file' to 'fileData' and added 'fileName'
//       await _service.uploadPastPaper(
//         fileData: fileBytes.toList(), // The required List<int> data
//         fileName: _selectedFile!.name, // The required file name
//         userId: userId,
//         metadata: {
//           'course_code': _courseCode,
//           'course_name': _courseName,
//           'instructor_name': _courseInstructorName,
//           'year': _year,
//           'semester': _semester,
//           'exam_type': _examType,
//         },
//       );

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Past Paper uploaded successfully!', style: TextStyle(color: Colors.white)), backgroundColor: kSuccessColor),
//         );
//         Navigator.pop(context);
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Upload failed: ${e.toString()}'), backgroundColor: kErrorColor),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Upload Past Paper')),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(kDefaultPadding),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // File Picker Section
//               ElevatedButton.icon(
//                 onPressed: _pickFile,
//                 icon: const Icon(Icons.picture_as_pdf),
//                 label: Text(_selectedFile == null ? 'Select PDF File (FR5)' : 'Change File'),
//                 style: ElevatedButton.styleFrom(
//                   // FIX: Deprecation warning for withOpacity
//                   backgroundColor: kPrimaryColor.withAlpha((255 * 0.8).round()),
//                   minimumSize: const Size(double.infinity, 50),
//                 ),
//               ),
//               if (_selectedFile != null)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 8.0),
//                   child: Text(
//                     'File: ${_selectedFile!.name}',
//                     style: const TextStyle(color: Colors.white70),
//                   ),
//                 ),
//               const SizedBox(height: 20),

//               // Course Code Field
//               TextFormField(
//                 decoration: const InputDecoration(labelText: 'Course Code (e.g., CS-305)'),
//                 onSaved: (val) => _courseCode = val!,
//                 validator: (val) => val!.isEmpty ? 'Required' : null,
//               ),
//               const SizedBox(height: 20),

//               // Course Name Field
//               TextFormField(
//                 initialValue: _courseName,
//                 decoration: const InputDecoration(labelText: 'Course Name'),
//                 onSaved: (val) => _courseName = val!,
//                 validator: (val) => val!.isEmpty ? 'Required' : null,
//               ),
//               const SizedBox(height: 20),
// TextFormField(
//   decoration: const InputDecoration(labelText: "Course Instructor"),
//   onSaved: (v) => _courseInstructor = v!,
//   validator: (v) => v!.isEmpty ? "Required" : null,
// ),
//               // Year Selector
//               DropdownButtonFormField<int>(
//                 decoration: const InputDecoration(labelText: 'Year'),
//                 // FIX: Deprecation warning: changed 'value' to 'initialValue' (preferred usage)
//                 initialValue: _year,
//                 items: List.generate(10, (index) => DateTime.now().year - index)
//                     .map((year) => DropdownMenuItem(value: year, child: Text(year.toString())))
//                     .toList(),
//                 onChanged: (val) => setState(() => _year = val!),
//                 onSaved: (val) => _year = val!,
//               ),
//               const SizedBox(height: 20),

//               // Semester Selector
//               DropdownButtonFormField<String>(
//                 decoration: const InputDecoration(labelText: 'Semester'),
//                 // FIX: Deprecation warning: changed 'value' to 'initialValue'
//                 initialValue: _semester,
//                 items: semesters.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
//                 onChanged: (val) => setState(() => _semester = val!),
//                 onSaved: (val) => _semester = val!,
//               ),
//               const SizedBox(height: 20),

//               // Exam Type Selector
//               DropdownButtonFormField<String>(
//                 decoration: const InputDecoration(labelText: 'Exam Type'),
//                 // FIX: Deprecation warning: changed 'value' to 'initialValue'
//                 initialValue: _examType,
//                 items: examTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
//                 onChanged: (val) => setState(() => _examType = val!),
//                 onSaved: (val) => _examType = val!,
//               ),
//               const SizedBox(height: 40),

//               // Upload Button
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: _uploadPaper,
//                   child: const Text('Upload Paper', style: TextStyle(fontSize: 18)),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// // // lib/pages/past_papers_upload_page.dart
// // import 'package:cui_companion_app/auth/auth_service.dart';
// // import 'package:cui_companion_app/services/past_paper_service.dart';
// // import 'package:cui_companion_app/utils/constants.dart';
// // import 'package:flutter/material.dart';
// // import 'package:file_picker/file_picker.dart';

// // class PastPapersUploadPage extends StatefulWidget {
// //   const PastPapersUploadPage({super.key});
// //   @override
// //   State<PastPapersUploadPage> createState() => _PastPapersUploadPageState();
// // }

// // class _PastPapersUploadPageState extends State<PastPapersUploadPage> {
// //   final _service = PastPaperService();
// //   final _formKey = GlobalKey<FormState>();
// //   PlatformFile? _file;
// //   String _code = '', _name = '';

// //   void _submit() async {
// //     if (_file?.bytes == null) {
// //        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select a PDF file first")));
// //        return;
// //     }
// //     if (!_formKey.currentState!.validate()) return;
// //     _formKey.currentState!.save();

// //     try {
// //       showDialog(context: context, barrierDismissible: false, builder: (_) => const Center(child: CircularProgressIndicator()));
      
// //       await _service.uploadPastPaper(
// //         fileData: _file!.bytes!,
// //         fileName: _file!.name,
// //         userId: AuthService().getCurrentUserId()!,
// //         metadata: {
// //           'course_code': _code, 
// //           'course_name': _name, 
// //           'year': DateTime.now().year, 
// //           'semester': 'Fall', 
// //           'exam_type': 'Mid-Term'
// //         },
// //       );
      
// //       if (mounted) {
// //         Navigator.pop(context); // Close loading
// //         Navigator.pop(context); // Go back
// //         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Success!"), backgroundColor: kSuccessColor));
// //       }
// //     } catch (e) {
// //       if (mounted) {
// //         Navigator.pop(context); // Close loading
// //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: kErrorColor));
// //       }
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: const Text("Upload Past Paper")),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Form(
// //           key: _formKey,
// //           child: Column(
// //             children: [
// //               ElevatedButton.icon(
// //                 onPressed: () async {
// //                   final res = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf'], withData: true);
// //                   if (res != null) setState(() => _file = res.files.single);
// //                 },
// //                 icon: const Icon(Icons.picture_as_pdf),
// //                 label: Text(_file == null ? "Select PDF" : _file!.name),
// //               ),
// //               const SizedBox(height: 20),
// //               TextFormField(decoration: const InputDecoration(labelText: "Course Code"), onSaved: (v) => _code = v!, validator: (v) => v!.isEmpty ? "Required" : null),
// //               const SizedBox(height: 10),
// //               TextFormField(decoration: const InputDecoration(labelText: "Course Name"), onSaved: (v) => _name = v!, validator: (v) => v!.isEmpty ? "Required" : null),
// //               const SizedBox(height: 30),
// //               SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _submit, child: const Text("Upload Paper"))),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }


// lib/pages/past_papers_upload_page.dart
import 'dart:typed_data';
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
  PlatformFile? _selectedFile;
  String _courseCode = '';
  String _courseName = '';
  String _courseInstructor = ''; // 1. Added variable
  int _year = DateTime.now().year;
  String _semester = 'Fall';
  String _examType = 'Mid-Term';

  final List<String> semesters = ['Fall', 'Spring', 'Summer'];
  final List<String> examTypes = ['Mid-Term', 'Final', 'Quiz', 'Assignment'];

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true,
    );

    if (result != null) {
      setState(() {
        _selectedFile = result.files.single;
        if (_courseName.isEmpty) {
          _courseName = _selectedFile!.name.split('.').first;
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

    final fileBytes = _selectedFile!.bytes;
    if (fileBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Could not read file data.')),
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
        fileData: fileBytes.toList(),
        fileName: _selectedFile!.name,
        userId: userId,
        metadata: {
          'course_code': _courseCode,
          'course_name': _courseName,
          'course_instructor': _courseInstructor, // 2. Added to metadata map
          'year': _year,
          'semester': _semester,
          'exam_type': _examType,
        },
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Past Paper uploaded successfully!', style: TextStyle(color: Colors.white)),
            backgroundColor: kSuccessColor,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Upload failed: ${e.toString()}'),
            backgroundColor: kErrorColor,
          ),
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
              ElevatedButton.icon(
                onPressed: _pickFile,
                icon: const Icon(Icons.picture_as_pdf),
                label: Text(_selectedFile == null ? 'Select PDF File' : 'Change File'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor.withAlpha((255 * 0.8).round()),
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
              if (_selectedFile != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'File: ${_selectedFile!.name}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
              const SizedBox(height: 20),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Course Code (e.g., CS-305)'),
                onSaved: (val) => _courseCode = val!,
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 20),

              TextFormField(
                initialValue: _courseName,
                decoration: const InputDecoration(labelText: 'Course Name'),
                onSaved: (val) => _courseName = val!,
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 20),

              // 3. Added the Instructor TextFormField
              TextFormField(
                decoration: const InputDecoration(labelText: "Course Instructor"),
                onSaved: (v) => _courseInstructor = v!,
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 20),

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

              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Semester'),
                value: _semester,
                items: semesters.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (val) => setState(() => _semester = val!),
                onSaved: (val) => _semester = val!,
              ),
              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Exam Type'),
                value: _examType,
                items: examTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (val) => setState(() => _examType = val!),
                onSaved: (val) => _examType = val!,
              ),
              const SizedBox(height: 40),

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