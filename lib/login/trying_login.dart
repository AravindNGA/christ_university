import 'package:christ_university/activities/facultymodules/faculties_signup_activity.dart';
import 'package:christ_university/activities/facultymodules/faculty_landing_with_bottom_nav.dart';
import 'package:christ_university/activities/studentmodules/student_landing_bottom_nav.dart';
import 'package:christ_university/activities/studentmodules/students_signup_activity.dart';
import 'package:christ_university/utils/important_variables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TryingLogin extends StatefulWidget {
  const TryingLogin({Key? key}) : super(key: key);

  @override
  _TryingLoginState createState() => _TryingLoginState();
}

FirebaseFirestore db = FirebaseFirestore.instance;

var dataBaseSearch;

class _TryingLoginState extends State<TryingLogin> {
  Widget gettingFirebaseData(String userEmail,String database) => StreamBuilder<QuerySnapshot>(
        stream: db
            .collection(database)
            .where("userEmail", isEqualTo: userEmail)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return userEmail.contains("mba.christuniversity.in")
                ? StudentSignUpActivity()
                : (userEmail.contains("christuniversity.in")
                    ? FacultySignUpActivity()
                    : FacultySignUpActivity());

            /*if(userEmail.contains("mba.christuniversity.in")){
          return StudentSignUpActivity();
        }else if(userEmail.contains("christuniversity.in")){
          return FacultySignUpActivity();
        }*/
          } else {
            return userEmail.contains("mba.christuniversity.in")
                ? StudentLandingActivity()
                : (userEmail.contains("christuniversity.in")
                    ? FacultyLandingActivity()
                    : FacultyLandingActivity());

            /*if(userEmail.contains("mba.christuniversity.in")){
          return StudentLanding();
        }else if(userEmail.contains("christuniversity.in")){
          return FacultyLandingActivity();
        }*/
          }
        },
      );

  @override
  Widget build(BuildContext context) {

    User? user = FirebaseAuth.instance.currentUser;
    String? userEmail = user!.email;

    if(userEmail!.contains("mba.christuniversity.in")){
      dataBaseSearch = ImportantVariables.facultyDatabase;
    }else if (userEmail.contains("christuniversity.in")){
      dataBaseSearch = ImportantVariables.studentsDatabase;
    }

    return Scaffold(
      body: gettingFirebaseData(userEmail,dataBaseSearch),
    );
  }
}
