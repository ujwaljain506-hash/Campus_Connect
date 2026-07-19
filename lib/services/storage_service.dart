import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadPostImage(File imageFile) async {
    try {
      final String fileName =
          'posts/${DateTime.now().millisecondsSinceEpoch}.jpg';

      final Reference ref = _storage.ref().child(fileName);

      await ref.putFile(imageFile);

      final String downloadUrl = await ref.getDownloadURL();
      return downloadUrl;

    } catch (e) {
      print('Storage error: $e');
      return null;
    }
  }
}