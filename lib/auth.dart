

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'login_page.dart';
import 'navigation.dart';

class Auth{
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
}) async {
    await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<User?> _handleSignIn() async {
    try {
      // Trigger the Google Sign In process
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser != null) {
        // Obtain the GoogleSignInAuthentication object
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        // Create a new credential using the GoogleSignInAuthentication object
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Sign in with the credential
        final UserCredential authResult = await _firebaseAuth.signInWithCredential(credential);

        return authResult.user;
      }

      return null;
    } catch (error) {
      print(error);
      return null;
    }
  }

Future<void> signOut() async {
  try {
    await googleSignIn.signOut();
    await _firebaseAuth.signOut();
    print("Signed out successfully.");
  } catch (error) {
    print("Error during sign-out: $error");
  }
    }
  }

