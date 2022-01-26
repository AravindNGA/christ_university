import 'package:christ_university/utils/routes.dart';
import 'package:flutter/material.dart';

class SplashActivity extends StatefulWidget {
  const SplashActivity({Key? key}) : super(key: key);

  @override
  State<SplashActivity> createState() => _SplashActivityState();
}
double sizedBoxHeight = 10;

class _SplashActivityState extends State<SplashActivity> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Column(
            children: [
              Center(
                child: Container(
                  height: MediaQuery.of(context).size.width * 0.8,
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Card(
                    margin: EdgeInsets.symmetric(horizontal: 2),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(150)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Image.asset(
                          "assets/christ_star.png",
                          height: MediaQuery.of(context).size.width * 0.4,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: sizedBoxHeight,
              ),
              Image.asset(
                "assets/christ.jpg",
                height: 90,
                fit: BoxFit.fitWidth,
              ),
              SizedBox(
                height: 2 * sizedBoxHeight,
              ),
              Text(
                "Welcome",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              SizedBox(
                height: sizedBoxHeight,
              ),
              Text(
                "Please login with your \nCHRIST (Deemed to be University)\nMail ID to login",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ],
          )),
      persistentFooterButtons: [
        Center(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Text(
                  "Get Started",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                SizedBox(
                  height: sizedBoxHeight,
                ),
                FloatingActionButton(
                    onPressed: () {
                      Navigator.pushNamed(context, MyRoutes.facultyOrStudent);
                    },
                    child : Icon(Icons.arrow_forward)
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
