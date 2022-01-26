import 'package:christ_university/utils/important_variables.dart';
import 'package:christ_university/utils/resuable_widgets.dart';
import 'package:christ_university/utils/routes.dart';
import 'package:christ_university/utils/shared_prefs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'individual_club.dart';

class ClubActivities extends StatefulWidget {

  const ClubActivities({Key? key}) : super(key: key);

  @override
  _ClubActivitiesState createState() => _ClubActivitiesState();
}

double sizedBoxHeight = 10;
bool didStudentLogin = false;

double screenHeight = 0.0;

final db = FirebaseFirestore.instance;

class _ClubActivitiesState extends State<ClubActivities> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPreferenceData();
  }

  getPreferenceData() async {
    didStudentLogin = await preferencesShared
        .getSavedBooleanState(ImportantVariables.didStudentLoginSharPref)!;
  }

  Widget forFaculty() => Container();

  @override
  Widget build(BuildContext context) {

    Widget gettingFirebaseData() => StreamBuilder<QuerySnapshot>(
          stream: db.collection(ImportantVariables.clubsDatabase).snapshots(),
          builder: (context, snapshot) {
            if(!snapshot.hasData){
              return Center(child: CircularProgressIndicator());
            }else{
              return Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: ListView(
                  children: snapshot.data!.docs.map((documents) {
                    return Container(
                      height: 160,
                      child : GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ClubIndividualData(
                                    title: documents["clubName"],
                                    summary : documents["clubSummary"],
                                    CatchPhrase: documents["clubCatchPhrase"],
                                  )));
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                            color: Colors.teal,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(16, 16, 16, 10),
                              child: Column(
                                children: [
                                  ReUsableWidgets().textOutput(
                                      documents["clubName"],
                                      Alignment.centerLeft,
                                      TextAlign.left,
                                      25,
                                      true,
                                      Colors.white),
                                  SizedBox(
                                    height: sizedBoxHeight / 2,
                                  ),
                                  ReUsableWidgets().textOutput(
                                      documents["clubCatchPhrase"],
                                      Alignment.centerLeft,
                                      TextAlign.left,
                                      14,
                                      false,
                                      Colors.white),
                                ],
                              ),
                            )),
                      ),
                    );
                  }).toList(),
                ),
              );
            }
          },
        );

    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("Clubs"),
      ),
      body: gettingFirebaseData(),
      floatingActionButton: Visibility(
        visible: !didStudentLogin,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, MyRoutes.clubsRegistration);
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
