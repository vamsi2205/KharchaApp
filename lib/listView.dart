

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

import 'package:kharcha/FirstPage.dart';
import 'package:kharcha/allowancePage.dart';
import 'package:kharcha/auth.dart';


class SecondPage extends StatefulWidget {
  @override
  Home createState() => Home();
}

class Home extends State<SecondPage> {


  FirebaseFirestore db = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

   DateTime now = DateTime.now();
  List userProfileList = [];
  List userAllowanceList = [];

  final User? user = Auth().currentUser;


  @override
  void initState() {
    super.initState();
    setState(() {
      fetchDatabaseList();
      fetchAllowanceList();
    });

  }

  Future<List<Map<String, dynamic>>> _fetchData() async {
    List<Map<String, dynamic>> itemList = [];
    User? user = Auth().currentUser;

    if (user != null) {
      String documentId = user.email ?? '';
      var db = FirebaseFirestore.instance;

      try {
        QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await db.collection("users").doc(documentId).collection("Data").get();

        for (var docSnapshot in querySnapshot.docs) {

          itemList.add(docSnapshot.data());
        }
      } catch (e) {
        print("Error fetching data: $e");
      }
    }

    return itemList;
  }
  Future<List<Map<String, dynamic>>> _fetchAllowance() async {
    List<Map<String, dynamic>> itemList = [];
    User? user = Auth().currentUser;

    if (user != null) {
      String documentId = user.email ?? '';
      var db = FirebaseFirestore.instance;

      try {
        QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await db.collection("users").doc(documentId).collection("Allowance").get();

        for (var docSnapshot in querySnapshot.docs) {

          itemList.add(docSnapshot.data());
        }
      } catch (e) {
        print("Error fetching data: $e");
      }
    }

    return itemList;
  }

  fetchDatabaseList() async {
    List<Map<String, dynamic>> resultant = await _fetchData();
    if (resultant.isNotEmpty) {
      setState(() {
        userProfileList = resultant;
      });
    }
  }
  fetchAllowanceList() async {
    List<Map<String, dynamic>> resultant = await _fetchAllowance();
    if (resultant.isNotEmpty) {
      setState(() {
        userAllowanceList = resultant;
      });
    }
  }






