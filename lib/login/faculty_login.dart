import 'package:christ_university/utils/important_variables.dart';
import 'package:christ_university/utils/resuable_widgets.dart';
import 'package:christ_university/utils/routes.dart';
import 'package:christ_university/utils/shared_prefs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FacultyLogin extends StatefulWidget {
  const FacultyLogin({Key? key}) : super(key: key);

  @override
  _FacultyLoginState createState() => _FacultyLoginState();
}

double sizedBoxHeight = 10;

class _FacultyLoginState extends State<FacultyLogin> {
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
              ReUsableWidgets().textOutput(
                  "Welcome to the",
                  Alignment.centerLeft,
                  TextAlign.left,
                  18,
                  false,
                  Colors.black),
              ReUsableWidgets().textOutput("Faculty Lounge",
                  Alignment.centerLeft, TextAlign.left, 30, true, Colors.black),
              SizedBox(height: 2 * sizedBoxHeight),
              ReUsableWidgets().textOutput(
                  "If your are a first time visitor, Feel free registering yourself and continue with the application.",
                  Alignment.centerLeft,
                  TextAlign.left,
                  18,
                  false,
                  Colors.black),
              SizedBox(height: 2 * sizedBoxHeight),
              ElevatedButton(
                onPressed: () => _signInWithGoogleTrying(),
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
              SizedBox(height: 2 * sizedBoxHeight),
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
              SizedBox(height: 2 * sizedBoxHeight),
              ReUsableWidgets().textOutput(
                  "If your are already a registered user, Click on the ${"Login"} button to start using the application.",
                  Alignment.centerLeft,
                  TextAlign.left,
                  18,
                  false,
                  Colors.black),
              SizedBox(height: 2 * sizedBoxHeight),
              OutlinedButton(
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
              SizedBox(height: sizedBoxHeight),
            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  var userEmail;

  Future<UserCredential> _signInWithGoogle() async {
    bool userLoggedInBefore = false;
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

      if (userEmail.contains("@christuniversity.in") ||
          userEmail.contains("aravindgoping@gmail.com") ||
          userEmail.contains("arvnfezz@gmail.com") ||
          userEmail.contains("jagadeesh.k@mba.christuniversity.in")) {

        setState(() {
          preferencesShared.setSaveBooleanState(
              ImportantVariables.loggedInStateSharPref, true);
          preferencesShared.setSaveBooleanState(
              ImportantVariables.didStudentLoginSharPref, false);
        });

        var userNameFromDB;

        FirebaseFirestore.instance
            .collection(ImportantVariables.facultyDatabase)
            .doc(userEmail)
            .get()
            .then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            userNameFromDB = documentSnapshot["firstName"];
            setState(() {
              preferencesShared.setSaveAString(
                  ImportantVariables.userFirstNameSharPref, userNameFromDB);
            });

            print('Document data: ${documentSnapshot["firstName"]}');
            Navigator.pushNamed(context, MyRoutes.facultyLanding);
          } else {
            Navigator.pushNamed(context, MyRoutes.facultySignUpRoute);
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

  Future<UserCredential> _signInWithGoogleTrying() async {
    bool userLoggedInBefore = false;
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

      Navigator.pushNamed(context, MyRoutes.testing);
    }
    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> _showMyDialog() async {
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
