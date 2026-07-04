import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notice.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addNotice(Notice notice) async {
    try {
      await _db
          .collection('notices')
          .doc(notice.id)
          .set(notice.toMap());
    } catch (e) {
      print('Error adding notice: $e');
    }
  }
}