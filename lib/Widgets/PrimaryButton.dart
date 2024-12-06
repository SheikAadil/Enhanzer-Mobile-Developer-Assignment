import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color? buttonColor;
  final String text;
  final Color textColor;
  final double fontSize;
  const PrimaryButton(
      {super.key,
      required this.onTap,
      required this.text,
      required this.textColor,
      required this.fontSize,
      required this.buttonColor});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Container(
          height: 50,
          width: 80,
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
