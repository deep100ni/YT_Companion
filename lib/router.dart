import 'package:go_router/go_router.dart';
import 'app_route.dart';
import 'home_screen.dart';
import 'login_screen.dart';

Future<GoRouter> getAppRouter(AppRoute initialLocation) async {
  return GoRouter(
    initialLocation: initialLocation.path,
    routes: [
      GoRoute(
        path: AppRoute.login.path,
        name: AppRoute.login.name,
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: AppRoute.home.path,
        name: AppRoute.home.name,
        builder: (context, state) => const HomeScreen(),
      ),
    ]
  );
}