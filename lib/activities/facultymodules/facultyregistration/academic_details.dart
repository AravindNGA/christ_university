import 'package:christ_university/utils/important_variables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FacultyAcademicDetails extends StatefulWidget {

  const FacultyAcademicDetails({Key? key}) : super(key: key);

  @override
  _FacultyAcademicDetailsState createState() => _FacultyAcademicDetailsState();
}

/*UI Items*/
final _fromKey = GlobalKey<FormState>();
const sizedBoxHeight = 10.0;

var defaultDegree = 'Percentage';
var defaultUGDropdownDegree = 'Choose';
var defaultPGDropdownDegree = 'Choose';
var defaultDropDownSpec = 'Choose Specialization';


var dropDownUGDegreeCollege = false;
var dropDownPGDegreeCollege = false;
var dropDownSpec = false;

var passPercent1 = false,
    passPercent2 = false,
    passPercent3 = false,
    passDegree = false;

var percentDropDownList = [
  'Percentage',
  'CGPA',
];
var UGDegreeDropDown = [
  'Choose',
  'B.E.,',
  'BBA',
  'BCA',
  'B.Com',
  'B.Com (Hons)',
  'B.Sc.,'
];
var PGDegreeDropDown = [
  'Choose',
  'M.E.,',
  'MBA',
  'MCA',
  'M.Com',
  'M.Com (Hons)',
  'M.Sc.,'
];



var specializationDropDown = ['Choose Specialization','LOS', 'Marketing', 'Finance', 'IBM', 'BA', 'HR'];
/*Upload Items*/

var userName, userEmail;

CollectionReference studentCollection =
    FirebaseFirestore.instance.collection(ImportantVariables.studentsDatabase);

var UGCollegeName,
    UGCollegeLocation,
    UGcollegeDegree,
    UGcollegeSpec;
int UGcollegePassedOut = 0;

var PGcollegeName,
    PGcollegeLocation,
    PGcollegeDegree,
    PGcollegeSpec;
int PGcollegePassedOut = 0;

var MPhilcollegeName,
    MPhilcollegeLocation,
    MPhilcollegeSpec;
int MPhilcollegePassedOut = 0;

var PhDcollegeName,
    PhDcollegeLocation,
    PhDcollegeSpec;
int PhDcollegePassedOut = 0;

double collegePercentOrCGPA = 0.0;
var specialization;
var academicDataFilled = false;


