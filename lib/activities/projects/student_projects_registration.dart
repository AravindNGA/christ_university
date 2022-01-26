import 'package:christ_university/utils/important_variables.dart';
import 'package:christ_university/utils/resuable_widgets.dart';
import 'package:christ_university/utils/shared_prefs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class StudentRegistrationForMentoringProjects extends StatefulWidget {

  final String AcademicProjectsTitle;

  const StudentRegistrationForMentoringProjects({Key? key, required this.AcademicProjectsTitle}) : super(key: key);

  @override
  _StudentRegistrationForMentoringProjectsState createState() => _StudentRegistrationForMentoringProjectsState();
}

final db = FirebaseFirestore.instance;

final _fromKey = GlobalKey<FormState>();
double sizedBox = 10;

DateTime currentDate = DateTime.now();
bool passStartDate = false, passOrgType = false;

var typeOfOrganization = ["Choose","NGO", "MSME"];
var defaultValue = "Choose";

bool passMentorName = false;
var projectRegistrationStatus = "Pending Approval";

var ostStartDateDD,
    ostStartDateMM,
    ostStartDateYY,
    userEmail,
    ostOrgName,
    orgType,
    ostOrgLocation,
    ostOrgAddress,
    ostHRName,
    ostHRPhoneNumber,
    ostHREmail;

class _StudentRegistrationForMentoringProjectsState extends State<StudentRegistrationForMentoringProjects> {

  isFormFilled(String projectTitle) {
    if (!passStartDate) {

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please enter a valid Start Date")));

    } else if(!passOrgType){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please Select Valid Organization Type")));
    }
    else if (_fromKey.currentState!.validate() && passOrgType && passStartDate) {
      //Navigator.pushNamed(context, MyRoutes.studentLanding);

      CollectionReference studentCollection =
      FirebaseFirestore.instance.collection(projectTitle);

      Map<String, dynamic> studentDocRef = {
        "ostStartDateDD":ostStartDateDD,
        "${projectTitle}StartDateMM":ostStartDateMM,
        "${projectTitle}StartDateYY":ostStartDateYY,
        "userEmail":FirebaseAuth.instance.currentUser!.email,
        "${projectTitle}OrgName":ostOrgName,
        "orgType":orgType,
        "${projectTitle}OrgLocation":ostOrgLocation,
        "${projectTitle}OrgAddress":ostOrgAddress,
        "${projectTitle}HRName":ostHRName,
        "${projectTitle}HRPhoneNumber":ostHRPhoneNumber,
        "${projectTitle}HREmail":ostHREmail,
        "projectType" : projectTitle,
        "projectRegistrationStatus" : projectRegistrationStatus,
      };

      setState(() {
        preferencesShared.setSaveAString("${widget.AcademicProjectsTitle}RegState", "Pending Approval");
      });

      DocumentReference studentDocuments = studentCollection.doc(FirebaseAuth.instance.currentUser!.email);

      studentDocuments.set(studentDocRef).whenComplete(() =>
      {
        ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Submitted Successfully"))),
        Navigator.pop(context)
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate)
      setState(() {
        currentDate = pickedDate;
        passStartDate = true;

        var newDate =
            DateFormat.yMMMMd().format(currentDate).toString().split(" ");
        ostStartDateDD = newDate[0];
        ostStartDateMM = int.parse(newDate[1].replaceFirst(",", ""));
        ostStartDateYY = int.parse(newDate[2]);
      });
  }

  @override
  Widget build(BuildContext context) {

    final String projectTitle = widget.AcademicProjectsTitle;

    return Scaffold(
      appBar: AppBar(
        title: Text("${projectTitle} Registration"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Form(
            key: _fromKey,
            child: Column(
              children: [
                SizedBox(height : 2 * sizedBox),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Provide details about your\n${widget.AcademicProjectsTitle} Organization",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold))),
                SizedBox(
                  height: sizedBox,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Enter your Organization name",
                    labelText: "Organization name",
                  ),
                  validator: (value) {
                    if (!value!.isNotEmpty) {
                      return "Enter valid Organization Name";
                    } else {
                      ostOrgName = value;
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: sizedBox,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text("Select your Organization type"),
                    ),
                    Expanded(
                      flex: 2,
                      child: DropdownButton(
                        icon: Icon(Icons.keyboard_arrow_down_rounded),
                        value: defaultValue,
                        items: typeOfOrganization.map((String? item) {
                          return DropdownMenuItem(
                              value: item, child: Text(item!));
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            defaultValue = value!;
                            if (value != "Choose") {
                              passOrgType = true;
                              orgType = defaultValue;
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: sizedBox,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Enter Organization Location",
                    labelText: "Organization Location",
                  ),
                  validator: (value) {
                    if (!value!.isNotEmpty) {
                      return "Enter valid Organization Location";
                    } else {
                      ostOrgLocation = value;
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: 2 * sizedBox,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Enter Organization Address",
                    labelText: "Organization Address",
                  ),
                  validator: (value) {
                    if (!value!.isNotEmpty) {
                      return "Enter valid Organization Address";
                    } else {
                      ostOrgAddress = value;
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: 2.5 * sizedBox,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "HR/Mentor Contact Person Information",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                      ),
                    )),
                SizedBox(
                  height: sizedBox,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Enter Name of Contact Person",
                    labelText: "Person Name",
                  ),
                  validator: (value) {
                    if (!value!.isNotEmpty) {
                      return "Enter valid Contact Person Name";
                    } else {
                      ostHRName = value;
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: sizedBox,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Enter Mail ID of Contact Person",
                    labelText: "Contact Person Mail ID",
                  ),
                  validator: (value) {
                    if (!value!.isNotEmpty && !value.contains("@")) {
                      return "Enter valid Contact Person Mail ID";
                    } else {
                      ostHREmail = value;
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: sizedBox,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Enter Mobile Number of Contact Person",
                    labelText: "Contact Person Mobile Number",
                  ),
                  validator: (value) {
                    if (!value!.isNotEmpty) {
                      return "Enter valid Contact Person Mobile Number";
                    } else if (value.length < 10 && value.length > 10) {
                      return "Mobile Number contains 10 Digits";
                    } else if (value.contains('+')) {
                      return "Enter Mobile Number without country code";
                    } else {
                      ostHRPhoneNumber = int.parse(value);
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: 2.5 * sizedBox,
                ),
                new Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Starting Date of ${widget.AcademicProjectsTitle}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 2 * sizedBox,
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
                  height: 4 * sizedBox,
                ),
                Material(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    onTap: () => isFormFilled(widget.AcademicProjectsTitle),
                    child: AnimatedContainer(
                      duration: Duration(seconds: 1),
                      width: 200,
                      height: 50,
                      alignment: Alignment.center,
                      child: Text("Submit",
                          style: TextStyle(fontSize: 17, color: Colors.white)),
                    ),
                  ),
                ),
                SizedBox(
                  height: sizedBox,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
