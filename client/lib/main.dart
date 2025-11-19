import 'package:client/core/databases/cache/cache_helper.dart';
import 'package:client/core/routes/app_routes.dart';
import 'package:client/core/services/services_locator.dart';
import 'package:client/core/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding();
  setupServiceLocator();
  await getIt<CacheHelper>().init();
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkThemeMode,
      routerConfig: router,
    );
  }
}
