import 'package:christ_university/activities/adminmodules/admin_bespoke_data.dart';
import 'package:christ_university/utils/important_variables.dart';
import 'package:flutter/material.dart';

class AdminLandingActivity extends StatefulWidget {
  const AdminLandingActivity({Key? key}) : super(key: key);

  @override
  _AdminLandingActivityState createState() => _AdminLandingActivityState();
}

class _AdminLandingActivityState extends State<AdminLandingActivity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Admin Landing")),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Icon(Icons.account_box_outlined),
                  ),
                  Expanded(
                    flex: 8,
                    child: Text("Students Data"),
                  ),
                  Expanded(
                      flex: 2,
                      child: IconButton(
                        icon: Icon(Icons.arrow_right_outlined),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdminBespokeData(
                                      dataRequest:
                                          ImportantVariables.studentsDatabase)));
                        },
                      )),
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Icon(Icons.account_circle_outlined),
                  ),
                  Expanded(
                    flex: 8,
                    child: Text("Faculty Data"),
                  ),
                  Expanded(
                      flex: 2,
                      child: IconButton(
                        icon: Icon(Icons.arrow_right_outlined),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdminBespokeData(
                                      dataRequest:
                                          ImportantVariables.facultyDatabase)));
                        },
                      )),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
