import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'firebase_options.dart';
import 'locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  setupLocator();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final GoRouter router = GetIt.instance.get();
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router( // ✅ Use MaterialApp.router
      title: 'Trip Planner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: false),
      routerConfig: router, // ✅ Correct here
    );
  }
}
