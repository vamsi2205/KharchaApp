import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kharcha/auth.dart';

import 'navigation.dart';

class LoginPage extends StatefulWidget{
   const LoginPage({Key? key}): super(key: key);


  @override
  State<LoginPage> createState()=> _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage ="";
  bool isLogin = true;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
          email: _controllerEmail.text,
          password: _controllerPassword.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
          email: _controllerEmail.text,
          password: _controllerPassword.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _title(){
    return Center(child: const Text('Kharcha',));
  }

  Widget _entryField(
      String title,
      TextEditingController controller,
      ){
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
      ),
    );
  }

  Widget _errorMessage(){
    return Text(errorMessage == '' ? '' : 'Humm ? $errorMessage');
  }

  Widget _submitButton(){
    return ElevatedButton(
        onPressed:
        isLogin ? signInWithEmailAndPassword : createUserWithEmailAndPassword,
        child:Text(isLogin ? 'Login' : 'Register'),
    );
  }

  Widget _loginOrRegisterButton(){
    return TextButton(
        onPressed: () {
          showDialog(context: context, builder: (context){
            return const Center(child: CircularProgressIndicator());
          });
          setState(() {
            isLogin = !isLogin;
          });
          Navigator.of(context).pop();
      } ,
        child: Text(isLogin ? 'Register Instead' : 'Login Instead'),
    );
  }


  @override
  Widget build(BuildContext context) {
  return Scaffold(
      appBar: AppBar(
        title: _title(),

      ),
    body: Container(
      height: double.infinity,
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
                 gradient: LinearGradient(
                   begin: Alignment.topRight,
                   end: Alignment.bottomLeft,
                   colors: [
                     Color(0xFF90CAF9),
                     Color(0xFFEF5350),
                   ]
                 )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children:<Widget> [
          Image.asset("assets/images/ruppee.png"),
          _entryField('Email',_controllerEmail),
          _entryField('Password', _controllerPassword),
          _errorMessage(),
          _submitButton(),
          _loginOrRegisterButton(),
          FloatingActionButton.extended(
            onPressed :() async {
              // showDialog(context: context, builder: (context){
              //   return const Center(child: CircularProgressIndicator());
              // });
              await _handleSignIn();
              // Navigator.of(context).pop();
            } ,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black, label: Text('Sign in with google'),
            icon: Image.asset('assets/images/google.jpg',
            height: 32,width: 32,),
          )
        ],
      ),
    ),
  );
  }


  Future<void> _handleSignIn() async {
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
        User? user = authResult.user;

        if (user != null) {
          // Navigate to the MainNavigator after successful sign-in

          Future.delayed(Duration(seconds: 2), () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => MainNavigator()));
          });

        } else {
          // Handle the case when user is null (sign-in failed)
          print('Google Sign-In failed');
        }
      } else {
        // Handle the case when googleUser is null (sign-in cancelled)
        print('Google Sign-In cancelled');
      }
    } catch (error) {
      print('Error during Google Sign-In: $error');
      // Handle any other errors during sign-in
    }
  }

}
