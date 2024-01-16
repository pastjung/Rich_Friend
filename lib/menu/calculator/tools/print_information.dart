import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // NumberFormat을 사용하여 콤마 붙이기

class PrintInformation extends StatelessWidget {
  final String labelText; // 제목
  final String helpDialogTitle; // 설명 제목
  final String helpDialogText; // 설명 내용
  final dynamic value; // 출력할 변수

  const PrintInformation({
    super.key,
    required this.labelText,
    required this.helpDialogTitle,
    required this.helpDialogText,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 제목 & 도움 말
        Stack(
          clipBehavior: Clip.none,
          children: [
            Center(
              child: Column(
                // 제목
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    labelText,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
            // 도움 말
            Positioned(
              top: -10,
              right: 14,
              child: IconButton(
                color: Colors.grey,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(helpDialogTitle),
                        content: Text(helpDialogText),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('닫기'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(Icons.help),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // 출력 값
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                // 사용 가능한 공간 중에서 모든 남은 공간을 차지하는 역할을 하는 위젯
                // Flex 위젯 내에서 다른 자식 위젯이나 위젯 트리에서 유용
                child: Center(
                  child: Text(
                    (value is int)
                        // value 가 int 타입인 경우
                        ? NumberFormat('#,###').format(value)
                        : (value is double)
                            // value 가 double 타입인 경우
                            ? value.toStringAsFixed(2)
                            // value가 Controller일 때
                            : value,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                (value is double) ? '%' : '원',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        // 밑줄
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Container(
            width: double.infinity,
            height: 1,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
