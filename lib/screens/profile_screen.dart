import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import 'package:trip_planner/app_route.dart';
import 'package:trip_planner/models/user.dart';
import 'package:trip_planner/repo/local_repo.dart';
import 'package:trip_planner/repo/user_repo.dart';
import 'package:trip_planner/services/youtube_service.dart';
import 'package:trip_planner/widget/api_key_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController handleController = TextEditingController();

  final UserRepo userRepo = UserRepo();
  final LocalRepo localRepo = GetIt.I.get();
  final YoutubeService youtubeService = YoutubeService();

  DateTime? selectedDate;
  Gender? gender;
  File? profileImage;
  User? user;
  String? channelId;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      nameController.text = user!.displayName ?? "";
      emailController.text = user!.email ?? "";
    }
  }

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
    await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() => profileImage = File(pickedFile.path));
    }
  }

  Future<void> _fetchChannelId() async {
    if (handleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a YouTube handle")),
      );
      return;
    }

    final handle = handleController.text.trim();
    final id = await youtubeService.fetchChannelIdFromHandle(handle);
    if (id != null) {
      setState(() => channelId = id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Channel ID: $channelId")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid handle or no channel found")),
      );
    }
  }

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    await localRepo.onLoggedOut();
    if (!context.mounted) return;
    context.go(AppRoute.login.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        title: const Text('Profile Screen'),
        backgroundColor: Colors.red,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 40),

                // Profile Image
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: const Color(0xFFDDEBFF),
                        backgroundImage: profileImage != null
                            ? FileImage(profileImage!)
                            : (user?.photoURL != null
                            ? NetworkImage(user!.photoURL!)
                            : null) as ImageProvider?,
                        child: (profileImage == null && user?.photoURL == null)
                            ? const Icon(Icons.person_outline,
                            size: 70, color: Colors.grey)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.camera_alt,
                                color: Colors.white, size: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Name
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Full Name",
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 16),

                // Email
                TextField(
                  controller: emailController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Email",
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 16),

                // DOB
                InkWell(
                  onTap: _pickDate,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Date of Birth",
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    child: Text(
                      selectedDate == null
                          ? "Select your DOB"
                          : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Gender
                Column(
                  children: [
                    RadioListTile<String>(
                      title: const Text("Male"),
                      value: Gender.male.name,
                      groupValue: gender?.name,
                      onChanged: (v) => setState(() => gender = Gender.male),
                    ),
                    RadioListTile<String>(
                      title: const Text("Female"),
                      value: Gender.female.name,
                      groupValue: gender?.name,
                      onChanged: (v) => setState(() => gender = Gender.female),
                    ),
                    RadioListTile<String>(
                      title: const Text("Other"),
                      value: Gender.other.name,
                      groupValue: gender?.name,
                      onChanged: (v) => setState(() => gender = Gender.other),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // YouTube Handle Input
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("YouTube Channel",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        TextField(
                          controller: handleController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Enter YouTube Handle (e.g. @Fukarey_7)",
                            prefixIcon: Icon(Icons.alternate_email),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: _fetchChannelId,
                          child: const Text("Fetch Channel ID"),
                        ),
                        if (channelId != null) ...[
                          const SizedBox(height: 8),
                          Text("Channel ID: $channelId",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green)),
                        ]
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Gemini API Key Card
                const ApiKeyCard(),
                const SizedBox(height: 24),

                // Save Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () async {
                    final obj = AppUser(
                      name: nameController.text,
                      email: emailController.text,
                      dob: selectedDate,
                      gender: gender,
                      photoUrl: user?.photoURL,
                      channelId: channelId,
                    );
                    await userRepo.saveUser(obj);
                    await localRepo.onLoggedIn(obj);
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Profile saved!")),
                    );
                    context.go(AppRoute.home.path);
                  },
                  child: const Text("Save Profile"),
                ),
                const SizedBox(height: 16),

                // Logout
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  onPressed: () => _logout(context),
                  child: const Text("Logout",
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}