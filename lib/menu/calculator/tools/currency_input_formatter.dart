import 'package:flutter/services.dart';
import 'package:intl/intl.dart'; // NumberFormat을 사용하기 위한 라이브러리

// 사용자가 값을 입력할 때 입력 값을 숫자로 변환 후 천 단위로 콤마 추가
class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    final List<String> parts = newValue.text.split('.');
    if (parts.length > 2) {
      return oldValue; // prevent entering more than one dot
    }

    String integerPart = parts[0].replaceAll(',', '');
    if (integerPart.isEmpty) {
      integerPart = '0';
    }

    final int value = int.parse(integerPart);

    final String newText = NumberFormat('#,###').format(value);

    if (parts.length == 2) {
      return newValue.copyWith(
        text: '$newText.${parts[1]}',
        selection: TextSelection.collapsed(offset: newText.length + 1),
      );
    } else {
      return newValue.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
      );
    }
  }
}
