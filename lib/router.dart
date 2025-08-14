import 'package:go_router/go_router.dart';

import 'app_route.dart';
import 'login_screen.dart';

GoRouter getAppRouter(AppRoute initialLocation){
  return GoRouter(
    initialLocation: initialLocation.path,
    observers: [RouteChangeListener()],
    routes: [
      GoRoute(
        path: AppRoute.login.path,
        name: AppRoute.login.name,
        builder: (context, state) => const LoginScreen(),
      ),
    ]
  );
}