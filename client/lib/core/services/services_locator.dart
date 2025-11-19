import 'package:client/core/connection/network_info.dart';
import 'package:client/core/databases/cache/cache_helper.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Cache
  getIt.registerSingleton<CacheHelper>(CacheHelper());

  // Network
  getIt.registerSingleton<Connectivity>(Connectivity());
  getIt.registerSingleton<NetworkInfo>(NetworkInfoImpl(getIt<Connectivity>()));
}
