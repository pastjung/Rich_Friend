import 'package:flutter/material.dart'; // 필수 라이브러리 가져오기
import 'menu/title_menu/home/home.dart';
import 'logo.dart';
import 'dart:async'; // 타이머 클래스 가져오기
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  // main 함수 : 앱의 진입점
  await Firebase.initializeApp();
  runApp(const MaterialApp(
    home: MainApp(), // MainAPP 위젯 : 앱 시작점
  ));
}

class MainApp extends StatefulWidget {
  // MainApp클래스 : StatefulWidget이며 앱의 최상위 위젯 역할을 함
  const MainApp({Key? key}) : super(key: key);

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  // MainAppState클래스 : MainApp 위젯의 상태를 관리함

  @override
  void initState() {
    // 앱 초기화시 최초 1회만 실행되는 함수
    super.initState();

    // 타이머 : 4초 후 화면을 전환
    Timer(const Duration(seconds: 4), () {
      _navigateToLoginScreen(); // 만약 계속 대기시켜야 하거나, 점검중일 경우 조건문 활용할 수 있음
    });
  }

  // Navigator를 사용하여 화면을 전환하는 함수
  void _navigateToLoginScreen() {
    // pushReplacement : 현재 화면을 'Login' 화면으로 전환
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const Home()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // build 함수 : 화면을 구성하며, 'Scaffold'위젯을 반환함

    return const MaterialApp(
      // MaterialApp : 모든 하위 페이지나 구성요소를 최 상단에서 담는 그릇
      home: Logo(),
    );
  }
}
