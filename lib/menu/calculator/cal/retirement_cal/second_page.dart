import 'package:flutter/material.dart';

import '../../../title_menu/home/home.dart';
import '../../tools/print_information.dart';

import 'retirement_cal.dart';
import 'fourth_page.dart';

// 2페이지 변수
String presentValueMinimumCostOfLiving = ""; // 최소생계비(현재가치)
String presentValueSpareLivingExpenses = ""; // 여유생계비(현재가치)
String futureValueMinimumCostOfLiving = ""; // 최소생계비(미래가치)
String futureValueSpareLivingExpenses = ""; // 여유생계비(미래가치)

class SecondPage extends StatefulWidget {
  final PageController pageController;

  const SecondPage({
    required this.pageController,
    Key? key,
  }) : super(key: key);

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
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
              // 밑줄
              Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey,
              ),
              const SizedBox(height: 10),
              // 최소자산(현재가치)
              PrintInformation(
                labelText: '최소자산(현재가치)',
                helpDialogTitle: '최소자산(현재가치)',
                helpDialogText:
                    '물가상승률과 현재 시스템수익률을 고려했을 때 최소한의 은퇴를 위해 필요한 현재 시스템자산',
                value: presentValueMinimumCostOfLiving,
              ),
              // 여유자산(현재가치)
              PrintInformation(
                labelText: '여유자산(현재가치)',
                helpDialogTitle: '여유자산(현재가치)',
                helpDialogText:
                    '물가상승률과 현재 시스템수익률을 고려했을 때 여유로운 은퇴를 위해 필요한 현재 시스템자산',
                value: presentValueSpareLivingExpenses,
              ),
              const SizedBox(height: 10),
              // 큰 밑줄
              Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey,
              ),
              const SizedBox(height: 10),
              // 최소자산(미래가치)
              PrintInformation(
                labelText: '최소자산(미래가치)',
                helpDialogTitle: '최소자산(미래가치)',
                helpDialogText:
                    '물가상승률과 현재 시스템수익률을 고려했을 때 최소한의 은퇴를 위해 필요한 은퇴 시점의 시스템자산',
                value: futureValueMinimumCostOfLiving,
              ),
              // 여유자산(미래가치)
              PrintInformation(
                labelText: '여유자산(미래가치)',
                helpDialogTitle: '여유자산(미래가치)',
                helpDialogText:
                    '물가상승률과 현재 시스템수익률을 고려했을 때 여유로운 은퇴를 위해 필요한 은퇴 시점의 시스템자산',
                value: futureValueSpareLivingExpenses,
              ),
              const SizedBox(height: 10),
              // 큰 밑줄
              Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey,
              ),
              // 은퇴 확률 계산 & 결과 저장 버튼
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // 은퇴 확률 계산 버튼
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () {
                          if (minAsset == "은퇴계산기 확인하기" &&
                              freeAsset == "은퇴계산기 확인하기") {
                            // 계산 결과 최초 등록을 하지 않은 경우 = 다음 결과 확인 불가
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: const Text('계산한 결과를 저장해주세요.'),
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
                            // 자산이 1개 이상일 경우
                            if (assets.isNotEmpty) {
                              setState(() {
                                // 4페이지 자산 선택시 최초 값 설정
                                selectedAsset = assets.first;
                                assetName = assets.first.name;
                                assetIncome =
                                    assets.first.annualReturn.toString();
                                assetAnnualPayment =
                                    selectedAsset!.annualPayment;
                              });

                              // 3, 4 페이지 활성화 : 다른 Dart 파일에서 RetirementCal 위젯의 페이지 수 변경
                              RetirementCal.pageViewKey.currentState
                                  ?.changePageCount(4);

                              // 다음 페이지로 이동
                              Future.delayed(Duration.zero, () {
                                widget.pageController.animateToPage(
                                  2,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                );
                              });
                            } else {
                              // 등록된 자산이 없을 경우 오류
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content:
                                        const Text('자산을 최소 하나 이상 추가시켜 주세요'),
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
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyan.shade300, // 배경 색상
                          minimumSize: const Size(0, 50), // 최소 높이
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16), // 내부 여백
                          shape: RoundedRectangleBorder(
                            // 버틈 모서리
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          '은퇴 확률 계산',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // 결과 저장 버튼
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        onPressed: () {
                          minAsset = futureValueMinimumCostOfLiving;
                          freeAsset = futureValueSpareLivingExpenses;

                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: const Text('은퇴시 필요한 자산 정보 갱신 완료'),
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
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade200, // 배경 색상
                          minimumSize: const Size(0, 50), // 최소 높이
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16), // 내부 여백
                          shape: RoundedRectangleBorder(
                            // 버틈 모서리
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          '결과 저장',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
