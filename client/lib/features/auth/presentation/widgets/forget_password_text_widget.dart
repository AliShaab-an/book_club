import 'package:client/core/functions/navigation.dart';
import 'package:client/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class ForgetPasswordWidget extends StatelessWidget {
  const ForgetPasswordWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        customNavigation(context, "/forgetPsw");
      },
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          "Forget Password ?",
          style: CustomTextStyles.poppins600style28.copyWith(fontSize: 12),
        ),
      ),
    );
  }
}
