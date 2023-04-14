// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:delivery_app_tutorial/common/constants/colors.dart';

class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final String? errorText;
  final bool isSecret;
  final bool isAutoFocus;
  final ValueChanged<String>? onChanged;

  const CustomTextFormField({
    Key? key,
    this.hintText,
    this.errorText,
    this.isSecret = false,
    this.isAutoFocus = false,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const baseBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: uBorderColor,
        width: 1.0,
      ),
    );

    return TextFormField(
      cursorColor: uPrimaryColor,
      obscureText: isSecret,
      autofocus: isAutoFocus,
      onChanged: onChanged,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(20),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: uFontBodyColor,
          fontSize: 14.0,
        ),
        errorText: errorText,
        fillColor: uInputColor,
        filled: true,
        border: baseBorder,
        enabledBorder: baseBorder,
        focusedBorder: baseBorder.copyWith(
          borderSide: const BorderSide(
            color: uPrimaryColor,
            width: 1.0,
          ),
        ),
      ),
    );
  }
}
