import 'package:flutter/material.dart';
import '../../../login/login.dart';

import 'record.dart';
import 'email_change.dart';
import 'id_change.dart';
import 'phone_number_change.dart';
import 'pw_change.dart';

// 내 정보 : 개인 정보 수정 가능(회원가입할 때 사용했던 정보들)
// Home에서 입력한 정보가 아닌 회원가입할 때 사용힌 개인정보 변경
class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              const UserInfoChangeButton(title: '계산 기록', nextPage: Record()),
              const Divider(),
              const UserInfoChangeButton(title: '아이디 변경', nextPage: IdChange()),
              const Divider(),
              const UserInfoChangeButton(
                  title: '비밀번호 변경', nextPage: PwChange()),
              const Divider(),
              const UserInfoChangeButton(
                  title: '이메일 변경', nextPage: EmailChange()),
              const Divider(),
              const UserInfoChangeButton(
                  title: '전화번호 변경', nextPage: PhoneNumberChange()),
              const Divider(),
              UserInfoChangeButton(
                title: '로그아웃',
                buttonColor: Colors.red, // 버튼 색상 변경
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('로그아웃'),
                        content: const Text('로그아웃 하시겠습니까?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // 다이얼로그 닫기
                            },
                            child: const Text('취소'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // 다이얼로그 닫기
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const Login(),
                                ),
                              );
                            },
                            child: const Text('로그아웃'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              const Divider(),
              Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(10),
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('회원탈퇴'),
                          content: const Text('회원탈퇴 하시겠습니까?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // 다이얼로그 닫기
                              },
                              child: const Text('취소'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // 다이얼로그 닫기
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => const Login(),
                                  ),
                                );
                              },
                              child: const Text('회원탈퇴'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text(
                    '회원탈퇴',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
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

class UserInfoChangeButton extends StatelessWidget {
  final String title;
  final Widget? nextPage;
  final Color? buttonColor;
  final VoidCallback? onPressed;

  const UserInfoChangeButton({
    Key? key,
    required this.title,
    this.nextPage,
    this.buttonColor,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => nextPage!),
          );
        },
        child: Text(
          title,
          style: TextStyle(fontSize: 18, color: buttonColor),
        ),
      ),
    );
  }
}
