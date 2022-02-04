import 'package:christ_university/utils/important_variables.dart';
import 'package:christ_university/utils/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'facultyregistration/work_exp_list.dart';

class FacultyDataCollection extends StatefulWidget {
  const FacultyDataCollection({Key? key}) : super(key: key);

  @override
  _FacultyDataCollectionState createState() => _FacultyDataCollectionState();
}

class _FacultyDataCollectionState extends State<FacultyDataCollection> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {

    Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;
    String url = user!.photoURL as String;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Profile", style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CircleAvatar(
                radius: 60,
                  backgroundImage: NetworkImage("${url}")),
              SizedBox(height: 20,),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      color: Colors.teal,
                      child: Padding(padding : EdgeInsets.all(10),
                          child : Icon(Icons.home, color: Colors.white)),
                    ),
                    Card(
                      color: Colors.teal,
                      child: Padding(padding : EdgeInsets.all(10),
                          child : Icon(Icons.phone, color: Colors.white)),
                    ),
                    Card(
                      color: Colors.teal,
                      child: Padding(padding : EdgeInsets.all(10),
                          child : Icon(Icons.message, color: Colors.white)),
                    )
                  ],
                ),
              ),
              SizedBox(height: 20,),
              OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(context,MyRoutes.facultyPersonalData);
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Icon(Icons.portrait_rounded, color: Colors.black,),
                      ),
                      Expanded(
                        flex: 8,
                        child: Text("Personal Details", style: TextStyle(color: Colors.black)),
                      ),
                      Expanded(
                          flex: 2,
                          child: Icon(Icons.arrow_right_outlined)
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10,),
              OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(context,MyRoutes.facultyAcademicData);
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Icon(Icons.menu_book_sharp, color: Colors.black,),
                      ),
                      Expanded(
                        flex: 8,
                        child: Text("Education Details", style: TextStyle(color: Colors.black),),
                      ),
                      Expanded(
                          flex: 2,
                          child: Icon(Icons.arrow_right_outlined)
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10,),
              OutlinedButton(
                onPressed: (){
                  Navigator.push(context,MaterialPageRoute(builder: (context) =>
                  FacultyWorkExFireList(
                    dbName: ImportantVariables.facultyWorkExDatabase,

                  )));
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Icon(Icons.build, color: Colors.black,),
                      ),
                      Expanded(
                        flex: 8,
                        child: Text("Work Experience", style: TextStyle(color: Colors.black)),
                      ),
                      Expanded(
                          flex: 2,
                          child: Icon(Icons.arrow_right_outlined)
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10,),
              OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(context,MyRoutes.facultyPublicationData);
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Icon(Icons.book_outlined, color: Colors.black,),
                      ),
                      Expanded(
                        flex: 8,
                        child: Text("Publication Details", style: TextStyle(color: Colors.black)),
                      ),
                      Expanded(
                          flex: 2,
                          child: Icon(Icons.arrow_right_outlined)
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
