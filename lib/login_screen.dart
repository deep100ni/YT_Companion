import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Future<void> signInWithGoogle() async {
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

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Signed in as $displayName ($email)'),
//             duration: const Duration(seconds: 3),
//           ),
//         );
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
              const SizedBox(height: 40),
              const TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email_outlined),
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const TextField(
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock_outline),
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text("Forgot password?"),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/home");
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Log In"),
              ),
              const SizedBox(height: 20),
              Row(
                children: const [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text("Or"),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 20),
              SignInButton(
                Buttons.Google,
                onPressed: signInWithGoogle,
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don’t have an account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    child: const Text(
                      "Sign up",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}