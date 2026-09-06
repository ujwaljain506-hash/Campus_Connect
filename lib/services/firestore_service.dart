import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/notice.dart';
import '../models/post.dart';
import '../models/study_resource.dart';
import '../models/question.dart';

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
  Future<void> addStudyResource(StudyResource resource) async {
    try {
      await _db
          .collection('study_resources')
          .doc(resource.id)
          .set(resource.toMap());
    } catch (e) {
      print('Error adding resource: $e');
    }
  }

  Stream<List<StudyResource>> getStudyResources() {
    return _db
        .collection('study_resources')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => StudyResource.fromMap(doc.data()))
              .toList(),
        );
  }
  Future<void> addQuestion(Question question) async {
  try {
    await _db
        .collection('questions')
        .doc(question.id)
        .set(question.toMap());
  } catch (e) {
    print('Error adding question: $e');
  }
}

Stream<List<Question>> getQuestions() {
  return _db
      .collection('questions')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map((doc) => Question.fromMap(doc.data()))
            .toList(),
      );
}
}