  @override
  Widget build(BuildContext context) {
    int totalAllowance =0;
    int totalExpenses =0;
    double food =0 ;
    double shopping =0 ;
    double party = 0;
    double medicine=0;
    double books=0;
    double others =0;
  for(int i=0;i<userProfileList.length;i++){
    String expenseAmountString = userProfileList[i]['amount'] as String;
    int? expenseAmount = int.tryParse(expenseAmountString);
    totalExpenses += expenseAmount ?? 0 ;
  }
  for(int i=0;i<userAllowanceList.length;i++){
    String expenseAmountString = userAllowanceList[i]['allowance'] as String;
    int? expenseAmount = int.tryParse(expenseAmountString);
    totalAllowance += expenseAmount ?? 0 ;
  }
    for (int i = 0; i < userProfileList.length; i++) {
      String spentOn = userProfileList[i]['spent on'] as String;
      String? expenseAmountString = userProfileList[i]['amount'] as String?;

      if (expenseAmountString != null) {
        double? expenseAmount = double.tryParse(expenseAmountString.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;

        switch (spentOn) {
          case 'FOOD':
            food += expenseAmount ;
            break;
          case 'SHOPPING':
            shopping += expenseAmount;
            break;
          case 'PARTY':
            party += expenseAmount;
            break;
          case 'MEDICINES':
            medicine += expenseAmount;
            break;
          case 'BOOKS':
            books += expenseAmount;
            break;
          default:
            others += expenseAmount;
            break;
        }
      }
      else{
        break;
      }

    }

    Map<String,double> dataMap ={
    'FOOD' : food,
    "SHOPPING" : shopping,
    'PARTY' : party,
    'MEDICINE' : medicine,
    'BOOKS': books,
    'OTHERS' : others,
  };
    List<Color> colorList = [
      const Color(0xffFF6B6B),  // Red
      const Color(0xffFFD166),  // Yellow
      const Color(0xff06D6A0),  // Green
      const Color(0xff118AB2),  // Blue
      const Color(0xffE63946),  // Maroon
      const Color(0xffF4A261),  // Orange
    ];

    final gradientList = <List<Color>>[
      [
        Color.fromRGBO(255, 107, 107, 1),   // Red
        Color.fromRGBO(255, 185, 74, 1),    // Orange
      ],
      [
        Color.fromRGBO(255, 209, 102, 1),   // Yellow
        Color.fromRGBO(255, 255, 140, 1),   // Light Yellow
      ],
      [
        Color.fromRGBO(6, 214, 160, 1),     // Green
        Color.fromRGBO(17, 138, 178, 1),    // Teal
      ],
      [
        Color.fromRGBO(17, 138, 178, 1),    // Blue
        Color.fromRGBO(230, 57, 70, 1),     // Maroon
      ],
      [
        Color.fromRGBO(230, 57, 70, 1),     // Maroon
        Color.fromRGBO(244, 162, 97, 1),    // Peach
      ],
      [
        Color.fromRGBO(244, 162, 97, 1),    // Orange
        Color.fromRGBO(255, 210, 97, 1),    // Light Orange
      ],
    ];



    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
               Container(
                          height: 80,
                          margin: EdgeInsets.all(5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 80,
                                height: 55,
                                padding: EdgeInsets.all(5),
                                margin: EdgeInsets.only(right: 5),
                                // color: Colors.blue,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                    borderRadius: BorderRadius.all(Radius.circular(10))
                                ),
                                child: RichText(
                                  text: TextSpan(
                                      text: 'Allowance: $totalAllowance'
                                  ),
                                ),
                              ),
                              Container(
                                width: 80,
                                height: 55,
                                padding: EdgeInsets.all(5),
                                margin: EdgeInsets.only(left: 5,right: 5),
                                decoration: BoxDecoration(
                                color: Colors.blue,
                                    borderRadius: BorderRadius.all(Radius.circular(10))
                                ),
                                child: RichText(
                                  text: TextSpan(
                                    text: 'Expense: $totalExpenses',
                                  ),
                                ),
                              ),
                              Container(
                                width: 80,
                                height: 55,
                                padding: EdgeInsets.all(5),
                                margin: EdgeInsets.only(left: 5),
                                decoration: BoxDecoration(
                                color: Colors.blue,
                                    borderRadius: BorderRadius.all(Radius.circular(10))
                                ),
                                child: RichText(
                                  text: TextSpan(
                                    text: 'Remaining: ${totalAllowance - totalExpenses}',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),


              Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.only(right: 20,left: 20,top: 20,bottom: 20),
                height: 330,
                decoration:  const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Color(0xFF26A69A),
                    boxShadow: [BoxShadow(
                      color: Colors.grey,
                      blurRadius: 15.0,
                    ),]
                ),
                child: Container(
                  height: 250,
                  width: double.maxFinite,
                   child: PieChart(
                     dataMap: dataMap,
                     colorList: colorList,
                     chartRadius: MediaQuery.of(context).size.width /2,
                     centerText: 'EXPENSE',
                     ringStrokeWidth: 10,
                     animationDuration: const Duration(seconds: 3),
                     chartValuesOptions: const ChartValuesOptions(
                       showChartValues: true,
                       showChartValuesOutside: true,
                       showChartValuesInPercentage: true,
                       showChartValueBackground: false,
                     ),
                     legendOptions: const LegendOptions(
                       showLegends : true,
                       legendShape: BoxShape.circle,
                       legendTextStyle: TextStyle(fontSize: 12),
                        legendPosition: LegendPosition.bottom,
                        showLegendsInRow: true,
                     ),
                     gradientList: gradientList,
                   )

                ),
              ),

              Container(
                height: 35,
                margin: EdgeInsets.only(top: 20),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Color(0xFF4DB6AC),
                ),
                child: FloatingActionButton.extended(
                  foregroundColor: Colors.black,
                  backgroundColor: Color(0xFF26A69A),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => FirstPage(),)
                    );
                  },
                  icon: const Icon(Icons.account_tree_sharp),
                  label: const Text('Expenses List'),
                ),
              ),
              Container(
                height: 35,
                margin: EdgeInsets.only(top: 20),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Color(0xFF4DB6AC),
                ),
                child: FloatingActionButton.extended(
                  foregroundColor: Colors.black,
                  backgroundColor: Color(0xFF26A69A),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AllowancePage(),)
                    );
                  },
                  icon: const Icon(Icons.account_tree_sharp),
                  label: const Text('Allowances List'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}