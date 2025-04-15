import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NoticeListScreen extends StatelessWidget {
  final pinnedQuery = FirebaseFirestore.instance
      .collection('notices')
      .where('department', isEqualTo: '경영대학')
      .where('isPinned', isEqualTo: true)
      .orderBy('date', descending: true);

  final normalQuery = FirebaseFirestore.instance
      .collection('notices')
      .where('department', isEqualTo: '경영대학')
      .where('isPinned', isEqualTo: false)
      .orderBy('date', descending: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('📢 경영대학 공지')),
      body: Column(
        children: [
          Expanded(
            flex: 0,
            child: StreamBuilder<QuerySnapshot>(
              stream: pinnedQuery.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError)
                  return Center(child: Text('오류 발생: ${snapshot.error}'));
                if (!snapshot.hasData) return CircularProgressIndicator();
                final docs = snapshot.data!.docs;

                return Column(
                  children:
                      docs.map((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        return ListTile(
                          leading: Icon(Icons.push_pin, color: Colors.red),
                          title: Text(data['title'] ?? '제목 없음'),
                          subtitle: Text(data['date'] ?? '날짜 없음'),
                        );
                      }).toList(),
                );
              },
            ),
          ),

          Divider(),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: normalQuery.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError)
                  return Center(child: Text('오류 발생: ${snapshot.error}'));
                if (!snapshot.hasData) return CircularProgressIndicator();
                final docs = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(data['title'] ?? '제목 없음'),
                      subtitle: Text(data['date'] ?? '날짜 없음'),
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
