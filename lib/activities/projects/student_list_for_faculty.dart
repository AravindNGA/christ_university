import 'package:christ_university/activities/projects/discuss_with_mentor.dart';
import 'package:christ_university/utils/important_variables.dart';
import 'package:christ_university/utils/resuable_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StudentList extends StatefulWidget {
  final String projectType;

  const StudentList({Key? key, required this.projectType}) : super(key: key);

  @override
  _StudentListState createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {

  bool isStudent = false;

  Widget gettingFirebaseData() => StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection(ImportantVariables.studentsChatScreen).where("projectType", isEqualTo: widget.projectType).where("Live ProjectMentorName", isEqualTo: FirebaseAuth.instance.currentUser!.email).snapshots(),
    builder: (context, snapshot) {
      if(!snapshot.hasData){
        return Center(child: CircularProgressIndicator());
      }else{
        return Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: ListView(
            children: snapshot.data!.docs.map((documents) {
              return Container(
                width: MediaQuery.of(context).size.width * 0.65,
                child : GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>
                        DiscussionWithMentor(studentName: "${widget.projectType}MenteeName",
                            facultyName: FirebaseAuth.instance.currentUser!.email as String,
                            projectType: widget.projectType)
                    ));
                  },
                  child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        isStudent ? BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomLeft: Radius.circular(20), bottomRight: Radius.circular(1)) :
                        BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(1), bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                      ),
                      color: Colors.teal,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(16, 16, 16, 10),
                        child: Column(
                          children: [
                            ReUsableWidgets().textOutput(
                                documents["${widget.projectType}MenteeName"],
                                Alignment.centerLeft,
                                TextAlign.left,
                                18,
                                false,
                                Colors.white),
                            SizedBox(
                              height: 10 / 2,
                            ),
                          ],
                        ),
                      )),
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
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.projectType} Students List"),
      ),
      body: gettingFirebaseData(),
    );
  }
}
