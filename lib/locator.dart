// locator.dart
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:trip_planner/router.dart';
import 'app_route.dart';
import 'local_repo.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  // Register GoRouter
  locator.registerSingleton<GoRouter>(
    getAppRouter(AppRoute.home), // you can change initial route here
  );

  locator.registerSingleton<LocalRepo>(LocalRepo());
}
