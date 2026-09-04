import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/post.dart';
import '../../services/firestore_service.dart';
import 'create_post_screen.dart';

class SocialFeedScreen extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Social Feed'),
      ),
      body: StreamBuilder<List<Post>>(
        stream: _firestoreService.getPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No posts yet — be the first!'));
          }

          final posts = snapshot.data!;

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        child: Text(
                          post.username[0].toUpperCase(),
                        ),
                      ),
                      title: Text(post.username),
                      subtitle: Text(
                        '${post.createdAt.day}/${post.createdAt.month}/${post.createdAt.year}',
                      ),
                    ),
                    if (post.imageUrl != null)
                      Image.network(
                        post.imageUrl!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(post.caption),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 12,
                        bottom: 8,
                      ),
                      child: Text(
                        '${post.likes.length} likes',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Row(
  children: [
    IconButton(
      onPressed: () async {
        final currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser == null) return;

        final bool isLiked = post.likes.contains(currentUser.uid);
        await _firestoreService.toggleLike(
          post.id,
          currentUser.uid,
          isLiked,
        );
      },
      icon: Icon(
        Icons.favorite,
        color: post.likes.contains(
          FirebaseAuth.instance.currentUser?.uid,
        )
            ? Colors.red
            : Colors.grey,
      ),
    ),
    Text('${post.likes.length} likes'),
  ],
),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreatePostScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}