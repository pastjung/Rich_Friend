/*
// 은퇴계산기 백업
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // TextField에 숫자만 입력받을 수 있도록 설정하기 위한 라이브러리
import 'package:intl/intl.dart'; // NumberFormat을 사용하여 콤마 붙이기
import 'dart:math'; // 제곱수 사용

import '../../title_menu/home/home.dart';
import '../tools/print_information.dart';
import '../tools/input_information.dart';

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

// 2페이지 변수
String presentValueMinimumCostOfLiving = ""; // 최소생계비(현재가치)
String presentValueSpareLivingExpenses = ""; // 여유생계비(현재가치)
String futureValueMinimumCostOfLiving = ""; // 최소생계비(미래가치)
String futureValueSpareLivingExpenses = ""; // 여유생계비(미래가치)

// 4페이지 변수
Asset? selectedAsset; // DropdownButtons에서 선택된 항목을 저장할 변수
String assetName = ""; // DropdownButtons에서 선택된 자산의 이름
String assetIncome = ""; //DropdownButtons에서 선택된 자산의 수익률
String assetAnnualPayment = ""; //DropdownButtons에서 선택된 자산의 연 추가 납입금

// 은퇴 계산기 : 은퇴 시점에 필요한 최소 자산 확인
class RetirementCal extends StatefulWidget {
  const RetirementCal({Key? key}) : super(key: key);

  @override
  State<RetirementCal> createState() => _RetirementCalState();
}

class _RetirementCalState extends State<RetirementCal> {
// 페이지 컨트롤러
  final PageController pageController = PageController(initialPage: 0);

// 페이지 비활성화 여부
  bool isSecondPageEnabled = false; // 2번째 페이지
  bool isThirdAndFourthPageEnabled = false; // 3,4번째 페이지

  @override
  Widget build(BuildContext context) {
    // 페이지 동적 개수 반환
    int pageCount() {
      if (isThirdAndFourthPageEnabled == true) {
        return 4;
      }
      if (isSecondPageEnabled == true) {
        return 2;
      }
      return 1;
    }

    // 페이지 번호 반환
    Widget buildPage(int index) {
      switch (index) {
        case 0:
          return _buildFirstPage();
        case 1:
          return _buildSecondPage();
        case 2:
          return _buildThirdPage();
        case 3:
          return _buildFourthPage();
        default:
          return _buildFirstPage();
      }
    }

    // 첫 번째 페이지 입력값 유지
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
        itemCount: pageCount(),
        itemBuilder: (context, index) {
          return buildPage(index);
        },
      ),
    );
  }

  // 은퇴계산기 메인
  Widget _buildFirstPage() {
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
              Container(
                width: 300, // 버튼의 폭
                height: 50, // 버튼의 높이
                decoration: BoxDecoration(
                  color: Colors.cyan.shade300,
                  borderRadius: BorderRadius.circular(12), // 모서리를 둥글게 만듦
                ),
                child: TextButton(
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
                                NumberFormat('#,###').format(extraLivingMoney);

                            // 최소자산(미래가치) 계산
                            var minimumFutureMoney = ((inputMinimumMoney * 12) *
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
                            isSecondPageEnabled = true;
                          },
                        );

                        // 다음 페이지로 이동
                        pageController.animateToPage(
                          1,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      }
                    }
                  },
                  child: const Text(
                    '결과 확인',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
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

  // 은퇴계산기 결과
  Widget _buildSecondPage() {
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
                                // 3, 4 페이지 활성화
                                isThirdAndFourthPageEnabled = true;

                                // 4페이지 자산 선택시 최초 값 설정
                                selectedAsset = assets.first;
                                assetName = assets.first.name;
                                assetIncome =
                                    assets.first.annualReturn.toString();
                                assetAnnualPayment =
                                    selectedAsset!.annualPayment;
                              });

                              // 다음 페이지로 이동
                              pageController.animateToPage(
                                2,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
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
                            borderRadius: BorderRadius.circular(10),
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
                            borderRadius: BorderRadius.circular(10),
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

  // 은퇴 확률 계산(부자계산기) : 은퇴 시점의 자산과 목표 자산(미래가치의 최소자산, 여유자산) 비교
  Widget _buildThirdPage() {
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // 자산이 1개 이상일 경우
                        if (assets.isNotEmpty) {
                          setState(() {
                            // 3, 4 페이지 활성화
                            isThirdAndFourthPageEnabled = true;
                          });

                          // 다음 페이지로 이동
                          pageController.animateToPage(
                            4,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
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
                        '자산별 세부정보 확인',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  ],
                ),
              ),
              // 실험
              //

              //
            ],
          ),
        ),
      ),
    );
  }

  // 은퇴시 시스템자산의 수익률 및 자산
  Widget _buildFourthPage() {
    // 선택된 자산 변수 초기화
    selectedAsset?.principal = 0; // 원금
    selectedAsset?.profit = 0; // 수익금
    selectedAsset?.totalProfit = 0; // 총 수익금
    selectedAsset?.totalAsset = 0; // 총자산
    selectedAsset?.totalReturn = 0; // 총 수익률

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Center(
          child: Column(
            children: [
              const Text('추가 납입금은 연 초에 납입한다고 가정'),
              const Text('총 자산은 해당 나이의 연 말을 기준으로 함'),
              const SizedBox(height: 10),
              // 큰 밑줄
              Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey,
              ),
              const SizedBox(height: 10),
              // 자산 선택 위젯
              Card(
                elevation: 2,
                color: Colors.grey.shade100,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DropdownButton<Asset>(
                        value: selectedAsset,
                        items:
                            assets.map<DropdownMenuItem<Asset>>((Asset asset) {
                          return DropdownMenuItem<Asset>(
                            value: asset,
                            child: Text(asset.name),
                          );
                        }).toList(),
                        onChanged: (Asset? newValue) {
                          setState(() {
                            selectedAsset = newValue!;
                            assetName = selectedAsset!.name;
                            assetIncome =
                                selectedAsset!.annualReturn.toString();
                            assetAnnualPayment = selectedAsset!.annualPayment;
                          });
                        },
                        icon: const SizedBox.shrink(), // DropdownButton의 화살표 삭제
                      ),
                    ],
                  ),
                ),
              ),
              // 선택된 자산의 기본정보 출력 위젯
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 5),
                    Text('자산 이름 : $assetName'),
                    Text('연 수익률 : $assetIncome %'),
                    Text('연 추가 납입금 : $assetAnnualPayment 원'),
                  ],
                ),
              ),
              // 큰 밑줄
              Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey,
              ),
              const SizedBox(height: 10),
              // 자산 내역
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    // 나이
                    DataColumn(label: Text('나이')),
                    // 원금
                    DataColumn(label: Text('원금')),
                    // 수익금
                    DataColumn(label: Text('수익금')),
                    // 총 수익금
                    DataColumn(label: Text('총 수익금')),
                    // 총 자산
                    DataColumn(label: Text('총 자산')),
                    // 총 수익률
                    DataColumn(label: Text('총 수익률')),
                  ],
                  rows: List.generate(
                      // 시행횟수 : 은퇴 나이 - 시작 나이 + 1
                      // index : 현재 시행한 횟수 (0번부터 시작)
                      int.parse(retirementAge.text) -
                          int.parse(currentAge.text) +
                          1, (index) {
                    int age = int.parse(currentAge.text) + index; // 나이

                    // 초기값 세팅
                    if (index == 0) {
                      // 원금
                      selectedAsset?.principal = int.parse(
                          selectedAsset?.startPayment.replaceAll(',', '') ??
                              "0");

                      // 수익금
                      selectedAsset?.profit =
                          ((int.parse(assetAnnualPayment.replaceAll(',', '')) +
                                      (selectedAsset?.principal ?? 0)) *
                                  ((selectedAsset?.annualReturn ?? 0) / 100))
                              .toInt();

                      // 총 자산
                      selectedAsset?.totalAsset =
                          int.parse(assetAnnualPayment.replaceAll(',', '')) +
                              (selectedAsset?.principal ?? 0) +
                              (selectedAsset?.profit ?? 0);
                    } else {
                      // 원금
                      selectedAsset?.principal += int.parse(
                          selectedAsset?.annualPayment.replaceAll(',', '') ??
                              "0");

                      // 수익금
                      selectedAsset?.profit =
                          ((int.parse(assetAnnualPayment.replaceAll(',', '')) +
                                      (selectedAsset?.totalAsset ?? 0)) *
                                  ((selectedAsset?.annualReturn ?? 0) / 100))
                              .toInt();

                      // 총 자산
                      selectedAsset?.totalAsset +=
                          int.parse(assetAnnualPayment.replaceAll(',', '')) +
                              (selectedAsset?.profit ?? 0);
                    }

                    // 총 수익금
                    selectedAsset?.totalProfit += (selectedAsset?.profit ?? 0);

                    // 총 수익률
                    if (selectedAsset?.totalAsset != 0) {
                      // 원금이 0이 아닌 경우
                      selectedAsset?.totalReturn =
                          (selectedAsset?.totalProfit ?? 1) /
                              (selectedAsset?.principal ?? 1) *
                              100;
                    } else {
                      // 원금이 0인 경우
                      selectedAsset?.totalReturn = 0;
                    }

                    return DataRow(cells: [
                      DataCell(Text('$age')),
                      DataCell(
                        // 원금
                        Text(
                            '${NumberFormat('#,###').format(selectedAsset!.principal)} 원'),
                      ),
                      DataCell(
                        //해당 연도 수익금
                        Text(
                            '${NumberFormat('#,###').format(selectedAsset!.profit)} 원'),
                      ),
                      DataCell(
                        // 총 수익금
                        Text(
                            '${NumberFormat('#,###').format(selectedAsset!.totalProfit)} 원'),
                      ),
                      DataCell(
                        // 총 자산
                        Text(
                            '${NumberFormat('#,###').format(selectedAsset!.totalAsset)} 원'),
                      ),
                      DataCell(
                        // 총 수익률
                        Text(
                            '${selectedAsset!.totalReturn.toStringAsFixed(2)} %'),
                      ),
                    ]);
                  }),
                ),
              ),
              // 큰 밑줄
              Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey,
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

*/