import 'package:christ_university/login/fresher_module/fresher_module.dart';
import 'package:christ_university/utils/important_variables.dart';
import 'package:christ_university/utils/resuable_widgets.dart';
import 'package:christ_university/utils/routes.dart';
import 'package:christ_university/utils/shared_prefs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

class StudentLogin extends StatefulWidget {
  const StudentLogin({Key? key}) : super(key: key);

  @override
  _StudentLoginState createState() => _StudentLoginState();
}

DateTime currentDate = DateTime.now();
bool passDOB = false;
var applicationNumber,
    firstName,
    lastName,
    dobMM,
    dobDD,
    dobYYYY,
    personalEmail,
    phoneNumber;

double sizedBoxHeight = 10;

final _registrationFromKey = GlobalKey<FormState>();

class _StudentLoginState extends State<StudentLogin> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  var userEmail;

  Future<UserCredential> _signInWithGoogle() async {
    // Trigger the authentication flow
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    if (firebaseAuth.currentUser != null) {
      userEmail = firebaseAuth.currentUser!.email!;

      if (userEmail.contains("@mba.christuniversity.in")) {

        setState(() {
          preferencesShared.setSaveBooleanState(
              ImportantVariables.loggedInStateSharPref, true);
          preferencesShared.setSaveBooleanState(
              ImportantVariables.didStudentLoginSharPref, true);
        });

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
            Navigator.pushNamed(context, MyRoutes.studentLanding);

          } else {
            Navigator.pushNamed(context, MyRoutes.studentsSignUpRoute);
          }
        });

      } else {
        await firebaseAuth.signOut().catchError((e) {
          print(e);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Please use your Christ Email ID"),
          ));
        });
      }
    }
    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black87),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ReUsableWidgets().textOutput("For Seniors", Alignment.centerLeft,
                  TextAlign.left, 30, true, Colors.black),
              ReUsableWidgets().textOutput(
                  "(for 2nd year MBA)",
                  Alignment.centerLeft,
                  TextAlign.left,
                  18,
                  false,
                  Colors.black),
              SizedBox(height: sizedBoxHeight),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: OutlinedButton(
                      onPressed: () => _signInWithGoogle(),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ReUsableWidgets().textOutput(
                            "Log In",
                            Alignment.center,
                            TextAlign.center,
                            16,
                            false,
                            Colors.blue),
                      ),
                    ),
                  ),
                  SizedBox(width: sizedBoxHeight),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, MyRoutes.FresherLanding);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ReUsableWidgets().textOutput(
                            "Sign Up",
                            Alignment.center,
                            TextAlign.center,
                            16,
                            false,
                            Colors.white),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: sizedBoxHeight),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Divider(),
                  ),
                  Expanded(
                    flex: 1,
                    child: ReUsableWidgets().textOutput("or", Alignment.center,
                        TextAlign.center, 20, false, Colors.black54),
                  ),
                  Expanded(
                    flex: 2,
                    child: Divider(),
                  ),
                ],
              ),
              SizedBox(height: sizedBoxHeight),
              ReUsableWidgets().textOutput("For Freshers", Alignment.centerLeft,
                  TextAlign.left, 30, true, Colors.black),
              ReUsableWidgets().textOutput(
                  "(for 1st year MBA)",
                  Alignment.centerLeft,
                  TextAlign.left,
                  18,
                  false,
                  Colors.black),
              SizedBox(height: sizedBoxHeight),
              Padding(
                padding: EdgeInsets.zero,
                child: Form(
                    key: _registrationFromKey,
                    child: Column(
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Enter your Application Number",
                            labelText: "Application Number",
                          ),
                          validator: (value) {
                            if (!value!.isNotEmpty) {
                              return "Application Number missing";
                            } else {
                              applicationNumber = value;
                              return null;
                            }
                          },
                        ),
                        SizedBox(height: sizedBoxHeight),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(DateFormat.yMMMMd()
                                  .format(currentDate)
                                  .toString()),
                            ),
                            Expanded(
                              flex: 2,
                              child: ElevatedButton.icon(
                                onPressed: () => _selectDate(context),
                                label: Text("Select Date"),
                                icon: Icon(Icons.calendar_today_outlined),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: sizedBoxHeight,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "First Name",
                            labelText: "First Name",
                          ),
                          validator: (value) {
                            if (!value!.isNotEmpty) {
                              return "First Name missing";
                            } else {
                              firstName = value;
                              return null;
                            }
                          },
                        ),
                        SizedBox(
                          height: sizedBoxHeight,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Last Name",
                            labelText: "Last Name",
                          ),
                          validator: (value) {
                            if (!value!.isNotEmpty) {
                              return "Last Name missing";
                            } else {
                              lastName = value;
                              return null;
                            }
                          },
                        ),
                        SizedBox(
                          height: sizedBoxHeight,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Enter your Phone Number",
                            labelText: "Phone Number",
                          ),
                          validator: (value) {
                            if (!value!.isNotEmpty) {
                              return "Phone Number missing";
                            } else {
                              phoneNumber = value;
                              return null;
                            }
                          },
                        ),
                        SizedBox(height: sizedBoxHeight),
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Enter your Personal Email ID",
                            labelText: "Personal Email ID",
                          ),
                          validator: (value) {
                            if (!value!.isNotEmpty) {
                              return "Enter your personal Email";
                            } else if (!value.contains("@") ||
                                !value.contains(".")) {
                              return "Enter a valid email ID";
                            } else {
                              personalEmail = value;
                              return null;
                            }
                          },
                        ),
                      ],
                    )),
              ),
              SizedBox(height: sizedBoxHeight),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: OutlinedButton(
                      onPressed: () => _showMyDialog(),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ReUsableWidgets().textOutput(
                            "Log in",
                            Alignment.center,
                            TextAlign.center,
                            16,
                            false,
                            Colors.blue),
                      ),
                    ),
                  ),
                  SizedBox(width: sizedBoxHeight),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () => fresherRegistration("Fresher"),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ReUsableWidgets().textOutput(
                            "Register",
                            Alignment.center,
                            TextAlign.center,
                            16,
                            false,
                            Colors.white),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 2 * sizedBoxHeight),
            ],
          ),
        ),
      ),
    );
  }

  Future fresherRegistration(String who) async {
    if (!passDOB && _registrationFromKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Please enter a valid DOB")));
    } else if (_registrationFromKey.currentState!.validate() && passDOB) {
      //Navigator.pushNamed(context, MyRoutes.studentLanding);

      Map<String, dynamic> studentDocRef = {
        "${who}ApplicationNumber": applicationNumber,
        "${who}userEmail": personalEmail,
        "${who}DOBDate": dobDD,
        "${who}DOBMonth": dobMM,
        "${who}DOBYear": dobYYYY,
        "${who}firstName": firstName,
        "${who}lastName": lastName,
        "${who}phoneNumber": phoneNumber,
      };

      setState(() {
        preferencesShared.setSaveAString(
            ImportantVariables.tempStudentDetailsApplicationNumber,
            applicationNumber);
        preferencesShared.setSaveBooleanState(
            ImportantVariables.tempStudentDetailsLogInStatus, true);
        preferencesShared.setSaveBooleanState(
            ImportantVariables.loggedInStateSharPref, true);
      });

      DocumentReference studentDocuments = FirebaseFirestore.instance
          .collection(ImportantVariables.freshersTempDB)
          .doc(applicationNumber);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Submitting"),
        duration: Duration(seconds: 1),
      ));

      studentDocuments.set(studentDocRef).whenComplete(() => {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Submitted Successfully"),
            )),
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FresherModuleLanding())),
            print("Submitted"),
          });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(1950),
        lastDate: DateTime(2030));

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

  var applicationNumberLogin = TextEditingController();

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('Log in with Application number')),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFormField(
                  controller: applicationNumberLogin,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter your Application Number",
                    labelText: "Application Number",
                  ),
                  validator: (value) {
                    if (!value!.isNotEmpty) {
                      return "Application Number missing";
                    } else {
                      applicationNumber = value;
                      return null;
                    }
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Login'),
              onPressed: () {
                if (!applicationNumberLogin.text.isEmpty) {
                  print(applicationNumberLogin.text);

                  FirebaseFirestore.instance
                      .collection(ImportantVariables.freshersTempDB)
                      .where("FresherApplicationNumber",
                          isEqualTo: applicationNumberLogin.text)
                      .get()
                      .then((document) => {
                            print(document),
                            setState(() {
                              preferencesShared.setSaveAString(
                                  ImportantVariables
                                      .tempStudentDetailsApplicationNumber,
                                  applicationNumberLogin.text);
                              preferencesShared.setSaveBooleanState(
                                  ImportantVariables
                                      .tempStudentDetailsLogInStatus,
                                  true);
                              preferencesShared.setSaveBooleanState(
                                  ImportantVariables.loggedInStateSharPref,
                                  true);
                            }),
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                MyRoutes.FresherLanding,
                                (Route<dynamic> route) => false)
                          });
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showUserAlreadyLoggedIn() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('Registration Detected')),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("You have registered already !\n\nContinue Login ?")
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Login'),
              onPressed: () {
                print("pressed");
                setState(() {
                  preferencesShared.setSaveBooleanState(
                      ImportantVariables.loggedInStateSharPref, true);
                  preferencesShared.setSaveBooleanState(
                      ImportantVariables.didStudentLoginSharPref, false);
                });

                Navigator.pushNamed(context, MyRoutes.facultyLanding);
              },
            ),
          ],
        );
      },
    );
  }
}
