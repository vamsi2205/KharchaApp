import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kharcha/auth.dart';


class AllowancePage extends StatefulWidget {
  @override
  Home createState() => Home();
}

class Home extends State<AllowancePage> {

  FirebaseFirestore db = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  User? user = Auth().currentUser;

  List userProfileList = [];
  bool progress = true;
  @override
  void initState() {
    super.initState();
    fetchAllowanceList();
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

  fetchAllowanceList() async {
    List<Map<String, dynamic>> resultant = await _fetchAllowance();
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
          title: Text("Allowance List",style: TextStyle(color: Colors.white),textScaleFactor: 1.2),
          backgroundColor: Colors.blue,

        ),
        body: progress ? Center(
            child: CircularProgressIndicator(value: 0.7, // The progress value from 0.0 to 1.0
              backgroundColor: Colors.grey,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              strokeWidth: 5,)
        ) : Container(
         child: StreamBuilder(
              stream: users.doc(user?.email).collection('Allowance').snapshots(),
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
                                onPressed: (context) =>
                                {
                                  editData(ds.id),
                                },
                                icon: Icons.edit,
                                backgroundColor: Colors.lightGreen,
                              )
                            ],
                          ),
                          child: ListTile(
                            title: Text(ds['allowance'] ?? 'Hi'),

                            // subtitle: Text(ds['spent on'] ?? 'bye'),

                            leading: CircleAvatar(
                              child: Icon(Icons.account_circle),
                            ),
                            trailing: Text(ds['source'] ??
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
      users.doc(user?.email).collection('Allowance').doc(id).delete();
    });
  }

  editData(String id) {

  }
}
