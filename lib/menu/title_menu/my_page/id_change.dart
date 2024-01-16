import 'package:flutter/material.dart';

// 아이디 변경
class IdChange extends StatelessWidget {
  const IdChange({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 20),
              Text(
                '커뮤니티',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(
                  width: 380,
                  child: Divider(color: Colors.red, thickness: 2.0)),
              SizedBox(height: 600),
              Text(
                'QA',
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
