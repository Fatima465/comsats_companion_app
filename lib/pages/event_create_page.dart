// import 'dart:typed_data';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../services/event_service.dart';

// class EventCreatePage extends StatefulWidget {
//   const EventCreatePage({super.key});

//   @override
//   State<EventCreatePage> createState() => _EventCreatePageState();
// }

// class _EventCreatePageState extends State<EventCreatePage> {
//   final _formKey = GlobalKey<FormState>();
//   final _titleController = TextEditingController();
//   final _descController = TextEditingController();
//   final _locationController = TextEditingController();
  
//   PlatformFile? _pickedFile;
//   bool _isLoading = false;

//   Future<void> _pickImage() async {
//     final result = await FilePicker.platform.pickFiles(type: FileType.image, withData: true);
//     if (result != null) setState(() => _pickedFile = result as PlatformFile?);
//   }

//   Future<void> _saveEvent() async {
//     if (!_formKey.currentState!.validate()) return;
//     setState(() => _isLoading = true);

//     try {
//       String? imageUrl;
//       if (_pickedFile != null) {
//         // Upload image to 'event_images' bucket
//         final fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
//         await Supabase.instance.client.storage
//             .from('event_images')
//             .uploadBinary(fileName, _pickedFile!.bytes!);
//         imageUrl = Supabase.instance.client.storage.from('event_images').getPublicUrl(fileName);
//       }

//       await Supabase.instance.client.from('events').insert({
//         'title': _titleController.text,
//         'description': _descController.text,
//         'location': _locationController.text,
//         'image_url': imageUrl,
//         'event_date': DateTime.now().toIso8601String(), // You can add a DatePicker here
//         'status': 'Upcoming',
//         'is_featured': false,
//       });

//       // ignore: use_build_context_synchronously
//       Navigator.pop(context);
//     } catch (e) {
//       // ignore: use_build_context_synchronously
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Create Event")),
//       body: Form(
//         key: _formKey,
//         child: ListView(
//           padding: const EdgeInsets.all(16),
//           children: [
//             GestureDetector(
//               onTap: _pickImage,
//               child: Container(
//                 height: 150,
//                 color: Colors.grey[800],
//                 child: _pickedFile == null 
//                   ? const Icon(Icons.add_a_photo, size: 50) 
//                   : Image.memory(_pickedFile!.bytes!, fit: BoxFit.cover),
//               ),
//             ),
//             TextFormField(controller: _titleController, decoration: const InputDecoration(labelText: 'Event Title')),
//             TextFormField(controller: _descController, maxLines: 3, decoration: const InputDecoration(labelText: 'Description')),
//             TextFormField(controller: _locationController, decoration: const InputDecoration(labelText: 'Location')),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _isLoading ? null : _saveEvent,
//               child: _isLoading ? const CircularProgressIndicator() : const Text("Post Event"),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../services/event_service.dart';

class EventCreatePage extends StatefulWidget {
  const EventCreatePage({super.key});

  @override
  State<EventCreatePage> createState() => _EventCreatePageState();
}

class _EventCreatePageState extends State<EventCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _locationController = TextEditingController();
  
  // Changed this to PlatformFile to match the picker result
  PlatformFile? _pickedFile;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    // withData: true is REQUIRED to get the bytes for upload
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image, 
      withData: true,
    );
    
    if (result != null) {
      setState(() {
        _pickedFile = result.files.first;
      });
    }
  }

  Future<void> _saveEvent() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);

    try {
      // 1. Prepare your data map
      final eventData = {
        'title': _titleController.text.trim(),
        'description': _descController.text.trim(),
        'location': _locationController.text.trim(),
        'event_date': DateTime.now().toIso8601String().split('T').first,
        'status': 'Upcoming',
        'is_featured': false,
      };

      // 2. Call the service using the bytes from the picked file
      await EventService().createEvent(
        eventData, 
        _pickedFile?.bytes, // These are the actual image bytes
      );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Event Posted Successfully!"), 
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      debugPrint("UPLOAD ERROR: $e"); 
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Upload Failed: $e"), 
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Event")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _pickedFile == null 
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_a_photo, size: 50, color: Colors.white54),
                        Text("Select Event Image", style: TextStyle(color: Colors.white54)),
                      ],
                    ) 
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.memory(_pickedFile!.bytes!, fit: BoxFit.cover),
                    ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleController, 
              decoration: const InputDecoration(labelText: 'Event Title', border: OutlineInputBorder()),
              validator: (v) => v!.isEmpty ? "Enter title" : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descController, 
              maxLines: 3, 
              decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
              validator: (v) => v!.isEmpty ? "Enter description" : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _locationController, 
              decoration: const InputDecoration(labelText: 'Location', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor),
                onPressed: _isLoading ? null : _saveEvent,
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white) 
                  : const Text("Post Event", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            )
          ],
        ),
      ),
    );
  }
}