import 'package:christ_university/utils/important_variables.dart';
import 'package:christ_university/utils/resuable_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'clubs.dart';

class ViewRegistrations extends StatefulWidget {
  final String clubName;
  const ViewRegistrations({Key? key, required this.clubName}) : super(key: key);

  @override
  _ViewRegistrationsState createState() => _ViewRegistrationsState();
}

class _ViewRegistrationsState extends State<ViewRegistrations> {

  Widget gettingFirebaseData() => StreamBuilder<QuerySnapshot>(
    stream: db.collection(ImportantVariables.clubRegistration).where("clubDetails", isEqualTo: widget.clubName).where("acceptedStatus", isEqualTo: false)
        .snapshots(),
    builder: (context, snapshot) {
      if(!snapshot.hasData){
        return Center(child: CircularProgressIndicator());
      }else{
        return Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: ListView(
            children: snapshot.data!.docs.map((documents) {
              return Container(
                height: 160,
                child : Card(
                  elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 10),
                      child: Column(
                        children: [
                          ReUsableWidgets().textOutput(
                              documents["memberName"],
                              Alignment.centerLeft,
                              TextAlign.left,
                              25,
                              true,
                              Colors.black),
                          SizedBox(
                            height: sizedBoxHeight / 2,
                          ),
                          ReUsableWidgets().textOutput(
                              documents["memberRollNumber"],
                              Alignment.centerLeft,
                              TextAlign.left,
                              14,
                              false,
                              Colors.black),
                          SizedBox(height: 20,),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: OutlinedButton(onPressed: () => registrationUpdate(false), child: Text("Decline"
                                    , style: TextStyle(color: Colors.red),)),
                              ),
                              Expanded(flex :2 ,child: SizedBox(width: 1,)),
                              Expanded(
                                flex: 2,
                                  child: OutlinedButton(onPressed: () => registrationUpdate(true), child: Text("Accept", style: TextStyle(color: Colors.green),)))
                            ],
                          )

                        ],
                      ),
                    )),
              );
            }).toList(),
          ),
        );
      }
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registrations for ${widget.clubName}"),
      ),
      body: gettingFirebaseData(),
    );
  }

  Future registrationUpdate(bool bool) async{

    User? user = FirebaseAuth.instance.currentUser;
    Map<String, dynamic> data = {"acceptedStatus" : bool};

    DocumentReference getDataFromParent = FirebaseFirestore.instance.collection(ImportantVariables.clubRegistration).doc(user!.email);
    getDataFromParent.update(data);

  }
}
