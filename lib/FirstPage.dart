import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kharcha/auth.dart';
import 'package:get/get.dart';


class FirstPage extends StatefulWidget {
  @override
  Home createState() => Home();
}

class Home extends State<FirstPage> {
  late Future<int> total;
  FirebaseFirestore db = FirebaseFirestore.instance;
  User? user = Auth().currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  String? spentOn = 'FOOD';
  String? modeOfPayment = 'UPI';
  String? amount ;
  String? allowance;
  String? source = 'MOM';
  List userProfileList = [];
  bool progress = true;
  List<String> list = <String>['FOOD', 'SHOPPING', 'PARTY', 'MEDICINE','BOOKS','OTHERS'];
  List<String> list2 = <String>['UPI', 'CASH', 'NEFT','OTHERS'];
  List<String> list3 = <String>['MOM', 'DAD', 'SIBLINGS','OTHERS'];

  String dropdownValue1 = 'FOOD';
  String dropdownValue2 = 'UPI';
  String dropdownValue3 = 'MOM';
  @override
  void initState() {
    super.initState();
    fetchDatabaseList();
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

  fetchDatabaseList() async {
    List<Map<String, dynamic>> resultant = await _fetchData();
    if (resultant.isNotEmpty) {
      setState(() {
        userProfileList = resultant;
        progress =false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    double progressValue = 0.0;
    return Scaffold(
      appBar: AppBar(
        title: Text("Expense List",style: TextStyle(color: Colors.white),textScaleFactor: 1.2),
        backgroundColor: Colors.blue,

      ),
      body: progress ? Center(
         child: CircularProgressIndicator(value: 0.7, // The progress value from 0.0 to 1.0
            backgroundColor: Colors.grey,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            strokeWidth: 5,)
      ) : Container(
           child: StreamBuilder(
    stream: users.doc(user?.email).collection('Data').snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData)
        return Center(
          child:
          CircularProgressIndicator(),
        );
      return ListView.builder(
          itemCount: snapshot.data?.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data?.docs[index] as DocumentSnapshot<Object?>;
            return Card(
              child: Slidable(
                endActionPane: ActionPane(
                  motion: const BehindMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) =>
                      {
                        deleteData(ds.id),
                      },
                      icon: Icons.delete,
                      backgroundColor: Colors.red,
                    ),
                    SlidableAction(
                      onPressed: (context) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Edit Info'),
                              content: Container(
                            //       color: Colors.blue,
                            //       child: Column(
                            //         children: [
                            //           Container(
                            //             padding: const EdgeInsets.only(left: 10, right: 10),
                            //             margin: const EdgeInsets.only(top: 30),
                            //             child: Container(
                            //
                            //               padding: EdgeInsets.all(10),
                            //               decoration: BoxDecoration(
                            //                   color: Colors.orange,
                            //                   borderRadius: BorderRadius.all(Radius.circular(10))
                            //               ),
                            //               child: SizedBox(
                            //                 width: 300,
                            //                 child: Row(
                            //                   children: [
                            //                     Text('Spent On   '),
                            //                     Expanded(child: SizedBox()),
                            //                     DropdownButton<String>(
                            //                       value: dropdownValue1,
                            //                       icon: const Icon(Icons.arrow_drop_down),
                            //                       elevation: 16,
                            //                       underline: Container(
                            //                         height: 2,
                            //                         color: Colors.deepOrange,
                            //                       ),
                            //                       style: TextStyle(color: Colors.black),
                            //                       onChanged: (value){
                            //                         setState(() {
                            //                           dropdownValue1 = value!;
                            //                           spentOn = value!;
                            //                         });
                            //                       },
                            //                       items: list.map<DropdownMenuItem<String>>((String value) {
                            //                         return DropdownMenuItem<String>(
                            //                           value: value,
                            //                           child: Text(value),
                            //                         );
                            //                       }).toList(),
                            //                     ),
                            //                   ],
                            //                 ),
                            //               ),
                            //             ),
                            //           ),
                            //           Container(
                            //             padding: const EdgeInsets.only(left: 10, right: 10),
                            //             margin: const EdgeInsets.only(top: 30),
                            //             child: Container(
                            //               padding: EdgeInsets.all(10),
                            //               decoration: BoxDecoration(
                            //                   color: Colors.orange,
                            //                   borderRadius: BorderRadius.all(Radius.circular(10))
                            //               ),
                            //               child: SizedBox(
                            //                 width: 300,
                            //                 child: Row(
                            //                   children: [
                            //                     Text('Mode of Payment   '),
                            //                     DropdownButton<String>(
                            //
                            //                       value: dropdownValue2,
                            //                       icon: const Icon(Icons.arrow_drop_down),
                            //                       elevation: 16,
                            //                       underline: Container(
                            //                         height: 2,
                            //                         color: Colors.deepOrange,
                            //                       ),
                            //                       style: TextStyle(color: Colors.black),
                            //                       onChanged: (value){
                            //                         setState(() {
                            //                           modeOfPayment = value;
                            //                           dropdownValue2 = value!;
                            //                         });
                            //                       },
                            //                       items: list2.map<DropdownMenuItem<String>>((String value) {
                            //                         return DropdownMenuItem<String>(
                            //                           value: value,
                            //                           child: Text(value),
                            //                         );
                            //                       }).toList(),
                            //                     ),
                            //                   ],
                            //                 ),
                            //               ),
                            //             ),
                            //           ),
                            //           Container(
                            //             padding: const EdgeInsets.only(left: 10, right: 10),
                            //             margin: const EdgeInsets.only(top: 30, bottom: 30),
                            //
                            //             child: Container(
                            //               decoration: BoxDecoration(
                            //                   color: Colors.orange,
                            //                   borderRadius: BorderRadius.all(Radius.circular(10))
                            //               ),
                            //               child: SizedBox(
                            //                 width: 300,
                            //                 child: TextField(
                            //                   onChanged: (value) {
                            //                     amount = value;
                            //                   },
                            //                   decoration: const InputDecoration(
                            //                     border: OutlineInputBorder(
                            //                       borderRadius: BorderRadius.all(Radius.circular(10)),
                            //                     ),
                            //                     labelText: 'Amount',
                            //                     focusColor: Colors.grey,
                            //                   ),
                            //                   keyboardType: TextInputType.number,
                            //                   inputFormatters: <TextInputFormatter>[
                            //                     FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            //                     FilteringTextInputFormatter.digitsOnly,
                            //                   ],
                            //                 ),
                            //               ),
                            //             ),
                            //           ),
                            //         ],
                            //       ),
                            //     ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    editData(ds.id, spentOn!, modeOfPayment!, amount!);
                                    Navigator.of(context).pop(); // Close the dialog
                                  },
                                  child: Text('Confirm'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: Icons.edit,
                      backgroundColor: Colors.lightGreen,
                      // onPressed: (context) =>
                      // {
                      //   showDialog(context: context, builder: )
                      //   Get.defaultDialog(
                      //     title: 'Edit Info',
                      //     content: Container(
                      //       color: Colors.blue,
                      //       child: Column(
                      //         children: [
                      //           Container(
                      //             padding: const EdgeInsets.only(left: 10, right: 10),
                      //             margin: const EdgeInsets.only(top: 30),
                      //             child: Container(
                      //
                      //               padding: EdgeInsets.all(10),
                      //               decoration: BoxDecoration(
                      //                   color: Colors.orange,
                      //                   borderRadius: BorderRadius.all(Radius.circular(10))
                      //               ),
                      //               child: SizedBox(
                      //                 width: 300,
                      //                 child: Row(
                      //                   children: [
                      //                     Text('Spent On   '),
                      //                     Expanded(child: SizedBox()),
                      //                     DropdownButton<String>(
                      //                       value: dropdownValue1,
                      //                       icon: const Icon(Icons.arrow_drop_down),
                      //                       elevation: 16,
                      //                       underline: Container(
                      //                         height: 2,
                      //                         color: Colors.deepOrange,
                      //                       ),
                      //                       style: TextStyle(color: Colors.black),
                      //                       onChanged: (value){
                      //                         setState(() {
                      //                           dropdownValue1 = value!;
                      //                           spentOn = value!;
                      //                         });
                      //                       },
                      //                       items: list.map<DropdownMenuItem<String>>((String value) {
                      //                         return DropdownMenuItem<String>(
                      //                           value: value,
                      //                           child: Text(value),
                      //                         );
                      //                       }).toList(),
                      //                     ),
                      //                   ],
                      //                 ),
                      //               ),
                      //             ),
                      //           ),
                      //           Container(
                      //             padding: const EdgeInsets.only(left: 10, right: 10),
                      //             margin: const EdgeInsets.only(top: 30),
                      //             child: Container(
                      //               padding: EdgeInsets.all(10),
                      //               decoration: BoxDecoration(
                      //                   color: Colors.orange,
                      //                   borderRadius: BorderRadius.all(Radius.circular(10))
                      //               ),
                      //               child: SizedBox(
                      //                 width: 300,
                      //                 child: Row(
                      //                   children: [
                      //                     Text('Mode of Payment   '),
                      //                     DropdownButton<String>(
                      //
                      //                       value: dropdownValue2,
                      //                       icon: const Icon(Icons.arrow_drop_down),
                      //                       elevation: 16,
                      //                       underline: Container(
                      //                         height: 2,
                      //                         color: Colors.deepOrange,
                      //                       ),
                      //                       style: TextStyle(color: Colors.black),
                      //                       onChanged: (value){
                      //                         setState(() {
                      //                           modeOfPayment = value;
                      //                           dropdownValue2 = value!;
                      //                         });
                      //                       },
                      //                       items: list2.map<DropdownMenuItem<String>>((String value) {
                      //                         return DropdownMenuItem<String>(
                      //                           value: value,
                      //                           child: Text(value),
                      //                         );
                      //                       }).toList(),
                      //                     ),
                      //                   ],
                      //                 ),
                      //               ),
                      //             ),
                      //           ),
                      //           Container(
                      //             padding: const EdgeInsets.only(left: 10, right: 10),
                      //             margin: const EdgeInsets.only(top: 30, bottom: 30),
                      //
                      //             child: Container(
                      //               decoration: BoxDecoration(
                      //                   color: Colors.orange,
                      //                   borderRadius: BorderRadius.all(Radius.circular(10))
                      //               ),
                      //               child: SizedBox(
                      //                 width: 300,
                      //                 child: TextField(
                      //                   onChanged: (value) {
                      //                     amount = value;
                      //                   },
                      //                   decoration: const InputDecoration(
                      //                     border: OutlineInputBorder(
                      //                       borderRadius: BorderRadius.all(Radius.circular(10)),
                      //                     ),
                      //                     labelText: 'Amount',
                      //                     focusColor: Colors.grey,
                      //                   ),
                      //                   keyboardType: TextInputType.number,
                      //                   inputFormatters: <TextInputFormatter>[
                      //                     FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      //                     FilteringTextInputFormatter.digitsOnly,
                      //                   ],
                      //                 ),
                      //               ),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //
                      //     textConfirm: 'Confirm',
                      //     onConfirm:() {
                      //       editData(ds.id , spentOn! , modeOfPayment! , amount!);
                      //       Navigator.of(context).pop();
                      // }
                      //   ),
                      // },
                      // icon: Icons.edit,
                      // backgroundColor: Colors.lightGreen,
                    )
                  ],
                ),
                child: ListTile(
                  title: Text(ds['amount'] ?? 'Hi'),

                  subtitle: Text(ds['spent on'] ?? 'bye'),

                  leading: CircleAvatar(
                    child: Icon(Icons.account_circle),
                  ),
                  trailing: Text(ds['mode of payment'] ??
                      'Hello'),

                ),
              ),
            );
          }
      );
    }
    ),

      )
    );
  }

  deleteData(String id) {
    setState(() {
      users.doc(user?.email).collection('Data').doc(id).delete();
    });

  }

  editData(String id , String spentOn , String modeOfPayment , String amount) {
       setState(() {
         users.doc(user?.email).collection('Data').doc(id).update({
           spentOn : spentOn,
           modeOfPayment : modeOfPayment,
           amount : amount,
         });
       });
  }

}




