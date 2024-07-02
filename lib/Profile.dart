import 'package:google_sign_in/google_sign_in.dart';
import 'package:kharcha/main.dart';
import 'package:kharcha/navigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kharcha/auth.dart';
import 'package:kharcha/widget_tree.dart';
import 'login_page.dart';

class Profile extends StatefulWidget{
  @override
  _Profile createState() => _Profile();

}

class _Profile extends State<Profile>{
  final User? user = Auth().currentUser;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final TextEditingController _amount = TextEditingController();
  Widget _enterAmount(
      String title,
      TextEditingController controller,
      ){
    return TextField(
      controller: controller,
      decoration:  InputDecoration(
        labelText: title,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 30,left: 30,right: 30,bottom: 30),
              margin: EdgeInsets.all(30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.teal,
              ),
              child: Column(
                children: [
                  Center(
                    child:Container(
                        width: 150,
                        height: 150,
                        child: Image.asset( 'assets/images/account.jpg',height: 50,width: 50,)
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.only(left: 10,right: 10),
                    margin: const EdgeInsets.only(top: 30),
                    child:  SizedBox(
                      width: 300,
                      child: Text(user!.displayName ?? 'NAME ',style: TextStyle(fontSize: 25),),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10,right: 10),
                    margin: const EdgeInsets.only(top: 30),
                    child: SizedBox(
                      width: 300,
                      child:  Text( user!.email ?? 'User email',style: TextStyle(fontSize: 25),),
                    ),
                  ),

                ],
              ),

            ),
            FloatingActionButton.extended(
               onPressed: () {
               signOut();
               if(user == null){
                 Navigator.pop(
                   context,
                   MaterialPageRoute(
                     builder: (context) => WidgetTree(),
                   ),
                 );
               }
              },
              icon: const Icon(Icons.logout),
              label: const Text('LOG OUT'),
              backgroundColor: Colors.red,
            ),

          ],
        )
    );
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