import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // TextField에 숫자만 입력받을 수 있도록 설정하기 위한 라이브러리
import 'package:intl/intl.dart'; // NumberFormat을 사용하기 위함
import '../../tools/currency_input_formatter.dart';

import '../../../title_menu/home/home.dart';

// 초기 납입금
final TextEditingController startMoney = TextEditingController();
// 매년 납입액
final TextEditingController annualPayment = TextEditingController();
// 연 복리 수익률
final TextEditingController annualCompoundInterestIncomeRate =
    TextEditingController();
// 목표 자산 : 은퇴계산기를 계산시 자동으로 할당되도록 설정
final TextEditingController targetAmount = TextEditingController();
// 현재 나이
final TextEditingController currentAge = TextEditingController();
// 은퇴 나이
final TextEditingController retirementAge = TextEditingController();

class AssetInfo {
  String assetName; // 자산 이름
  double annualIncomeRate; // 연 수익률
  List<int> annualIncome = []; // 연 수익금
  List<int> totalAsset = []; // 총 자산
  List<double> totalIncomeRate = []; // 총 수익률

  AssetInfo({
    required this.assetName,
    required this.annualIncomeRate,
  });
}

List<AssetInfo> assetList = [];

double retirementIncomeRate = 0; // 은퇴 시점의 총 수익률
int retirementTotalAsset = 0; // 은퇴 시점의 자산
int targetAsset = 0; // 목표 자산

class RichCal extends StatefulWidget {
// 부자 계산기 : 은퇴 시점의 예상 자산을 계산 + 목표자산(은퇴계산기 결과)와 자산 비교
// 납입금을 이용해 은퇴 시점에 필요한 최소 자산을 만들기 위해 필요한 연 수익률 제공 및 투자 방법 제공
  const RichCal({super.key});

  @override
  State<RichCal> createState() => _RichCalState();
}

class _RichCalState extends State<RichCal> {
  // 페이지 컨트롤러
  final PageController _pageController = PageController(initialPage: 0);

  bool pageEnabled = false; // 2번째 페이지 비활성화 여부

