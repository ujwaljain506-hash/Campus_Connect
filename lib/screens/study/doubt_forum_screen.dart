import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/question.dart';
import '../../services/firestore_service.dart';

class DoubtForumScreen extends StatefulWidget {
  @override
  State<DoubtForumScreen> createState() => _DoubtForumScreenState();
}

class _DoubtForumScreenState extends State<DoubtForumScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Doubt Forum')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Question Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: bodyController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Describe your doubt',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final currentUser =
                          FirebaseAuth.instance.currentUser;
                      if (currentUser == null) return;

                      final question = Question(
                        id: DateTime.now()
                            .millisecondsSinceEpoch
                            .toString(),
                        title: titleController.text,
                        body: bodyController.text,
                        askedBy: currentUser.email ?? 'Anonymous',
                        createdAt: DateTime.now(),
                      );

                      await _firestoreService.addQuestion(question);
                      titleController.clear();
                      bodyController.clear();
                      print('Question posted!');
                    },
                    child: const Text('Post Question'),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: StreamBuilder<List<Question>>(
              stream: _firestoreService.getQuestions(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('No questions yet — ask away!'));
                }

                final questions = snapshot.data!;

                return ListView.builder(
                  itemCount: questions.length,
                  itemBuilder: (context, index) {
                    final question = questions[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.question_mark),
                        ),
                        title: Text(question.title),
                        subtitle: Text(
                          '${question.askedBy} • ${question.createdAt.day}/${question.createdAt.month}',
                        ),
                        trailing: const Icon(Icons.chevron_right),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}