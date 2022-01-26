import 'package:christ_university/utils/important_variables.dart';
import 'package:christ_university/utils/resuable_widgets.dart';
import 'package:christ_university/utils/shared_prefs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ConfirmRegistration extends StatefulWidget {
  final String clubName;
  const ConfirmRegistration({Key? key, required this.clubName}) : super(key: key);

  @override
  _ConfirmRegistrationState createState() => _ConfirmRegistrationState();
}

var fireStore = FirebaseFirestore.instance;

class _ConfirmRegistrationState extends State<ConfirmRegistration> {

  /*Future CheckExitingUser(String email) async{
    CollectionReference findteam = fireStore.collection(ImportantVariables.clubRegistration);

  }*/

  Future RegisterMe() async{

    User? user = FirebaseAuth.instance.currentUser;

    Map<String, dynamic> memberInfo = {
      "memberName" : preferencesShared.getSavedString(ImportantVariables.userFirstNameSharPref),
      "memberRollNumber" : preferencesShared.getSavedString(ImportantVariables.studentRollNumberSharPref),
      "memberEmail" : user!.email,
      "clubDetails" : widget.clubName,
      "acceptedStatus" : false,
      "isPOC" : false
    };

    DocumentReference joinTeam1 = fireStore.collection(ImportantVariables.clubRegistration).doc(user.email);

    joinTeam1.set(memberInfo).whenComplete(() => {
      ReUsableWidgets().SnacksBar(context, "Registration Successful"),
      Navigator.pop(context)
    });

    Map<String, dynamic> data = {"clubJoined" : widget.clubName};

    DocumentReference getDataFromParent = fireStore.collection(ImportantVariables.studentsDatabase).doc(user.email);
        getDataFromParent.update(data);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title : Text("Confirm Registration")
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Text("Are you sure to register with ${widget.clubName}"),
            ElevatedButton(onPressed: () => RegisterMe(), child: Text("Confirm"))
          ],
        ),
      ),
    );
  }
}
