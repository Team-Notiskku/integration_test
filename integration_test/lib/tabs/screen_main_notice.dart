import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  @override
  Widget build(BuildContext context) {
    final noticesAsync = ref.watch(noticesProvider); 

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
              onRefresh: () async {
                ref.invalidate(noticesProvider); 
              },
              child: noticesAsync.when(
                data: (notices) => ListView.builder(
                  itemCount: notices.length,
                  itemBuilder: (context, index) {
                    return NoticeTile(notice: notices[index]); 
                  },
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => const Center(
                  child: Text("공지사항을 불러올 수 없습니다."),
                ),
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
                MaterialPageRoute(
                  builder: (context) => ScreenMainSearch(),
                ),
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