import 'package:christ_university/utils/important_variables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StudentWorkExprienceDetails extends StatefulWidget {
  const StudentWorkExprienceDetails({Key? key}) : super(key: key);

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

var companyName,companyLocation, workExp, fieldWorkExp;

var workExDataFilled = false;


/*STFUL Class*/
class _WorkExperienceDetailsState extends State<StudentWorkExprienceDetails> {
  isFormFilled() {
    if (_fromKey.currentState!.validate()) {
      //Navigator.pushNamed(context, MyRoutes.studentLanding);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Submitted Successfully")));

      workExDataFilled = true;

      Map<String, dynamic> updateUserData = {
        "companyName": companyName,
        "companyLocation": companyLocation,
        "workExp": workExp,
        "fieldWorkExp": fieldWorkExp,
        "workExDataFilled" : workExDataFilled
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
                    child: Text("Student Personal",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold))),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Enter Company Name",
                    labelText: "Company Name",
                  ),
                  validator: (value) {
                    if (!value!.isNotEmpty) {
                      return "Enter Company Name";
                    } else {
                      companyName = value;
                      return null;
                    }
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Enter Company Location",
                    labelText: "Company Location",
                  ),
                  validator: (value) {
                    if (!value!.isNotEmpty) {
                      return "Enter Company Location";
                    } else {
                      companyLocation = value;
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
                      workExp = int.parse(value);
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
                      fieldWorkExp = value;
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
