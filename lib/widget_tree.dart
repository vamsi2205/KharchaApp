import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kharcha/auth.dart';
import 'package:kharcha/login_page.dart';
import 'package:kharcha/navigation.dart';


class WidgetTree extends StatefulWidget{
  const WidgetTree({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTree ();
}

class _WidgetTree  extends State<WidgetTree>{
  @override
  Widget build(BuildContext context) {
   return StreamBuilder(
     stream: Auth().authStateChanges,
     builder: (context,snapshot){
       if(snapshot.hasData){
         return MainNavigator();
       }else{
         return  LoginPage();
       }

     },
   );
  }

}