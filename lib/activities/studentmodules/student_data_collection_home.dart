import 'package:christ_university/utils/resuable_widgets.dart';
import 'package:christ_university/utils/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class StudentDataCollection extends StatefulWidget {
  const StudentDataCollection({Key? key}) : super(key: key);

  @override
  _StudentDataCollectionState createState() => _StudentDataCollectionState();
}

class _StudentDataCollectionState extends State<StudentDataCollection> {

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
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20,0,20,0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Container(
                  height: MediaQuery.of(context).size.width * 0.6,
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Card(
                    margin: EdgeInsets.symmetric(horizontal: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(150)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: CircleAvatar(
                            radius: MediaQuery.of(context).size.width * 0.15,
                            backgroundImage: NetworkImage("${url}")),
                      ),
                    ),
                  ),
                ),
              ),

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
              ReUsableWidgets().CardContentOptions(Icons.portrait_rounded,"Personal Details", context ,MyRoutes.studentPersonalData),
              ReUsableWidgets().CardContentOptions(Icons.menu_book_sharp,"Education Details", context ,MyRoutes.studentAcademicData),
              ReUsableWidgets().CardContentOptions(Icons.build,"Work Experience", context ,MyRoutes.studentWorkExData),
            ],
          ),
        ),
      ),
    );
  }
}
