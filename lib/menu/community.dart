import 'package:flutter/material.dart';

// 커뮤니티 : 사용자들끼리 정보를 공유할 수 있는 공간
class Community extends StatelessWidget {
  const Community({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 20),
              Text(
                '보류',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(
                  width: 380,
                  child: Divider(color: Colors.red, thickness: 2.0)),
              SizedBox(height: 600),
              Text(
                '커뮤니티',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
