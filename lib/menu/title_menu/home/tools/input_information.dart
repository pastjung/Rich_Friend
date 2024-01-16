import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // TextField에 숫자만 입력받을 수 있도록 설정하기 위한 라이브러리

import '../../../calculator/tools/currency_input_formatter.dart';

class InputInformation extends StatelessWidget {
  final String labelText; // 제목
  final TextEditingController value; // 입력받는 변수
  final String unit; // 단위

  const InputInformation({
    super.key,
    required this.labelText,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          labelText,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 10),
        Expanded(
          // 나이를 입력받는 경우
          child: (unit == '세')
              ? TextField(
                  controller: value,
                  decoration: const InputDecoration(
                    hintText: '입력하세요',
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: <TextInputFormatter>[
                    // 숫자만 입력 받을 수 있게 설정
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  textAlign: TextAlign.center, // 중앙 정렬
                )
              :
              // 연봉을 입력받는 경우
              TextField(
                  controller: value,
                  decoration: const InputDecoration(
                    hintText: '입력하세요',
                  ),
                  // TextField에 숫자와 소수점만 입력 가능하게 변경
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: <TextInputFormatter>[
                    // 숫자만 입력 받을 수 있게 설정
                    FilteringTextInputFormatter.digitsOnly,
                    // 입력시 천의 자리마다 콤마(,) 자동으로 붙이기
                    CurrencyInputFormatter(),
                  ],
                  textAlign: TextAlign.center, // 오른쪽 정렬 추가
                ),
        ),
        const SizedBox(width: 10),
        Text(
          unit,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ],
    );
  }
}