/*STFUL Class*/
class _FacultyAcademicDetailsState extends State<FacultyAcademicDetails> {
  isFormFilled() {
    if (_fromKey.currentState!.validate()) {
      //Navigator.pushNamed(context, MyRoutes.studentLanding);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Submitted Successfully")));

      academicDataFilled = true;

      Map<String, dynamic> updateUserData = {
        "UGcollegeName": UGCollegeName,
        "UGcollegeLocation": UGCollegeLocation,
        "UGcollegeDegree": UGcollegeDegree,
        "UGcollegeSpec": UGcollegeSpec,
        "UGcollegePassedOut": UGcollegePassedOut,
        "PGcollegeName": PGcollegeName,
        "PGcollegeLocation": PGcollegeLocation,
        "PGcollegeDegree": PGcollegeDegree,
        "PGcollegeSpec": PGcollegeSpec,
        "PGcollegePassedOut": PGcollegePassedOut,
        "MPhilcollegeName": MPhilcollegeName,
        "MPhilcollegeLocation": MPhilcollegeLocation,
        "MPhilcollegeSpec": MPhilcollegeSpec,
        "MPhilcollegePassedOut": MPhilcollegePassedOut,
        "PhDcollegeName": PhDcollegeName,
        "PhDcollegeLocation": PhDcollegeLocation,
        "PhDcollegeSpec": PhDcollegeSpec,
        "PhDcollegePassedOut": PhDcollegePassedOut,
        "academicDataFilled": academicDataFilled,
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

    String title = "Education Details";

    return Scaffold(
      appBar: AppBar(
        title: Text("${title}"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Form(
            key: _fromKey,
            child: Column(
              children: [
                SizedBox(height: sizedBoxHeight),
                Column(
                  children: [

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
                        border: OutlineInputBorder(),
                        hintText: "Enter College/University Name",
                        labelText: "College/University Name",
                      ),
                      validator: (value) {
                        if (!value!.isNotEmpty) {
                          return "Enter your College/University Name";
                        } else {
                          UGCollegeName = value;
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: sizedBoxHeight),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter College/University Location",
                        labelText: "College/University Location",
                      ),
                      validator: (value) {
                        if (!value!.isNotEmpty) {
                          return "Enter your School Location";
                        } else {
                          UGCollegeLocation = value;
                          return null;
                        }
                      },
                    ),SizedBox(height: sizedBoxHeight),
                    /*Row(
                  children: [
                    Expanded(flex: 4, child: Text("Enter College Degree")),
                    SizedBox(width: sizedBoxHeight),
                    Expanded(
                      flex: 3,
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: DropdownButton(
                          icon: Icon(Icons.keyboard_arrow_down_rounded),
                          value: defaultUGDropdownDegree,
                          items: UGDegreeDropDown.map((String? item) {
                            return DropdownMenuItem(
                                value: item, child: Text(item!));
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              defaultUGDropdownDegree = value!;
                              if (value != "Choose") {
                                dropDownUGDegreeCollege = true;
                                UGcollegeDegree = defaultUGDropdownDegree;
                              }
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),*/
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter Degree Awarded",
                        labelText: "Degree Awarded",
                      ),
                      validator: (value) {
                        if (!value!.isNotEmpty) {
                          return "Enter Degree Awarded";
                        }  else {
                          UGcollegeDegree = int.parse(value);
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: sizedBoxHeight),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter Specialisation",
                        labelText: "Specialisation",
                      ),
                      validator: (value) {
                        if (!value!.isNotEmpty) {
                          return "Enter your School Location";
                        } else {
                          UGcollegeSpec = value;
                          return null;
                        }
                      },
                    ),SizedBox(height: sizedBoxHeight),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
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
                          UGcollegePassedOut = int.parse(value);
                          return null;
                        }
                      },
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(height: 2*sizedBoxHeight),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Masters Degree (PG)",
                          style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        )),
                    SizedBox(height: sizedBoxHeight),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter College/University Name",
                        labelText: "College/University Name",
                      ),
                      validator: (value) {
                        if (!value!.isNotEmpty) {
                          return "Enter your College/University Name";
                        } else {
                          PGcollegeName = value;
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: sizedBoxHeight),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter College/University Location",
                        labelText: "College/University Location",
                      ),
                      validator: (value) {
                        if (!value!.isNotEmpty) {
                          return "Enter your School Location";
                        } else {
                          PGcollegeLocation = value;
                          return null;
                        }
                      },
                    ),
                    /*Row(
                  children: [
                    Expanded(flex: 4, child: Text("Enter College Degree")),
                    SizedBox(width: sizedBoxHeight),
                    Expanded(
                      flex: 3,
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: DropdownButton(
                          icon: Icon(Icons.keyboard_arrow_down_rounded),
                          value: defaultPGDropdownDegree,
                          items: PGDegreeDropDown.map((String? item) {
                            return DropdownMenuItem(
                                value: item, child: Text(item!));
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              defaultPGDropdownDegree = value!;
                              if (value != "Choose") {
                                dropDownPGDegreeCollege = true;
                                PGcollegeDegree = defaultPGDropdownDegree;
                              }
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),*/
                    SizedBox(height: sizedBoxHeight),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter Degree Awarded",
                        labelText: "Degree Awarded",
                      ),
                      validator: (value) {
                        if (!value!.isNotEmpty) {
                          return "Enter Degree Awarded";
                        }  else {
                          UGcollegeDegree = int.parse(value);
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: sizedBoxHeight),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter Specialisation",
                        labelText: "Specialisation",
                      ),
                      validator: (value) {
                        if (!value!.isNotEmpty) {
                          return "Enter your School Location";
                        } else {
                          PGcollegeSpec = value;
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: sizedBoxHeight),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
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
                          PGcollegePassedOut = int.parse(value);
                          return null;
                        }
                      },
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(height: 2*sizedBoxHeight),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "MPhil",
                          style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        )),
                    SizedBox(height: sizedBoxHeight),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter College/University Name",
                        labelText: "College/University Name",
                      ),
                      validator: (value) {
                        if (!value!.isNotEmpty) {
                          return "Enter your College/University Name";
                        } else {
                          MPhilcollegeName = value;
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: sizedBoxHeight),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter College/University Location",
                        labelText: "College/University Location",
                      ),
                      validator: (value) {
                        if (!value!.isNotEmpty) {
                          return "Enter your School Location";
                        } else {
                          MPhilcollegeLocation = value;
                          return null;
                        }
                      },
                    ),
                    /*Row(
                  children: [
                    Expanded(flex: 4, child: Text("Enter College Degree")),
                    SizedBox(width: sizedBoxHeight),
                    Expanded(
                      flex: 3,
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: DropdownButton(
                          icon: Icon(Icons.keyboard_arrow_down_rounded),
                          value: defaultPGDropdownDegree,
                          items: PGDegreeDropDown.map((String? item) {
                            return DropdownMenuItem(
                                value: item, child: Text(item!));
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              defaultPGDropdownDegree = value!;
                              if (value != "Choose") {
                                dropDownPGDegreeCollege = true;
                                PGcollegeDegree = defaultPGDropdownDegree;
                              }
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),*/
                    SizedBox(height: sizedBoxHeight),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter Specialisation",
                        labelText: "Specialisation",
                      ),
                      validator: (value) {
                        if (!value!.isNotEmpty) {
                          return "Enter your School Location";
                        } else {
                          MPhilcollegeSpec = value;
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: sizedBoxHeight),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
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
                          MPhilcollegePassedOut = int.parse(value);
                          return null;
                        }
                      },
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(height: 2*sizedBoxHeight),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "PhD,",
                          style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        )),
                    SizedBox(height: sizedBoxHeight),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter College/University Name",
                        labelText: "College/University Name",
                      ),
                      validator: (value) {
                        if (!value!.isNotEmpty) {
                          return "Enter your College/University Name";
                        } else {
                          PhDcollegeName = value;
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: sizedBoxHeight),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter College/University Location",
                        labelText: "College/University Location",
                      ),
                      validator: (value) {
                        if (!value!.isNotEmpty) {
                          return "Enter your School Location";
                        } else {
                          PhDcollegeLocation = value;
                          return null;
                        }
                      },
                    ),
                    /*Row(
                  children: [
                    Expanded(flex: 4, child: Text("Enter College Degree")),
                    SizedBox(width: sizedBoxHeight),
                    Expanded(
                      flex: 3,
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: DropdownButton(
                          icon: Icon(Icons.keyboard_arrow_down_rounded),
                          value: defaultPGDropdownDegree,
                          items: PGDegreeDropDown.map((String? item) {
                            return DropdownMenuItem(
                                value: item, child: Text(item!));
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              defaultPGDropdownDegree = value!;
                              if (value != "Choose") {
                                dropDownPGDegreeCollege = true;
                                PGcollegeDegree = defaultPGDropdownDegree;
                              }
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),*/
                    SizedBox(height: sizedBoxHeight),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter Specialisation",
                        labelText: "Specialisation",
                      ),
                      validator: (value) {
                        if (!value!.isNotEmpty) {
                          return "Enter your School Location";
                        } else {
                          PhDcollegeSpec = value;
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: sizedBoxHeight),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
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
                          PhDcollegePassedOut = int.parse(value);
                          return null;
                        }
                      },
                    ),
                  ],
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
