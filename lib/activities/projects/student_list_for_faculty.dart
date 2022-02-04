import 'package:christ_university/activities/projects/discuss_with_mentor.dart';
import 'package:christ_university/utils/resuable_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StudentList extends StatefulWidget {
  final String AcademicProjectsTitle;

  const StudentList({Key? key, required this.AcademicProjectsTitle}) : super(key: key);

  @override
  _StudentListState createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {

  bool isStudent = false;

  Widget gettingFirebaseData() => StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection(widget.AcademicProjectsTitle)
        .where("${widget.AcademicProjectsTitle}MentorEmailID", isEqualTo: FirebaseAuth.instance.currentUser!.email).snapshots(),
    builder: (context, snapshot) {
      if(!snapshot.hasData){
        return Center(child: Text("No mentees yet"));
      }else{
        return Container(
          child: ListView(
            children: snapshot.data!.docs.map((documents) {
              return Container(
                width: MediaQuery.of(context).size.width * 0.65,
                child : OutlinedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>
                        DiscussionWithMentor(studentName: documents["menteeName"],
                            facultyName: FirebaseAuth.instance.currentUser!.email as String,
                            projectType: widget.AcademicProjectsTitle)
                    ));
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ReUsableWidgets().textOutput(
                            documents["menteeName"],
                            Alignment.centerLeft,
                            TextAlign.left,
                            16,
                            false,
                            Colors.black),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Icon(
                            Icons.arrow_forward_ios
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }
    },
  );

  @override
  Widget build(BuildContext context) {

    print(widget.AcademicProjectsTitle);

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.AcademicProjectsTitle} Students List"),
      ),
      body: gettingFirebaseData(),
    );
  }
}
