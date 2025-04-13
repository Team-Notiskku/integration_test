import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:integration_test/models/notice.dart';
import 'package:integration_test/providers/bar_providers.dart';
import 'package:integration_test/providers/list_notices_provider.dart';
import 'package:integration_test/widgets/bar/bar_categories.dart';
import 'package:integration_test/widgets/bar/bar_notices.dart';
import 'package:integration_test/tabs/screen_main_search.dart';
import 'package:integration_test/widgets/notice_tile.dart';

class ScreenMainNotice extends ConsumerStatefulWidget {
  const ScreenMainNotice({Key? key}) : super(key: key);

  @override
  _ScreenMainNoticeState createState() => _ScreenMainNoticeState();
}

class _ScreenMainNoticeState extends ConsumerState<ScreenMainNotice> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
  }

  void _scrollListener() {
    final position = _scrollController.position;
    final notices = ref.read(listNoticesProvider);

    // 공지 개수가 10개 이하일 땐 항상 추가 로드
    if (notices.length <= 10) {
      ref.read(listNoticesProvider.notifier).loadMoreNotices();
      return;
    }

    // 스크롤이 맨 아래에 닿았을 때만 추가 로드
    if (position.pixels >= position.maxScrollExtent - 100) {
      ref.read(listNoticesProvider.notifier).loadMoreNotices();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notices = ref.watch(listNoticesProvider);
    final categoryIndex = ref.watch(barCategoriesProvider); // 현재 선택된 카테고리 인덱스
    final categoryName = BarCategories.categories[categoryIndex]; // 실제 카테고리 이름
    final filteredNotices =
        categoryName == '전체'
            ? notices
            : notices
                .where((notice) => notice.category == "[$categoryName]")
                .toList();

    return Scaffold(
      appBar: const _NoticeAppBar(),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          BarNotices(),
          SizedBox(height: 6.h),
          BarCategories(),
          Expanded(
            child: RefreshIndicator(
              color: const Color(0xFF0B5B42),
              backgroundColor: Colors.white,
              onRefresh: () async {
                await ref.read(listNoticesProvider.notifier).refreshNotices();
              },
              child: ListView.builder(
                controller: _scrollController,
                itemCount: filteredNotices.length,
                itemBuilder: (context, index) {
                  return NoticeTile(notice: filteredNotices[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Notice App Bar
// ❌❌❌❌❌ DO NOT MODIFY ❌❌❌❌❌
class _NoticeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _NoticeAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: Padding(
        padding: EdgeInsets.all(10.0),
        child: Image.asset('assets/images/greenlogo_fix.png', width: 40),
      ),
      title: Text(
        "공지사항",
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      actions: [
        Padding(
          padding: EdgeInsets.all(15.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ScreenMainSearch()),
              );
            },
            child: Image.asset('assets/images/search_fix.png', width: 30),
          ),
        ),
      ],
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
