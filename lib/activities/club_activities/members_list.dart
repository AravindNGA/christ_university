import 'package:christ_university/utils/important_variables.dart';
import 'package:christ_university/utils/resuable_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MembersList extends StatefulWidget {
  final String clubName;
  const MembersList({Key? key, required this.clubName}) : super(key: key);

  @override
  _MembersListState createState() => _MembersListState();
}

class _MembersListState extends State<MembersList> {

  var db = FirebaseFirestore.instance;

  Widget gettingFirebaseData() => StreamBuilder<QuerySnapshot>(
    stream: db.collection(ImportantVariables.clubRegistration).where("clubDetails", isEqualTo: widget.clubName).where("acceptedStatus", isEqualTo: true)
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
                            height: 10,
                          ),
                          ReUsableWidgets().textOutput(
                              documents["memberRollNumber"],
                              Alignment.centerLeft,
                              TextAlign.left,
                              14,
                              false,
                              Colors.black),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                  child: ReUsableWidgets().textOutput(
                                      documents["isPOC"] ? "POC" : "",
                                      Alignment.centerLeft,
                                      TextAlign.left,
                                      14,
                                      false,
                                      Colors.black),),
                              Expanded(
                                flex: 2,
                                  child: Align(
                                      alignment: Alignment.centerRight,
                                      child: OutlinedButton(onPressed: () => registrationUpdate(!documents["isPOC"]),
                                          child: documents["isPOC"] ? Text("Un make POC") : Text("Make POC"))))
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
        title: Text("Club Members"),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
          child: gettingFirebaseData(),
      ),
    );
  }

  Future registrationUpdate(bool bool) async{

    User? user = FirebaseAuth.instance.currentUser;
    Map<String, dynamic> data = {"isPOC" : bool};

    DocumentReference getDataFromParent = FirebaseFirestore.instance.collection(ImportantVariables.clubRegistration).doc(user!.email);
    getDataFromParent.update(data);

  }
}
