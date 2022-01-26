import 'package:christ_university/utils/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FacultyDataCollection extends StatefulWidget {
  const FacultyDataCollection({Key? key}) : super(key: key);

  @override
  _FacultyDataCollectionState createState() => _FacultyDataCollectionState();
}

class _FacultyDataCollectionState extends State<FacultyDataCollection> {


  @override
  Widget build(BuildContext context) {

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
              Card(
                child: InkWell(
                  onTap: (){
                    Navigator.pushNamed(context,MyRoutes.facultyPersonalData);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Icon(Icons.portrait_rounded),
                        ),
                        Expanded(
                          flex: 8,
                          child: Text("Personal Details"),
                        ),
                        Expanded(
                            flex: 2,
                            child: Icon(Icons.arrow_right_outlined)
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                child: InkWell(
                  onTap: (){
                    Navigator.pushNamed(context,MyRoutes.facultyAcademicData);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Icon(Icons.menu_book_sharp),
                        ),
                        Expanded(
                          flex: 8,
                          child: Text("Education Details"),
                        ),
                        Expanded(
                            flex: 2,
                            child: Icon(Icons.arrow_right_outlined)
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                child: InkWell(
                  onTap: (){
                    Navigator.pushNamed(context,MyRoutes.facultyWorkExData);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Icon(Icons.build),
                        ),
                        Expanded(
                          flex: 8,
                          child: Text("Work Experience"),
                        ),
                        Expanded(
                            flex: 2,
                            child: Icon(Icons.arrow_right_outlined)
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                child: InkWell(
                  onTap: (){
                    Navigator.pushNamed(context,MyRoutes.facultyPublicationData);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Icon(Icons.book_outlined),
                        ),
                        Expanded(
                          flex: 8,
                          child: Text("Publication Details"),
                        ),
                        Expanded(
                            flex: 2,
                            child: Icon(Icons.arrow_right_outlined)
                        ),
                      ],
                    ),
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
