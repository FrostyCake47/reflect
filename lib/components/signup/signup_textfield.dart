import 'package:flutter/material.dart';
import 'package:reflect/constants/colors.dart';

class SignUpTextField extends StatelessWidget {
  final String text;
  final TextEditingController controller;
  final ThemeData themeData;
  const SignUpTextField({super.key, required this.text, required this.controller, required this.themeData});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: controller,
        style: themeData.textTheme.bodyMedium,
        decoration: InputDecoration(
          labelStyle: themeData.textTheme.bodyMedium,
          labelText: text,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: themeData.colorScheme.onPrimary
            ),
            borderRadius: BorderRadius.circular(8)
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: themeData.colorScheme.primary,
              width: 2
            )
          )
        ),
      ),
    );
  }
}