import 'package:flutter/material.dart';

class Logo extends StatefulWidget {
  const Logo({super.key});

  @override
  State<Logo> createState() => _LogoState();
}

class _LogoState extends State<Logo> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // WillPopScope위젯 : 뒤로가기 버튼이나 사용자가 앱을 닫으려고 할 때의 동작을 제어
      onWillPop: () async => false,
      // 뒤로 가기 버튼을 눌러도 액션이 수행되지 않도록 설정, "onWillPop : null"일 경우 WillPopScope가 동작X

      child: MediaQuery(
        // 앱화면 크기 알아내는 클래스 : Container로 감싼 후 아래 명령어를 사용하여 해당 Container의 크기 반환
        // MediaQuery.of(context).size/size.height/size.width/devicePixelRatio/padding.top
        // 앱 화면 크기(넓이,높이)/앱 화면 높이 double/ 앱 화면 넓이 double/화면 배율/상단 상태 표시줄 높이
        // -> 이때 이 값들은 실제 픽셀 값이 아닌 논리적 픽셀값이므로 화면배율(devicePixelRatio)를 곱하면 실제 픽셀 값을 알 수 있다.

        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        //사용자가 기기의 설정으로 폰트 크기를 변경한 것을 무시하고 폰트 크기를 고정하는 코드
        // textScaleFactor를 1.0으로 설정하여 사용자의 폰트 크기 설정을 무시

        child: Scaffold(
          backgroundColor: Colors.blue.shade100, // 바탕화면 색상
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // ListView : Widget 리스트
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 로고 만들기 : 나중에 이미지를 만들어서 불러오는 식으로 변경하기
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20), // 모서리 둥글게 만들기
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '부자',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '친구',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
