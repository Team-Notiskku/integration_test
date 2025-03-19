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
  int currentRow = 1; 
  bool isLoading = false; 

  @override
  void initState() {
    super.initState();
    _loadSheetData();
  }

  Future<void> _loadSheetData() async {
    if (isLoading) return;
    setState(() => isLoading = true);

    final data = await GoogleSheetsAPI.readData(startRow: currentRow, limit: 10);

    setState(() {
      sheetData.addAll(data);
      currentRow += 10;
      isLoading = false;
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
              itemCount: sheetData.length + 1,
              itemBuilder: (context, index) {
                if (index == sheetData.length) {
                  return isLoading
                      ? Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: _loadSheetData,
                          child: Text("더 보기"),
                        );
                }
                return ListTile(
                  title: Text(sheetData[index].join(" | ")), 
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}