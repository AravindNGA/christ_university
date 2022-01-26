import 'package:christ_university/activities/projects/student_projects_landing.dart';
import 'package:christ_university/utils/important_variables.dart';
import 'package:christ_university/utils/resuable_widgets.dart';
import 'package:christ_university/utils/routes.dart';
import 'package:christ_university/utils/shared_prefs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class FresherModuleLanding extends StatefulWidget {

  const FresherModuleLanding({Key? key}) : super(key: key);

  @override
  _FresherModuleLandingState createState() => _FresherModuleLandingState();
}

var applicationNumber;
String ost = ImportantVariables.ostVariableSharPref;

double sizedBox = 10;
bool dataEntryStatus = false;

class _FresherModuleLandingState extends State<FresherModuleLanding> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    applicationNumber = preferencesShared.getSavedString(ImportantVariables.tempStudentDetailsApplicationNumber)!;
  }

  @override
  Widget build(BuildContext context) {

    callFirebase();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: () => LogOutfromFresher(),
              child: ReUsableWidgets().textOutput("Logout", Alignment.centerRight, TextAlign.center, 18, false, Colors.black),
            )
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                ReUsableWidgets().textOutput("Welcome", Alignment.centerLeft, TextAlign.left, 30, true , Colors.black87),
                SizedBox(height: 2* sizedBox,),
                Container(
                  height: 100,
                  child: Anotherwidget(),
                ),
                cards(ost,
                    Icons.account_tree_outlined,
                    Colors.teal,
                    ProjectsModuleStudent(
                      AcademicProjectsTitle: ost,
                    ))

              ],
            ),
          ),
      ),
    );

  }

  void callFirebase() async {
    await Firebase.initializeApp();
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
                SizedBox(height: 2 * sizedBox),
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

  Future LogOutfromFresher() async{
    setState(() {
      preferencesShared.setSaveAString(ImportantVariables.tempStudentDetailsApplicationNumber, "notPresent");
      preferencesShared.setSaveBooleanState(ImportantVariables.tempStudentDetailsLogInStatus, false);
    });
    Navigator.of(context)
        .pushNamedAndRemoveUntil(MyRoutes.splash , (Route<dynamic> route) => false);
    
    ReUsableWidgets().SnacksBar(context, "Signed out Successfully");
  }

}

class Anotherwidget extends StatefulWidget {
  const Anotherwidget({Key? key}) : super(key: key);

  @override
  _AnotherwidgetState createState() => _AnotherwidgetState();
}

class _AnotherwidgetState extends State<Anotherwidget> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: gettingFirebaseData(),
    );
  }

  Widget gettingFirebaseData() => StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection(ImportantVariables.freshersTempDB)
        .where("FresherApplicationNumber", isEqualTo: applicationNumber).snapshots(),
    builder: (context, snapshot) {
      if(!snapshot.hasData){
        return Center(child: CircularProgressIndicator());
      }else{
        return ListView(
          children: snapshot.data!.docs.map((documents) {
            return Container(
              child : GestureDetector(
                onTap: () {},
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
                              documents["FresherfirstName"],
                              Alignment.centerLeft,
                              TextAlign.left,
                              25,
                              true,
                              Colors.white),
                          SizedBox(
                            height: sizedBox / 2,
                          ),
                          ReUsableWidgets().textOutput(
                              documents["FresheruserEmail"],
                              Alignment.centerLeft,
                              TextAlign.left,
                              14,
                              false,
                              Colors.white),
                          SizedBox(
                            height: sizedBox / 2,
                          ),
                        ],
                      ),
                    )),
              ),
            );
          }).toList(),
        );
      }
    },
  );
}

