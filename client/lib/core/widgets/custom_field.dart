import 'package:client/core/utils/app_colors.dart';
import 'package:client/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final bool isObscureText;
  final String? hintText;

  const CustomField({
    super.key,
    required this.labelText,
    required this.controller,
    this.isObscureText = false,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, left: 8.0, top: 24.0),
      child: TextFormField(
        controller: controller,
        cursorColor: Pallete.blackColor,
        style: const TextStyle(color: Pallete.blackColor, fontSize: 16),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: CustomTextStyles.poppins500style18,
          filled: true,
          fillColor: Pallete.whiteColor,
          enabledBorder: getBorderStyle(),
          focusedBorder: getBorderStyle(),
        ),
        obscureText: isObscureText,
        validator: (value) {
          if (value!.trim().isEmpty) {
            return "this field is required";
          } else {
            return null;
          }
        },
      ),
    );
  }
}

OutlineInputBorder getBorderStyle() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(4),
    borderSide: BorderSide(color: Pallete.greenColor),
  );
}
