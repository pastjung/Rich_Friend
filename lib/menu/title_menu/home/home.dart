import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // TextField에 숫자만 입력받을 수 있도록 설정하기 위한 라이브러리
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart'; // Slidable 사용(스와이프시 메뉴)

import '../../calculator/tools/currency_input_formatter.dart';
import '../my_page/my_page.dart';
import '../settings.dart';

import '../../calculator/cal/retirement_cal/retirement_cal.dart'; // 은퇴 계산기
import '../../calculator/cal/rich_cal/rich_cal.dart'; // 부자계산기

import '../../../login/login.dart';
import '../../community.dart'; // 커뮤니티
import '../suggestions.dart'; // 건의사항

import 'tools/input_information.dart'; // 자산 입력

// 현재 선택된 페이지의 이름 저장---------------------------------------------------------------------------------
String selectedPage = 'Home';

// 이름 정보 입력 받는 변수
final TextEditingController userNameController = TextEditingController();
// 연봉 정보 입력 받는 변수
final TextEditingController salaryController = TextEditingController();
// 투자 시작 나이 입력 받는 변수
final TextEditingController startYearController = TextEditingController();
// 희망 은퇴 나이 입력 받는 변수
final TextEditingController retirementAgeController = TextEditingController();

// 자산 객체
class Asset {
  String name; // 이름
  String startPayment; // 최초 납입금
  String annualPayment; // 연 납입금
  double annualReturn; // 연 기대수익률

  // 4페이지의 자산별 수익 변수
  int principal = 0; // 원금
  int profit = 0; // 수익금
  int totalProfit = 0; // 총 수익금
  int totalAsset = 0; // 총자산
  double totalReturn = 0; // 총 수익률

  Asset(this.name, this.startPayment, this.annualPayment, this.annualReturn);
}

// 자산 객체 리스트
List<Asset> assets = [];

// 연 기대수익률
double expectedReturnRate = 0;
// 총 납입금액
int totalInputMoney = 0;
// 총 납입금액(출력형태)
String formattedTotalInputMoney = "0";
// 총 연 추가납입금
int totalNewInputMoney = 0;
// 총 연 추가납입금(출력 형태)
String formattedTotalNewInputMoney = "0";
// 목표 자산
int targetAsset = 0;

// 은퇴시 최소자산(미래가치)
String minAsset = "은퇴계산기 확인하기";
// 은퇴시 여유자산(미래가치)
String freeAsset = "은퇴계산기 확인하기";

// Home : 내 정보를 확인하고 수정할 수 있는 공간
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
} // private 클래스 : 앞에 "_" 사용, public 클래스 : 앞에 아무것도 붙이지 않음

class HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // _scaffoldKey : 이 화면의 Scaffold와 과련된 동작 및 상태를 관리하고 제어하는데 사용
  // 이를 통해 앱의 사용자 인터페이스를 동적으로 조작하고 다양한 상호작용 기능을 구현 가능
  // -> 화면의 기본적인 구조를 제공 : snackbar, Drawer, 미래 페이지로의 이동 등
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // 사이드바 사용

      // AppBar
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: const Color(0xff9DD7DD),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          centerTitle: true, // 중앙 정렬

          title: Column(
            children: [
              const Text(
                '부자 친구',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                selectedPage, // 현재 선택된 페이지 이름을 표시
                style: const TextStyle(fontSize: 10),
              ),
            ],
          ),

          // AppBar에 있는 사이드바 Drawer 메뉴
          actions: [
            GestureDetector(
              onTap: _openDrawer,
              child: const Row(
                children: [
                  Icon(
                    Icons.menu,
                  ),
                  SizedBox(width: 10),
                ],
              ),
            ),
          ],
        ),
      ),

      // 화면 상하 드래그 제스처 활성화
      endDrawerEnableOpenDragGesture: true,
      // 사이드바 Drawer 펼쳤을 때 메뉴
      endDrawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // 메뉴 Header
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // 도움말 버튼
                        GestureDetector(
                          onTap: () {
                            // 아이콘을 누르면 사이드바 닫기
                            Navigator.pop(context);

                            // 도움말 기능
                          },
                          child: const Icon(
                            Icons.question_mark,
                            color: Colors.black,
                            size: 26,
                          ),
                        ),
                        // 사이드 닫기
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            // 아이콘을 누르면 사이드바 닫기
                          },
                          child: const Icon(
                            Icons.close,
                            color: Colors.black,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      height: 1,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 메뉴
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          ListTile(
                            title: const Text('은퇴계산기'),
                            onTap: () {
                              _navigateToPage('은퇴계산기');
                            },
                          ),
                          ListTile(
                            title: const Text('부자계산기'),
                            onTap: () {
                              _navigateToPage('부자계산기');
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 메뉴
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    // 큰 밑줄
                    Container(
                      width: double.infinity,
                      height: 1,
                      color: Colors.grey,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.home),
                          onPressed: () {
                            _navigateToPage('Home');
                          },
                          color: Colors.black,
                        ),
                        IconButton(
                          icon: const Icon(Icons.person),
                          onPressed: () {
                            _navigateToPage('내 정보');
                          },
                          color: Colors.black,
                        ),
                        IconButton(
                          icon: const Icon(Icons.mail),
                          onPressed: () {
                            _navigateToPage('건의사항');
                          },
                          color: Colors.black,
                        ),
                        IconButton(
                          icon: const Icon(Icons.settings),
                          onPressed: () {
                            _navigateToPage('설정');
                          },
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // 선택된 페이지에 따라 body 내용 변경
      body: _getPageForName(selectedPage),
    );
  }

  //페이지 이름에 따라 해당 페이지의 위젯 반환------------------------------------------------------------------------
  Widget _getPageForName(String pageName) {
    switch (pageName) {
      case '내 정보':
        return const MyPage();
      case '건의사항':
        return Suggestions();
      case '설정':
        return const Settings();
      case '은퇴계산기':
        return RetirementCal();
      case '부자계산기':
        return const RichCal();
      case '커뮤니티':
        return const Community();
      default:
        // 기본 페이지 : "홈" 설정
        return Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment
                    .spaceEvenly, // child widget 사이의 여유 공간을 모두 균등 배분
                crossAxisAlignment: CrossAxisAlignment.stretch, // 좌우를 꽉 차게 배치
                children: <Widget>[
                  // Home 구성 내용
                  buildLoginCard(),
                  buildInfoCard(),
                  buildAssetCard(),
                  buildRetirementInfoCard(),
                ],
              ),
            ),
          ),
        );
    }
  }

  // 사이드바 Drawer 열기 : Scaffold 상태 사용
  void _openDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  // 메뉴 항목을 클릭시 해당 페이지로 페이지 변경
  void _navigateToPage(String pageName) {
    setState(() {
      // body가 바뀌었음을 알림
      selectedPage = pageName;
    });
    Navigator.pop(context); // 사이드바 닫기
  }

  // 로그인 정보
  Widget buildLoginCard() {
    return Card(
      // 입렵받은 정보를 이용해 사용자 Card 생성
      elevation: 4, // 컨테이너 아래에 고도(shadow) 설정
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '로그인 정보',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            isUserLoggedIn
                ? Row(
                    children: [
                      const Text(
                        '이름',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Center(
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                // body가 바뀌었음을 알림
                                selectedPage = '내 정보';
                              });
                            },
                            child: Text(
                              userName,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Login()),
                        );
                      },
                      child: const Text(
                        '로그인 해주세요',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  // 개인정보 입력 위젯
  Widget buildInfoCard() {
    return Card(
      // 입렵받은 정보를 이용해 사용자 Card 생성
      elevation: 4, // 컨테이너 아래에 고도(shadow) 설정
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '개인 정보',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            // 연봉
            InputInformation(
              labelText: '연봉',
              value: salaryController,
              unit: '원',
            ),
            // 투자 시작 나이
            InputInformation(
              labelText: '투자 시작 나이',
              value: startYearController,
              unit: '세',
            ),
            // 희망 은퇴 나이
            InputInformation(
              labelText: '희망 은퇴 나이',
              value: retirementAgeController,
              unit: '세',
            ),
          ],
        ),
      ),
    );
  }

  // 자산 삭제 메서드
  void removeAsset(Asset asset) {
    setState(() {
      assets.remove(asset);
    });
  }

  // 추가한 자산을 보여주는 메서드
  void showAssetInputDialog(BuildContext context,
      {Asset? asset, VoidCallback? onAssetUpdated}) {
    TextEditingController nameController = TextEditingController();
    TextEditingController moneyController = TextEditingController();
    TextEditingController paymentController = TextEditingController();
    TextEditingController returnController = TextEditingController();

    // 수정할 자산이 존재할 경우
    if (asset != null) {
      nameController.text = asset.name;
      moneyController.text = asset.startPayment;
      paymentController.text = asset.annualPayment;
      returnController.text = asset.annualReturn.toString();
    }

    // 자산 등록 or 수정
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: SingleChildScrollView(
            child: AlertDialog(
              // 테두리 모양 설정
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),

              title: const Text('내 자산'),
              content: Column(
                children: [
                  // 자산 이름
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: '자산 이름'),
                  ),
                  const SizedBox(height: 10),
                  // 납부한 금액
                  TextField(
                    controller: moneyController,
                    decoration: const InputDecoration(labelText: '납부한금액'),

                    // TextField에 숫자와 소수점만 입력 가능하게 변경
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),

                    inputFormatters: <TextInputFormatter>[
                      // 숫자만 입력 받을 수 있게 설정
                      FilteringTextInputFormatter.digitsOnly,
                      // 입력시 천의 자리마다 콤마(,) 자동으로 붙이기
                      CurrencyInputFormatter(),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // 연 추가납입금
                  TextField(
                    controller: paymentController,
                    decoration: const InputDecoration(labelText: '연 추가납입금'),

                    // TextField에 숫자와 소수점만 입력 가능하게 변경
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),

                    inputFormatters: <TextInputFormatter>[
                      // 숫자만 입력 받을 수 있게 설정
                      FilteringTextInputFormatter.digitsOnly,
                      // 입력시 천의 자리마다 콤마(,) 자동으로 붙이기
                      CurrencyInputFormatter(),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // 연 수익률
                  TextField(
                    controller: returnController,
                    decoration: const InputDecoration(labelText: '연 수익률'),
                    // TextField에 숫자와 소수점만 입력 가능하게 변경
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: <TextInputFormatter>[
                      // 숫자와 소수점만 입력 받을 수 있게 설정
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d{0,2}'),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                // 자산 추가 버튼
                ElevatedButton(
                  onPressed: () {
                    // 입력을 확인하고 리스트에 자산 추가
                    if (nameController.text.isNotEmpty &&
                        moneyController.text.isNotEmpty &&
                        paymentController.text.isNotEmpty &&
                        returnController.text.isNotEmpty) {
                      if (asset == null) {
                        // 새로운 자산 추가
                        Asset newAsset = Asset(
                          nameController.text,
                          moneyController.text,
                          paymentController.text,
                          double.parse(returnController.text),
                        );
                        assets.add(newAsset);
                      } else {
                        // 기존 자산 수정
                        asset.name = nameController.text;
                        asset.startPayment = moneyController.text;
                        asset.annualPayment = paymentController.text;
                        asset.annualReturn =
                            double.parse(returnController.text);
                      }

                      // 자산을 추가/수정하고 컨트롤러 비우기
                      nameController.clear();
                      moneyController.clear();
                      paymentController.clear();
                      returnController.clear();

                      // 자산 추가/수정하고 UI 업데이트
                      updateUI();

                      // dialog 종료
                      Navigator.pop(context);

                      // 자산 수정일 경우
                      if (onAssetUpdated != null) {
                        onAssetUpdated();
                      }
                    } else {
                      // 칸이 비어있을 경우 에러
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              // 테두리 모양 설정
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            title: const Text('오류'),
                            content: const Text('모든 칸을 채워주세요!'),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('확인'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: const Text('추가'),
                ),
                TextButton(
                  onPressed: () {
                    // 자산추가 dialog 창 종료
                    Navigator.pop(context);
                  },
                  child: const Text('취소'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 자산 수정/삭제 후 업데이트
  void updateUI() {
    // 변수 초기화
    totalInputMoney = 0;
    totalNewInputMoney = 0;
    expectedReturnRate = 0;

    // 총 자산, 연 추가 납입금 계산
    for (var asset in assets) {
      // List의 초기 납입금에서 콤마를 제거한 후 int로 변환
      int inputMoney = int.parse(asset.startPayment.replaceAll(',', ''));

      // 총 납입금 계산
      totalInputMoney += inputMoney;

      int inputAnnualMoney = int.parse(asset.annualPayment.replaceAll(',', ''));

      // 총 연 추가 납입금 계산
      totalNewInputMoney += inputAnnualMoney;
    }

    // 연 기대수익률 계산
    for (var asset in assets) {
      // List의 납입금에서 콤마를 제거한 후 int로 변환
      int inputMoney = int.parse(asset.startPayment.replaceAll(',', ''));

      // 연 기대수익률 계산
      expectedReturnRate += asset.annualReturn * (inputMoney / totalInputMoney);
    }

    // 총 납입금 출력형태 변경
    formattedTotalInputMoney = NumberFormat('#,###').format(totalInputMoney);

    // 총 연 추가 납입금 출력형태 변경
    formattedTotalNewInputMoney =
        NumberFormat('#,###').format(totalNewInputMoney);

    // UI를 갱신하여 화면을 다시 보여줌
    setState(() {});
  }

  // 자산 등록 위젯
  Widget buildAssetCard() {
    return Card(
      // 입렵받은 정보를 이용해 사용자 Card 생성
      elevation: 4, // 컨테이너 아래에 고도(shadow) 설정
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16), // 테두리
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '내 자산',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text('총 납입금 : $formattedTotalInputMoney 원'),
            Text('총 연 추가 납입금 : $formattedTotalNewInputMoney 원'),
            Text('연 기대수익률 : ${expectedReturnRate.toStringAsFixed(2)} %'),
            const SizedBox(height: 10),
            // 추가한 자산 확인 & 삭제 버튼
            if (assets.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.grey,
                  ),
                  for (var asset in assets)
                    // 모든 자산의 정보 출력
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Slidable(
                        endActionPane: ActionPane(
                          extentRatio: 0.25, // 패널의 사이즈
                          motion: const ScrollMotion(), // 스와이프 애니메이션
                          children: [
                            // 자산 수정 버튼
                            SlidableAction(
                              flex: 1, // 여러 액션이 있을때 차지하는 비율
                              onPressed: (BuildContext context) {
                                // 수정 버튼 눌렀을 때의 동작 정의
                                showAssetInputDialog(
                                  context,
                                  asset: asset,
                                  onAssetUpdated: () {
                                    // 수정 후의 동작 정의
                                    updateUI();
                                  },
                                );
                              },
                              icon: Icons.edit,
                              label: '수정',
                            ),
                            // 자산 삭제 버튼
                            SlidableAction(
                              flex: 1,
                              onPressed: (BuildContext context) {
                                removeAsset(asset);

                                updateUI();
                              },
                              icon: Icons.delete,
                              label: '삭제',
                            ),
                          ],
                        ),
                        child: Card(
                          elevation: 2,
                          color: Colors.grey.shade100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 4),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('자산 이름 : ${asset.name}'),
                                    Text('납입한 금액 : ${asset.startPayment} 원'),
                                    Text('연 추가 납입금 : ${asset.annualPayment} 원'),
                                    Text('연 기대수익률 : ${asset.annualReturn} %'),
                                  ],
                                ),
                              ),
                              // 자산 수정 & 삭제 버튼
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            // 자산 등록 버튼
            ElevatedButton(
              onPressed: () {
                showAssetInputDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade200, // 배경 색상
                minimumSize: const Size(0, 40), // 최소 높이
                padding: const EdgeInsets.symmetric(horizontal: 16), // 내부 여백
                shape: RoundedRectangleBorder(
                  // 버틈 모서리
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                '자산 등록',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 은퇴정보 입력 위젯
  Widget buildRetirementInfoCard() {
    return Card(
      // 입렵받은 정보를 이용해 사용자 Card 생성
      elevation: 4, // 컨테이너 아래에 고도(shadow) 설정
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16), // 테두리
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '은퇴시 필요한 자산',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            // 최소자산
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "최소자산(미래가치)",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(minAsset),
                    const SizedBox(width: 10),
                    const Text(
                      '원',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            // 여유 자산
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "여유자산(미래가치)",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(freeAsset),
                    const SizedBox(width: 10),
                    const Text(
                      '원',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),

            // 은퇴계산기 확인 버튼
            ElevatedButton(
              onPressed: () {
                setState(() {
                  // body가 바뀌었음을 알림
                  selectedPage = '은퇴계산기';
                });
                _getPageForName(selectedPage);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade200, // 배경 색상
                minimumSize: const Size(0, 40), // 최소 높이
                padding: const EdgeInsets.symmetric(horizontal: 16), // 내부 여백
                shape: RoundedRectangleBorder(
                  // 버틈 모서리
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                '확인하기',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
