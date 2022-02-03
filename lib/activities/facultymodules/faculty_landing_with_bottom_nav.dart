import 'package:christ_university/activities/facultymodules/courses/csv_to_list.dart';
import 'package:christ_university/activities/facultymodules/faculty_activity_home.dart';
import 'package:christ_university/activities/facultymodules/faculty_data_collection_home.dart';
import 'package:christ_university/utils/important_variables.dart';
import 'package:christ_university/utils/routes.dart';
import 'package:christ_university/utils/shared_prefs.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class FacultyLandingActivity extends StatefulWidget {
  const FacultyLandingActivity({Key? key}) : super(key: key);

  @override
  _FacultyLandingActivityState createState() => _FacultyLandingActivityState();
}

var indexing = 0;

final screens = [
  FacultyHomeActivity(),
  CsvToList(),
  FacultyDataCollection(),
];

class _FacultyLandingActivityState extends State<FacultyLandingActivity> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Firebase.initializeApp();

    preferencesShared.setSaveAString(ImportantVariables.whereAmI, MyRoutes.facultyLanding);
  }

  @override
  Widget build(BuildContext context) {

    Firebase.initializeApp();
    preferencesShared.setSaveAString(ImportantVariables.whereAmI, MyRoutes.facultyLanding);

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(index: indexing, children: screens),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: indexing,
        onTap: (index) => setState(() {
          indexing = index;
        }),
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_sharp),
              label: "CSV to List",
              backgroundColor: Colors.green),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile",
              backgroundColor: Colors.green),

        ],
      ),
    );
  }
}
