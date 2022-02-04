import 'package:christ_university/activities/facultymodules/faculty_data_collection_home.dart';
import 'package:christ_university/activities/facultymodules/facultyregistration/work_exprience_details.dart';
import 'package:christ_university/utils/important_variables.dart';
import 'package:christ_university/utils/resuable_widgets.dart';
import 'package:christ_university/utils/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FacultyWorkExFireList extends StatefulWidget {
  final String dbName;
  const FacultyWorkExFireList({Key? key,
    required this.dbName}) : super(key: key);

  @override
  State<FacultyWorkExFireList> createState() => _FacultyWorkExFireListState();
}

class _FacultyWorkExFireListState extends State<FacultyWorkExFireList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Work Experience Details"),
      ),
      body: gettingFirebaseData(),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FacultyWorkExprienceDetails(
                          newData: false,
                        )));
          },
          child: Icon(Icons.add)
      ),
    );
  }

  Widget gettingFirebaseData() => StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection(widget.dbName)
            .where("userID",
                isEqualTo: FirebaseAuth.instance.currentUser!.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (!(snapshot.hasData)) {
            return Center(
                child: Text(
                    "Click + button to start entering your work experience"));
          } else {
            return ListView(
              children: snapshot.data!.docs.map((documents) {
                return TextButton(
                  onPressed: () {
                    /*Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FacultyWorkExprienceDetails(
                                  newData: false,
                                )));*/
                  },
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: ReUsableWidgets().textOutput(
                              "Experience Type : ${documents["expType"]}",
                              Alignment.centerLeft,
                              TextAlign.left,
                              16,
                              false,
                              Colors.black),
                        ),
                        ReUsableWidgets().textOutput(
                            documents["expOrgName"],
                            Alignment.centerLeft,
                            TextAlign.left,
                            25,
                            true,
                            Colors.black),
                        ReUsableWidgets().textOutput(
                            documents["expJobRole"],
                            Alignment.centerLeft,
                            TextAlign.left,
                            14,
                            false,
                            Colors.black),
                        SizedBox(
                          height: sizedBoxHeight / 2,
                        ),
                        ReUsableWidgets().textOutput(
                            "Experience : ${documents["expInYears"]} years, ${documents["expInMonths"]} months",
                            Alignment.centerLeft,
                            TextAlign.left,
                            14,
                            false,
                            Colors.black),
                        Divider()
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          }
        },
      );
}
