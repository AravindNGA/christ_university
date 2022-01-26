import 'package:christ_university/utils/important_variables.dart';
import 'package:christ_university/utils/routes.dart';
import 'package:christ_university/utils/shared_prefs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';

class LoginActivity extends StatefulWidget {
  const LoginActivity({Key? key}) : super(key: key);

  @override
  _LoginActivityState createState() => _LoginActivityState();
}

bool isLoggedIn = false;

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final FirebaseFirestore fireStore = FirebaseFirestore.instance;

String userEmail = "";

class _LoginActivityState extends State<LoginActivity> {
  static const double sizedBoxHeight = 20.0;
  bool isClicked = false;

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
  }

  /*void SignInWithGoogle() {
    setState(() {
      isClicked = true;
    });

    if (isLoggedIn) {
      _googleSignIn.signOut().then((value) {
        setState(() {
          isLoggedIn = false;
          print("User Signed out");
        });
      }).catchError((e) {
        print(e);
      });
    } else {
      _googleSignIn.signIn().then((userData){

          isLoggedIn = true;

          _userObj = userData!;
          UserName = _userObj.displayName!;
          UserEmail = _userObj.email;
          print(_userObj.displayName);

          if (_userObj.email.contains("christuniversity.in") &&
              _userObj.email.contains("mba")) {
            Navigator.pushNamed(context, MyRoutes.studentsRegistrationRoute);
          } else if (_userObj.email.contains("christuniversity.in")) {
            Navigator.pushNamed(context, MyRoutes.teachersRegistrationRoute);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Please use your Christ Email ID"),
            ));
          }
      }).catchError((e) {
        print(e);
      });
    }
  }*/

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
        await preferencesShared.setSaveBooleanState(ImportantVariables.didStudentLoginSharPref, true);
        print("trued");
        Navigator.pushNamed(context, MyRoutes.studentsSignUpRoute);
        //Navigator.pushNamed(context, MyRoutes.facultySignUpRoute);
      } else if (userEmail.contains("@christuniversity.in")) {
        await preferencesShared.setSaveBooleanState(ImportantVariables.didStudentLoginSharPref, false);
        Navigator.pushNamed(context, MyRoutes.facultySignUpRoute);
      }else if (userEmail.contains("aravindgoping@gmail.com") ||
          userEmail.contains("jagadeesh.k@mba.christuniversity.in")){
        Navigator.pushNamed(context, MyRoutes.facultySignUpRoute);
      }
      else {
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 60, 20, 0),
        child: Center(
          child: Column(
            children: <Widget>[
              Image.asset(
                "assets/christ_star.png",
                height: 130,
                fit: BoxFit.fitHeight,
              ),
              SizedBox(
                height: sizedBoxHeight,
              ),
              Image.asset(
                "assets/christ.jpg",
                height: 80,
                fit: BoxFit.fitWidth,
              ),
              SizedBox(
                height: 2 * sizedBoxHeight,
              ),
              Text(
                "Welcome",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                ),
              ),
              SizedBox(
                height: sizedBoxHeight,
              ),
              Text(
                "Please login with your \nCHRIST (Deemed to be University)\nMail ID to login",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  height: 1.5,
                ),
              ),
              SizedBox(
                height: 2 * sizedBoxHeight,
              ),
              Material(
                color: Colors.teal,
                borderRadius: BorderRadius.circular(isClicked ? 50 : 8),
                child: InkWell(
                  onTap: () => _signInWithGoogle(),
                  child: AnimatedContainer(
                    duration: Duration(seconds: 1),
                    width: isClicked ? 50 : 100,
                    height: 50,
                    alignment: Alignment.center,
                    child: isClicked
                        ? Icon(Icons.done, color: Colors.white)
                        : Text("Log in",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                  ),
                ),
              ),
              SizedBox(height: sizedBoxHeight),
              OutlinedButton(
                onPressed: (){
                  Navigator.pushNamed(context, MyRoutes.adminLandingActivity);
                },
                child: Text(
                  "Admin Login",
                  style : TextStyle(
                    color: Colors.blue,
                    fontStyle: FontStyle.italic
                  )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
