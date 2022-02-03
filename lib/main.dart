import 'package:christ_university/activities/adminmodules/admin_activity.dart';
import 'package:christ_university/activities/club_activities/club_registeration.dart';
import 'package:christ_university/activities/facultymodules/eventreporting/activity_reports.dart';
import 'package:christ_university/activities/facultymodules/faculties_signup_activity.dart';
import 'package:christ_university/activities/facultymodules/faculty_data_collection_home.dart';
import 'package:christ_university/activities/facultymodules/faculty_landing_with_bottom_nav.dart';
import 'package:christ_university/activities/facultymodules/facultyregistration/personal_details.dart';
import 'package:christ_university/activities/facultymodules/facultyregistration/publication_details.dart';
import 'package:christ_university/activities/facultymodules/facultyregistration/work_exprience_details.dart';
import 'package:christ_university/activities/studentmodules/student_landing_bottom_nav.dart';
import 'package:christ_university/login/faculty_login.dart';
import 'package:christ_university/login/splash_screen.dart';
import 'package:christ_university/activities/studentmodules/student_home.dart';
import 'package:christ_university/activities/studentmodules/student_data_collection_home.dart';
import 'package:christ_university/testing_ui.dart';
import 'package:christ_university/utils/important_variables.dart';
import 'package:christ_university/utils/shared_prefs.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:christ_university/utils/routes.dart';
import 'package:christ_university/login_activity.dart';
import 'package:christ_university/activities/studentmodules/students_signup_activity.dart';

import 'activities/facultymodules/facultyregistration/academic_details.dart';
import 'login/fresher_module/fresher_module.dart';
import 'activities/studentmodules/studentsregistration/academic_details.dart';
import 'activities/studentmodules/studentsregistration/personal_details.dart';
import 'activities/studentmodules/studentsregistration/work_exprience_details.dart';
import 'login/faculty_or_student.dart';
import 'login/student_login.dart';
import 'login/trying_login.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  Firebase.initializeApp().catchError((e){
    print(e);
  });

  await preferencesShared.init();
  bool loginState = false, didStudentLogin = false, fresherLogin;
  String whereAmI;

  loginState = await preferencesShared.getSavedBooleanState(ImportantVariables.loggedInStateSharPref) ?? false;
  didStudentLogin = await preferencesShared.getSavedBooleanState(ImportantVariables.didStudentLoginSharPref) ?? false;

  fresherLogin = await preferencesShared
      .getSavedBooleanState(ImportantVariables.tempStudentDetailsLogInStatus) ?? false;

  whereAmI = await preferencesShared
      .getSavedString(ImportantVariables.whereAmI) ?? MyRoutes.splash;


  runApp(MaterialApp(

    //debugShowCheckedModeBanner: false,

    themeMode: ThemeMode.light,
    theme: ThemeData(
      primaryColor: Colors.teal,
      secondaryHeaderColor: Colors.teal,
    ),

    /*initialRoute: loginState ? (fresherLogin ? MyRoutes.FresherLanding
        : (didStudentLogin ? MyRoutes.studentLanding : MyRoutes.facultyLanding))
        : MyRoutes.splash,*/

    initialRoute: whereAmI,

    //initialRoute: "/testing",

    routes: {

      MyRoutes.testing : (context) => TryingLogin(),

      MyRoutes.splash : (context) => SplashActivity(),
      MyRoutes.facultyOrStudent : (context) => FacultyOrStudent(),

      MyRoutes.login : (context) => LoginActivity(),
      MyRoutes.studentLogin : (context) => StudentLogin(),
      MyRoutes.FresherLanding : (context) => FresherModuleLanding(),

      /*Students*/
      MyRoutes.studentsSignUpRoute : (context) => StudentSignUpActivity(),
      MyRoutes.studentLanding : (context) => StudentLandingActivity(),
      MyRoutes.studentDataCollection : (context) => StudentDataCollection(),
      MyRoutes.studentAcademicData : (context) => StudentAcademicDetails(),
      MyRoutes.studentPersonalData : (context) => StudentPersonalDetails(),
      MyRoutes.studentWorkExData : (context) => StudentWorkExprienceDetails(),

      //MyRoutes.studentOST : (context) => OSTModuleStudent(),
      //MyRoutes.studentOSTRegistration : (context) => StudentRegistrationForMentoringActivities(AcademicProjectsTitle: '',),

      /*Faculty*/
      MyRoutes.facultyLogin : (context) => FacultyLogin(),
      MyRoutes.facultySignUpRoute : (context) => FacultySignUpActivity(),

      MyRoutes.facultyLanding : (context) => FacultyLandingActivity(),

      MyRoutes.facultyDataCollection : (context) => FacultyDataCollection(),
      MyRoutes.facultyAcademicData : (context) => FacultyAcademicDetails(),
      MyRoutes.facultyPersonalData : (context) => FacultyPersonalDetails(),
      MyRoutes.facultyWorkExData : (context) => FacultyWorkExprienceDetails(),
      MyRoutes.facultyPublicationData : (context) => FacultyPublicationData(),

      MyRoutes.activityReporting : (context) => ActivityReporting(),

      /*Clubs*/
      MyRoutes.clubsRegistration : (context) => ClubRegistration(),

      /*Admin*/
      MyRoutes.adminLandingActivity : (context) => AdminLandingActivity(),
    },
  ));
}

