import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notice.dart';
import '../models/post.dart';
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
Future<void> addPost(Post post) async {
  try {
    await _db
        .collection('posts')
        .doc(post.id)
        .set(post.toMap());
  } catch (e) {
    print('Error adding post: $e');
  }
}
Stream<List<Post>> getPosts() {
  return _db
      .collection('posts')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) {
        return snapshot.docs
            .map((doc) => Post.fromMap(doc.data()))
            .toList();
      });
}
}