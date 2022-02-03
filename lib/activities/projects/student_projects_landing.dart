import 'package:christ_university/activities/projects/discuss_with_mentor.dart';
import 'package:christ_university/activities/projects/student_projects_registration.dart';
import 'package:christ_university/utils/important_variables.dart';
import 'package:christ_university/utils/resuable_widgets.dart';
import 'package:christ_university/utils/routes.dart';
import 'package:christ_university/utils/shared_prefs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProjectsModuleStudent extends StatefulWidget {
  final String AcademicProjectsTitle;

  const ProjectsModuleStudent({Key? key, required this.AcademicProjectsTitle})
      : super(key: key);

  @override
  _ProjectsModuleStudentState createState() => _ProjectsModuleStudentState();
}

var highTitle = "Select your mentor";

var regStatus = ["Unregistered", "Pending Approval", "Approved"];

double sizedBoxHeight = 10;
bool registered = false;

final db = FirebaseFirestore.instance;
var actualMentorName;

var projectTitleLIst = [
  "OST",
  "OBT",
  "Master Thesis",
  "Live Project",
  "SIP or WIP",
  "SCP"
];

class _ProjectsModuleStudentState extends State<ProjectsModuleStudent> {
  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();

    int _count = projectTitleLIst.indexOf(widget.AcademicProjectsTitle);

    final String projectTitle = widget.AcademicProjectsTitle;
    User? user = FirebaseAuth.instance.currentUser;

    preferencesShared.setSaveAString(
        "${widget.AcademicProjectsTitle}RegState", "Unregistered");

    bool? mentorNameIsPresent = preferencesShared
            .getSavedBooleanState("${widget.AcademicProjectsTitle}") ??
        false;

    print(_count);

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
              //dispose();
            },
          ),
          title: Text(
            "${projectTitle}",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: KeyedSubtree(
            key: ValueKey<int>(_count),
            child: Column(
              children: [
                ReUsableWidgets().textOutput(
                    "${highTitle}",
                    Alignment.centerLeft,
                    TextAlign.left,
                    20,
                    true,
                    Colors.black),
                StreamBuilder<QuerySnapshot>(
                    stream: db
                        .collection(widget.AcademicProjectsTitle)
                        .where("menteeName", isEqualTo: user!.email)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError || !(snapshot.hasData)) {
                        return gettingFirebaseListData();
                      } else {
                        var name = snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          return document[
                              '${widget.AcademicProjectsTitle}MentorName'];
                        }).toList();
                        if (name.isEmpty) {
                          return gettingFirebaseListData();
                        } else {
                          print("is present");
                          highTitle = "Mentor Name";
                          return ReUsableWidgets().textOutput(
                              "${name[0]}",
                              Alignment.centerLeft,
                              TextAlign.left,
                              25,
                              true,
                              Colors.black);
                        }
                      }
                    }),
              ],
            ),
          ),
        ),
        floatingActionButton: Visibility(
          visible: !registered,
          child: FloatingActionButton.extended(
            onPressed: () {},
            label: Row(
              children: [
                Icon(Icons.add),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "Weekly Report",
                  style: TextStyle(letterSpacing: .1),
                )
              ],
            ),
          ),
        ));
  }

  Widget gettingFirebaseListData() {
    var mentorNamesList;

    return StreamBuilder<QuerySnapshot>(
      stream: db.collection(ImportantVariables.facultyDatabase).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else {
          List<DropdownMenuItem> mentors = [];
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            DocumentSnapshot snap = snapshot.data!.docs[i];

            mentors.add(
              DropdownMenuItem(
                child: Text(
                    "${snap["salutation"]} ${snap["firstName"]} ${snap["lastName"]}"),
                value:
                    "${snap["salutation"]} ${snap["firstName"]} ${snap["lastName"]}0${snap["userEmail"]}",
              ),
            );
          }
          return Column(
            children: [
              SizedBox(
                height: 10,
              ),
              DropdownButtonHideUnderline(
                child: Container(
                  height: 70,
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                      border: Border.all()),
                  child: DropdownButton<dynamic>(
                    isDense: true,
                    isExpanded: true,
                    items: mentors,
                    onChanged: (value) {
                      print(value);
                      mentorNamesList = value;
                    },
                    value: mentorNamesList,
                    hint: Text("Select Mentor"),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () => updateMentorData(mentorNamesList),
                child: Padding(
                    padding: EdgeInsets.fromLTRB(60, 10, 60, 10),
                    child: Text("Confirm")),
              )
            ],
          );
        }
      },
    );
  }

  updateMentorData(String mentorName) {
    var mentorItems = mentorName.split("0");
    /*print(mentorItems[0]);
    print(mentorItems[1]);*/

    CollectionReference studentCollection =
        FirebaseFirestore.instance.collection(widget.AcademicProjectsTitle);

    Map<String, dynamic> studentDocRef = {
      "${widget.AcademicProjectsTitle}MentorEmailID": mentorItems[1],
      "${widget.AcademicProjectsTitle}MentorName": mentorItems[0],
      "menteeName": FirebaseAuth.instance.currentUser!.email
    };

    //print(mentorName);

    DocumentReference studentDocuments =
        studentCollection.doc(FirebaseAuth.instance.currentUser!.email);

    setState(() {
      preferencesShared.setSaveBooleanState(
          "${widget.AcademicProjectsTitle}", true);
      preferencesShared.setSaveAString(
          "${widget.AcademicProjectsTitle}MentorName", mentorItems[1]);
    });

    studentDocuments.set(studentDocRef).whenComplete(() => {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Submitted here Successfully"))),
        });
  }
}
