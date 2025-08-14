import 'package:go_router/go_router.dart';
import 'package:trip_planner/signup_screen.dart';
import 'app_route.dart';
import 'home_screen.dart';
import 'login_screen.dart';

GoRouter getAppRouter(AppRoute initialLocation){
  return GoRouter(
    initialLocation: initialLocation.path,
    observers: [],
    routes: [
      GoRoute(
        path: AppRoute.home.path,
        name: AppRoute.home.name,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoute.login.path,
        name: AppRoute.login.name,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoute.signup.path,
        name: AppRoute.signup.name,
        builder: (context, state) => const SignUpScreen(),
      ),
    ]
  );
}