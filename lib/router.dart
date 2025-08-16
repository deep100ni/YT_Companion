import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:trip_planner/local_repo.dart';
import 'app_route.dart';
import 'home_screen.dart';
import 'login_screen.dart';

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
    ]
  );
}