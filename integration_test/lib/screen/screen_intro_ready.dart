import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:integration_test/screen/screen_main_tabs.dart';
import 'package:integration_test/widgets/button/wide_green.dart';

class ScreenIntroReady extends StatelessWidget {
  const ScreenIntroReady({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 60.h), // 반응형 상단 여백
            Column(
              children: [
                Image.asset(
                  'assets/images/fourth_fix.png',
                  height: 170.h, // Image size based on screen height
                  width: 170.h, // Image width based on screen width
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 23.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '이제 준비가 완료되었습니다!',
                      style: TextStyle(
                        color: Color(0xFF0B5B42),
                        fontSize: 24.sp,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text('🎉', style: TextStyle(fontSize: 24.sp)),
                  ],
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 40.h), // 반응형 하단 여백
              child: WideGreen(
                text: '나의 공지 보러가기',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ScreenMainTabs(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
