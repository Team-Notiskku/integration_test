// ❌❌❌❌❌ DO NOT MODIFY UNDER ❌❌❌❌❌

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:integration_test/google/google_sheets_api.dart';
import 'package:integration_test/models/notice.dart';
import 'package:integration_test/services/preference_services.dart';

// 앱 시작 시 SharedPreference에서 로드
final starredProvider = StateNotifierProvider<StarredNotifier, List<Notice>>((ref) {
  return StarredNotifier();
});

class StarredNotifier extends StateNotifier<List<Notice>> {
  StarredNotifier() : super([]) {
    _loadStarredNotices();
  }

  // 1. 별표 공지 로드 (앱 시작 시 SharedPreferences에서 ID 불러오기)
  Future<void> _loadStarredNotices() async {
    final savedIDs = await getSavedStarredID(); 

    if (savedIDs.isNotEmpty) {
      final allNotices = await GoogleSheetsAPI.readData(); 
      final starredNotices = allNotices.where((notice) {
        final parsedID = int.tryParse(notice.id.trim());
        return parsedID != null && savedIDs.contains(parsedID);
      }).toList();

      state = starredNotices; 
    }
  }

  // 2. 별표 UI (추가 / 제거)
  void toggleNotice(Notice notice) async {
    final updatedState = state.any((n) => n.id == notice.id)
        ? state.where((n) => n.id != notice.id).toList()
        : [...state, notice];

    state = updatedState;

    final starredIDs = state
        .map((n) => int.tryParse(n.id.trim()) ?? -1)
        .where((id) => id != -1) 
        .toList();

    await saveStarredID(starredIDs); 
  }
}