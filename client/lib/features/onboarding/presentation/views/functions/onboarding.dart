import 'package:client/core/databases/cache/cache_helper.dart';
import 'package:client/core/services/services_locator.dart';

void onBoardingVisited() {
  getIt<CacheHelper>().saveData(key: "isOnboardingVisited", value: true);
}
