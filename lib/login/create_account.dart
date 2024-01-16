import 'package:flutter/material.dart';

class CreateAccount extends StatelessWidget {
  final Function(String) changePage;

  const CreateAccount(this.changePage, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Login 창의 body부분
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 300,
            height: 400,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xff9CE8EE),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: '이름',
                  ),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: '아이디',
                  ),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: '비밀번호',
                  ),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: '전화번호',
                  ),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'E-mail',
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                        changePage('findId');
                      },
                      child: const Text(
                        'ID찾기',
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        changePage('login');
                      },
                      child: const Text(
                        '로그인',
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      ),
                    ),
                  ],
                ),

                // 회원가입 버튼
                Container(
                  width: 200,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xffAE8FDC),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextButton(
                    onPressed: () {
                      // 회원가입 로직 : 나중에 데이터베이스 연결시키기
                    },
                    child: const Text(
                      '회원가입',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
