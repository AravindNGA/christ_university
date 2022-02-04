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


/*var bloodGroup, phoneNumber, AlternativePhoneNumber,
    perAddressLine1, perAddressLine2, perCity, perState, perCountry, perPinCode, nationality,
    tempAddressLine1, tempAddressLine2, tempCity, tempState, tempCountry, tempPinCode, fatherName, fatherEmail, fatherPhone, motherName, motherEmail, motherPhone;*/

var personalDataFilled = false;


var bloodGroup;
final phoneNumber = TextEditingController();
final AlternativePhoneNumber = TextEditingController();
final perAddressLine1 = TextEditingController();
final perAddressLine2 = TextEditingController();
final perCity = TextEditingController();
final perState = TextEditingController();
final perCountry = TextEditingController();
final perPinCode = TextEditingController();
final nationality = TextEditingController();
final tempAddressLine1 = TextEditingController();
final tempAddressLine2 = TextEditingController();
final tempCity = TextEditingController();
final tempState = TextEditingController();
final tempCountry = TextEditingController();
final tempPinCode = TextEditingController();
final fatherName = TextEditingController();
final fatherEmail = TextEditingController();
final fatherPhone = TextEditingController();
final motherName = TextEditingController();
final motherEmail = TextEditingController();
final motherPhone = TextEditingController();

final db = FirebaseFirestore.instance;

/*STFUL Class*/
class _FacultyPersonalDetailsState extends State<FacultyPersonalDetails> {

