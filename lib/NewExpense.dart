
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:kharcha/auth.dart';
import 'package:kharcha/navigation.dart';

class NewExpense extends StatefulWidget {
  @override
  _NewExpenseState createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final User? user = Auth().currentUser;
  final CollectionReference users =
  FirebaseFirestore.instance.collection("users");

  String? spentOn = 'FOOD';
  String? modeOfPayment = 'UPI';
  String? amount ;
  String? allowance;
  String? source = 'MOM';
  int index =0 ;

  bool isFlip = false;

  void _saveExpense() async {
    if (spentOn == null || modeOfPayment == null || amount == null) {
      // Some input fields are empty, show an error message or handle it appropriately
      return;
    }

    String? customDocumentId = user?.email;

    Map<String, dynamic> data = {
          'spent on': spentOn!,
          'mode of payment': modeOfPayment!,
          'amount': amount!,
        };
    // await users.doc(customDocumentId).set(data);
    await users.doc(customDocumentId).collection('Data').add(data);

    // After data is added or updated, you can choose to navigate to a new page or show a success message here.

  }
  void _saveAllowance() async {
    if (source == null || allowance == null) {
      // Some input fields are empty, show an error message or handle it appropriately
      return;
    }
    String? customDocumentId = user?.email;
    Map<String, dynamic> data = {
      'source': source!,
      'allowance': allowance!,
    };

    // await users.doc(customDocumentId).set(data);
    await users.doc(customDocumentId).collection('Allowance').add(data);

    // After data is added or updated, you can choose to navigate to a new page or show a success message here.
  }

  List<String> list = <String>['FOOD', 'SHOPPING', 'PARTY', 'MEDICINE','BOOKS','OTHERS'];
  List<String> list2 = <String>['UPI', 'CASH', 'NEFT','OTHERS'];
  List<String> list3 = <String>['MOM', 'DAD', 'SIBLINGS','OTHERS'];

  String dropdownValue1 = 'FOOD';
  String dropdownValue2 = 'UPI';
  String dropdownValue3 = 'MOM';


  Widget addExpense() {
  return  Container(
    key: Key('first'),
      padding: EdgeInsets.only(top: 30, left: 30, right: 30, bottom: 30),
      margin: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.teal,
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            margin: const EdgeInsets.only(top: 30),
            child: Container(
              
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: SizedBox(
                width: 300,
                child: Row(
                  children: [
                    Text('Spent On   '),
                    Expanded(child: SizedBox()),
                    DropdownButton<String>(
                      value: dropdownValue1,
                      icon: const Icon(Icons.arrow_drop_down),
                      elevation: 16,
                      underline: Container(
                        height: 2,
                        color: Colors.deepOrange,
                      ),
                      style: TextStyle(color: Colors.black),
                      onChanged: (value){
                        setState(() {
                          dropdownValue1 = value!;
                          spentOn = value!;
                        });
                      },
                      items: list.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            margin: const EdgeInsets.only(top: 30),
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: SizedBox(
                width: 300,
                child: Row(
                  children: [
                    Text('Mode of Payment   '),
                    DropdownButton<String>(

                      value: dropdownValue2,
                      icon: const Icon(Icons.arrow_drop_down),
                      elevation: 16,
                      underline: Container(
                        height: 2,
                        color: Colors.deepOrange,
                      ),
                      style: TextStyle(color: Colors.black),
                      onChanged: (value){
                        setState(() {
                          modeOfPayment = value;
                          dropdownValue2 = value!;
                        });
                      },
                      items: list2.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            margin: const EdgeInsets.only(top: 30, bottom: 30),

            child: Container(
              decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: SizedBox(
                width: 300,
                child: TextField(
                  onChanged: (value) {
                    amount = value;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    labelText: 'Amount',
                    focusColor: Colors.grey,
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }

  Widget addAllowance(){
    return Container(
      key: Key('second'),
      padding: EdgeInsets.only(top: 30, left: 30, right: 30, bottom: 30),
      margin: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.teal,
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            margin: const EdgeInsets.only(top: 30),
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: SizedBox(
                width: 300,
                child: Row(
                  children: [
                    Text('Source     '),
                    Expanded(child: SizedBox()),
                    DropdownButton<String>(
                      value: dropdownValue3,
                      icon: const Icon(Icons.arrow_drop_down),
                      elevation: 16,
                      underline: Container(
                        color: Colors.deepOrange,
                        height: 2,
                      ),
                      style: TextStyle(color: Colors.black),
                      onChanged: (value){
                        setState(() {
                          source = value;
                          dropdownValue3=value!;
                        });
                      },
                      items: list3.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                )
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            margin: const EdgeInsets.only(top: 30, bottom: 30),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: SizedBox(
                width: 300,
                child: TextField(
                  onChanged: (value) {
                    allowance = value;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    labelText: 'Amount',
                    focusColor: Colors.grey,
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget transition(Widget widget, Animation<double> animation) {
    final flipAnimation = Tween(begin: pi, end: 0.0).animate(animation);

    return AnimatedBuilder(
      animation: flipAnimation,
      child: widget,
      builder: (context, child) {
        final isUnder = (ValueKey(isFlip) != widget.key);
        final value = isUnder ? min(flipAnimation.value * pi / 2, pi / 2) : flipAnimation.value;

        return Transform(
          transform: Matrix4.rotationY(value),
          child: child,
          alignment: Alignment.center,
        );
      },
    );
  }




  @override
  Widget build(BuildContext context) {
    List <Widget> screens = [
      addExpense(),
      addAllowance()
    ];
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                      onPressed: () {
                        setState(() {
                         isFlip = !isFlip;
                        });
                      },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: Colors.red[400],
                      ),

                      height: 60,
                      width: 100,

                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: Text('New Expense')),
                      ),
                    ),
                  ),

                  MaterialButton(
                    onPressed: () {
                      setState(() {
                        isFlip = !isFlip;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: Colors.blue[400],
                      ),

                      height: 60,
                      width: 100,

                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: Text('New Allowance')),
                      ),
                    ),
                  ),
                ],
              ),
            ),
             Container(
               height: 450,
               child: Center(
                 child:AnimatedSwitcher(
                   reverseDuration: Duration(milliseconds: 500),
                   duration: Duration(milliseconds: 500),
                   switchInCurve: Curves.ease,
                   switchOutCurve: Curves.ease,
                   child: isFlip ? addAllowance() : addExpense(),
                   transitionBuilder: transition,
                 ) ,
               ),
             ),
            FloatingActionButton.extended(
              onPressed:(){

                isFlip ? _saveAllowance() : _saveExpense();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainNavigator(),
                  ),
                );
              },
              icon: const Icon(Icons.add_circle),
              label: const Text('ADD'),
              backgroundColor: Colors.teal[400],
            ),
            // screens[index],
          ],
        ),
      ),
    );
  }
}



class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
