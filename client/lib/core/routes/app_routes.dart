import 'package:client/features/auth/presentation/screens/forget_password.dart';
import 'package:client/features/auth/presentation/screens/login.dart';
import 'package:client/features/auth/presentation/screens/sign_up.dart';
import 'package:client/features/main/presentation/pages/main_scaffold.dart';
import 'package:client/features/onboarding/presentation/views/on_boarding_view.dart';
import 'package:client/features/splash/presintation/view/splash_view.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(path: "/", builder: (context, state) => const SplashView()),
    GoRoute(
      path: "/onboarding",
      builder: (context, state) => const OnBoardingView(),
    ),
    GoRoute(path: "/signup", builder: (context, state) => const SignUpPage()),
    GoRoute(path: "/login", builder: (context, state) => const LoginPage()),
    GoRoute(
      path: "/forgetPsw",
      builder: (context, state) => const ForgetPasswordPage(),
    ),
    GoRoute(path: "/home", builder: (context, state) => const MainScaffold()),
  ],
);
