import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart'; // NumberFormat을 사용하여 콤마 붙이기
import 'dart:math'; // 제곱수 사용

import '../../tools/input_information.dart';

import 'second_page.dart';
import 'retirement_cal.dart';

// 1페이지 변수
final TextEditingController minimumCostOfLiving =
    TextEditingController(text: "2,077,892"); // 최소생계비
final TextEditingController extraLivingExpenses =
    TextEditingController(text: "3,260,085"); // 여유생계비
final TextEditingController inflationRate =
    TextEditingController(text: '2.0'); // 물가상승률
final TextEditingController systemAmountIncomeRate =
    TextEditingController(); // 연복리 수익률
final TextEditingController currentAge = TextEditingController(); // 현재 나이
final TextEditingController retirementAge = TextEditingController(); // 은퇴 나이

class FirstPage extends StatefulWidget {
  final PageController pageController;

  const FirstPage({
    required this.pageController,
    Key? key,
  }) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Center(
          child: Column(
            children: [
              const Text('지금 은퇴 시 필요한 정보를 이용해'),
              const Text('미래에 은퇴 시 필요한 자산을 알아보자'),
              const SizedBox(height: 10),
              // 큰 밑줄
              Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey,
              ),
              const SizedBox(height: 10),
              // 월 최저생계비
              InputInformation(
                labelText: '월 최저생계비',
                helpDialogTitle: '월 최저생계비',
                helpDialogText:
                    '최소한의 생활을 위한 최소 소비금액\n\nTip\n2023년 통계청의 발표자료에 따르는 개인회생 조정금액.\n1인 가구 : 1,249,735원\n2인 가구 : 2,073,693원\n3인 가구 : 2,660,890원\n4인 가구 : 3,240,578원',
                value: minimumCostOfLiving,
                hint: 'ex) 2,077,892',
                unit: '원',
              ),
              // 월 여유생계비
              InputInformation(
                labelText: '월 여유생계비',
                helpDialogTitle: '월 여유생계비',
                helpDialogText:
                    '즉, 여유로운 생활을 위한 최소 소비금액\n\nTip\n2023년 통계청의 발표자료에 따르는 "국민기초생활 보장법"에 의한 기준 중위소득.\n1인 가구 : 2,077,892원\n2인 가구 : 3,456,155원\n3인 가구 : 4,434,816원\n4인 가구 : 5,400,964원',
                value: extraLivingExpenses,
                hint: 'ex) 3,260,085',
                unit: '원',
              ),
              // 물가상승률
              InputInformation(
                labelText: '물가상승률',
                helpDialogTitle: '물가상승률',
                helpDialogText:
                    '매년 물가상승률만큼 우리의 화폐가치는 하락하기 때문에 은퇴 후 필요한 생활비는 현 시점의 생활비에서 물가상승률만큼 상승한다고 볼 수 있다.\n\n따라서 우리는 매년 최소한 물가상승률보다는 높은 수익률을 얻어야 우리의 자산 가치를 지킬 수 있다.\n\nTip\n통계청 발표 자료를 이용해 구한 물가상승률 5년 평균값에 가까운 약 2%를 추천한다.',
                value: inflationRate,
                hint: 'ex) 2.0',
                unit: '%',
              ),
              // 시스템 자산 수익률
              InputInformation(
                labelText: '시스템 자산 수익률',
                helpDialogTitle: '시스템 자산 수익률',
                helpDialogText:
                    '시스템자산 : 내가 일을하지 않아도 돈을 벌어오는 자산\n\nTip\n경제적 자유의 룰인 4%룰에 따르면 전체 은퇴 자금의 4% 이하로만 생활비로 쓴다면 이 은퇴자금은 영원히 손실되지 않을 가능성이 높다는 공식이 있다. \n\n 따라서 우리는 시스템 자산 수익률을 4% 이상으로 만들고 자산의 4%가 중위소득을 초과하게 만들어야 안정된 노후가 보장된다.',
                value: systemAmountIncomeRate,
                hint: 'ex) 6.0',
                unit: '%',
              ),
              // 현재 나이 & 은퇴 나이
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      // 현재 나이
                      child: Column(
                        children: [
                          const Text(
                            '현재 나이',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 1),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      TextField(
                                        textAlign:
                                            TextAlign.center, // 입력값을 중앙 정렬
                                        controller: currentAge,
                                        decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.zero,
                                          hintText: 'ex) 25',
                                        ),
                                        // TextField에 숫자와 소수점만 입력 가능하게 변경
                                        keyboardType: const TextInputType
                                            .numberWithOptions(decimal: true),
                                        inputFormatters: <TextInputFormatter>[
                                          // 숫자만 입력 받을 수 있게 설정
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  '세',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 은퇴 나이
                    Expanded(
                      child: Column(
                        children: [
                          const Text(
                            '은퇴 나이',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 1),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      TextField(
                                        textAlign:
                                            TextAlign.center, // 입력값을 중앙 정렬
                                        controller: retirementAge,
                                        decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.zero,
                                          hintText: 'ex) 55',
                                        ),
                                        // TextField에 숫자와 소수점만 입력 가능하게 변경
                                        keyboardType: const TextInputType
                                            .numberWithOptions(decimal: true),
                                        inputFormatters: <TextInputFormatter>[
                                          // 숫자만 입력 받을 수 있게 설정
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  '세',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // 결과 확인 버튼
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (minimumCostOfLiving.text == "" ||
                          extraLivingExpenses.text == "" ||
                          inflationRate.text == "" ||
                          systemAmountIncomeRate.text == "" ||
                          currentAge.text == "" ||
                          retirementAge.text == "") {
                        // 빈 칸이 존재할 경우 오류 출력
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: const Text('빈칸을 모두 채워주세요!'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('닫기'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        // TextField로 입력받은 값에서 콤마를 제거한 후 int로 변환
                        int inputMinimumMoney = int.parse(
                            minimumCostOfLiving.text.replaceAll(',', ''));
                        int inputExtraLivingMoney = int.parse(
                            extraLivingExpenses.text.replaceAll(',', ''));

                        // TextField로 입력받은 값을 double로 변환
                        double inflation = double.parse(inflationRate.text);
                        double incomeRate =
                            double.parse(systemAmountIncomeRate.text);

                        // TextField로 입력받은 값을 int로 변환
                        int startAge =
                            int.parse(currentAge.text.replaceAll(',', ''));
                        int endAge =
                            int.parse(retirementAge.text.replaceAll(',', ''));

                        // 오류 확인
                        if (inflation >= incomeRate) {
                          // 연 복리수익률 > 물가상승률 을 만족하지 못하는 경우 오류 출력
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: const Text(
                                    '시스템 자산 수익률이 물가상승률보다 낮아 자산 가치가 하락합니다.'),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('닫기'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } else if (startAge >= endAge) {
                          // 은퇴 나이 > 현재 나이 를 만족하지 못하는 경우 오류 출력
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: const Text(
                                    '희망 은퇴 나이는 현재 나이보다 최소 1년 이상 높아야 합니다.'),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('닫기'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          // 정상 계산
                          setState(
                            () {
                              // 최소자산(현재가치) 계산
                              //((필요자산 * 12) * (pow((100+물가상승률)/100, 은퇴 나이 - 시작 나이)) ~/ (연 평균수익률 - 물가상승률)/100)
                              var minimumMoney = (inputMinimumMoney * 12) ~/
                                  (incomeRate - inflation) *
                                  100;
                              // 계산한 최소자산(현재가치)을 문자열로 변환 후 천 단위마다 콤마 붙이기
                              presentValueMinimumCostOfLiving =
                                  NumberFormat('#,###').format(minimumMoney);

                              // 여유자산(현재가치) 계산
                              var extraLivingMoney =
                                  (inputExtraLivingMoney * 12) ~/
                                      (incomeRate - inflation) *
                                      100;
                              // 계산한 여유자산(현재가치) 문자열로 변환 후 천 단위마다 콤마 붙이기
                              presentValueSpareLivingExpenses =
                                  NumberFormat('#,###')
                                      .format(extraLivingMoney);

                              // 최소자산(미래가치) 계산
                              var minimumFutureMoney =
                                  ((inputMinimumMoney * 12) *
                                          pow(((100 + inflation) / 100),
                                              (endAge - startAge))) ~/
                                      (incomeRate - inflation) *
                                      100;
                              // 계산한 최소자산(미래가치) 문자열로 변환 후 천 단위마다 콤마 붙이기
                              futureValueMinimumCostOfLiving =
                                  NumberFormat('#,###')
                                      .format(minimumFutureMoney);

                              // 여유자산(미래가치) 계산
                              var extraLivingFutureMoney =
                                  ((inputExtraLivingMoney * 12) *
                                          pow(((100 + inflation) / 100),
                                              (endAge - startAge))) ~/
                                      (incomeRate - inflation) *
                                      100;
                              // 계산한 여유자산(미래가치) 문자열로 변환 후 천 단위마다 콤마 붙이기
                              futureValueSpareLivingExpenses =
                                  NumberFormat('#,###')
                                      .format(extraLivingFutureMoney);

                              // 2 페이지 활성화
                              RetirementCal.pageViewKey.currentState
                                  ?.changePageCount(2);

                              // 다음 페이지로 이동
                              Future.delayed(Duration.zero, () {
                                widget.pageController.animateToPage(
                                  1,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                );
                              });
                            },
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade200, // 배경 색상
                      minimumSize: const Size(0, 50), // 최소 높이
                      padding:
                          const EdgeInsets.symmetric(horizontal: 16), // 내부 여백
                      shape: RoundedRectangleBorder(
                        // 버틈 모서리
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      '결과 확인',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // 큰 밑줄
              Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey,
              ),
              const SizedBox(height: 1),
              // 큰 밑줄
              Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
