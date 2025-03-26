// ❌❌❌❌❌ DO NOT MODIFY ❌❌❌❌❌

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:integration_test/google/google_sheets_api.dart';
import 'package:integration_test/models/notice.dart';
import 'package:integration_test/providers/bar_providers.dart';
import 'package:integration_test/widgets/bar/bar_categories.dart';

/// 공지 목록을 관리하는 Notifier
class NoticesNotifier extends StateNotifier<List<Notice>> {
  NoticesNotifier({required this.categoryName}) : super([]) {
    refreshNotices();
  }

  final String categoryName;
  int currentRow = 1;
  bool isLoading = false;
  bool hasMore = true;

  /// 새로고침 (처음부터 다시 불러옴)
  Future<void> refreshNotices() async {
    currentRow = 1;
    hasMore = true;
    final allData = await GoogleSheetsAPI.readData(startRow: 1, limit: 10);
    final filtered = _filterByCategory(allData);
    state = filtered;
    currentRow += 10;
  }

  /// 스크롤 시 추가 로딩
  Future<void> loadMoreNotices() async {
    if (isLoading || !hasMore) return;
    isLoading = true;
    final data = await GoogleSheetsAPI.readData(
      startRow: currentRow,
      limit: 10,
    );
    if (data.isEmpty) {
      hasMore = false;
    } else {
      final filtered = _filterByCategory(data);
      state = [...state, ...filtered];
      currentRow += 10;
    }
    isLoading = false;
  }

  /// 카테고리에 따라 공지 필터링
  List<Notice> _filterByCategory(List<Notice> data) {
    if (categoryName == '전체') return data;
    return data.where((n) => n.category == "[$categoryName]").toList();
  }
}

/// ✅ Provider 정의는 클래스 바깥에서!
final listNoticesProvider = StateNotifierProvider<NoticesNotifier, List<Notice>>((ref) {
  final categoryIndex = ref.watch(barCategoriesProvider);
  final categoryName = BarCategories.categories[categoryIndex];
  return NoticesNotifier(categoryName: categoryName);
});