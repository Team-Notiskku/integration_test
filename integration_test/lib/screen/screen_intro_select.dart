import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:integration_test/providers/bar_providers.dart';
import 'package:integration_test/providers/keyword_providers.dart';
import 'package:integration_test/providers/major_provider.dart';
import 'package:integration_test/screen/screen_intro_alarm.dart';
import 'package:integration_test/widgets/bar/bar_settings.dart';
import 'package:integration_test/widgets/button/wide_condition.dart';
import 'package:integration_test/widgets/grid/grid_keywords.dart';
import 'package:integration_test/widgets/list/list_major.dart';

// 관심 학과와 키워드를 선택해주세요 
class ScreenIntroSelect extends ConsumerWidget {
  const ScreenIntroSelect({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.watch로 상태 읽기 
    final toggleIndex = ref.watch(toggleIndexProvider); 
    final majorState = ref.watch(majorProvider);
    final keywordState = ref.watch(keywordProvider);

    // '설정완료' 버튼 활성화 조건: 학과 1개 이상 + 키워드 1개 이상 선택
    final isButtonEnabled = majorState.selectedMajors.isNotEmpty && keywordState.selectedKeywords.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 80.h),

          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: Text(
                '관심 학과와 키워드를 선택해주세요😀\n(학과는 최대 2개까지 가능)',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.black.withOpacity(0.9),
                  fontSize: 14.sp,
                  fontFamily: 'GmarketSans',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          const BarSettings.BarSettings(), // 학과|키워드
          SizedBox(height: 10.h),
          Expanded(
            child: toggleIndex == 0
                ? const ListMajor() // 전체 전공 리스트 보여주기 
                : const GridKeywords(), // 전체 키워드 그리드 보여주기 
          ),
          SizedBox(height: 30.h),

          WideCondition(
            text: '설정 완료',
            isEnabled: isButtonEnabled,
            onPressed: isButtonEnabled
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ScreenIntroAlarm(), 
                      ),
                    );
                  }
                : null,
          ),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }
}
