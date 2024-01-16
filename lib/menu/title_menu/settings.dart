import 'package:flutter/material.dart';

// 설정 : 테마 및 배경색 등 변경
class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 20),
              Text(
                '테마 및 배경색 등 변경',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(
                  width: 380,
                  child: Divider(color: Colors.red, thickness: 2.0)),
              SizedBox(height: 600),
              Text(
                'Settings',
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
