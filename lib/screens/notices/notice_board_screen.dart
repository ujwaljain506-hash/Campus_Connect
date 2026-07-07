import 'package:flutter/material.dart';
import '../../models/notice.dart';
import '../../services/firestore_service.dart';
import 'notice_detail_screen.dart';

class NoticeBoardScreen extends StatefulWidget {
  @override
  State<NoticeBoardScreen> createState() => _NoticeBoardScreenState();
}

class _NoticeBoardScreenState extends State<NoticeBoardScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();

  final FirestoreService _firestoreService = FirestoreService();

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    departmentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notice Board'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: bodyController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Body',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: departmentController,
              decoration: const InputDecoration(
                labelText: 'Department',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                final notice = Notice(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: titleController.text,
                  body: bodyController.text,
                  department: departmentController.text,
                  createdAt: DateTime.now(),
                );

                await _firestoreService.addNotice(notice);

                titleController.clear();
                bodyController.clear();
                departmentController.clear();

                print('Notice posted successfully!');
              },
              child: const Text('Post Notice'),
            ),
            const SizedBox(height: 24),
            StreamBuilder<List<Notice>>(
              stream: _firestoreService.getNotices(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No notices yet');
                }

                final notices = snapshot.data!;

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: notices.length,
                  itemBuilder: (context, index) {
                    final notice = notices[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NoticeDetailScreen(notice: notice),
                          ),
                        );
                      },
                      child: Card(
                        child: ListTile(
                          title: Text(notice.title),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                notice.body.length > 50
                                    ? '${notice.body.substring(0, 50)}...'
                                    : notice.body,
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                notice.department,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                          trailing: Text(
                            '${notice.createdAt.day}/${notice.createdAt.month}',
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}   