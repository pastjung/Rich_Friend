import 'package:flutter/material.dart';
import 'find_id.dart';
import 'find_pw.dart';
import 'create_account.dart';
import '../menu/title_menu/home/home.dart';

bool isUserLoggedIn = false; // 사용자의 로그인 여부
String userName = "사용자 이름";

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  String currentPage = 'login';

  void changePage(String page) {
    setState(() {
      currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff9DD7DD), // hex값으로 설정 = "oxff" + 설정값
          shape: const RoundedRectangleBorder(
            // AppBar의 하단바 모서리 둥글게
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12)),
          ),
          centerTitle: true, // AppBar의 title을 중앙으로 정렬
          title: const Column(
            children: [
              Text(
                '부자 친구',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                '로그인',
                style: TextStyle(fontSize: 10),
              ),
            ],
          ),
        ),
        body: currentPage == 'findId'
            ? FindID(changePage)
            : currentPage == 'findPw'
                ? FindPW(changePage)
                : currentPage == 'createAccount'
                    ? CreateAccount(changePage)
                    : _buildLoginBody());
  }

  // currentPage에 따라서 로그인 창의 body 변경하기
  Widget _buildLoginBody() {
    return Center(
      // 스크롤링 설정
      child: SingleChildScrollView(
        child: Container(
          width: 300, // 로그인 창의 폭
          height: 250, // 로그인 창의 높이
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xff9CE8EE),
            borderRadius: BorderRadius.circular(12), // 로그인 창 모세리 둥글게
          ),
          child: Column(
            // 로그인 창 내부 사각형 위젯 안쪽 중앙 정렬
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              TextFormField(
                decoration: const InputDecoration(
                  hintText: '아이디',
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: '비밀번호',
                ),
              ),
              Row(
                // 아이디 찾기, 비밀번호 찾기, 회원가입 버튼 좌우 대칭
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      changePage('findId');
                    },
                    child: const Text(
                      'ID찾기',
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      changePage('findPw');
                    },
                    child: const Text(
                      'PW찾기',
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      changePage('createAccount');
                    },
                    child: const Text(
                      '회원가입',
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ),
                ],
              ),
              Container(
                width: 200, // 버튼의 폭
                height: 50, // 버튼의 높이
                decoration: BoxDecoration(
                  color: const Color(0xffAE8FDC),
                  borderRadius: BorderRadius.circular(12), // 모서리를 둥글게 만듦
                ),
                child: TextButton(
                  onPressed: () {
                    // 로그인 로직 : 나중에 데이터베이스 연결시키기
                    Navigator.pushAndRemoveUntil(
                      // push : 스택에 저장하고 페이지 이동
                      // pushReplacement : 해당 페이지는 스택에서 제거하고 페이지 이동
                      // pushAndRemoveUntil : 스택을 비우고 페이지 이동
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Home(),
                      ),
                      (route) => false, // 모든 페이지를 제거하기 위해 false를 반환
                    );
                    setState(() {
                      isUserLoggedIn = true;
                    });
                  },
                  child: const Text(
                    '로그인',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: Login()));
}
