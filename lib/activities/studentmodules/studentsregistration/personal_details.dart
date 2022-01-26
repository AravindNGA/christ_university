import 'package:christ_university/utils/important_variables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StudentPersonalDetails extends StatefulWidget {
  const StudentPersonalDetails({Key? key}) : super(key: key);

  @override
  _StudentPersonalDetailsState createState() => _StudentPersonalDetailsState();
}

/*UI Items*/
final _fromKey = GlobalKey<FormState>();
const sizedBoxHeight = 20.0;

var defaultDropdownBloodGroup = 'Choose Blood Group';

var passDownBloodGroup = false;

var bloodGroupDropDown = [
  'Choose Blood Group',
  'A +ve',
  'A -ve',
  'B +ve',
  'B -ve',
  'AB +ve',
  'AB -ve',
  'O +ve',
  'O -ve'
];
/*Upload Items*/

var userName, userEmail;

CollectionReference studentCollection = FirebaseFirestore.instance
    .collection(ImportantVariables.studentsDatabase);

var bloodGroup, phoneNumber, addressLine1,addressLine2, city, state, country, nationality;
var fatherName, fatherEmail, fatherPhone, motherName, motherEmail, motherPhone;

var personalDataFilled = false;


/*STFUL Class*/
class _StudentPersonalDetailsState extends State<StudentPersonalDetails> {
  isFormFilled() {
    if (_fromKey.currentState!.validate() && passDownBloodGroup) {
      //Navigator.pushNamed(context, MyRoutes.studentLanding);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Submitted Successfully")));

      personalDataFilled = true;

      Map<String, dynamic> updateUserData = {
        "bloodGroup": bloodGroup,
        "phoneNumber": phoneNumber,
        "addressLine1": addressLine1,
        "addressLine2": addressLine2,
        "city": city,
        "state": state,
        "country": country,
        "nationality": nationality,
        "personalDataFilled" : personalDataFilled
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
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Student Personal",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold))),
                Row(
                  children: [
                    Expanded(flex: 2, child: Text("Blood Group")),
                    SizedBox(width: sizedBoxHeight),
                    Expanded(
                      flex: 4,
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: DropdownButton(
                          icon: Icon(Icons.keyboard_arrow_down_rounded),
                          value: defaultDropdownBloodGroup,
                          items: bloodGroupDropDown.map((String? item) {
                            return DropdownMenuItem(
                                value: item, child: Text(item!));
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              defaultDropdownBloodGroup = value!;
                              if (value != "Choose") {
                                passDownBloodGroup = true;
                                bloodGroup = defaultDropdownBloodGroup;
                              }
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: "Enter Phone Number",
                    labelText: "Phone Number",
                  ),
                  validator: (value) {
                    if (!value!.isNotEmpty) {
                      return "Enter Phone Number";
                    } else if (value.length != 10){
                      return "Enter Valid Phone number without country code";
                    }else{
                      phoneNumber = int.parse(value);
                      return null;
                    }
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Enter Address Line 1",
                    labelText: "Address Line 1",
                  ),
                  validator: (value) {
                    if (!value!.isNotEmpty) {
                      return "Enter Address Line 1";
                    } else {
                      addressLine1 = value;
                      return null;
                    }
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Enter Address Line 2",
                    labelText: "Address Line 2",
                  ),
                  validator: (value) {
                    if (!value!.isNotEmpty) {
                      return "Enter Address Line 2";
                    } else {
                      addressLine2 = value;
                      return null;
                    }
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Enter City",
                    labelText: "City",
                  ),
                  validator: (value) {
                    if (!value!.isNotEmpty) {
                      return "Enter City";
                    } else {
                      city = value;
                      return null;
                    }
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Enter State",
                    labelText: "State",
                  ),
                  validator: (value) {
                    if (!value!.isNotEmpty) {
                      return "Enter State";
                    } else {
                      state = value;
                      return null;
                    }
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Enter Nationality",
                    labelText: "Nationality",
                  ),
                  validator: (value) {
                    if (!value!.isNotEmpty) {
                      return "Enter Nationality";
                    } else {
                      nationality = value;
                      return null;
                    }
                  },
                ),
                SizedBox(height: 2 * sizedBoxHeight),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Fathers's Details",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold))),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Enter Father's Name",
                    labelText: "Father's Name",
                  ),
                  validator: (value) {
                    if (!value!.isNotEmpty) {
                      return "Enter Father's Name";
                    }else{
                      fatherName = value;
                      return null;
                    }
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: "Enter Father's Phone Number",
                    labelText: "Father's Phone Number",
                  ),
                  validator: (value) {
                    if (!value!.isNotEmpty) {
                      return "Enter Father's Phone Number";
                    } else if (value.length != 10){
                      return "Enter Valid Phone number without country code";
                    }else{
                      fatherPhone = int.parse(value);
                      return null;
                    }
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Enter Father's Email",
                    labelText: "Father's Email",
                  ),
                  validator: (value) {
                    if (!value!.isNotEmpty) {
                      return "Enter Father's Email";
                    }else{
                      fatherEmail = value;
                      return null;
                    }
                  },
                ),
                SizedBox(height: 2 * sizedBoxHeight),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Mother's Details",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold))),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Enter Mothers's Name",
                    labelText: "Mothers's Name",
                  ),
                  validator: (value) {
                    if (!value!.isNotEmpty) {
                      return "Enter Mothers's Name";
                    }else{
                      motherName = value;
                      return null;
                    }
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: "Enter Mother's Phone Number",
                    labelText: "Mother's Phone Number",
                  ),
                  validator: (value) {
                    if (!value!.isNotEmpty) {
                      return "Enter Mother's Phone Number";
                    } else if (value.length != 10){
                      return "Enter Valid Phone number without country code";
                    }else{
                      motherPhone = int.parse(value);
                      return null;
                    }
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Enter Mother's Email",
                    labelText: "Mother's Email",
                  ),
                  validator: (value) {
                    if (!value!.isNotEmpty) {
                      return "Enter Mother's Email";
                    }else{
                      motherEmail = value;
                      return null;
                    }
                  },
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
