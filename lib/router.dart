import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:trip_planner/repo/local_repo.dart';
import 'package:trip_planner/screens/profile_screen.dart';
import 'app_route.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

Future<GoRouter> getAppRouter() async {
  final LocalRepo localRepo = GetIt.I.get();

  AppRoute initialLocation;
  if (await localRepo.isLoggedIn()){
    initialLocation = AppRoute.home;
  }else{
    initialLocation = AppRoute.login;
  }

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
        builder: (context, state) => HomeScreen(),
      ),
      GoRoute(
        path: AppRoute.profile.path,
        name: AppRoute.profile.name,
        builder: (context, state) => ProfileScreen(),
      ),
    ]
  );
}