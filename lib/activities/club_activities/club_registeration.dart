import 'package:christ_university/utils/image_uploader.dart';
import 'package:christ_university/utils/important_variables.dart';
import 'package:christ_university/utils/resuable_widgets.dart';
import 'package:christ_university/utils/shared_prefs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final clubNameText = TextEditingController();
final clubSummary = TextEditingController();
final clubCatchPhrase = TextEditingController();

bool clicked = false;

String clubNames = "";

class ClubRegistration extends StatefulWidget {
  const ClubRegistration({Key? key}) : super(key: key);

  @override
  State<ClubRegistration> createState() => _ClubRegistrationState();
}

class _ClubRegistrationState extends State<ClubRegistration> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Club Registration"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(18),
          child: Column(
            children: [
              TextFormField(
                controller: clubNameText,
                decoration: InputDecoration(
                    hintText: "Fantastic Name of your club",
                    labelText: "Club Name"),
                validator: (value) {
                  if (value != null) {
                    clubNames = value;
                  }
                },
              ),
              TextFormField(
                controller: clubSummary,
                decoration: InputDecoration(
                    hintText: "Enter your Catch Phrase",
                    labelText: "Catch Phrase"),
              ),
              TextFormField(
                maxLines: 5,
                controller: clubCatchPhrase,
                decoration: InputDecoration(
                    hintText: "Please tell us something about the club",
                    labelText: "Club Summary"),
              ),
              SizedBox(
                height: 20,
              ),
              Material(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(6),
                child: InkWell(
                  onTap: () => pushNames(),
                  child: AnimatedContainer(
                    width: 200,
                    duration: Duration(seconds: 1),
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text("Upload Club Logo",
                          style: TextStyle(fontSize: 17, color: Colors.white)),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Material(
                color: Colors.teal,
                borderRadius: BorderRadius.circular(6),
                child: InkWell(
                  onTap: () => registerClub(context, clicked),
                  child: AnimatedContainer(
                    duration: Duration(seconds: 1),
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text("Submit",
                          style: TextStyle(fontSize: 17, color: Colors.white)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  registerClub(BuildContext context, bool clicked) {
    clicked = true;

    if (clubNameText.text.isNotEmpty && clubSummary.text.isNotEmpty) {
      print("${clubNameText.text}, ${clubSummary}");
      Map<String, dynamic> clubRegistrationDocs = {
        "clubName": clubNameText.text,
        "clubSummary": clubSummary.text,
        "clubCatchPhrase": clubCatchPhrase.text,
        "createdBy": preferencesShared
            .getSavedString(ImportantVariables.userFirstNameSharPref),
      };

      CollectionReference clubCollRef = FirebaseFirestore.instance
          .collection(ImportantVariables.clubsDatabase);

      DocumentReference clubDocs = clubCollRef.doc(clubNameText.text);

      clubDocs.set(clubRegistrationDocs).whenComplete(() => {
            ReUsableWidgets().SnacksBar(context, "Registration Successful !!"),
            Navigator.pop(context),
            clubNameText.clear(),
            clubSummary.clear()
          });
    } else {
      ReUsableWidgets().SnacksBar(context, "Some Contents missing");
    }
  }

  pushNames() {
    if (clubNameText.text.isNotEmpty) {
      print(clubNameText.text);

      final clubNam = clubNameText.text;

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ImageUploader(clubName: clubNam)));
    }
  }
}
