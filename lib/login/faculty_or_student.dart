import 'package:christ_university/utils/important_variables.dart';
import 'package:christ_university/utils/resuable_widgets.dart';
import 'package:christ_university/utils/routes.dart';
import 'package:christ_university/utils/shared_prefs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FacultyOrStudent extends StatefulWidget {
  const FacultyOrStudent({Key? key}) : super(key: key);

  @override
  _FacultyOrStudentState createState() => _FacultyOrStudentState();
}

double sizedBox = 10;

class _FacultyOrStudentState extends State<FacultyOrStudent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ReUsableWidgets().textOutput(
                  "Before we get started",
                  Alignment.centerLeft,
                  TextAlign.left,
                  25,
                  false,
                  Colors.black),
              ReUsableWidgets().textOutput("You are a .....",
                  Alignment.centerLeft, TextAlign.left, 30, true, Colors.black),
              SizedBox(
                height: 2 * sizedBox,
              ),
              OutlinedButton(
                onPressed: () => Navigator.pushNamed(context, MyRoutes.facultyLogin),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: MediaQuery.of(context).size.width * 0.25,
                        backgroundImage: AssetImage("assets/student_1.jpg"),
                      ),
                      SizedBox(
                        height: sizedBox,
                      ),
                      ReUsableWidgets().textOutput("Faculty", Alignment.center,
                          TextAlign.center, 20, true, Colors.black),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: sizedBox,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Divider(),
                  ),
                  Expanded(
                    flex: 1,
                    child: ReUsableWidgets().textOutput("or", Alignment.center,
                        TextAlign.center, 20, false, Colors.black54),
                  ),
                  Expanded(
                    flex: 2,
                    child: Divider(),
                  ),
                ],
              ),
              SizedBox(
                height: sizedBox,
              ),
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    preferencesShared.setSaveBooleanState(
                        ImportantVariables.didStudentLoginSharPref, true);
                  });
                  Navigator.pushNamed(context, MyRoutes.studentLogin);
                },
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: MediaQuery.of(context).size.width * 0.25,
                        backgroundImage: AssetImage("assets/student_3.jpg"),
                      ),
                      SizedBox(
                        height: sizedBox,
                      ),
                      ReUsableWidgets().textOutput("Student", Alignment.center,
                          TextAlign.center, 20, true, Colors.black),
                    ],
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
