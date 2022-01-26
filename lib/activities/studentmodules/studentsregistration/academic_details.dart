import 'package:christ_university/utils/important_variables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StudentAcademicDetails extends StatefulWidget {
  const StudentAcademicDetails({Key? key}) : super(key: key);

  @override
  _StudentAcademicDetailsState createState() => _StudentAcademicDetailsState();
}

/*UI Items*/
final _fromKey = GlobalKey<FormState>();
const sizedBoxHeight = 20.0;
var defaultPercentValueSchool10 = 'Percentage';
var defaultPercentValueSchool12 = 'Percentage';
var defaultDegree = 'Percentage';
var defaultDropdownDegree = 'Choose';
var defaultDropDownSpec = 'Choose Specialization';

var dropDownPercentSchool10 = false;
var dropDownPercentSchool12 = false;
var dropDownPercentCollege = false;
var dropDownDegree = false;
var dropDownSpec = false;

var passPercent1 = false,
    passPercent2 = false,
    passPercent3 = false,
    passDegree = false;

var percentDropDownList = [
  'Percentage',
  'CGPA',
];
var degreeDropDown = [
  'Choose',
  'B.E.,',
  'BBA',
  'BCA',
  'B.Com',
  'B.Com (Hons)',
  'B.Sc.,'
];

var specializationDropDown = ['Choose Specialization','LOS', 'Marketing', 'Finance', 'IBM', 'BA', 'HR'];
/*Upload Items*/

var userName, userEmail;

CollectionReference studentCollection =
    FirebaseFirestore.instance.collection(ImportantVariables.studentsDatabase);

var schoolName10, schoolLocation10, schoolPercentType10;
int schoolPassedOut10 = 0;
double schoolPercent10 = 0.0;
var schoolName12, schoolLocation12, schoolPercentType12;
int schoolPassedOut12 = 0;
double schoolPercent12 = 0.0;
var collegeName,
    collegeLocation,
    collegeDegree,
    collegeSpec,
    collegePercentType;
int collegePassedOut = 0;
double collegePercentOrCGPA = 0.0;
var specialization;
var academicDataFilled = false;


