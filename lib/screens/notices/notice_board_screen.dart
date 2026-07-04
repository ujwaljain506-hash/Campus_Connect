import 'package:flutter/material.dart';
import '../../models/notice.dart';
import '../../services/firestore_service.dart';

class NoticeBoardScreen extends StatefulWidget {
    @override
    State<NoticeBoardScreen> createState() => _NoticeBoardScreenState();
}

class _NoticeBoardScreenState extends State<NoticeBoardScreen> {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController bodyController = TextEditingController();
    final TextEditingController departmentController = TextEditingController();
    FirestoreService _firestoreService = FirestoreService();
    
    @override
    void dispose(){
        titleController.dispose();
        bodyController.dispose();
        departmentController.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text('Notice Board'),
            ),
            body: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                    children: [
                        TextField(
                            controller: titleController,
                            decoration: InputDecoration(
                                labelText: 'Title',
                            ),
                        ),
                        SizedBox(height: 16.0),
                        TextField(
                            maxLines: 3,
                            controller: bodyController,
                            decoration: InputDecoration(
                                labelText: 'Body',
                            ),
                        ),
                        SizedBox(height: 16.0),
                        TextField(
                            controller: departmentController,
                            decoration: InputDecoration(
                                labelText: 'Department',
                            ),
                        ),
                        SizedBox(height: 16.0),
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
                            child:Text('Post Notice'),
                                ),

                    ]
                )
            )
        );
    }



}


