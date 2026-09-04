import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/notice.dart';
import '../models/post.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addNotice(Notice notice) async {
    try {
      await _db.collection('notices').doc(notice.id).set(notice.toMap());
    } catch (error) {
      debugPrint('Error adding notice: $error');
    }
  }

  Stream<List<Notice>> getNotices() {
    return _db
        .collection('notices')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Notice.fromMap(doc.data())).toList(),
        );
  }

  Future<void> addPost(Post post) async {
    try {
      await _db.collection('posts').doc(post.id).set(post.toMap());
    } catch (error) {
      debugPrint('Error adding post: $error');
    }
  }

  Stream<List<Post>> getPosts() {
    return _db
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Post.fromMap(doc.data())).toList(),
        );
  }

  Future<void> toggleLike(String postId, String userId, bool isLiked) async {
    try {
      await _db.collection('posts').doc(postId).update({
        'likes': isLiked
            ? FieldValue.arrayRemove([userId])
            : FieldValue.arrayUnion([userId]),
      });
    } catch (error) {
      debugPrint('Error toggling like: $error');
    }
  }
  Stream<List<Post>> getUserPosts(String userId) {
  return _db
      .collection('posts')
      .where('userId', isEqualTo: userId)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map(
        (snapshot) =>
            snapshot.docs.map((doc) => Post.fromMap(doc.data())).toList(),
      );
}
}
