import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomOTPField extends StatelessWidget {
  const CustomOTPField({super.key, required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
          color: const Color(0xFFF2f2f2),
          borderRadius: BorderRadius.circular(12)),
      child: TextField(
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        cursorColor: const Color(0xFF969696),
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
        style: TextStyle(color: Colors.blue[900], fontSize: 25),
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        onChanged: onChanged,
      ),
    );
  }
}
