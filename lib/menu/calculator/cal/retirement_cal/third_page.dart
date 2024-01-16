import 'package:flutter/material.dart';

import '../../../title_menu/home/home.dart';
import '../../tools/print_information.dart';

import 'first_page.dart';
import 'second_page.dart';

class ThirdPage extends StatefulWidget {
  final PageController pageController;

  const ThirdPage({
    required this.pageController,
    Key? key,
  }) : super(key: key);

  @override
  State<ThirdPage> createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  @override
  Widget build(BuildContext context) {
    // 3페이지 변수
    int principalPaidAtRetirement = 0; // 은퇴시점 납입한 원금
    int totalEarningsAtRetirement = 0; // 은퇴시점 총 수익금
    int totalAssetsAtRetirement = 0; // 은퇴시점 총 자산
    double totalReturnAtRetirement = 0; // 은퇴시점 총 수익률
    double minimumAssetAchievementRate = 0; // 최소자산(미래가치) 달성률
    double surplusAssetsAchievementRate = 0; // 여유자산(미래가치) 달성률

    // 은퇴시점 납입한 원금 & 총 수익금 & 총 자산
    for (Asset asset in assets) {
      int money = int.parse(asset.startPayment.replaceAll(",", "")); // 납입한 원금
      int money1 = int.parse(asset.startPayment.replaceAll(",", "")); // 연말 자산
      late int money2; // 연말 수익금

      // 연말 자산 정보
      for (int i = int.parse(currentAge.text);
          i <= int.parse(retirementAge.text);
          i++) {
        // 연 추가 납입금
        money += int.parse(asset.annualPayment.replaceAll(",", ""));

        // 연말 자산 : 연 추가 납입금 적립
        money1 += int.parse(asset.annualPayment.replaceAll(",", ""));

        // 연 수익금
        money2 = (money1 * asset.annualReturn) ~/ 100;
        money1 += money2;

        // 특정 자산의 연말 수익금 적립
        totalEarningsAtRetirement += money2;
      }
      // 특정 자산의 납입한 원금
      principalPaidAtRetirement += money;

      // 특정 자산의 총 자산
      totalAssetsAtRetirement += money1;
    }

    // 은퇴시점 총 수익률
    if (totalAssetsAtRetirement != 0) {
      totalReturnAtRetirement =
          ((totalAssetsAtRetirement / principalPaidAtRetirement) * 100);
    }

    // 최소자산(미래가치) 달성률
    if (int.parse(futureValueMinimumCostOfLiving.replaceAll(',', '')) != 0) {
      minimumAssetAchievementRate = (totalAssetsAtRetirement /
              int.parse(futureValueMinimumCostOfLiving.replaceAll(',', ''))) *
          100;
    }
    // 여유자산(미래가치) 달성률
    if (int.parse(futureValueSpareLivingExpenses.replaceAll(',', '')) != 0) {
      surplusAssetsAchievementRate = (totalAssetsAtRetirement /
              int.parse(futureValueSpareLivingExpenses.replaceAll(',', ''))) *
          100;
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Center(
          child: Column(
            children: [
              const Text('투자시 변동성이 존재하므로 추가 납입금은 연 단위로 설정'),
              const Text('보통 추가 납입을 나눠서 진행하므로'),
              const Text('연 평균 수익률은 실제 값보다 더 낮을 수 있음'),
              const SizedBox(height: 10),
              // 큰 밑줄
              Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey,
              ),
              const SizedBox(height: 10),
              // 은퇴시점 납입한 원금
              PrintInformation(
                labelText: '은퇴시점 납입한 원금',
                helpDialogTitle: '은퇴시점 납입한 원금',
                helpDialogText: '은퇴시점까지 납입한 금액',
                value: principalPaidAtRetirement,
              ),
              // 연 평균 수익률
              PrintInformation(
                labelText: '연 평균 수익률',
                helpDialogTitle: '연 평균 수익률',
                helpDialogText: '자산별 납입한 금액의 비중에 따라서 계산한 자산들의 연 평균 수익률',
                value: expectedReturnRate,
              ),
              // 은퇴시점 총 수익금
              PrintInformation(
                labelText: '은퇴시점 총 수익금',
                helpDialogTitle: '은퇴시점 총 수익금',
                helpDialogText: '납입한 원금과 지속적으로 추가 납부한 자산들이 복리로 쌓인 수익',
                value: totalEarningsAtRetirement,
              ),
              // 은퇴시점 총 자산
              PrintInformation(
                labelText: '은퇴시점 총 자산',
                helpDialogTitle: '은퇴시점 총 자산',
                helpDialogText: '은퇴시점까지 얻은 모든 수익과 납부한 원금을 합한 자산',
                value: totalAssetsAtRetirement,
              ),
              // 은퇴시점 총 수익률
              PrintInformation(
                labelText: '은퇴시점 총 수익률',
                helpDialogTitle: '은퇴시점 총 수익률',
                helpDialogText: '은퇴시점까지 납입한 원금을 이용해 얻은 수익금의 비율',
                value: totalReturnAtRetirement,
              ),
              const SizedBox(height: 10),
              // 큰 밑줄
              Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey,
              ),
              const SizedBox(height: 10),
              // 최소자산(미래가치) 달성률
              PrintInformation(
                labelText: '최소자산(미래가치) 달성률',
                helpDialogTitle: '최소자산(미래가치) 달성률',
                helpDialogText: '은퇴계산기를 통해 얻은 최소자산(미래가치)을 은퇴시점 총 자산이 달성한 비율',
                value: minimumAssetAchievementRate,
              ),
              // 여유자산(미래가치) 달성률
              PrintInformation(
                labelText: '여유자산(미래가치) 달성률',
                helpDialogTitle: '여유자산(미래가치) 달성률',
                helpDialogText: '은퇴계산기를 통해 얻은 여유자산(미래가치)을 은퇴시점 총 자산이 달성한 비율',
                value: surplusAssetsAchievementRate,
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
              // 자산별 세부정보 확인 버튼
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // 자산이 1개 이상일 경우
                        if (assets.isNotEmpty) {
                          // 다음 페이지로 이동
                          Future.delayed(Duration.zero, () {
                            widget.pageController.animateToPage(
                              3,
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
                                content: const Text('자산을 최소 하나 이상 추가시켜 주세요'),
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
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan.shade300, // 배경 색상
                        minimumSize: const Size(0, 50), // 최소 높이
                        padding:
                            const EdgeInsets.symmetric(horizontal: 16), // 내부 여백
                        shape: RoundedRectangleBorder(
                          // 버틈 모서리
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        '자산별 세부정보',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
