import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // NumberFormat을 사용하여 콤마 붙이기

import '../../../title_menu/home/home.dart';

import 'retirement_cal.dart';
import 'first_page.dart';

// 4페이지 변수
Asset? selectedAsset; // DropdownButtons에서 선택된 항목을 저장할 변수
String assetName = ""; // DropdownButtons에서 선택된 자산의 이름
String assetIncome = ""; //DropdownButtons에서 선택된 자산의 수익률
String assetAnnualPayment = ""; //DropdownButtons에서 선택된 자산의 연 추가 납입금

class FourthPage extends StatefulWidget {
  // GlobalKey 추가
  static final GlobalKey<RetirementCalState> fourthKey =
      GlobalKey<RetirementCalState>();

  const FourthPage({
    Key? key,
  }) : super(key: key);

  @override
  State<FourthPage> createState() => _FourthPageState();
}

class _FourthPageState extends State<FourthPage> {
  @override
  Widget build(BuildContext context) {
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
