import 'dart:io';
import '../../services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/post.dart';
import '../../services/storage_service.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}


class _CreatePostScreenState extends State<CreatePostScreen> {
    final TextEditingController captionController = TextEditingController();
    final FirestoreService _firestoreService = FirestoreService(); 
    final ImagePicker picker = ImagePicker();
    File? _selectedImage;


    @override
    void dispose() {
        captionController.dispose();
        super.dispose();
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Post"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _selectedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          _selectedImage!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Icon(
                        Icons.add_a_photo,
                        size: 50,
                        color: Colors.grey,
                      ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: captionController,
              decoration: const InputDecoration(
                hintText: "What's on your mind?",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                final currentUser = FirebaseAuth.instance.currentUser;
                if (currentUser == null) return;

                String? imageUrl;
                if (_selectedImage != null) {
                  imageUrl = await StorageService().uploadPostImage(_selectedImage!);
                }

                final post = Post(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  userId: currentUser.uid,
                  username: currentUser.email ?? 'Anonymous',
                  caption: captionController.text,
                  imageUrl: imageUrl,
                  createdAt: DateTime.now(),
                );

                await _firestoreService.addPost(post);
                captionController.clear();
                setState(() {
                  _selectedImage = null;
                });

                print('Post created successfully!');
              },
                child: const Text('Post'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }
}
