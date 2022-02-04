import 'dart:io';

import 'package:christ_university/activities/club_activities/clubs.dart';
import 'package:christ_university/activities/projects/student_list_for_faculty.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'important_variables.dart';

class ReUsableWidgets {
  Widget textOutput(String title, Alignment contentAlign, TextAlign align,
          double fontSize, bool bold, Color color) =>
      Align(
        alignment: contentAlign,
        child: Text(
          "$title",
          textAlign: align,
          style: TextStyle(
            color: color,
            fontSize: fontSize,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      );

  Widget CardContentOptions(
          IconData icon, String title, BuildContext context, String Route) =>
      Card(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Icon(icon),
              ),
              Expanded(
                flex: 8,
                child: Text("$title"),
              ),
              Expanded(
                  flex: 2,
                  child: IconButton(
                    icon: Icon(Icons.arrow_right_outlined),
                    onPressed: () {
                      Navigator.pushNamed(context, Route);
                    },
                  )),
            ],
          ),
        ),
      );

  Widget CardView(IconData icon, String title, BuildContext context) => OutlinedButton(
    onPressed: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  StudentList(AcademicProjectsTitle: title)));
    },
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Icon(icon,
                color: Colors.teal,),
              ),
              Expanded(
                flex: 8,
                child: Text(title,
                style: TextStyle(
                  color: Colors.black
                ),),
              ),
              Expanded(
                  flex: 2,
                  child: IconButton(
                    icon: Icon(Icons.arrow_right_outlined),
                    onPressed: () {},
                  )),
            ],
          ),
        )
      );

  SnacksBar(BuildContext context, String content) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(content),
    ));
  }

  Widget SilverBaring(String title) => CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 150,
            flexibleSpace: FlexibleSpaceBar(
                title: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate((context, index) => ListTile(
                    title: Text("Items ${index}"),
                  ))),
        ],
      );

  Widget NothingToDisplay(String string) =>
      Center(child: Padding(padding: EdgeInsets.all(10), child: Text(string)));

  Widget ListViewBuilder(int itemCount, String clubName, String clubSummary) =>
      Container(
        child: ListView.builder(
          itemCount: itemCount,
          itemBuilder: (_, index) => Container(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
              height: 170,
              child: GestureDetector(
                onTap: () {
                  /*Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ClubIndividualData(
                                title: clubNames[index],
                              )));*/
                },
                child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 10),
                      child: Column(
                        children: [
                          ReUsableWidgets().textOutput(
                              clubName,
                              Alignment.centerLeft,
                              TextAlign.left,
                              25,
                              true,
                              Colors.white),
                          SizedBox(
                            height: 10 / 2,
                          ),
                          ReUsableWidgets().textOutput(
                              clubSummary,
                              Alignment.centerLeft,
                              TextAlign.left,
                              16,
                              false,
                              Colors.white),
                        ],
                      ),
                    )),
              )),
        ),
      );

  /*Stream builder Dropdown Box*/

  var firstName, lastName, Sal, mentorNames, fullName;

  Widget gettingFacultyData() => StreamBuilder<QuerySnapshot>(
        stream: db.collection(ImportantVariables.facultyDatabase).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            List<DropdownMenuItem> mentors = [];
            for (int i = 0; i < snapshot.data!.docs.length; i++) {
              DocumentSnapshot snap = snapshot.data!.docs[i];

              firstName = snap["firstName"];
              lastName = snap["lastName"];
              Sal = snap["salutation"];

              fullName = Sal + " " + firstName + " " + lastName;

              mentors.add(
                DropdownMenuItem(
                  child: Text("${Sal + " " + firstName + " " + lastName}"),
                  value: "${snap.id}",
                ),
              );
            }
            return Row(
              children: [
                Icon(Icons.baby_changing_station),
                DropdownButton<dynamic>(
                  items: mentors,
                  onChanged: (value) {
                    print(value);
                    mentorNames = value;
                  },
                  value: mentorNames,
                  isExpanded: false,
                  hint: Text("Select Mentor"),
                )
              ],
            );
          }
        },
      );

  GettingFirebaseCollectionData(String userEmail) {
    var userNameFromDB;

    FirebaseFirestore.instance
        .collection(ImportantVariables.studentsDatabase)
        .doc(userEmail)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        userNameFromDB = documentSnapshot["firstName"];
        /*setState(() {
          preferencesShared.setSaveAString(ImportantVariables.userFirstNameSharPref, userNameFromDB);
        });*/

        print('Document data: ${documentSnapshot["firstName"]}');
      }
    });
  }
}

class FirebaseApi {
  static UploadTask? uploadTask(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putFile(file);
    } on FirebaseException catch (e) {
      return null;
    }
  }
}

class Learning{
  /*Widget team() =>StreamBuilder<QuerySnapshot>(
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
  return Column(
  children: [
  ReUsableWidgets().textOutput(
  "${name[0]}",
  Alignment.centerLeft,
  TextAlign.left,
  25,
  true,
  Colors.black),
  Align(
  alignment: Alignment.centerRight,
  child: OutlinedButton(onPressed: () {
  Navigator.push(context, MaterialPageRoute(builder: (context)=>
  DiscussionWithMentor(
  studentName: FirebaseAuth.instance.currentUser!.email as String,
  facultyName: name[1],
  projectType: widget.AcademicProjectsTitle)
  ));
  }, child: Text("Discuss with mentor")))
  ],
  );
  }
  }
  });*/
}
