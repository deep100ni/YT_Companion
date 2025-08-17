import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:trip_planner/repo/local_repo.dart';
import 'package:trip_planner/repo/user_repo.dart';
import '../app_route.dart';
import '../models/user.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UserRepo userRepo = GetIt.I.get();
  final LocalRepo localRepo = GetIt.I.get();

  AppUser? user;

  @override
  void initState() {
    super.initState();

    start();
  }

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    await localRepo.onLoggedOut();
    if (!context.mounted) return;
    context.go(AppRoute.login.path);
  }

  void _profile(BuildContext context) {
    context.push(AppRoute.profile.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        title: const Text('Home Screen'),
        backgroundColor: Colors.red,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTapDown: (details) {
                showMenu(
                  context: context,
                  position: RelativeRect.fromLTRB(
                    details.globalPosition.dx,
                    details.globalPosition.dy,
                    MediaQuery.of(context).size.width - details.globalPosition.dx,
                    0,
                  ),
                  items: [
                    PopupMenuItem(
                      child: const Text("Profile"),
                      onTap: () {
                        Future.delayed(
                          Duration.zero,
                              () => _profile(context),
                        );
                      },
                    ),
                    PopupMenuItem(
                      child: const Text("Logout"),
                      onTap: () {
                        Future.delayed(
                          Duration.zero,
                              () => _logout(context),
                        );
                      },
                    ),
                  ],
                );
              },
              child: CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(
                  user?.photoUrl ?? ''
                ),
              ),
            ),
          )
        ],
      ),
      body: const Center(
        child: Text("Home Screen Body"),
      ),
    );
  }

  Future<void> start() async {
    final _user = await localRepo.getUser();
    setState(() {
      user = _user;
    });
  }
}