  @override
  Widget build(BuildContext context) {

    final User? user = FirebaseAuth.instance.currentUser;
    userEmail = user!.email;

    gettingUserName(userEmail);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Scaffold(
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
                    controller: phoneNumber,
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
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: sizedBoxHeight/2,),
                  TextFormField(
                    controller: AlternativePhoneNumber,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter Alternative Mobile Number",
                      labelText: "Alternative Mobile Number",
                    ),
                    validator: (value) {
                      if (!value!.isNotEmpty) {
                        return "Enter Alternative Mobile Number";
                      } else if (value.length != 10){
                        return "Enter Valid Mobile number without country code";
                      }else{
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: sizedBoxHeight/2,),
                  TextFormField(
                    controller: nationality,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter Nationality",
                      labelText: "Nationality",
                    ),
                    validator: (value) {
                      if (!value!.isNotEmpty) {
                        return "Enter Nationality";
                      } else {
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
                    controller: tempAddressLine1,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter Address Line 1",
                      labelText: "Address Line 1",
                    ),
                    validator: (value) {
                      if (!value!.isNotEmpty) {
                        return "Enter Address Line 1";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: sizedBoxHeight/2,),
                  TextFormField(
                    controller: tempAddressLine2,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter Address Line 2",
                      labelText: "Address Line 2",
                    ),
                    validator: (value) {
                      if (!value!.isNotEmpty) {
                        return "Enter Address Line 2";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: sizedBoxHeight/2,),
                  TextFormField(
                    controller: tempCity,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter City",
                      labelText: "City",
                    ),
                    validator: (value) {
                      if (!value!.isNotEmpty) {
                        return "Enter City";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: sizedBoxHeight/2,),
                  TextFormField(
                    controller: tempState,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter State",
                      labelText: "State",
                    ),
                    validator: (value) {
                      if (!value!.isNotEmpty) {
                        return "Enter State";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(height : sizedBoxHeight/2),
                  TextFormField(
                    controller: tempCountry,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter Country",
                      labelText: "Country",
                    ),
                    validator: (value) {
                      if (!value!.isNotEmpty) {
                        return "Enter Country";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(height : sizedBoxHeight/2),
                  TextFormField(
                    controller: tempPinCode,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter Pincode",
                      labelText: "Pincode",
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (!value!.isNotEmpty) {
                        return "Enter Pincode";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(height : sizedBoxHeight/2),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Permanent Address",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold))),
                  SizedBox(height : sizedBoxHeight/2),
                  TextFormField(
                    controller: perAddressLine1,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter Address Line 1",
                      labelText: "Address Line 1",
                    ),
                    validator: (value) {
                      if (!value!.isNotEmpty) {
                        return "Enter Address Line 1";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(height : sizedBoxHeight/2),
                  TextFormField(
                    controller: perAddressLine2,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter Address Line 2",
                      labelText: "Address Line 2",
                    ),
                    validator: (value) {
                      if (!value!.isNotEmpty) {
                        return "Enter Address Line 2";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(height : sizedBoxHeight/2),
                  TextFormField(
                    controller: perCity,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter City",
                      labelText: "City",
                    ),
                    validator: (value) {
                      if (!value!.isNotEmpty) {
                        return "Enter City";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(height : sizedBoxHeight/2),
                  TextFormField(
                    controller: perState,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter State",
                      labelText: "State",
                    ),
                    validator: (value) {
                      if (!value!.isNotEmpty) {
                        return "Enter State";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(height : sizedBoxHeight/2),
                  TextFormField(
                    controller: perCountry,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter Country",
                      labelText: "Country",
                    ),
                    validator: (value) {
                      if (!value!.isNotEmpty) {
                        return "Enter Country";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(height : sizedBoxHeight/2),
                  TextFormField(
                    controller: perPinCode,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter Pincode",
                      labelText: "Pincode",
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (!value!.isNotEmpty) {
                        return "Enter Pincode";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(height : sizedBoxHeight/2),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Fathers's Details",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold))),
                  SizedBox(height : sizedBoxHeight/2),
                  TextFormField(
                    controller: fatherName,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter Father's Name",
                      labelText: "Father's Name",
                    ),
                    validator: (value) {
                      if (!value!.isNotEmpty) {
                        return "Enter Father's Name";
                      }else{
                        return null;
                      }
                    },
                  ),
                  SizedBox(height : sizedBoxHeight/2),
                  TextFormField(
                    controller: fatherPhone,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter Father's Phone Number",
                      labelText: "Father's Phone Number",
                    ),
                    validator: (value) {
                      if (!value!.isNotEmpty) {
                        return "Enter Father's Phone Number";
                      } else if (value.length != 10){
                        return "Enter Valid Phone number without country code";
                      }else{
                        return null;
                      }
                    },
                  ),
                  SizedBox(height : sizedBoxHeight/2),
                  TextFormField(
                    controller: fatherEmail,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter Father's Email",
                      labelText: "Father's Email",
                    ),
                    validator: (value) {
                      if (!value!.isNotEmpty) {
                        return "Enter Father's Email";
                      }else{
                        return null;
                      }
                    },
                  ),
                  SizedBox(height : sizedBoxHeight/2),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Mother's Details",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold))),
                  SizedBox(height : sizedBoxHeight/2),
                  TextFormField(
                    controller: motherName,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter Mothers's Name",
                      labelText: "Mothers's Name",
                    ),
                    validator: (value) {
                      if (!value!.isNotEmpty) {
                        return "Enter Mothers's Name";
                      }else{
                        return null;
                      }
                    },
                  ),
                  SizedBox(height : sizedBoxHeight/2),
                  TextFormField(
                    controller: motherPhone,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter Mother's Phone Number",
                      labelText: "Mother's Phone Number",
                    ),
                    validator: (value) {
                      if (!value!.isNotEmpty) {
                        return "Enter Mother's Phone Number";
                      } else if (value.length != 10){
                        return "Enter Valid Phone number without country code";
                      }else{
                        return null;
                      }
                    },
                  ),
                  SizedBox(height : sizedBoxHeight/2),
                  TextFormField(
                    controller: motherEmail,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter Mother's Email",
                      labelText: "Mother's Email",
                    ),
                    validator: (value){
                      if (!value!.isNotEmpty) {
                        return "Enter Mother's Email";
                      }else{
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: sizedBoxHeight),
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
        )
      ),
    );
  }

  gettingUserName(String userEmail) {

    FirebaseFirestore.instance
        .collection(ImportantVariables.facultyDatabase)
        .doc(userEmail)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {

        if(documentSnapshot['personalDataFilled']){

          setState(() {
             phoneNumber.text = int.parse(documentSnapshot['phoneNumber']) as String;
             AlternativePhoneNumber.text = documentSnapshot['AlternativePhoneNumber'];
             perAddressLine1.text = "documentSnapshot['perAddressLine1']";
             perAddressLine2.text = documentSnapshot['perAddressLine2'];
             perCity.text = documentSnapshot['perCity'];
             perState.text = documentSnapshot['perState'];
             perCountry.text = documentSnapshot['perCountry'];
             perPinCode.text = documentSnapshot['perPinCode'];
             nationality.text = documentSnapshot['nationality'];
             tempAddressLine1.text = documentSnapshot['tempAddressLine1'];
             tempAddressLine2.text = documentSnapshot['tempAddressLine2'];
             tempCity.text = documentSnapshot['tempCity'];
             tempState.text = documentSnapshot['tempState'];
             tempCountry.text = documentSnapshot['tempCountry'];
             tempPinCode.text = documentSnapshot['tempPinCode'];
             fatherName.text = documentSnapshot['fatherName'];
             fatherEmail.text = documentSnapshot['fatherEmail'];
             fatherPhone.text = documentSnapshot['fatherPhone'];
             motherName.text = documentSnapshot['motherName'];
             motherEmail.text = documentSnapshot['motherEmail'];
             motherPhone.text = documentSnapshot['motherPhone'];
          });
        }

        print('Document data: ${documentSnapshot["firstName"]}');
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  isFormFilled() {
    if (_fromKey.currentState!.validate() && passDownBloodGroup) {
      //Navigator.pushNamed(context, MyRoutes.studentLanding);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Submitted Successfully")));

      personalDataFilled = true;

      Map<String, dynamic> updateUserData = {
        "phoneNumber": phoneNumber.text,
        "AlternativePhoneNumber": AlternativePhoneNumber.text,
        "tempAddressLine1":tempAddressLine1.text,
        "tempAddressLine2":tempAddressLine2.text,
        "tempCity":tempCity.text,
        "tempState":tempState.text,
        "tempCountry":tempCountry.text,
        "tempPinCode":tempPinCode.text,
        "addressLine1": perAddressLine1.text,
        "addressLine2": perAddressLine2.text,
        "city": perCity.text,
        "state": perState.text,
        "country": perCountry.text,
        "perPinCode":perPinCode.text,
        "nationality": nationality.text,
        "fatherName": fatherName.text,
        "fatherEmail": fatherEmail.text,
        "fatherPhone": fatherPhone.text,
        "motherName": motherName.text,
        "motherEmail": motherEmail.text,
        "motherPhone": motherPhone.text,
        "personalDataFilled" : personalDataFilled
      };

      DocumentReference facultyDocs = FirebaseFirestore.instance
          .collection(ImportantVariables.facultyDatabase).doc(userEmail);
      facultyDocs.set(updateUserData).whenComplete(() {
        print('Submitted');
        Navigator.pop(context);
      });
    }
  }
}

