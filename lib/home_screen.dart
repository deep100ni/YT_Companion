import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:trip_planner/local_repo.dart';
import 'package:trip_planner/user_repo.dart';
import 'app_route.dart';

class HomeScreen extends StatelessWidget {
  final UserRepo userRepo = GetIt.I.get();
  final LocalRepo localRepo = GetIt.I.get();

  HomeScreen({super.key}) {
    test();
  }

  Future<void> test() async {
//    final user = AppUser(name: 'Deep Soni', email: 'deep@example.com');
//    await userRepo.saveUser(user);
//    print('DEEPLOG userSaved!');

//    final user = await userRepo.getUser('deep@example.com');
//    print('DEEPLOG user: ${user?.toJson()}');
  }

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    await localRepo.onLoggedOut();
    // Redirect to login screen
    if (!context.mounted) return;

    context.go(AppRoute.login.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        title: Text('Home Screen'),
        backgroundColor: Colors.red,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Color(0xFFDDEBFF),
                  child: Icon(
                    Icons.person_outline,
                    size: 60,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Center(
                child: Text(
                  'Deep Soni',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  'deep@example.com',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _logout(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Log out"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
