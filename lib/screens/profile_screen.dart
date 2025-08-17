import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trip_planner/app_route.dart';
import 'package:trip_planner/models/user.dart';
import 'package:trip_planner/repo/local_repo.dart';
import 'package:trip_planner/repo/user_repo.dart';

class ProfileScreen extends StatefulWidget {

  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final UserRepo userRepo = UserRepo();
  final LocalRepo localRepo = GetIt.I.get();

  DateTime? selectedDate; // DOB
  Gender? gender; // Gender selection
  File? profileImage; // Profile image file

  User? user;


  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    user = FirebaseAuth.instance.currentUser;
    user?.photoURL;
    if (user != null) {
      // Prefill name and email
      nameController.text = user!.displayName ?? "";
      emailController.text = user!.email ?? "";
    }
  }

  // Function to pick date
  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // Function to pick profile image
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
    await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        profileImage = File(pickedFile.path);
      });
    }
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                // Profile Image with Edit Option
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

                // Input field for Name
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Full Name",
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 16),

                // Input field for Email (Read-only)
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

                // Date Picker for DOB
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

                // Gender Section
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFCDD2), // light red background
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Gender",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      RadioListTile<String>(
                        title: const Text("Male"),
                        value: Gender.male.name, // store as string
                        groupValue: gender?.name,
                        activeColor: Colors.red,
                        dense: true,
                        visualDensity: VisualDensity.compact,
                        contentPadding: EdgeInsets.zero,
                        onChanged: (value) {
                          setState(() => gender = Gender.male);
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text("Female"),
                        value: Gender.female.name,
                        groupValue: gender?.name,
                        activeColor: Colors.red,
                        dense: true,
                        visualDensity: VisualDensity.compact,
                        contentPadding: EdgeInsets.zero,
                        onChanged: (value) {
                          setState(() => gender = Gender.female);
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text("Others"),
                        value: Gender.other.name,
                        groupValue: gender?.name,
                        activeColor: Colors.red,
                        dense: true,
                        visualDensity: VisualDensity.compact,
                        contentPadding: EdgeInsets.zero,
                        onChanged: (value) {
                          setState(() => gender = Gender.other);
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Save Button
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () async {
                      // Check internet connection
                      var connectivityResult = await Connectivity().checkConnectivity();
                      if (!context.mounted) return;

                      if (connectivityResult.contains(ConnectivityResult.none)) {
                        // Show offline message
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("You are offline. Please connect to the internet.")),
                        );
                        return;
                      }

                      // Show loading dialog
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => const Center(
                          child: CircularProgressIndicator(color: Colors.red),
                        ),
                      );

                      try {
                        final obj = AppUser(
                          name: nameController.text,
                          email: emailController.text,
                          dob: selectedDate,
                          gender: gender,
                          photoUrl: user?.photoURL,
                        );

                        await userRepo.saveUser(obj);
                        await localRepo.onLoggedIn(obj);
                        if (!context.mounted) return;

                        Navigator.of(context).pop();
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Profile saved successfully!")),
                        );
                        context.go(AppRoute.home.path);
                      } catch (e) {
                        if (!context.mounted) return;
                        Navigator.of(context).pop(); // close loading
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Error: ${e.toString()}")),
                        );
                      }
                    },
                    child: const Text(
                      "Save Profile",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
