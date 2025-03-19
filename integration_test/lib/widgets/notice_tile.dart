import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:integration_test/models/notice.dart';
import 'package:integration_test/providers/starred_provider.dart';
import 'package:url_launcher/url_launcher.dart'; // URL 런처 패키지 추가

class NoticeTile extends ConsumerWidget {
  final Notice notice;

  const NoticeTile({Key? key, required this.notice}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isStarred = ref.watch(starredProvider);

    return Column(
      children: [
        ListTile(
          title: Text(
            notice.title,
            style: TextStyle(fontSize: 15.sp, color: Colors.black),
          ),
          subtitle: Text('${notice.date} | 조회수: ${notice.views}'),
          trailing: GestureDetector(
            onTap: () {
              ref.read(starredProvider.notifier).toggleNotice(notice);
            },
            child: Image.asset(
              isStarred.any((n) => n.id == notice.id)
                  ? 'assets/images/fullstar_fix.png'
                  : 'assets/images/emptystar_fix.png',
              width: 26.w,
              height: 26.h,
            ),
          ),
          onTap: () {
            final url = notice.link; 
            if (Uri.parse(url).isAbsolute) {
              launchUrl(Uri.parse(url));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('잘못된 URL 형식: $url')),
              );
            }
          },
        ),
        Divider(
          color: Colors.grey,
          thickness: 1.h,
          indent: 16.w,
          endIndent: 16.w,
        ),
      ],
    );
  }
}