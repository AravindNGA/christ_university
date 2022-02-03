import 'package:christ_university/activities/club_activities/clubs.dart';
import 'package:christ_university/utils/important_variables.dart';
import 'package:christ_university/utils/resuable_widgets.dart';
import 'package:christ_university/utils/shared_prefs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DiscussionWithMentor extends StatefulWidget {
  final String studentName;
  final String facultyName;
  final String projectType;

  const DiscussionWithMentor(
      {Key? key,
      required this.studentName,
      required this.facultyName,
      required this.projectType})
      : super(key: key);

  @override
  _DiscussionWithMentorState createState() => _DiscussionWithMentorState();
}

FirebaseFirestore db = FirebaseFirestore.instance;
var message = TextEditingController();

class _DiscussionWithMentorState extends State<DiscussionWithMentor> {


  Widget gettingFirebaseData() => StreamBuilder<QuerySnapshot>(
        stream: db.collection(ImportantVariables.studentsChatScreen)
        .where("${widget.projectType}MenteeName", isEqualTo: widget.studentName)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: Text("Start A new chat"));
          } else {
            return Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: ListView(
                children: snapshot.data!.docs.map((documents) {
                  return Container(
                    child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: documents["sentByStudent"]
                              ? BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(1))
                              : BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(1),
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20)),
                        ),
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(16, 16, 16, 10),
                          child: Column(
                            children: [
                              ReUsableWidgets().textOutput(
                                  documents["content"],
                                  Alignment.centerLeft,
                                  TextAlign.left,
                                  18,
                                  false,
                                  Colors.black),
                              SizedBox(
                                height: sizedBoxHeight / 5,
                              ),
                            ],
                          ),
                        )),
                  );
                }).toList(),
              ),
            );
          }
        },
      );

  @override
  Widget build(BuildContext context) {
    /*isStudent = preferencesShared
            .getSavedBooleanState(ImportantVariables.didStudentLoginSharPref) ??
        false;
*/
    updateMentorData(String content) {
      CollectionReference studentCollection = FirebaseFirestore.instance
          .collection(ImportantVariables.studentsChatScreen);

      Map<String, dynamic> studentDocRef = {
        "${widget.projectType}MenteeName": widget.studentName,
        "${widget.projectType}MentorName": widget.facultyName,
        "projectType": widget.projectType,
        "sentByStudent": preferencesShared
            .getSavedBooleanState(ImportantVariables.didStudentLoginSharPref),
        "content": content
      };

      message.clear();

      DocumentReference studentDocuments = studentCollection.doc();

      studentDocuments.set(studentDocRef).whenComplete(() => {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Submitted here Successfully"))),
          });
    }

    print("${widget.studentName}");

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.studentName}"),
      ),
      body: gettingFirebaseData(),
      persistentFooterButtons: [
        Row(
          children: [
            SizedBox(
              width: 10,
            ),
            Expanded(
                flex: 3,
                child: TextFormField(
                  controller: message,
                  decoration: InputDecoration(
                    hintText: "Type here",
                  ),
                  validator: (value) {
                    if (!value!.isNotEmpty) {
                      return "Enter your First Name";
                    } else {
                      return null;
                    }
                  },
                )),
            SizedBox(
              width: 10,
            ),
            Expanded(
                flex: 1,
                child: ElevatedButton(
                  onPressed: () => updateMentorData(message.text),
                  child: Icon(Icons.send),
                  style: ElevatedButton.styleFrom(
                      shape: CircleBorder(), padding: EdgeInsets.all(15)),
                ))
          ],
        )
      ],
    );
  }
}
