import 'package:christ_university/utils/shared_prefs.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import 'package:christ_university/utils/routes.dart';
import 'package:christ_university/utils/important_variables.dart';

class StudentSignUpActivity extends StatefulWidget {
  const StudentSignUpActivity({Key? key}) : super(key: key);

  @override
  _StudentSignUpActivityState createState() => _StudentSignUpActivityState();
}

/*Global variables*/
final _fromKey = GlobalKey<FormState>();
const double sizedBox = 10;

/*UI items*/
DateTime currentDate = DateTime.now();

/*Data Upload procedures*/
var userName, userEmail, displayName;

CollectionReference studentCollection =
    FirebaseFirestore.instance.collection(ImportantVariables.studentsDatabase);

var defaultGenderValue = "Choose";
var dropDownList = ['Choose', 'Male', 'Female'];

bool passGender = false, passDOB = false, passRoll = false;
var registrationStatus = ImportantVariables.registeredStatus;

var firstName,
    lastName,
    dobDD,
    dobMM,
    dobYYYY,
    gender,
    profilePic,
    registrationDone = true;
int rollNumber = 0;

/*Stful class*/
class _StudentSignUpActivityState extends State<StudentSignUpActivity> {
  late Map downloadData;

  /* ifDataExists() async {
    var document = await FirebaseFirestore.instance.collection(DatabaseImportant.studentsDatabase).where(
      rollNumber, isEqualTo: "rollNumber").get().then((value){
       if(value.docs.isNotEmpty){
         Map<String, dynamic> documentData = value.docs as Map<String, dynamic>;
         print(documentData);
       }
    });
  } */

  isFormFilled() async {
    if (!passGender || !passDOB || passRoll) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Please enter a valid DOB")));
    } else if (_fromKey.currentState!.validate() && passGender && passDOB) {
      //Navigator.pushNamed(context, MyRoutes.studentLanding);

      Map<String, dynamic> studentDocRef = {
        "firstName": firstName,
        "lastName": lastName,
        "userEmail": userEmail,
        "rollNumber": rollNumber,
        "DOBDate": dobDD,
        "DOBMonth": dobMM,
        "DOBYear": dobYYYY,
        "Gender": gender,
        "registrationDone": registrationDone,
        "profilePic": profilePic,
        "registrationStatus": registrationStatus
      };

      await preferencesShared.setSaveBooleanState(
          ImportantVariables.loggedInStateSharPref, true);

      preferencesShared.setSaveBooleanState(
          ImportantVariables.didStudentLoginSharPref, true);

      /*print("prefernces state set, ${preferencesShared.getSavedBooleanState(
          ImportantVariables.loggedInState)}");*/

      DocumentReference studentDocuments = studentCollection.doc(userEmail);

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Submitted Successfully")));

      studentDocuments.set(studentDocRef).whenComplete(
          () => {Navigator.pushNamed(context, MyRoutes.studentLanding)});
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(1930),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate)
      setState(() {
        currentDate = pickedDate;
        passDOB = true;

        var newDate =
            DateFormat.yMMMMd().format(currentDate).toString().split(" ");
        dobMM = newDate[0];
        dobDD = int.parse(newDate[1].replaceFirst(",", ""));
        dobYYYY = int.parse(newDate[2]);
      });
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    userEmail = user!.email;
    userName = user.displayName;
    profilePic = user.photoURL;

    var name = userName!.split(" ");
    name.removeLast();
    var displayName = name.join(" ");

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(32, 50, 32, 10),
            child: Form(
              key: _fromKey,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: sizedBox,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Hi, $displayName",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: sizedBox / 2,
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Provide us with some of your details",
                          style: TextStyle(fontSize: 17))),
                  SizedBox(
                    height: 5 * sizedBox,
                  ),
                  TextFormField(
                    initialValue: displayName,
                    decoration: InputDecoration(
                      hintText: "Enter First Name",
                      labelText: "First Name",
                    ),
                    validator: (value) {
                      if (!value!.isNotEmpty) {
                        return "Enter your First Name";
                      } else {
                        firstName = value;
                        preferencesShared.setSaveAString(
                            ImportantVariables.userFirstNameSharPref, value);
                        return null;
                      }
                    },
                  ),
                  SizedBox(
                    height: sizedBox,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "Enter Last Name",
                      labelText: "Last Name",
                    ),
                    validator: (value) {
                      if (!value!.isNotEmpty) {
                        return "Enter your Last Name";
                      } else {
                        lastName = value;
                        return null;
                      }
                    },
                  ),
                  SizedBox(
                    height: 2 * sizedBox,
                  ),
                  TextFormField(
                    initialValue: userEmail,
                    decoration: InputDecoration(
                      hintText: "Your Email ID",
                      labelText: "Email ID",
                    ),
                    validator: (value) {
                      if (!value!.isNotEmpty) {
                        return "Enter your First Name";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(
                    height: sizedBox,
                  ),
                  SizedBox(
                    height: sizedBox,
                  ),
                  new Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Date of Birth",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                            DateFormat.yMMMMd().format(currentDate).toString()),
                      ),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () => _selectDate(context),
                          child: Text('Select date'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: sizedBox,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Enter Roll Number",
                      labelText: "Roll Number",
                    ),
                    validator: (value) {
                      if (!value!.isNotEmpty) {
                        return "Enter your Registration Number ";
                      } else if (!(value.length == 7)) {
                        return "Enter valid Roll Number";
                      } else {
                        rollNumber = int.parse(value);
                        preferencesShared.setSaveAString(
                            ImportantVariables.studentRollNumberSharPref, value);
                        return null;
                      }
                    },
                  ),
                  SizedBox(
                    height: 2 * sizedBox,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text("Select your Gender"),
                      ),
                      Expanded(
                        flex: 3,
                        child: DropdownButton(
                          icon: Icon(Icons.keyboard_arrow_down_rounded),
                          value: defaultGenderValue,
                          items: dropDownList.map((String? item) {
                            return DropdownMenuItem(
                                value: item, child: Text(item!));
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              defaultGenderValue = value!;
                              if (value != "Choose") {
                                passGender = true;
                                gender = defaultGenderValue;
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 4 * sizedBox,
                  ),
                  Material(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      onTap: () => isFormFilled(),
                      child: AnimatedContainer(
                        duration: Duration(seconds: 1),
                        width: 200,
                        height: 50,
                        alignment: Alignment.center,
                        child: Text("Submit",
                            style:
                                TextStyle(fontSize: 17, color: Colors.white)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
