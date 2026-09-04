
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class StorageService {
  final String _cloudName = 'pk0w8u3g';
  final String _uploadPreset = 'campus_connect_preset';

  Future<String?> uploadPostImage(File imageFile) async {
    try {
      final uri = Uri.parse(
        'https://api.cloudinary.com/v1_1/$_cloudName/image/upload',
      );

      final request = http.MultipartRequest('POST', uri);
      request.fields['upload_preset'] = _uploadPreset;
      request.files.add(
        await http.MultipartFile.fromPath('file', imageFile.path),
      );

      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      final jsonData = jsonDecode(responseData);

      if (response.statusCode == 200) {
        return jsonData['secure_url'];
      } else {
        print('Cloudinary error: ${jsonData['error']['message']}');
        return null;
      }
    } catch (e) {
      print('Upload error: $e');
      return null;
    }
  }
  Future<String?> uploadPDF(String filePath, String fileName) async {
  try {
    final uri = Uri.parse(
      'https://api.cloudinary.com/v1_1/$_cloudName/raw/upload',
    );

    final request = http.MultipartRequest('POST', uri);
    request.fields['upload_preset'] = _uploadPreset;
    request.fields['resource_type'] = 'raw';
    request.files.add(
      await http.MultipartFile.fromPath('file', filePath,
          filename: fileName),
    );

    final response = await request.send();
    final responseData = await response.stream.bytesToString();
    final jsonData = jsonDecode(responseData);

    if (response.statusCode == 200) {
      return jsonData['secure_url'];
    } else {
      print('Cloudinary PDF error: ${jsonData['error']['message']}');
      return null;
    }
  } catch (e) {
    print('PDF upload error: $e');
    return null;
  }
}
}
// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';

// class StorageService {
//   final FirebaseStorage _storage = FirebaseStorage.instance;

//   Future<String?> uploadPostImage(File imageFile) async {
//     try {
//       final String fileName =
//           'posts/${DateTime.now().millisecondsSinceEpoch}.jpg';

//       final Reference ref = _storage.ref().child(fileName);

//       await ref.putFile(imageFile);

//       final String downloadUrl = await ref.getDownloadURL();
//       return downloadUrl;

//     } catch (e) {
//       print('Storage error: $e');
//       return null;
//     }
//   }
// }