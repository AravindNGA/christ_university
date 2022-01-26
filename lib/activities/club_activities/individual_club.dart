import 'package:christ_university/activities/club_activities/confirm_member_registration.dart';
import 'package:christ_university/activities/club_activities/members_list.dart';
import 'package:christ_university/activities/club_activities/view_registrations.dart';
import 'package:christ_university/utils/important_variables.dart';
import 'package:christ_university/utils/resuable_widgets.dart';
import 'package:flutter/material.dart';
import 'package:christ_university/utils/shared_prefs.dart';

class ClubIndividualData extends StatefulWidget {
  final String title;
  final String summary;
  final String CatchPhrase;

  const ClubIndividualData(
      {Key? key,
      required this.title,
      required this.summary,
      required this.CatchPhrase})
      : super(key: key);

  @override
  _ClubIndividualDataState createState() => _ClubIndividualDataState();
}

bool didStudentLogin = false;

class _ClubIndividualDataState extends State<ClubIndividualData> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPreferenceData();
  }
  getPreferenceData() async {
    didStudentLogin = await preferencesShared.getSavedBooleanState(ImportantVariables.didStudentLoginSharPref)!;
    print(didStudentLogin);
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(20)),
                ),
                color: Colors.teal,
                child: Container(
                  child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
                        child: Column(
                          children: [
                            Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  child: Card(
                                    child: Center(
                                      child: Text("logo"),
                                    ),
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(50)),
                                    ),
                                  ),
                                  height: 110,
                                  width: 110,
                                )),
                            ReUsableWidgets().textOutput(
                                widget.title,
                                Alignment.bottomLeft,
                                TextAlign.left,
                                40,
                                true,
                                Colors.white),
                            SizedBox(
                              height: 10,
                            ),
                            ReUsableWidgets().textOutput(
                                widget.CatchPhrase,
                                Alignment.bottomLeft,
                                TextAlign.left,
                                16,
                                false,
                                Colors.white),
                            SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      )),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex : 2,
                          child: ReUsableWidgets().textOutput(
                              "About the Club",
                              Alignment.topLeft,
                              TextAlign.left,
                              18,
                              true,
                              Colors.black),
                        ),
                        Expanded(
                          flex: 2,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> MembersList(clubName: widget.title)));
                            },
                            child: Text("View Members"),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ReUsableWidgets().textOutput(
                        widget.summary,
                        Alignment.topLeft,
                        TextAlign.left,
                        18,
                        false,
                        Colors.black),
                  ],
                ),
              ),
              Visibility(
                visible: didStudentLogin,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 2,
                          child: ReUsableWidgets().textOutput(
                              "Register",
                              Alignment.topLeft,
                              TextAlign.left,
                              18,
                              true,
                              Colors.black)),
                      Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            child: Text("Register"),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ConfirmRegistration(
                                          clubName: widget.title)));
                            },
                          )),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: !didStudentLogin,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 2,
                          child: ReUsableWidgets().textOutput(
                              "View Registrations",
                              Alignment.topLeft,
                              TextAlign.left,
                              18,
                              true,
                              Colors.black)),
                      Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            child: Text("Registrations"),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ViewRegistrations(
                                          clubName: widget.title)));
                            },
                          )),
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
