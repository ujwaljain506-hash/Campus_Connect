import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/study_resource.dart';
import '../../services/firestore_service.dart';

import '../../services/storage_service.dart';

class StudyHubScreen extends StatefulWidget {
  @override
  State<StudyHubScreen> createState() => _StudyHubScreenState();
}

class _StudyHubScreenState extends State<StudyHubScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();
  final StorageService _storageService = StorageService();
  String? _selectedFilePath;
  String? _selectedFileName;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    subjectController.dispose();
    super.dispose();
  }
    Future<void> _pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
    );

    if (result != null) {
        setState(() {
        _selectedFilePath = result.files.single.path;
        _selectedFileName = result.files.single.name;
        });
    }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Hub'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: subjectController,
              decoration: const InputDecoration(
                labelText: 'Subject',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: _pickPDF,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.picture_as_pdf, color: Colors.red),
                    const SizedBox(width: 12),
                    Text(
                      _selectedFileName ?? 'Tap to select PDF',
                      style: TextStyle(
                        color: _selectedFileName != null
                            ? Colors.black
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (_selectedFilePath == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select a PDF')),
                    );
                    return;
                  }

                  final currentUser = FirebaseAuth.instance.currentUser;
                  if (currentUser == null) return;

                  final fileUrl = await _storageService.uploadPDF(
                    _selectedFilePath!,
                    _selectedFileName!,
                  );

                  if (fileUrl == null) return;

                  final resource = StudyResource(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: titleController.text,
                    description: descriptionController.text,
                    fileUrl: fileUrl,
                    subject: subjectController.text,
                    uploadedBy: currentUser.email ?? 'Anonymous',
                    createdAt: DateTime.now(),
                  );

                  await _firestoreService.addStudyResource(resource);

                  titleController.clear();
                  descriptionController.clear();
                  subjectController.clear();
                  setState(() {
                    _selectedFilePath = null;
                    _selectedFileName = null;
                  });

                  print('Resource uploaded successfully!');
                },
                child: const Text('Upload Notes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}