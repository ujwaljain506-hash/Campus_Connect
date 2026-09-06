import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/study_resource.dart';
import '../../services/firestore_service.dart';
import '../../services/storage_service.dart';
import 'doubt_forum_screen.dart';

class StudyHubScreen extends StatefulWidget {
  const StudyHubScreen({super.key});

  @override
  State<StudyHubScreen> createState() => _StudyHubScreenState();
}

class _StudyHubScreenState extends State<StudyHubScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _subjectController = TextEditingController();
  final _firestoreService = FirestoreService();
  final _storageService = StorageService();

  String? _selectedFilePath;
  String? _selectedFileName;
  bool _isUploading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _subjectController.dispose();
    super.dispose();
  }

  Future<void> _pickPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (!mounted || result == null) return;

    setState(() {
      _selectedFilePath = result.files.single.path;
      _selectedFileName = result.files.single.name;
    });
  }

  Future<void> _openPdf(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null || !await canLaunchUrl(uri)) return;

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _uploadResource() async {
    if (_selectedFilePath == null || _selectedFileName == null) {
      _showMessage('Please select a PDF');
      return;
    }

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      _showMessage('Please sign in to upload notes');
      return;
    }

    setState(() => _isUploading = true);

    try {
      final fileUrl = await _storageService.uploadPDF(
        _selectedFilePath!,
        _selectedFileName!,
      );

      if (fileUrl == null) {
        _showMessage('Could not upload the PDF');
        return;
      }

      final resource = StudyResource(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        fileUrl: fileUrl,
        subject: _subjectController.text.trim(),
        uploadedBy: currentUser.email ?? 'Anonymous',
        createdAt: DateTime.now(),
      );

      await _firestoreService.addStudyResource(resource);

      if (!mounted) return;
      _titleController.clear();
      _descriptionController.clear();
      _subjectController.clear();
      setState(() {
        _selectedFilePath = null;
        _selectedFileName = null;
      });
      _showMessage('Resource uploaded successfully');
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildFilePicker() {
    return InkWell(
      onTap: _isUploading ? null : _pickPdf,
      borderRadius: BorderRadius.circular(8),
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
            Expanded(
              child: Text(
                _selectedFileName ?? 'Tap to select PDF',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: _selectedFileName == null
                      ? Colors.grey
                      : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceList() {
    return StreamBuilder<List<StudyResource>>(
      stream: _firestoreService.getStudyResources(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final resources = snapshot.data ?? [];
        if (resources.isEmpty) {
          return const Center(child: Text('No notes uploaded yet'));
        }

        return ListView.builder(
          itemCount: resources.length,
          itemBuilder: (context, index) {
            final resource = resources[index];
            return Card(
              child: ListTile(
                leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                title: Text(resource.title),
                subtitle: Text(
                  '${resource.subject} • ${resource.uploadedBy}',
                ),
                trailing: IconButton(
                  tooltip: 'Open PDF',
                  icon: const Icon(Icons.download),
                  onPressed: () => _openPdf(resource.fileUrl),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Study Hub')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTextField(controller: _titleController, label: 'Title'),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _descriptionController,
              label: 'Description',
            ),
            const SizedBox(height: 12),
            _buildTextField(controller: _subjectController, label: 'Subject'),
            const SizedBox(height: 12),
            _buildFilePicker(),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isUploading ? null : _uploadResource,
                child: Text(_isUploading ? 'Uploading...' : 'Upload Notes'),
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.forum, color: Colors.blue),
              title: const Text('Doubt Forum'),
              subtitle: const Text('Ask and answer questions'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DoubtForumScreen(),
                  ),
                );
              },
            ),
            const Text(
              'Uploaded Notes',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(child: _buildResourceList()),
          ],
        ),
      ),
    );
  }
}