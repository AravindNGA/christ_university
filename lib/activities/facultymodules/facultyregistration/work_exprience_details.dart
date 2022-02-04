import 'package:christ_university/utils/important_variables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FacultyWorkExprienceDetails extends StatefulWidget {

  final bool newData;
  final id;
  final expType, expOrgLocation, expOrgName, expJobRole;

  const FacultyWorkExprienceDetails({Key? key,
    required this.newData, this.id, this.expType, this.expOrgLocation, this.expOrgName, this.expJobRole}) : super(key: key);

  @override
  _WorkExperienceDetailsState createState() => _WorkExperienceDetailsState();
}

/*UI Items*/
final _fromKey = GlobalKey<FormState>();
const sizedBoxHeight = 20.0;
DateTime startDate = DateTime.now();
DateTime endDate = DateTime.now();

/*Upload Items*/

var userName, userEmail;
var typeOfExpDropDownList = [
  "Choose",
  "Industry Experience",
  "Academic Experience"
];
var defaultDropDownExpValue = "Choose";
bool passExpType = false;

var expType, expOrgLocation, expOrgName, expJobRole,expInMonths, expInYears;

var workExDataFilled = false;

class _WorkExperienceDetailsState extends State<FacultyWorkExprienceDetails> {
  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    userEmail = user!.email;

    return Scaffold(
      appBar: AppBar(
        title: Text("Add Work/Academic Experience"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(18),
          child: Form(
            key: _fromKey,
            child: Column(
              children: [
                Text("Experience Type"),
                SizedBox(
                  height: 5,
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                      border: Border.all(color: Colors.black26)),
                  child: DropdownButton(
                    icon: Icon(Icons.keyboard_arrow_down_rounded),
                    value: defaultDropDownExpValue,
                    items: typeOfExpDropDownList.map((String? item) {
                      return DropdownMenuItem(value: item, child: Text(item!));
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        defaultDropDownExpValue = value!;
                        if (value != "Choose") {
                          expType = defaultDropDownExpValue;
                          passExpType = true;
                        }
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Column(
                  children: [
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Enter Organization Name",
                    labelText: "Organization Name",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (!value!.isNotEmpty) {
                      return "Enter Organization Name";
                    } else {
                      expOrgName = value;
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Enter Organization Location",
                    labelText: "Organization Location",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (!value!.isNotEmpty) {
                      return "Enter Organization Location";
                    } else {
                      expOrgLocation = value;
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Enter Job Role",
                    labelText: "Job Role",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (!value!.isNotEmpty) {
                      return "Job Role cannot be empty";
                    } else {
                      expJobRole = value;
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Text("Start date"),
                          TextButton(
                            onPressed: () => _selectDate(context, true),
                            child: Text(DateFormat.yMMMM()
                                .format(startDate)
                                .toString()),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("TO"),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Text("End date"),
                          TextButton(
                            onPressed: () => _selectDate(context, false),
                            child: Text(DateFormat.yMMMM()
                                .format(endDate)
                                .toString()),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                    onPressed: () => isFormFilled(),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Text("Submit"),
                    ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool whichDate) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: whichDate ? startDate : endDate,
        firstDate: DateTime(1930),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != startDate)
      setState(() {
        whichDate ? startDate = pickedDate : endDate = pickedDate;
      });
  }

  isFormFilled() {

    print("Form key ${_fromKey.currentState!.validate()}");

    if(startDate.year > endDate.year){
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Start date should not be "
          "greater than end date")));
    }

    else if (_fromKey.currentState!.validate()) {

      expInYears = endDate.year - startDate.year;
      expInMonths = endDate.month - startDate.month;

      workExDataFilled = true;

      Map<String, dynamic> updateUserData = {
        "expType": expType,
        "expOrgName": expOrgName,
        "expOrgLocation": expOrgLocation,
        "expJobRole": expJobRole,
        "expStartDate": startDate,
        "expEndDate": endDate,
        "expEndYear": endDate.year,
        "expInYears": expInYears,
        "expInMonths": expInMonths,
        "userID" : userEmail
      };

      //Map<String, dynamic> updateWorkExDate = {"workExData": updateUserData};


      CollectionReference facultyWorkEx = FirebaseFirestore.instance
          .collection(ImportantVariables.facultyWorkExDatabase);

      facultyWorkEx.add(updateUserData).whenComplete(() {
        print('Submitted');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Submitted Successfully")));
        Navigator.pop(context);
      });

      /*if (widget.newData){

      }else{
        DocumentReference facultyWorkEx = FirebaseFirestore.instance
            .collection(ImportantVariables.facultyWorkExDatabase).doc(widget.id);

        facultyWorkEx.update(updateWorkExDate).whenComplete(() {
          print('Updated');
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Updated Successfully")));
          Navigator.pop(context);
        });

      }*/
    }
  }
}
