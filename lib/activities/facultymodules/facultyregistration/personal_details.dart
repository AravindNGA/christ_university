import 'package:christ_university/utils/important_variables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FacultyPersonalDetails extends StatefulWidget {

  const FacultyPersonalDetails({Key? key}) : super(key: key);

  @override
  _FacultyPersonalDetailsState createState() => _FacultyPersonalDetailsState();
}

/*UI Items*/

final String title = "Personal Details";

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

var bloodGroup, phoneNumber, 
    perAddressLine1, perAddressLine2, perCity, perState, perCountry, nationality,
    tempAddressLine1, tempAddressLine2, tempCity, tempState, tempCountry;
var fatherName, fatherEmail, fatherPhone, motherName, motherEmail, motherPhone;

var personalDataFilled = false;


/*STFUL Class*/
class _FacultyPersonalDetailsState extends State<FacultyPersonalDetails> {
  isFormFilled() {
    if (_fromKey.currentState!.validate() && passDownBloodGroup) {
      //Navigator.pushNamed(context, MyRoutes.studentLanding);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Submitted Successfully")));

      personalDataFilled = true;

      Map<String, dynamic> updateUserData = {
        "bloodGroup": bloodGroup,
        "phoneNumber": phoneNumber,
        "addressLine1": perAddressLine1,
        "addressLine2": perAddressLine2,
        "city": perCity,
        "state": perState,
        "country": perCountry,
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
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(18),
          child: Form(
            key: _fromKey,
            child: Column(
              children: [
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
                    border: OutlineInputBorder(),
                    hintText: "Enter Mobile Number",
                    labelText: "Mobile Number",
                  ),
                  validator: (value) {
                    if (!value!.isNotEmpty) {
                      return "Enter Mobile Number";
                    } else if (value.length != 10){
                      return "Enter Valid Mobile number without country code";
                    }else{
                      phoneNumber = int.parse(value);
                      return null;
                    }
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
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
                SizedBox(height : sizedBoxHeight),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Current Address",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold))),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter Address Line 1",
                    labelText: "Address Line 1",
                  ),
                  validator: (value) {
                    if (!value!.isNotEmpty) {
                      return "Enter Address Line 1";
                    } else {
                      tempAddressLine1 = value;
                      return null;
                    }
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter Address Line 2",
                    labelText: "Address Line 2",
                  ),
                  validator: (value) {
                    if (!value!.isNotEmpty) {
                      return "Enter Address Line 2";
                    } else {
                      tempAddressLine2 = value;
                      return null;
                    }
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter City",
                    labelText: "City",
                  ),
                  validator: (value) {
                    if (!value!.isNotEmpty) {
                      return "Enter City";
                    } else {
                      tempCity = value;
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
                      tempState = value;
                      return null;
                    }
                  },
                ),
                SizedBox(height : sizedBoxHeight),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Permanent Address",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold))),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Enter Address Line 1",
                    labelText: "Address Line 1",
                  ),
                  validator: (value) {
                    if (!value!.isNotEmpty) {
                      return "Enter Address Line 1";
                    } else {
                      perAddressLine1 = value;
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
                      perAddressLine2 = value;
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
                      perCity = value;
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
                      perState = value;
                      return null;
                    }
                  },
                ),
                SizedBox(height: 2 * sizedBoxHeight),
                /*Align(
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
                ),*/
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
