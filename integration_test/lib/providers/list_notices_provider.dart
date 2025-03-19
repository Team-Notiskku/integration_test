// ❌❌❌❌❌ DO NOT MODIFY ❌❌❌❌❌

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:integration_test/google/google_sheets_api.dart';
import 'package:integration_test/models/notice.dart';

// 구글 시트의 데이터를 저장하는 Provider
final noticesProvider = FutureProvider<List<Notice>>((ref) async {
  final data = await GoogleSheetsAPI.readData();
  return data; 
});