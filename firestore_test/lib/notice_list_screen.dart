import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NoticeListScreen extends StatelessWidget {
  final noticesRef = FirebaseFirestore.instance.collection('notices');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('📢 공지사항')),
      body: StreamBuilder<QuerySnapshot>(
        stream: noticesRef.orderBy('date', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text('오류 발생'));
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) return Center(child: Text('📭 공지 없음'));

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text(data['title'] ?? '제목 없음'),
                subtitle: Text(data['uploader'] ?? '작성자 없음'),
              );
            },
          );
        },
      ),
    );
  }
}
