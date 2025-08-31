import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:trip_planner/repo/local_repo.dart';
import 'package:trip_planner/repo/user_repo.dart';
import 'package:trip_planner/screens/upload_content_screen.dart';
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
  int _currentIndex = 0;

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
        title: const Text('AI Marketplace Assistant'),
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
                        Future.delayed(Duration.zero, () => _profile(context));
                      },
                    ),
                    PopupMenuItem(
                      child: const Text("Logout"),
                      onTap: () {
                        Future.delayed(Duration.zero, () => _logout(context));
                      },
                    ),
                  ],
                );
              },
              child: CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(user?.photoUrl ?? ''),
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          children: [
            _buildCard(
              icon: Icons.upload_file,
              title: "Upload Content",
              subtitle: "Add your video and thumbnail",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const UploadContentScreen()),
                );
              },
            ),
            _buildCard(
              icon: Icons.comment,
              title: "Analyze Comments",
              subtitle: "AI-powered insights",
              onTap: () {
                // Later implementation
              },
            ),
            _buildCard(
              icon: Icons.lightbulb,
              title: "Insights & Ideas",
              subtitle: "Discover new opportunities",
              onTap: () {
                // Later implementation
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          if (index == 1) {
            context.push(AppRoute.profile.path);
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[200],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.red),
            const SizedBox(height: 10),
            Text(title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: Colors.black54)),
          ],
        ),
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