/*STFUL Class*/
class _StudentAcademicDetailsState extends State<StudentAcademicDetails> {
  isFormFilled() {
    if (_fromKey.currentState!.validate()) {
      //Navigator.pushNamed(context, MyRoutes.studentLanding);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Submitted Successfully")));

      academicDataFilled = true;

      Map<String, dynamic> updateUserData = {
        "specialization":specialization,
        "schoolName10": schoolName10,
        "schoolLocation10": schoolLocation10,
        "schoolPassedOut10": schoolPassedOut10,
        "schoolPercent10": schoolPercent10,
        "schoolPercentType10": schoolPercentType10,
        "schoolName12": schoolName12,
        "schoolLocation12": schoolLocation12,
        "schoolPassedOut12": schoolPassedOut12,
        "schoolPercent12": schoolPercent12,
        "schoolPercentType12": schoolPercentType12,
        "collegeName": collegeName,
        "collegeLocation": collegeLocation,
        "collegeDegree": collegeDegree,
        "collegeSpec": collegeSpec,
        "collegePassedOut": collegePassedOut,
        "collegePercentOrCGPA": collegePercentOrCGPA,
        "collegePercentType": collegePercentType,
        "acadamicDataFilled": academicDataFilled
      };

      DocumentReference studentDocuments = studentCollection.doc(userEmail);
      studentDocuments.update(updateUserData).whenComplete(() {
        print('Submitted');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    userEmail = user!.email;

    return Scaffold(
      appBar: AppBar(
        title: Text("Academic Details"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(18),
          child: Form(
            key: _fromKey,
            child: Column(
              children: [
                SizedBox(height: sizedBoxHeight),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text("10th Standard",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold))),
                SizedBox(height: sizedBoxHeight),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Enter School Name",
                    labelText: "School Name",
                  ),
                  validator: (value) {
                    if (!value!.isNotEmpty) {
                      return "Enter your School Name";
                    } else {
                      schoolName10 = value;
                      return null;
                    }
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Enter School Location",
                    labelText: "School Location",
                  ),
                  validator: (value) {
                    if (!value!.isNotEmpty) {
                      return "Enter your School Location";
                    } else {
                      schoolLocation10 = value;
                      return null;
                    }
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Enter Passing out year",
                    labelText: "Finished on",
                  ),
                  validator: (value) {
                    if (!value!.isNotEmpty) {
                      return "Enter passed out year";
                    } else if (value.length != 4 &&
                        int.parse(value) > 2050 &&
                        int.parse(value) <= 1950) {
                      return "Enter a valid year";
                    } else {
                      schoolPassedOut10 = int.parse(value);
                      return null;
                    }
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Enter Percentage",
                          labelText: "Percentage / CGPA",
                        ),
                        validator: (value) {
                          if (!value!.isNotEmpty) {
                            return "Enter Percentage / CGPA";
                          } else if (int.parse(value) > 100 ||
                              int.parse(value) <= 0) {
                            return "Enter valid Number";
                          } else {
                            schoolPercent10 = double.parse(value);
                            return null;
                          }
                        },
                      ),
                    ),
                    SizedBox(width: sizedBoxHeight),
                    Expanded(
                      flex: 3,
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: DropdownButton(
                          icon: Icon(Icons.keyboard_arrow_down_rounded),
                          value: defaultPercentValueSchool10,
                          items: percentDropDownList.map((String? item) {
                            return DropdownMenuItem(
                                value: item, child: Text(item!));
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              defaultPercentValueSchool10 = value!;
                              schoolPercentType10 = defaultPercentValueSchool10;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2 * sizedBoxHeight),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text("12th Standard",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold))),
                SizedBox(height: sizedBoxHeight),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Enter School Name",
                    labelText: "School Name",
                  ),
                  validator: (value) {
                    if (!value!.isNotEmpty) {
                      return "Enter your School Name";
                    } else {
                      schoolName12 = value;
                      return null;
                    }
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Enter School Location",
                    labelText: "School Location",
                  ),
                  validator: (value) {
                    if (!value!.isNotEmpty) {
                      return "Enter your School Location";
                    } else {
                      schoolLocation12 = value;
                      return null;
                    }
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Enter Passing out year",
                    labelText: "Finished on",
                  ),
                  validator: (value) {
                    if (!value!.isNotEmpty) {
                      return "Enter passed out year";
                    } else if (value.length != 4 &&
                        int.parse(value) > 2050 &&
                        int.parse(value) <= 1950) {
                      return "Enter a valid year";
                    } else {
                      schoolPassedOut12 = int.parse(value);
                      return null;
                    }
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Enter Percentage",
                          labelText: "Percentage / CGPA",
                        ),
                        validator: (value) {
                          if (!value!.isNotEmpty) {
                            return "Enter your First Name";
                          } else if (int.parse(value) > 100 ||
                              int.parse(value) <= 0) {
                            return "Enter valid Number";
                          } else {
                            schoolPercent12 = double.parse(value);
                            return null;
                          }
                        },
                      ),
                    ),
                    SizedBox(width: sizedBoxHeight),
                    Expanded(
                      flex: 3,
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: DropdownButton(
                          icon: Icon(Icons.keyboard_arrow_down_rounded),
                          value: defaultPercentValueSchool12,
                          items: percentDropDownList.map((String? item) {
                            return DropdownMenuItem(
                                value: item, child: Text(item!));
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              defaultPercentValueSchool12 = value!;
                              schoolPercentType12 = defaultPercentValueSchool12;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2 * sizedBoxHeight),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Bachelors Degree (UG)",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    )),
                SizedBox(height: sizedBoxHeight),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Enter College/University Name",
                    labelText: "College/University Name",
                  ),
                  validator: (value) {
                    if (!value!.isNotEmpty) {
                      return "Enter your College/University Name";
                    } else {
                      collegeName = value;
                      return null;
                    }
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Enter College/University Location",
                    labelText: "College/University Location",
                  ),
                  validator: (value) {
                    if (!value!.isNotEmpty) {
                      return "Enter your School Location";
                    } else {
                      collegeLocation = value;
                      return null;
                    }
                  },
                ),
                Row(
                  children: [
                    Expanded(flex: 4, child: Text("Enter College Degree")),
                    SizedBox(width: sizedBoxHeight),
                    Expanded(
                      flex: 3,
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: DropdownButton(
                          icon: Icon(Icons.keyboard_arrow_down_rounded),
                          value: defaultDropdownDegree,
                          items: degreeDropDown.map((String? item) {
                            return DropdownMenuItem(
                                value: item, child: Text(item!));
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              defaultDropdownDegree = value!;
                              if (value != "Choose") {
                                dropDownPercentCollege = true;
                                collegeDegree = defaultDropdownDegree;
                              }
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Enter Specialisation",
                    labelText: "Specialisation",
                  ),
                  validator: (value) {
                    if (!value!.isNotEmpty) {
                      return "Enter your School Location";
                    } else {
                      collegeSpec = value;
                      return null;
                    }
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Enter Passing out year",
                    labelText: "Finished on",
                  ),
                  validator: (value) {
                    if (!value!.isNotEmpty) {
                      return "Enter passed out year";
                    } else if (value.length != 4 &&
                        int.parse(value) > 2050 &&
                        int.parse(value) <= 1950) {
                      return "Enter a valid year";
                    } else {
                      collegePassedOut = int.parse(value);
                      return null;
                    }
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Enter Percentage",
                          labelText: "Percentage / CGPA",
                        ),
                        validator: (value) {
                          if (!value!.isNotEmpty) {
                            return "Enter your First Name";
                          } else if (int.parse(value) > 100 ||
                              int.parse(value) <= 0) {
                            return "Enter valid Number";
                          } else {
                            collegePercentOrCGPA = double.parse(value);
                            return null;
                          }
                        },
                      ),
                    ),
                    SizedBox(width: sizedBoxHeight),
                    Expanded(
                      flex: 3,
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: DropdownButton(
                          icon: Icon(Icons.keyboard_arrow_down_rounded),
                          value: defaultDegree,
                          items: percentDropDownList.map((String? item) {
                            return DropdownMenuItem(
                                value: item, child: Text(item!));
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              defaultDegree = value!;
                              passDegree = true;
                              collegePercentType = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: sizedBoxHeight),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "MBA",
                      style:
                      TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    )),
                SizedBox(height: sizedBoxHeight),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: DropdownButton(
                    icon: Icon(Icons.keyboard_arrow_down_rounded),
                    value: defaultDropDownSpec,
                    items: specializationDropDown.map((String? item) {
                      return DropdownMenuItem(
                          value: item, child: Text(item!));
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        defaultDropDownSpec = value!;
                        if (value != "Choose") {
                          dropDownSpec = true;
                          specialization = defaultDropDownSpec;
                        }
                      });
                    },
                  ),
                ),
                SizedBox(height: 3 * sizedBoxHeight),
                Align(
                  alignment: Alignment.centerRight,
                  child: Material(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(6),
                    child: InkWell(
                      onTap: () => isFormFilled(),
                      child: AnimatedContainer(
                        duration: Duration(seconds: 1),
                        width: 200,
                        height: 45,
                        alignment: Alignment.center,
                        child: Text("Submit",
                            style:
                                TextStyle(fontSize: 17, color: Colors.white)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