  @override
  Widget build(BuildContext context) {
    // 페이지 동적 개수 반환
    int pageCount() {
      if (pageEnabled == true) {
        return 3;
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
        default:
          throw Exception("Invalid index");
      }
    }

    // 이미 입력한 값이 있을 경우 해당 값으로 업데이트
    if (totalInputMoney != 0) {
      // 초기 납입금
      startMoney.text = NumberFormat('#,###').format(totalInputMoney);
    }
    if (totalNewInputMoney != 0) {
      // 매년 납입액
      annualPayment.text = NumberFormat('#,###').format(totalNewInputMoney);
    }
    if (expectedReturnRate != 0) {
      // 연 복리 수익률
      annualCompoundInterestIncomeRate.text =
          expectedReturnRate.toStringAsFixed(2);
    }
    if (startYearController.text.isNotEmpty) {
      // 현재 나이
      currentAge.text = startYearController.text;
    }
    if (retirementAgeController.text.isNotEmpty) {
      // 은퇴 나이
      retirementAge.text = retirementAgeController.text;
    }

    // 화면 출력
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        itemCount: pageCount(),
        itemBuilder: (context, index) {
          return buildPage(index);
        },
      ),
    );
  }

  Widget _buildFirstPage() {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text('자산등록 없이 대략적인 계산으로'),
            const Text('은퇴시 예상되는 은퇴 자산과 목표 자산 비교'),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey,
            ),
            const SizedBox(height: 10),
            Stack(
              children: [
                const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '초기 납입금',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: -11,
                  right: 26,
                  child: IconButton(
                    color: Colors.grey,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('초기 납입금'),
                            content: const Text(
                                '투자를 시작할 때 초기 자금\n\nTip\n초기 납입금은 적을 수 밖에 없다.\n하지만 작은 금액이라도 복리효과를 누리면 내 은퇴시기는 빠르게 압당겨질 것이다.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('닫기'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.help),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 300, // 조정 가능한 폭
                  child: Column(
                    children: [
                      TextField(
                        textAlign: TextAlign.center, // 입력값을 중앙 정렬
                        controller: startMoney,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          hintText: 'ex) 0',
                        ),
                        // TextField에 숫자와 소수점만 입력 가능하게 변경
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: <TextInputFormatter>[
                          // 숫자만 입력 받을 수 있게 설정
                          FilteringTextInputFormatter.digitsOnly,
                          // 입력시 천의 자리마다 콤마(,) 자동으로 붙이기
                          CurrencyInputFormatter(),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  '원',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Stack(
              children: [
                const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '연 납입금',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: -11,
                  right: 26,
                  child: IconButton(
                    color: Colors.grey,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('연 납입금'),
                            content: const Text(
                                '매년 새로 투자하는 금액\n\n전략적으로 투자를 원한다면 2023년 기준 개인연금에 월 50만원, 주택청약에 25만원을 투자한다면 세액공제 혜택을 최대로 얻음과 동시에 추가 수익을 노려볼 수 있다. 추가로 퇴직연금또한 세액공제를 받을 수 있다.\n\nTip\n내 수입 중 세금을 포함한 지출이 나가기 전에 최소한 10%는 투자를 해야 돈이 모이기 시작한다.'),
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
                    icon: const Icon(Icons.help),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 300, // 조정 가능한 폭
                  child: Column(
                    children: [
                      TextField(
                        textAlign: TextAlign.center, // 입력값을 중앙 정렬
                        controller: annualPayment,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          hintText: 'ex) 6,000,000',
                        ),
                        // TextField에 숫자와 소수점만 입력 가능하게 변경
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: <TextInputFormatter>[
                          // 숫자만 입력 받을 수 있게 설정
                          FilteringTextInputFormatter.digitsOnly,
                          // 입력시 천의 자리마다 콤마(,) 자동으로 붙이기
                          CurrencyInputFormatter(),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  '원',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Stack(
              children: [
                const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '연 복리수익률',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: -11,
                  right: 26,
                  child: IconButton(
                    color: Colors.grey,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('연 복리수익률'),
                            content: const Text(
                                '매년 내가 얻을 수 있는 기대수익률.\n\nTip\n최소한 물가상승량보다 높은 수익률을 달성해야 내 자산의 가치가 하락하지 않는다.'),
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
                    icon: const Icon(Icons.help),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 300, // 조정 가능한 폭
                  child: Column(
                    children: [
                      TextField(
                        textAlign: TextAlign.center, // 입력값을 중앙 정렬
                        controller: annualCompoundInterestIncomeRate,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          hintText: 'ex) 4.0',
                        ),
                        // TextField에 숫자와 소수점만 입력 가능하게 변경
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: <TextInputFormatter>[
                          // 숫자와 소수점만 입력 받을 수 있게 설정
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d{0,2}'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  '%',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Stack(
              children: [
                const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '목표 자산',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: -11,
                  right: 26,
                  child: IconButton(
                    color: Colors.grey,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('목표 자산'),
                            content: const Text(
                                '은퇴계산기를 사용하여 지금 은퇴시 필요한 정보를 이용해 내가 은퇴시 필요한 자산을 계산해보자.'),
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
                    icon: const Icon(Icons.help),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 300, // 조정 가능한 폭
                  child: Column(
                    children: [
                      TextField(
                        textAlign: TextAlign.center, // 입력값을 중앙 정렬
                        controller: targetAmount,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          hintText: 'ex) 1,500,000,000',
                        ),
                        // TextField에 숫자와 소수점만 입력 가능하게 변경
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: <TextInputFormatter>[
                          // 숫자만 입력 받을 수 있게 설정
                          FilteringTextInputFormatter.digitsOnly,
                          // 입력시 천의 자리마다 콤마(,) 자동으로 붙이기
                          CurrencyInputFormatter(),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  '원',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(
                            '현재 나이',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          SizedBox(width: 100),
                          Text(
                            '은퇴 나이',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 145,
                  child: Column(
                    children: [
                      TextField(
                        textAlign: TextAlign.center, // 입력값을 중앙 정렬
                        controller: currentAge,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          hintText: 'ex) 25',
                        ),
                        // TextField에 숫자와 소수점만 입력 가능하게 변경
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: <TextInputFormatter>[
                          // 숫자만 입력 받을 수 있게 설정
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ],
                  ),
                ),
                const Text(
                  '세',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 145,
                  child: Column(
                    children: [
                      TextField(
                        textAlign: TextAlign.center, // 입력값을 중앙 정렬
                        controller: retirementAge,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          hintText: 'ex) 55',
                        ),
                        // TextField에 숫자와 소수점만 입력 가능하게 변경
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: <TextInputFormatter>[
                          // 숫자만 입력 받을 수 있게 설정
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ],
                  ),
                ),
                const Text(
                  '세',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              width: 300, // 버튼의 폭
              height: 50, // 버튼의 높이
              decoration: BoxDecoration(
                color: const Color(0xffAE8FDC),
                borderRadius: BorderRadius.circular(12), // 모서리를 둥글게 만듦
              ),
              child: TextButton(
                onPressed: () {
                  if (startMoney.text == "" ||
                      annualPayment.text == "" ||
                      annualCompoundInterestIncomeRate.text == "" ||
                      targetAmount.text == "" ||
                      currentAge.text == "" ||
                      retirementAge.text == "") {
                    // 빈 칸이 존재할 경우 오류 출력
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: const Text('모든 빈칸을 채워주세요'),
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
                    // TextField로 입력받은 값을 int로 변환
                    int startAge =
                        int.parse(currentAge.text.replaceAll(',', ''));
                    int endAge =
                        int.parse(retirementAge.text.replaceAll(',', ''));

                    // 오류 확인
                    if (startAge >= endAge) {
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
                      setState(() {
                        // 다음 페이지 활성화
                        pageEnabled = true;
                      });

                      // 다음 페이지로 이동
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease,
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
            Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey,
            ),
            const SizedBox(height: 1),
            Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondPage() {
    int principalPaidAtRetirement = 0; // 은퇴시점 납입한 원금
    int totalEarningsAtRetirement = 0; // 은퇴시점 총 수익금
    int totalAssetsAtRetirement = 0; // 은퇴시점 총 자산
    double totalReturnAtRetirement = 0; // 은퇴시점 총 수익률
    double achievementRate = 0; // 목표자산 달성률

    // 은퇴시점 납입한 원금 & 총 수익금 & 총 자산
    int money = int.parse(startMoney.text.replaceAll(",", "")); // 납입한 원금
    int money1 = int.parse(startMoney.text.replaceAll(",", "")); // 연말 자산
    late int money2; // 연말 수익금

    // 연말 자산 정보
    for (int i = int.parse(currentAge.text);
        i <= int.parse(retirementAge.text);
        i++) {
      // 연 추가 납입금
      money += int.parse(annualPayment.text.replaceAll(",", ""));

      // 연말 자산 : 연 추가 납입금 적립
      money1 += int.parse(annualPayment.text.replaceAll(",", ""));

      // 연 수익금
      money2 =
          (money1 * double.parse(annualCompoundInterestIncomeRate.text)) ~/ 100;
      money1 += money2;

      // 특정 자산의 연말 수익금 적립
      totalEarningsAtRetirement += money2;
    }
    // 특정 자산의 납입한 원금
    principalPaidAtRetirement += money;

    // 특정 자산의 총 자산
    totalAssetsAtRetirement += money1;

    // 은퇴시점 총 수익률
    if (totalAssetsAtRetirement != 0) {
      totalReturnAtRetirement =
          ((totalAssetsAtRetirement / principalPaidAtRetirement) * 100);
    }

    // 목표자산 달성률
    if (int.parse(targetAmount.text.replaceAll(',', '')) != 0) {
      achievementRate = totalAssetsAtRetirement /
          int.parse(targetAmount.text.replaceAll(',', '')) *
          100;
    }

    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text('투자시 변동성이 존재하므로 추가 납입금은 연 단위로 설정'),
            const Text('보통 추가 납입을 나눠서 진행하므로'),
            const Text('연 평균 수익률은 실제 값보다 더 낮을 수 있음'),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey,
            ),
            const SizedBox(height: 10),
            // 은퇴시점 납입한 원금
            Stack(
              children: [
                const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '은퇴시점 납입한 원금',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: -11,
                  right: 26,
                  child: IconButton(
                    color: Colors.grey,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('은퇴시점 납입한 원금'),
                            content: const Text('설명'),
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
                    icon: const Icon(Icons.help),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 300, // 조정 가능한 폭
                  child: Center(
                    child: Text(
                      NumberFormat('#,###').format(principalPaidAtRetirement),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  '원',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Container(
              width: 340,
              height: 1,
              color: Colors.grey,
            ),
            const SizedBox(height: 10),
            // 연 평균 수익률
            Stack(
              children: [
                const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '연 평균 수익률',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: -11,
                  right: 26,
                  child: IconButton(
                    color: Colors.grey,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('연 평균 수익률'),
                            content: const Text('설명'),
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
                    icon: const Icon(Icons.help),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 300, // 조정 가능한 폭
                  child: Center(
                    child: Text(
                      // 연 수익률
                      annualCompoundInterestIncomeRate.text,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  '%',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Container(
              width: 340,
              height: 1,
              color: Colors.grey,
            ),
            const SizedBox(height: 10),
            // 은퇴시점 총 수익금
            Stack(
              children: [
                const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '은퇴시점 총 수익금',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: -11,
                  right: 26,
                  child: IconButton(
                    color: Colors.grey,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('은퇴시점 총 수익금'),
                            content: const Text('설명'),
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
                    icon: const Icon(Icons.help),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 300, // 조정 가능한 폭
                  child: Center(
                    child: Text(
                      NumberFormat('#,###').format(totalEarningsAtRetirement),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  '원',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Container(
              width: 340,
              height: 1,
              color: Colors.grey,
            ),
            const SizedBox(height: 10),
            // 은퇴시점 총 자산
            Stack(
              children: [
                const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '은퇴시점 총 자산',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: -11,
                  right: 26,
                  child: IconButton(
                    color: Colors.grey,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('은퇴시점 총 자산'),
                            content: const Text('설명'),
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
                    icon: const Icon(Icons.help),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 300, // 조정 가능한 폭
                  child: Center(
                    child: Text(
                      NumberFormat('#,###').format(totalAssetsAtRetirement),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  '원',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Container(
              width: 340,
              height: 1,
              color: Colors.grey,
            ),
            const SizedBox(height: 10),
            // 은퇴시점 총 수익률
            Stack(
              children: [
                const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '은퇴시점 총 수익률',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: -11,
                  right: 26,
                  child: IconButton(
                    color: Colors.grey,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('은퇴시점 총 수익률'),
                            content: const Text('설명'),
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
                    icon: const Icon(Icons.help),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 300, // 조정 가능한 폭
                  child: Center(
                    child: Text(
                      totalReturnAtRetirement.toStringAsFixed(2),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  '%',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Container(
              width: 340,
              height: 1,
              color: Colors.grey,
            ),
            const SizedBox(height: 10),
            //
            Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey,
            ),
            const SizedBox(height: 10),
            // 목표자산 달성률
            Stack(
              children: [
                const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '목표자산 달성률',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: -11,
                  right: 26,
                  child: IconButton(
                    color: Colors.grey,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('목표자산 달성률'),
                            content: const Text('설명'),
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
                    icon: const Icon(Icons.help),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 300, // 조정 가능한 폭
                  child: Center(
                    child: Text(
                      achievementRate.toStringAsFixed(2),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  '%',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Container(
              width: 340,
              height: 1,
              color: Colors.grey,
            ),
            const SizedBox(height: 10),
            //
            Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey,
            ),
            const SizedBox(height: 1),
            Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey,
            ),
            // 자산별 세부정보 확인 버튼
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease,
                      );
                    },
                    child: const Text('세부정보 확인'),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThirdPage() {
    // 선택된 자산 변수 초기화
    int principal = 0; // 원금
    int profit = 0; // 수익금
    int totalProfit = 0; // 총 수익금
    int totalAsset = 0; // 총자산
    double totalReturn = 0; // 총 수익률

    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text('추가 납입금은 연 초에 납입한다고 가정'),
            const Text('총 자산은 해당 나이의 연 말을 기준으로 함'),
            const SizedBox(height: 10),
            //
            Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey,
            ),
            const SizedBox(height: 5),
            // 선택된 자산의 기본정보 출력 위젯
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 5),
                  Text('초기 납입금 : ${startMoney.text}'),
                  Text('연 복리수익률 : ${annualCompoundInterestIncomeRate.text} %'),
                  Text('연 추가 납입금 : ${annualPayment.text} 원'),
                ],
              ),
            ),
            //
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
                    principal = int.parse(startMoney.text.replaceAll(',', ''));

                    // 수익금
                    profit =
                        ((int.parse(annualPayment.text.replaceAll(',', '')) +
                                    principal) *
                                (double.parse(
                                        annualCompoundInterestIncomeRate.text) /
                                    100))
                            .toInt();

                    // 총 자산
                    totalAsset =
                        int.parse(annualPayment.text.replaceAll(',', '')) +
                            principal +
                            profit;
                  } else {
                    // 원금
                    principal +=
                        int.parse(annualPayment.text.replaceAll(',', ''));

                    // 수익금
                    profit =
                        ((int.parse(annualPayment.text.replaceAll(',', '')) +
                                    totalAsset) *
                                (double.parse(
                                        annualCompoundInterestIncomeRate.text) /
                                    100))
                            .toInt();

                    // 총 자산
                    totalAsset +=
                        int.parse(annualPayment.text.replaceAll(',', '')) +
                            profit;
                  }

                  // 총 수익금
                  totalProfit += profit;

                  // 총 수익률
                  if (totalAsset != 0) {
                    // 원금이 0이 아닌 경우
                    totalReturn = totalProfit / principal * 100;
                  } else {
                    // 원금이 0인 경우
                    totalReturn = 0;
                  }

                  return DataRow(cells: [
                    DataCell(Text('$age')),
                    DataCell(
                      // 원금
                      Text('${NumberFormat('#,###').format(principal)} 원'),
                    ),
                    DataCell(
                      //해당 연도 수익금
                      Text('${NumberFormat('#,###').format(profit)} 원'),
                    ),
                    DataCell(
                      // 총 수익금
                      Text('${NumberFormat('#,###').format(totalProfit)} 원'),
                    ),
                    DataCell(
                      // 총 자산
                      Text('${NumberFormat('#,###').format(totalAsset)} 원'),
                    ),
                    DataCell(
                      // 총 수익률
                      Text('${totalReturn.toStringAsFixed(2)} %'),
                    ),
                  ]);
                }),
              ),
            ),
            //
            Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey,
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
