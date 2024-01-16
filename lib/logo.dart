import 'package:flutter/material.dart';

class Logo extends StatefulWidget {
  const Logo({super.key});

  @override
  State<Logo> createState() => _LogoState();
}

class _LogoState extends State<Logo> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      // WillPopScope위젯 : 뒤로가기 버튼이나 사용자가 앱을 닫으려고 할 때의 동작을 제어
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
    );
  }
}
