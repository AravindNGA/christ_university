import 'package:christ_university/activities/club_activities/clubs.dart';
import 'package:christ_university/utils/important_variables.dart';
import 'package:christ_university/utils/resuable_widgets.dart';
import 'package:christ_university/utils/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:christ_university/utils/shared_prefs.dart';

class FacultyHomeActivity extends StatefulWidget {
  const FacultyHomeActivity({Key? key}) : super(key: key);

  @override
  _FacultyHomeActivityState createState() => _FacultyHomeActivityState();
}

var userName, userEmail;

double sizedBoxHeight = 10;
double screenWidth = 400;

TextAlign left = TextAlign.left;
Alignment centerLeft = Alignment.centerLeft;


class _FacultyHomeActivityState extends State<FacultyHomeActivity> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Firebase.initializeApp().whenComplete(() {
      print("doe");
    });
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    userEmail = user!.email;

    userName = preferencesShared.getSavedString(ImportantVariables.userFirstNameSharPref) ?? "";

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 40, 20, 0),
            child: Column(
              children: [
                ReUsableWidgets().textOutput(
                    "Welcome", Alignment.centerLeft, TextAlign.left, 18, false, Colors.black),
                ReUsableWidgets().textOutput(
                    userName, Alignment.centerLeft, TextAlign.left, 35, true, Colors.black),
                ReUsableWidgets().textOutput("Specialization",
                    Alignment.centerLeft, TextAlign.left, 18, false, Colors.black),
                SizedBox(height: 2 * sizedBoxHeight),
                Container(
                  width: screenWidth * 0.95,
                  child: Row(children: [
                    titleCards(
                        "Profile",
                        Icons.edit,
                        MyRoutes.facultyDataCollection,
                        Colors.white,
                        Colors.white,
                        Colors.teal),
                    titleCards(
                        "Appointments",
                        Icons.calendar_today_rounded,
                        MyRoutes.testing,
                        Colors.teal,
                        Colors.black,
                        Colors.white),
                    titleCards(
                        "Notification",
                        Icons.notifications_active_outlined,
                        MyRoutes.testing,
                        Colors.teal,
                        Colors.black,
                        Colors.white),
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
                          ReUsableWidgets()
                              .CardView(Icons.ac_unit, "OST", context),
                          ReUsableWidgets()
                              .CardView(Icons.ac_unit, "OBT", context),
                          ReUsableWidgets()
                              .CardView(Icons.ac_unit, "SCP", context),
                          ReUsableWidgets()
                              .CardView(Icons.ac_unit, "Live Project", context),
                          ReUsableWidgets()
                              .CardView(Icons.ac_unit, "SIP / WIP", context),
                          ReUsableWidgets()
                              .CardView(Icons.ac_unit, "Master Thesis", context),
                        ],
                      ),
                    ),
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
                          Column(
                            children: [
                              Card(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) =>
                                            ClubActivities() )
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Icon(Icons.ac_unit),
                                        ),
                                        Expanded(
                                          flex: 8,
                                          child: Text("Clubs"),
                                        ),
                                        Expanded(
                                            flex: 2,
                                            child: IconButton(
                                              icon: Icon(Icons.arrow_right_outlined),
                                              onPressed: () {},
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
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
}