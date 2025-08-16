import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:trip_planner/app_route.dart';
import 'package:trip_planner/local_repo.dart';

class LoginScreen extends StatelessWidget {
  final LocalRepo localRepo = GetIt.I.get();

  LoginScreen({super.key});

  Future<void> signInWithGoogle(BuildContext context) async {
       // Trigger the authentication flow
       await GoogleSignIn.instance.initialize(
         serverClientId: '825142671774-jpv5v4rved56b92h45crv85oh5ajpq92.apps.googleusercontent.com',
       );

       final GoogleSignInAccount googleUser = await GoogleSignIn.instance.authenticate();

       // Obtain the auth details from the request
       final GoogleSignInAuthentication googleAuth = googleUser.authentication;

       // Create a new credential
       final credential = GoogleAuthProvider.credential(
         idToken: googleAuth.idToken,
       );

       // Sign in to Firebase
       final UserCredential userCredential =
       await FirebaseAuth.instance.signInWithCredential(credential);
       final user = userCredential.user;

       // Show SnackBar with user info
       if (user != null) {
         final displayName = user.displayName ?? "No Name";
         final email = user.email ?? "No Email";

         await localRepo.onLoggedIn();

         if (!context.mounted) return;

         context.go(AppRoute.home.path);

         ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(
             content: Text('Signed in as $displayName ($email)'),
             duration: const Duration(seconds: 3),
           ),
         );
       }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Login',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              SignInButton(
                Buttons.Google,
                onPressed: (){
                  signInWithGoogle(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}