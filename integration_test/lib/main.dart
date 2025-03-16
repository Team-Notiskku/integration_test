import 'package:flutter/material.dart';
import 'google_sheets_api.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GoogleSheetsPage(),
    );
  }
}

class GoogleSheetsPage extends StatefulWidget {
  @override
  _GoogleSheetsPageState createState() => _GoogleSheetsPageState();
}

class _GoogleSheetsPageState extends State<GoogleSheetsPage> {
  List<List<String>> sheetData = [];

  @override
  void initState() {
    super.initState();
    _loadSheetData();
  }

  Future<void> _loadSheetData() async {
    final data = await GoogleSheetsAPI.readData();
    setState(() {
      sheetData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Google Sheets API 연동")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: sheetData.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(sheetData[index].join(" | ")), // 데이터 표시
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}