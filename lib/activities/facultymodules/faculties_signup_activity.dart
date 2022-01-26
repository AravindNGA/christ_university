import 'package:christ_university/utils/resuable_widgets.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:christ_university/utils/shared_prefs.dart';

import 'package:christ_university/utils/routes.dart';
import 'package:christ_university/utils/important_variables.dart';
import 'package:introduction_screen/introduction_screen.dart';

class FacultySignUpActivity extends StatefulWidget {
  const FacultySignUpActivity({Key? key}) : super(key: key);

  @override
  _FacultySignUpActivityState createState() => _FacultySignUpActivityState();
}

/*Global variables*/
final _fromKey1 = GlobalKey<FormState>();
final _fromKey2 = GlobalKey<FormState>();

const double sizedBox = 10;

/*UI items*/
DateTime dobCurrentDate = DateTime.now();
DateTime dojCurrentDate = DateTime.now();

/*Data Upload procedures*/
var userName, userEmail, displayName;

CollectionReference studentCollection =
    FirebaseFirestore.instance.collection(ImportantVariables.facultyDatabase);

var defaultGenderValue = "Choose Gender";
var dropDownList = ['Choose Gender', 'Male', 'Female'];

var defaultEmploymentType = "Choose";

var dropDownListEmploymentType = [
  'Choose',
  'Full Time Faculty',
  'Adjunct Faculty',
  'Guest Faculty '
];

var defaultSal = "Choose";

var dropDownListSal = [
  'Choose',
  'Mr.',
  'Ms.',
  'Mrs.',
  'Prof.',
  'Dr.',
];

var campusSel = [];

var defaultSpecialization = "Choose";
var defaultDepartment = "Choose";
var dropDownListDepartment = [
  'Choose',
  'BBA',
  'BBA Hons',
  'BBA (BA)',
  'BBA (DS)',
  'BBA (F & IB)',
  'BBA (FTH)',
  'BBA (T & TM)',
  'BHM',
  'MBA',
  'MBA Executive',
  'MMTM'
];

var dropDownListSpecialization = [
  'Choose',
  'Finance',
  'Human Resource',
  'Lean Operations and Systems',
  'Marketing',
  'Business Analytics',
  'Economics and Quants',
  'Stratergy and Leadership'
];

final campuses = [
  CampusCheckBoxState(title: 'Bangalore Bannerghatta road Campus'),
  CampusCheckBoxState(title: 'Bangalore Central Campus'),
  CampusCheckBoxState(title: 'Bangalore Kengeri Campus'),
  CampusCheckBoxState(title: 'Delhi NCR Campus'),
  CampusCheckBoxState(title: 'Pune Lavasa Campus'),
];

bool passGender = false,
    passDOB = false,
    passRoll = false,
    passDOJ = false,
    passFacultyType = false,
    passDepartment = false,
    passSepc = false;

var Sal,
    firstName,
    lastName,
    dobDD,
    dobMM,
    dobYYYY,
    gender,
    employmentType,
    dojDD,
    dojMM,
    dojYY,
    department,
    spec,
    registrationDone = true;
int empIDNumber = 0;

/*Stful class*/
class _FacultySignUpActivityState extends State<FacultySignUpActivity> {
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

