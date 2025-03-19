import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
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

  void _launchURL(String url) async {
  final Uri uri = Uri.parse(url);
  
  if (await canLaunchUrl(uri)) {
    bool launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (launched) {
      print("URL Opened");
    } else {
      print("CANNOT OPEN ERROR: $url");
    }
  } else {
    print("INVALID ERROR: $url");
  }
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

                String noticeText = sheetData[index].sublist(0, sheetData[index].length - 1).join(" | "); 
                String url = sheetData[index].last; 

                return ListTile(
                  title: Text(
                    noticeText,
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    if (Uri.parse(url).isAbsolute) {
                      _launchURL(url);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('잘못된 URL 형식: $url')),
                      );
                    }
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