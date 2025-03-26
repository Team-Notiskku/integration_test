import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:integration_test/google/google_sheets_api.dart';
import 'package:integration_test/models/notice.dart';
import 'package:integration_test/providers/keyword_providers.dart';

final ListKeyNoticesProvider = FutureProvider<List<Notice>>((ref) async {
  final keywordState = ref.watch(keywordProvider);
  final selectedKeywords = keywordState.selectedKeywords;

  final allData = await GoogleSheetsAPI.readData();

  if (selectedKeywords.isEmpty) return allData;

  return allData.where((notice) => 
    selectedKeywords.contains(notice.category)
  ).toList();
});
