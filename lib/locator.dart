// locator.dart
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:trip_planner/router.dart';
import 'package:trip_planner/repo/user_repo.dart';
import 'repo/local_repo.dart' ;

final GetIt locator = GetIt.instance;

Future<void> setupLocator() async {

  locator.registerSingleton<LocalRepo>(LocalRepo());
  locator.registerSingleton<UserRepo>(UserRepo());

  // Register GoRouter
  locator.registerSingleton<GoRouter>(
    await getAppRouter(), // you can change initial route here
  );
}
