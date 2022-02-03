import 'package:christ_university/utils/important_variables.dart';
import 'package:christ_university/utils/resuable_widgets.dart';
import 'package:christ_university/utils/routes.dart';
import 'package:christ_university/utils/shared_prefs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../projects/student_projects_landing.dart';
import '../projects/student_projects_registration.dart';
import '../club_activities/clubs.dart';

class StudentHome extends StatefulWidget {
  const StudentHome({Key? key}) : super(key: key);

  @override
  _StudentHomeState createState() => _StudentHomeState();
}

var userName, userEmail;
double sizedBoxHeight = 10;

TextAlign left = TextAlign.left;
Alignment centerLeft = Alignment.centerLeft;

String ost = ImportantVariables.ostVariableSharPref;
String obt = ImportantVariables.obtVariableSharPref;
String scp = ImportantVariables.scpVariableSharPref;
String sip = ImportantVariables.sipVariableSharPref;
String liveProject = ImportantVariables.liveProjectVariableSharPref;
String masterThesis = ImportantVariables.MasterThesisVariableSharPref;

double screenWidth = 400;

bool? loginState = preferencesShared
    .getSavedBooleanState(ImportantVariables.didStudentLoginSharPref);

class _StudentHomeState extends State<StudentHome> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });

    preferencesShared.setSaveAString(ImportantVariables.whereAmI, MyRoutes.studentLanding);
  }

  /*gettingUserName(String userEmail){
    var userNameFromDB;

    FirebaseFirestore.instance
        .collection(ImportantVariables.studentsDatabase)
        .doc(userEmail)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        userNameFromDB = documentSnapshot["firstName"];
        setState(() {
          preferencesShared.setSaveAString(ImportantVariables.userFirstNameSharPref, userNameFromDB);
        });

        print('Document data: ${documentSnapshot["firstName"]}');
      } else {
        print('Document does not exist on the database');
      }
    });
  }*/

  /*Individual title Cards*/
  Widget titleCards(String title, IconData icon, String routeName,
      Color iconColor, Color fontColor, Color bgColor) {
    return Expanded(
        flex: 1,
        child: Column(
          children: [
            Container(
                height: 110,
                child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, routeName);
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 8,
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Center(
                              child: Column(children: [
                            SizedBox(height: 10),
                            Icon(
                              icon,
                              color: iconColor,
                              size: 30,
                            ),
                            SizedBox(height: 2 * sizedBoxHeight),
                            Text("$title",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: fontColor,
                                ))
                          ]))),
                      color: bgColor,
                    )))
          ],
        ));
  }

  /* Individual modules*/
  Widget ModuleItems(String title, IconData icon, String routeName,
      Color bgColor, String title1, IconData icon1, String routeName1) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
              child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProjectsModuleStudent(
                            AcademicProjectsTitle: title,
                          )));
            },
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Icon(
                        icon,
                        color: Colors.white,
                        size: 35,
                      ),
                    ),
                    SizedBox(height: 2 * sizedBoxHeight),
                    Align(
                        alignment: Alignment.bottomLeft,
                        child: Text("$title",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold))),
                  ],
                ),
              ),
              color: bgColor,
            ),
          )),
        ),
        Expanded(
          flex: 2,
          child: Container(
              child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProjectsModuleStudent(
                            AcademicProjectsTitle: title1,
                          )));
            },
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Icon(
                        icon1,
                        color: Colors.white,
                        size: 35,
                      ),
                    ),
                    SizedBox(height: 2 * sizedBoxHeight),
                    Align(
                        alignment: Alignment.bottomLeft,
                        child: Text("$title1",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold))),
                  ],
                ),
              ),
              color: bgColor,
            ),
          )),
        ),
      ],
    );
  }

  Widget cards(String title, IconData icon,
      Color bgColor, Widget widget) => Container(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => widget));
        },
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
                SizedBox(height: 2 * sizedBoxHeight),
                Align(
                    alignment: Alignment.bottomLeft,
                    child: Text("$title",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold))),
              ],
            ),
          ),
          color: bgColor,
        ),
      ));

  @override
  Widget build(BuildContext context) {

    Firebase.initializeApp();

    preferencesShared.setSaveAString(ImportantVariables.whereAmI, MyRoutes.studentLanding);

    User? user = FirebaseAuth.instance.currentUser;
    userEmail = user!.email;

    //gettingUserName(userEmail);
    //debugPaintSizeEnabled = true;

    userName = preferencesShared
        .getSavedString(ImportantVariables.userFirstNameSharPref) ?? "";

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 40, 20, 0),
            child: Column(
              children: [
                ReUsableWidgets().textOutput("Welcome", Alignment.centerLeft,
                    TextAlign.left, 18, false, Colors.black),
                ReUsableWidgets().textOutput(userName, Alignment.centerLeft,
                    TextAlign.left, 35, true, Colors.black),
                SizedBox(height: 2 * sizedBoxHeight),
                Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: Row(children: [
                    titleCards(
                        "Profile",
                        Icons.edit,
                        MyRoutes.studentDataCollection,
                        Colors.white,
                        Colors.white,
                        Colors.teal),
                    titleCards(
                        "Notifications",
                        Icons.notifications_active,
                        MyRoutes.testing,
                        Colors.teal,
                        Colors.black,
                        Colors.white),
                    titleCards(
                        "Appointment",
                        Icons.calendar_today_outlined,
                        MyRoutes.testing,
                        Colors.teal,
                        Colors.black,
                        Colors.white)
                  ]),
                ),
                SizedBox(height: 2 * sizedBoxHeight),
                Divider(),
                SizedBox(
                  height: sizedBoxHeight,
                ),
                Column(
                  children: [
                    ExpandablePanel(
                        header: Padding(
                            padding: EdgeInsets.fromLTRB(5, 10, 0, 10),
                            child: ReUsableWidgets().textOutput("Mentoring",
                                centerLeft, left, 18, true, Colors.black)),
                        collapsed: SizedBox(
                          height: sizedBoxHeight,
                        ),
                        expanded: Column(
                          children: [
                            Row(
                              children: [
                                Visibility(
                                  visible : true,
                                  child: Expanded(
                                    flex : 2,
                                      child: cards(ost,
                                    Icons.account_tree_outlined,
                                    Colors.teal,
                                          ProjectsModuleStudent(
                                            AcademicProjectsTitle: ost,
                                          ))
                                  ),
                                ),
                                Visibility(
                                  visible: true,
                                  child: Expanded(
                                      flex : 2,
                                      child: cards(obt,
                                        Icons.architecture_outlined,
                                        Colors.teal,
                                          ProjectsModuleStudent(
                                            AcademicProjectsTitle: obt,
                                          )
                                      )),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Visibility(
                                  visible : true,
                                  child: Expanded(
                                      flex : 2,
                                      child: cards(scp,
                                          Icons.social_distance,
                                          Colors.teal,
                                          ProjectsModuleStudent(
                                            AcademicProjectsTitle: scp,
                                          ))
                                  ),
                                ),
                                Visibility(
                                  visible: true,
                                  child: Expanded(
                                      flex : 2,
                                      child: cards(liveProject,
                                          Icons.desktop_windows_outlined,
                                          Colors.teal,
                                          ProjectsModuleStudent(
                                            AcademicProjectsTitle: liveProject,
                                          )
                                      )),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Visibility(
                                  visible : true,
                                  child: Expanded(
                                      flex : 2,
                                      child: cards(sip,
                                          Icons.wallet_travel_rounded,
                                          Colors.teal,
                                          ProjectsModuleStudent(
                                            AcademicProjectsTitle: sip,
                                          ))
                                  ),
                                ),
                                Visibility(
                                  visible: true,
                                  child: Expanded(
                                      flex : 2,
                                      child: cards(masterThesis,
                                          Icons.analytics_outlined,
                                          Colors.teal,
                                          ProjectsModuleStudent(
                                            AcademicProjectsTitle: masterThesis,
                                          )
                                      )),
                                ),
                              ],
                            ),
                          ],
                        )),
                    SizedBox(
                      height: sizedBoxHeight,
                    ),
                    ExpandablePanel(
                        header: Padding(
                            padding: EdgeInsets.fromLTRB(5, 10, 0, 10),
                            child: ReUsableWidgets().textOutput("Extra Curricular",
                                centerLeft, left, 18, true, Colors.black)),
                        collapsed: SizedBox(
                          height: sizedBoxHeight,
                        ),
                        expanded: Column(
                          children: [
                            Row(
                              children: [
                                Visibility(
                                  visible : true,
                                  child: Expanded(
                                      flex : 2,
                                      child: cards("Clubs",
                                          Icons.gamepad_outlined,
                                          Colors.lightGreen,
                                          ClubActivities())
                                  ),
                                ),
                                Visibility(
                                  visible: !true,
                                  child: Expanded(
                                      flex : 2,
                                      child: Text("Nothing yet")
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )),
                    SizedBox(
                      height: 2 * sizedBoxHeight,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void callFirebase() async {
    await Firebase.initializeApp();

  }
}
/* see also Expanded Panel list*/
