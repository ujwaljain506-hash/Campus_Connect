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
  Stream<List<Notice>> getNotices() {
  return _db
      .collection('notices')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) {
        return snapshot.docs
            .map((doc) => Notice.fromMap(doc.data()))
            .toList();
      });
}
}