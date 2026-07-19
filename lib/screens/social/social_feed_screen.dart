import 'package:flutter/material.dart';
import 'create_post_screen.dart';

class SocialFeedScreen extends StatelessWidget {
  //final dynamic post;

  //const SocialFeedScreen({Key? key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Social Feed'),
      ),
      body: const Center(child: Text('Posts coming soon...')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreatePostScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}