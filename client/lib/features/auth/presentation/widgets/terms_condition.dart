import 'package:client/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

import 'custom_checkbox.dart';

class TermsAndCondition extends StatelessWidget {
  const TermsAndCondition({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomCheckBox(),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "I have agree to our ",
                style: CustomTextStyles.poppins400style14,
              ),
              TextSpan(
                text: "Terms and Condition",
                style: CustomTextStyles.poppins400style14.copyWith(
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
