import 'package:go_router/go_router.dart';

void customReplacementNavigation(context, String route) {
  GoRouter.of(context).pushReplacement(route);
}

void customNavigation(context, String route) {
  GoRouter.of(context).push(route);
}
