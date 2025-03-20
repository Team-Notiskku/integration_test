// ❌❌❌❌❌ DO NOT MODIFY ❌❌❌❌❌

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:integration_test/google/google_sheets_api.dart';
import 'package:integration_test/models/notice.dart';

class NoticesNotifier extends StateNotifier<List<Notice>> {
  NoticesNotifier() : super([]) {
    _loadNotices();
  }

  int currentRow = 1;
  final int limit = 10;
  bool hasMoreData = true;

  Future<void> _loadNotices() async {
    if (!hasMoreData) return;

    final newNotices = await GoogleSheetsAPI.readData(startRow: currentRow, limit: limit);
    if (newNotices.isEmpty) {
      hasMoreData = false;
      return;
    }

    state = [...state, ...newNotices];
    currentRow += limit;
  }

  Future<void> loadMoreNotices() async {
    await _loadNotices();
  }

  Future<void> refreshNotices() async {
    currentRow = 1;
    hasMoreData = true;
    state = [];
    await _loadNotices();
  }
}

final noticesProvider = StateNotifierProvider<NoticesNotifier, List<Notice>>((ref) {
  return NoticesNotifier();
});