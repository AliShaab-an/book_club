import 'package:client/core/utils/app_assets.dart';

class OnboardingModel {
  final String imagePath;
  final String title;
  final String subTitle;

  OnboardingModel({
    required this.imagePath,
    required this.title,
    required this.subTitle,
  });
}

List<OnboardingModel> onBoardingData = [
  OnboardingModel(
    imagePath: Assets.onBoarding1,
    title: "Explore The Book with DeepReads in a smart way",
    subTitle: "Explore The Book with DeepReads in a smart way",
  ),
  OnboardingModel(
    imagePath: Assets.onBoarding2,
    title: "Explore The Book with DeepReads in a smart way",
    subTitle: "Explore The Book with DeepReads in a smart way",
  ),
  OnboardingModel(
    imagePath: Assets.onBoarding3,
    title: "Explore The Book with DeepReads in a smart way",
    subTitle: "Explore The Book with DeepReads in a smart way",
  ),
];