  isFormFilled() {
    if (!passGender || !passDOB || !passDepartment || !passSepc ) {

      String gen = "Gender, ", DOB = "DOB, ",
          department = "Department, ", Spec = "Specialization.";

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Missing ${!passGender ? gen : ""}${!passDOB ? DOB : ""}"
          "${!passDepartment ? department : ""}${!passSepc ? Spec : ""}")));

    } else if (_fromKey1.currentState!.validate() && passGender && passDOB) {
      //Navigator.pushNamed(context, MyRoutes.studentLanding);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Submitted Successfully")));

      Map<String, dynamic> studentDocRef = {
        "salutation": Sal,
        "firstName": firstName,
        "lastName": lastName,
        "userEmail": userEmail,
        "empIDNumber": empIDNumber,
        "DOBDate": dobDD,
        "DOBMonth": dobMM,
        "DOBYear": dobYYYY,
        "Gender": gender,
        "registrationDone": registrationDone,
        "employmentType": employmentType,
        "dojDD": dojDD,
        "dojMM": dojMM,
        "dojYY": dojYY,
        "department" : department,
        "spec": spec,
        "campus" : campusSel,
      };


      DocumentReference studentDocuments = studentCollection.doc(userEmail);
      studentDocuments.set(studentDocRef).whenComplete(
          () => {Navigator.pushNamed(context, MyRoutes.facultyLanding)});
    }
  }

  Future<void> _DOBSelectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: dobCurrentDate,
        firstDate: DateTime(1930),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != dobCurrentDate)
      setState(() {
        dobCurrentDate = pickedDate;
        passDOB = true;

        var newDate =
            DateFormat.yMMMMd().format(dobCurrentDate).toString().split(" ");
        dobMM = newDate[0];
        dobDD = int.parse(newDate[1].replaceFirst(",", ""));
        dobYYYY = int.parse(newDate[2]);
      });
  }

  Future<void> _DOJSelectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: dojCurrentDate,
        firstDate: DateTime(1930),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != dojCurrentDate)
      setState(() {
        dojCurrentDate = pickedDate;
        passDOJ = true;

        var newDate =
            DateFormat.yMMMMd().format(dojCurrentDate).toString().split(" ");
        dojMM = newDate[0];
        dojDD = int.parse(newDate[1].replaceFirst(",", ""));
        dojYY = int.parse(newDate[2]);
      });
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    userEmail = user!.email;
    userName = user.displayName;

    var name = userName!.split(" ");
    name.removeLast();
    var displayName = name.join(" ");

    return Scaffold(
      body: SafeArea(
          child: IntroductionScreen(
        onDone: () => isFormFilled(),
        done: Text('Submit'),
        next: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Next"),
              SizedBox(width: 10),
              Icon(Icons.navigate_next),
            ],
          ),
        pages: [
          PageViewModel(
              reverse: true,
              title: "Hi, $displayName",
              body: "Lets's start with something personal\n\nyour email : ${userEmail}",
              footer: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                  key: _fromKey1,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: ReUsableWidgets().textOutput("Salutation", Alignment.centerLeft, TextAlign.left, 18, true, Colors.black),
                          ),
                          SizedBox(
                            width: sizedBox,
                          ),
                          Expanded(
                            flex: 2,
                            child: DropdownButton(
                              icon: Icon(Icons.keyboard_arrow_down_rounded),
                              value: defaultSal,
                              items: dropDownListSal.map((String? item) {
                                return DropdownMenuItem(
                                    value: item, child: Text(item!));
                              }).toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  defaultSal = value!;
                                  if (value != "Choose") {
                                    passGender = true;
                                    gender = defaultSal;
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 2* sizedBox,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              initialValue: displayName,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "Enter First Name",
                                labelText: "First Name",
                              ),
                              validator: (value) {
                                if (!value!.isNotEmpty) {
                                  return "Enter your First Name";
                                } else {
                                  firstName = value;
                                  preferencesShared.setSaveAString(
                                      ImportantVariables.userFirstNameSharPref,
                                      value);
                                  return null;
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
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
                          ),
                        ],
                      ),
                      SizedBox(height: 2*sizedBox),
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
                            child: Text(DateFormat.yMMMMd()
                                .format(dobCurrentDate)
                                .toString()),
                          ),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: () => _DOBSelectDate(context),
                              child: Text('Select date'),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: sizedBox,
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
                                  if (value != "Choose Gender") {
                                    passGender = true;
                                    gender = defaultGenderValue;
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
          ),
          PageViewModel(
              reverse: true,
              title: "Academic",
              body: "Lets's focus on your Academic profile",
              footer: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                  key: _fromKey2,
                  child: Column(
                    children: [
                      Divider(),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text("Employment Type"),
                          ),
                          Expanded(
                            flex: 3,
                            child: DropdownButton(
                              icon: Icon(Icons.keyboard_arrow_down_rounded),
                              value: defaultEmploymentType,
                              items: dropDownListEmploymentType.map((String? item) {
                                return DropdownMenuItem(
                                    value: item, child: Text(item!));
                              }).toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  defaultEmploymentType = value!;
                                  if (value != "Choose ") {
                                    passFacultyType = true;
                                    employmentType = defaultEmploymentType;
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      Align(alignment: Alignment.centerLeft,child: Text("Campus")),
                      SizedBox(
                        height: sizedBox,
                      ),
                      for (var i in campuses) CampusCheckerBox(i),
                      SizedBox(
                        height: 2 * sizedBox,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Enter EmpID Number",
                          labelText: "EmpID Number",
                        ),
                        validator: (value) {
                          if (!value!.isNotEmpty) {
                            return "Enter your EmpID Number ";
                          } else if (int.parse(value) == 0) {
                            return "Enter valid EmpID Number";
                          } else {
                            empIDNumber = int.parse(value);
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: 2 * sizedBox,
                      ),
                      Column(
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Department")),
                          Align(
                            alignment: Alignment.centerRight,
                            child: DropdownButton(
                              icon: Icon(Icons.keyboard_arrow_down_rounded),
                              value: defaultDepartment,
                              items: dropDownListDepartment.map((String? item) {
                                return DropdownMenuItem(
                                    value: item, child: Text(item!));
                              }).toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  defaultDepartment = value!;
                                  if (value != "Choose") {
                                    passDepartment = true;
                                    department = defaultDepartment;
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Specialization")),
                          Align(
                            alignment: Alignment.centerRight,
                            child: DropdownButton(
                              icon: Icon(Icons.keyboard_arrow_down_rounded),
                              value: defaultSpecialization,
                              items: dropDownListSpecialization.map((String? item) {
                                return DropdownMenuItem(
                                    value: item, child: Text(item!));
                              }).toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  defaultSpecialization = value!;
                                  if (value != "Choose ") {
                                    passSepc = true;
                                    spec = defaultSpecialization;
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
                      new Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Date of Joining",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(DateFormat.yMMMMd()
                                .format(dojCurrentDate)
                                .toString()),
                          ),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: () => _DOJSelectDate(context),
                              child: Text('Select date'),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 4 * sizedBox,
                      ),
                    ],
                  ),
                ),
              )
          ),
        ],
      )),
    );
  }

  Widget thigsn() => SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(32, 50, 32, 10),
          child: Form(
            key: _fromKey1,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text("Employment Type"),
                    ),
                    Expanded(
                      flex: 3,
                      child: DropdownButton(
                        icon: Icon(Icons.keyboard_arrow_down_rounded),
                        value: defaultEmploymentType,
                        items: dropDownListEmploymentType.map((String? item) {
                          return DropdownMenuItem(
                              value: item, child: Text(item!));
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            defaultEmploymentType = value!;
                            if (value != "Choose ") {
                              passFacultyType = true;
                              employmentType = defaultEmploymentType;
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Enter EmpID Number",
                    labelText: "EmpID Number",
                  ),
                  validator: (value) {
                    if (!value!.isNotEmpty) {
                      return "Enter your EmpID Number ";
                    } else if (int.parse(value) == 0) {
                      return "Enter valid EmpID Number";
                    } else {
                      empIDNumber = int.parse(value);
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: 2 * sizedBox,
                ),
                Column(
                  children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Specialization")),
                    Align(
                      alignment: Alignment.centerRight,
                      child: DropdownButton(
                        icon: Icon(Icons.keyboard_arrow_down_rounded),
                        value: defaultSpecialization,
                        items: dropDownListSpecialization.map((String? item) {
                          return DropdownMenuItem(
                              value: item, child: Text(item!));
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            defaultSpecialization = value!;
                            if (value != "Choose ") {
                              passSepc = true;
                              spec = defaultSpecialization;
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
                new Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Date of Joining",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(DateFormat.yMMMMd()
                          .format(dojCurrentDate)
                          .toString()),
                    ),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () => _DOJSelectDate(context),
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
                    onTap: () => isFormFilled(),
                    child: AnimatedContainer(
                      duration: Duration(seconds: 1),
                      width: 200,
                      height: 50,
                      alignment: Alignment.center,
                      child: Text("Submit",
                          style: TextStyle(fontSize: 17, color: Colors.white)),
                    ),
                  ),
                )],
            ),
          ),
        ),
      );

  onSubmit(){
    print(campusSel);
  }

  Widget CampusCheckerBox(CampusCheckBoxState checkBoxState) =>
      CheckboxListTile(
        controlAffinity: ListTileControlAffinity.platform,
        onChanged: (value) =>
            setState(() {
              checkBoxState.checkValue = value as bool;
              if(checkBoxState.checkValue){
                campusSel.add(checkBoxState.title);
                print("${checkBoxState.title} added");
              }else{
                campusSel.removeAt(campusSel.indexOf(checkBoxState.title));
                print("${checkBoxState.title} removed");
              }
            }),
        value: checkBoxState.checkValue,
        title: Text(
          checkBoxState.title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        activeColor: Colors.teal,
      );
}

class CampusCheckBoxState{
  final String title;
  bool checkValue;

  CampusCheckBoxState({
    required this.title,
    this.checkValue = false});
}