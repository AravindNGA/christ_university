import 'package:christ_university/utils/resuable_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddNewCourse extends StatefulWidget {

  final newCourse;
  final List title;
  final id;

  const AddNewCourse({
    Key? key,
    this.newCourse,
    this.id,
    required this.title}) : super(key: key);

  @override
  _AddNewCourseState createState() => _AddNewCourseState();
}

List headings = ["Curriculum", "Term (semester)", "Type of course", "Theory", "Course code", "Course title", "Course Acronym", "Theory Credits", "Tutorial credits", "practical credits", "total credits", "Total CIA weightabe", "Total TEE Weightage", "total Weightage", "Course domain", "Pre requisite courses", "Course owner", "Reviewer Department", "Course Reviewer", "Last date to Review", "Total Contact hours", "Total CIA marks", "Total Midterm marks", "Total TEE marks", "Total attendence marks", "Total pratical marks", "TEE Duration (hours)", "Blooms domain"];

final _fromKey1 = GlobalKey<FormState>();

class _AddNewCourseState extends State<AddNewCourse> {

  saveButton(){
    if(_fromKey1.currentState!.validate()){
      print(widget.title);

      Map<String, dynamic> data = {
        "lister" : widget.title
      };

      FirebaseFirestore.instance.collection("Books").doc(widget.id).update(data).whenComplete((){
        print("updated");
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ReUsableWidgets().textOutput("Edit Course", Alignment.centerLeft, TextAlign.left, 20, true, Colors.white),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0,0,8,0),
            child: TextButton(onPressed: () => saveButton(), child: ReUsableWidgets().textOutput("Save", Alignment.centerLeft, TextAlign.left, 16, false, Colors.white),),
          ),
        ],
      ),
      body: Form(
        key: _fromKey1,
        child: ListView.builder(
          itemCount: widget.title.length,
          itemBuilder: (BuildContext context, int index){
            return ListTile(
              title: Column(
                  children : [
                    SizedBox(height: 10,),
                    TextFormField(
                      initialValue: widget.title[index],
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter ${headings[index]}",
                        labelText: "${headings[index]}",
                      ),
                      validator: (value) {
                        if (!value!.isNotEmpty) {
                          return "Enter ${headings[index]}";
                        } else {
                          widget.title[index] = value;
                          return null;
                        }
                      },
                    ),
                  ]
              ),
            );
          },
        ),
      ),
    );
  }
}

