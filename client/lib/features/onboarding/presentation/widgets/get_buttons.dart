import 'package:client/core/functions/navigation.dart';
import 'package:client/core/utils/app_text_styles.dart';
import 'package:client/core/widgets/custom_button.dart';
import 'package:client/features/onboarding/data/models/on_boarding_model.dart';
import 'package:client/features/onboarding/presentation/views/functions/onboarding.dart';
import 'package:flutter/material.dart';

class GetButtons extends StatelessWidget {
  const GetButtons({
    super.key,
    required this.currentIndex,
    required this.controller,
  });

  final int currentIndex;
  final PageController controller;

  @override
  Widget build(BuildContext context) {
    if (currentIndex == onBoardingData.length - 1) {
      return Column(
        children: [
          CustomButton(
            text: "Create Account",
            onTap: () {
              onBoardingVisited();
              customReplacementNavigation(context, "/signup");
            },
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              onBoardingVisited();
              customReplacementNavigation(context, "/login");
            },
            child: Text(
              "Login Now",
              style: CustomTextStyles.poppins300style16.copyWith(
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      );
    } else {
      return CustomButton(
        text: "Next",
        onTap: () {
          controller.nextPage(
            duration: Duration(microseconds: 200),
            curve: Curves.bounceIn,
          );
        },
      );
    }
  }
}
