import 'package:christ_university/activities/notifications.dart';
import 'package:christ_university/activities/studentmodules/student_data_collection_home.dart';
import 'package:christ_university/activities/studentmodules/student_home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class StudentLanding extends StatefulWidget {
  const StudentLanding({Key? key}) : super(key: key);

  @override
  _StudentLandingState createState() => _StudentLandingState();
}

var indexing = 0;

final screens = [
  StudentHome(),
  Notifications(),
  StudentDataCollection(),
];

class _StudentLandingState extends State<StudentLanding> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {

    Firebase.initializeApp();

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
              icon: Icon(Icons.notifications_active_rounded),
              label: "Notifications",
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
