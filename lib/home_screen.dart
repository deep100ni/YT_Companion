import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'app_route.dart'; // for AppRoute.login

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    // Redirect to login screen
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
