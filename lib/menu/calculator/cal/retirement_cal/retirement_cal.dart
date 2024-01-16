import 'package:flutter/material.dart';

import '../../../title_menu/home/home.dart';

import 'first_page.dart';
import 'second_page.dart';
import 'third_page.dart';
import 'fourth_page.dart';

// 은퇴 계산기 : 은퇴 시점에 필요한 최소 자산 확인
class RetirementCal extends StatefulWidget {
  // GlobalKey 추가 : 글로벌키를 추가할 때는 super도 수정해주기
  static final GlobalKey<RetirementCalState> pageViewKey =
      GlobalKey<RetirementCalState>();

  RetirementCal({Key? key}) : super(key: key ?? pageViewKey);

  @override
  State<RetirementCal> createState() => RetirementCalState();
}

class RetirementCalState extends State<RetirementCal> {
  // 페이지 컨트롤러
  final PageController pageController = PageController(initialPage: 0);

  int pageCount = 1; // 초기 페이지 수

  // 페이지 수를 동적으로 변경하는 메서드
  void changePageCount(int newPageCount) {
    setState(() {
      pageCount = newPageCount;
    });
  }

  int calculatePageCount() {
    return pageCount;
  }

  @override
  Widget build(BuildContext context) {
    // BuildContext context : 다른 widget과 통신을 위한 용도로 사용(경로, 테마 가져오기, Navigator 등)

    // 페이지 번호 반환
    Widget buildPage(int index) {
      switch (index) {
        case 1:
          return SecondPage(pageController: pageController);
        case 2:
          return ThirdPage(pageController: pageController);
        case 3:
          return const FourthPage();
        default:
          return FirstPage(pageController: pageController);
      }
    }

    // 1 페이지 입력값 유지
    if (expectedReturnRate != 0) {
      // 연 복리 수익률
      systemAmountIncomeRate.text = expectedReturnRate.toStringAsFixed(2);
    }
    if (startYearController.text.isNotEmpty) {
      // 현재 나이
      currentAge.text = startYearController.text;
    }
    if (retirementAgeController.text.isNotEmpty) {
      // 은퇴 나이
      retirementAge.text = retirementAgeController.text;
    }
    return Scaffold(
      body: PageView.builder(
        controller: pageController,
        itemCount: calculatePageCount(),
        itemBuilder: (context, index) {
          return buildPage(index);
        },
      ),
    );
  }
}
