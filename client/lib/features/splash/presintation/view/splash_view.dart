import 'package:client/core/databases/cache/cache_helper.dart';
import 'package:client/core/functions/navigation.dart';
import 'package:client/core/services/services_locator.dart';
import 'package:client/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    bool isOnboardingVisited =
        getIt<CacheHelper>().getData(key: "isOnboardingVisited") ?? false;
    if (isOnboardingVisited == true) {
      delayedNavigation(context, "/signup");
    } else {
      delayedNavigation(context, "/onboarding");
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("DeepReads", style: CustomTextStyles.pacifico400style64),
      ),
    );
  }
}

void delayedNavigation(context, path) {
  Future.delayed(const Duration(seconds: 3), () {
    customReplacementNavigation(context, path);
  });
}
