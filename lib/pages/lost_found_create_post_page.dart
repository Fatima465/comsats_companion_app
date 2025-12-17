// lib/pages/lost_found_create_post_page.dart

import 'dart:typed_data'; // Needed for image bytes
import 'package:cui_companion_app/auth/auth_service.dart';
import 'package:cui_companion_app/services/lost_and_found_service.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart'; // New Import
import 'package:cui_companion_app/utils/constants.dart'; 

class LostFoundCreatePostPage extends StatefulWidget {
  const LostFoundCreatePostPage({super.key});

  @override
  State<LostFoundCreatePostPage> createState() => _LostFoundCreatePostPageState();
}

class _LostFoundCreatePostPageState extends State<LostFoundCreatePostPage> {
  final _service = LostFoundService(); // <--- UNCOMMENTED
  final _formKey = GlobalKey<FormState>();
  
  String _postType = 'Lost'; 
  String _title = '';
  String _description = '';
  String? _location;
  String? _contactInfo;
  PlatformFile? _selectedImage; // <--- Correct type for web compatibility

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true, // CRITICAL: Get file bytes
    );

    if (result != null) {
      setState(() {
        _selectedImage = result.files.single;
      });
    }
  }

  void _submitPost() async {
    if (!_formKey.currentState!.validate() || _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image and fill all fields.')),
      );
      return;
    }
    
    final fileBytes = _selectedImage!.bytes;
    if (fileBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Could not read image data.')),
      );
      return;
    }

    _formKey.currentState!.save();
    
    final userId = AuthService().getCurrentUserId();
    if (userId == null) {
      // ... error handling
      return;
    }

    try {
      // --- IMPLEMENTED SUPABASE SERVICE CALL HERE ---
      await _service.createPost(
        userId: userId,
        postType: _postType,
        title: _title,
        description: _description,
        location: _location,
        contactInfo: _contactInfo,
        fileData: fileBytes.toList(), // Pass bytes
        fileName: _selectedImage!.name, // Pass file name
      );
      // ... success/error handling
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$_postType post submitted!', style: const TextStyle(color: Colors.white)), backgroundColor: kSuccessColor),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Submission failed: ${e.toString()}'), backgroundColor: kErrorColor),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create $_postType Post')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Image Picker
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image),
                label: Text(_selectedImage == null ? 'Select Image (Required)' : 'Change Image: ${_selectedImage!.name}'),
                style: ElevatedButton.styleFrom(
                   backgroundColor: kPrimaryColor.withAlpha((255 * 0.8).round()),
                   minimumSize: const Size(double.infinity, 50),
                ),
              ),
              if (_selectedImage != null)
                 Padding(
                   padding: const EdgeInsets.only(top: 8.0),
                   child: Text(
                     'Image Size: ${(_selectedImage!.size / 1024).toStringAsFixed(1)} KB',
                     style: const TextStyle(color: Colors.white70),
                   ),
                 ),
              const SizedBox(height: 20),

              // Post Type Selector
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Post Type'),
                initialValue: _postType, // Changed from value:
                items: ['Lost', 'Found'].map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
                onChanged: (val) => setState(() => _postType = val!),
                onSaved: (val) => _postType = val!,
              ),
              const SizedBox(height: 20),
              // ... (rest of the form fields are fine)
              // Title
              TextFormField(
                decoration: InputDecoration(labelText: 'Title (e.g., ${_postType == 'Lost' ? 'Lost Red Backpack' : 'Found CUI ID Card'})'),
                onSaved: (val) => _title = val!,
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 20),

              // Description
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description (Details, Time, Color, etc.)'),
                maxLines: 3,
                onSaved: (val) => _description = val!,
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 20),
              
              // Location (Optional)
              TextFormField(
                decoration: const InputDecoration(labelText: 'Last Seen/Found Location'),
                onSaved: (val) => _location = val,
              ),
              const SizedBox(height: 20),

              // Contact Info (Optional)
              TextFormField(
                decoration: const InputDecoration(labelText: 'Contact Info (Phone/Room No.)'),
                onSaved: (val) => _contactInfo = val,
              ),
              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitPost,
                  child: Text('Submit $_postType Post', style: const TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}