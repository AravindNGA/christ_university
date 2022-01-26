import 'package:christ_university/utils/important_variables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FacultyWorkExprienceDetails extends StatefulWidget {
  const FacultyWorkExprienceDetails({Key? key}) : super(key: key);

  @override
  _WorkExperienceDetailsState createState() => _WorkExperienceDetailsState();
}

/*UI Items*/
final _fromKey = GlobalKey<FormState>();
const sizedBoxHeight = 20.0;

/*Upload Items*/

var userName, userEmail;

CollectionReference studentCollection = FirebaseFirestore.instance
    .collection(ImportantVariables.studentsDatabase);

var IndorganizationalName,IndorganizationLocation, IndworkExp, IndfieldWorkExp;
var EduorganizationalName,EduorganizationLocation, EduworkExp, EdufieldWorkExp;

var workExDataFilled = false;


/*STFUL Class*/
class _WorkExperienceDetailsState extends State<FacultyWorkExprienceDetails> {
  isFormFilled() {
    if (_fromKey.currentState!.validate()) {
      //Navigator.pushNamed(context, MyRoutes.studentLanding);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Submitted Successfully")));

      workExDataFilled = true;

      Map<String, dynamic> updateUserData = {
        "IndcompanyName": IndorganizationalName,
        "IndcompanyLocation": IndorganizationLocation,
        "IndworkExp": IndworkExp,
        "IndfieldWorkExp": IndfieldWorkExp,
        "EducompanyName": EduorganizationalName,
        "EducompanyLocation": EduorganizationLocation,
        "EduworkExp": EduworkExp,
        "EdufieldWorkExp": EdufieldWorkExp,
        "EduworkExDataFilled" : workExDataFilled
      };

      DocumentReference studentDocuments = studentCollection.doc(userEmail);
      studentDocuments.update(updateUserData).whenComplete(() {
        print('Submitted');
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final User? user = FirebaseAuth.instance.currentUser;
    userEmail = user!.email;

    return Scaffold(
      appBar: AppBar(
        title: Text("Work Experience Details"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(18),
          child: Form(
            key: _fromKey,
            child: Column(
              children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Industry Experience",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold))),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Enter Organization Name",
                    labelText: "Organization Name",
                  ),
                  validator: (value) {
                    if (!value!.isNotEmpty) {
                      return "Enter Organization Name";
                    } else {
                      IndorganizationalName = value;
                      return null;
                    }
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Enter Organization Location",
                    labelText: "Organization Location",
                  ),
                  validator: (value) {
                    if (!value!.isNotEmpty) {
                      return "Enter Organization Location";
                    } else {
                      IndorganizationLocation = value;
                      return null;
                    }
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Enter Work Experience",
                    labelText: "Work Experience (in Months)",
                  ),
                  validator: (value) {
                    if (!value!.isNotEmpty) {
                      return "Enter Work Experience";
                    } else {
                      IndworkExp = int.parse(value);
                      return null;
                    }
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Enter Field of Experience",
                    labelText: "Field of Experience",
                  ),
                  validator: (value) {
                    if (!value!.isNotEmpty) {
                      return "Enter Field of Experience";
                    } else {
                      IndfieldWorkExp = value;
                      return null;
                    }
                  },
                ),
                SizedBox(height : sizedBoxHeight),

                Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Teaching Experience",textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold))),
                SizedBox(height : sizedBoxHeight/2),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Prior to joining Christ University",textAlign: TextAlign.left,
                        )),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Enter Organization Name",
                    labelText: "Organization Name",
                  ),
                  validator: (value) {
                    if (!value!.isNotEmpty) {
                      return "Enter Organization Name";
                    } else {
                      EduorganizationalName = value;
                      return null;
                    }
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Enter Organization Location",
                    labelText: "Organization Location",
                  ),
                  validator: (value) {
                    if (!value!.isNotEmpty) {
                      return "Enter Organization Location";
                    } else {
                      EduorganizationLocation = value;
                      return null;
                    }
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Enter Work Experience",
                    labelText: "Work Experience (in Months)",
                  ),
                  validator: (value) {
                    if (!value!.isNotEmpty) {
                      return "Enter Work Experience";
                    } else {
                      EduworkExp = int.parse(value);
                      return null;
                    }
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Enter Field of Experience",
                    labelText: "Field of Experience",
                  ),
                  validator: (value) {
                    if (!value!.isNotEmpty) {
                      return "Enter Field of Experience";
                    } else {
                      EdufieldWorkExp = value;
                      return null;
                    }
                  },
                ),

                SizedBox(height: 3*sizedBoxHeight),
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
