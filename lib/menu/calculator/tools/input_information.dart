import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // TextField에 숫자만 입력받을 수 있도록 설정하기 위한 라이브러리

import 'currency_input_formatter.dart'; // 입력 받은 값 변경

class InputInformation extends StatelessWidget {
  final String labelText; // 제목
  final String helpDialogTitle; // 설명 제목
  final String helpDialogText; // 설명 내용
  final TextEditingController value; // 입력받는 변수
  final String hint; // 힌트 텍스트
  final String unit; // 단위

  const InputInformation({
    super.key,
    required this.labelText,
    required this.helpDialogTitle,
    required this.helpDialogText,
    required this.value,
    required this.hint,
    required this.unit,
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

        // 입력 공간
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                // 사용 가능한 공간 중에서 모든 남은 공간을 차지하는 역할을 하는 위젯
                // Flex 위젯 내에서 다른 자식 위젯이나 위젯 트리에서 유용
                child: (unit == '원')
                    ?
                    // 입력값이 '원'일 경우
                    TextField(
                        textAlign: TextAlign.center, // 입력값을 중앙 정렬
                        controller: value,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          hintText: hint,
                        ),
                        // TextField에 숫자와 소수점만 입력 가능하게 변경
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: <TextInputFormatter>[
                          // 숫자만 입력 받을 수 있게 설정
                          FilteringTextInputFormatter.digitsOnly,
                          // 입력시 천의 자리마다 콤마(,) 자동으로 붙이기
                          CurrencyInputFormatter(),
                        ],
                      )
                    :
                    // 입력값이 '%' 인 경우
                    TextField(
                        textAlign: TextAlign.center, // 입력값을 중앙 정렬
                        controller: value,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          hintText: hint,
                        ),
                        // TextField에 숫자와 소수점만 입력 가능하게 변경
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: <TextInputFormatter>[
                          // 숫자와 소수점만 입력 받을 수 있게 설정
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d{0,2}'),
                          ),
                        ],
                      ),
              ),
              const SizedBox(width: 10),
              Text(
                unit,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
