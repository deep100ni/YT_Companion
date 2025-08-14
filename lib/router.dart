import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:trip_planner/signup_screen.dart';
import 'app_route.dart';
import 'home_screen.dart';
import 'login_screen.dart';

GoRouter getAppRouter(AppRoute initialLocation){
  return GoRouter(
    redirect: (context, state){
      final user = FirebaseAuth.instance.currentUser;

      // If not logged in, go to login
      if (user == null && state.matchedLocation != AppRoute.login.path) {
        return AppRoute.login.path;
      }
      // If logged in and trying to access login, send to home
      if (user != null && state.matchedLocation == AppRoute.login.path) {
        return AppRoute.home.path;
      }
      return null; // No redirect
    },
    routes: [
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
      GoRoute(
        path: AppRoute.home.path,
        name: AppRoute.home.name,
        builder: (context, state) => const HomeScreen(),
      ),
    ]
  );
}