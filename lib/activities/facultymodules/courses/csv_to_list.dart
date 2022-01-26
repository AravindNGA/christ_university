import 'dart:convert';
import 'dart:io';
import 'package:christ_university/activities/facultymodules/courses/add_course.dart';
import 'package:christ_university/utils/resuable_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CsvToList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CsvToListState();
  }
}

double sizedBoxHeight = 10;

class CsvToListState extends State<CsvToList> {
  late List<List<dynamic>> employeeData;

  List<PlatformFile>? _paths;
  String? _extension = "csv";
  FileType _pickingType = FileType.custom;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Firebase.initializeApp();
    employeeData = List<List<dynamic>>.empty(growable: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: Text(
          "Courses",
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        actions: [
          TextButton.icon(
            onPressed: _openFileExplorer,
            icon: Icon(Icons.add),
            label: Text("Add CSV"),
          ),
        ],
      ),
      body: gettingFirebaseData(),
      floatingActionButton: FloatingActionButton(
        onPressed: _openFileExplorer,
        child: Icon(Icons.add),
      ),
    );
  }

  openFile(filepath) async {
    File f = new File(filepath);
    print("CSV to List");
    final input = f.openRead();
    final fields = await input
        .transform(utf8.decoder)
        .transform(new CsvToListConverter())
        .toList();
    //print(fields);

    for (var a in fields) {
      //print(a);
      if(!(a[0] == "Curriculum")){
        print(a[0]);
        Map<String, dynamic> lister = {"lister": a};
        FirebaseFirestore.instance.collection("Books").add(lister);
      }
    }
    ;

    setState(() {
      employeeData = fields;
    });
  }

  void _openFileExplorer() async {
    try {
      _paths = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowMultiple: false,
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '').split(',')
            : null,
      ))
          ?.files;
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    } catch (ex) {
      print(ex);
    }
    if (!mounted) return;
    setState(() {
      openFile(_paths![0].path);
      print(_paths);
      print("one File path ${_paths![0]}");
      print(_paths!.first.extension);
    });
  }

  Widget gettingFirebaseData() => StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("Books").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            return ListView(
              children: snapshot.data!.docs.map((documents) {
                return Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Container(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddNewCourse(
                              id: documents.id,
                              title: documents["lister"],
                              newCourse: false,
                            )));
                      },
                      child: Card(
                        elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                            child: Column(
                              children: [
                                ReUsableWidgets().textOutput(
                                    "Course Name:",
                                    Alignment.centerLeft,
                                    TextAlign.left,
                                    18,
                                    true,
                                    Colors.black),
                                ReUsableWidgets().textOutput(
                                    "${documents["lister"][0]}",
                                    Alignment.centerLeft,
                                    TextAlign.left,
                                    16,
                                    false,
                                    Colors.black),
                                SizedBox(
                                  height: sizedBoxHeight / 2,
                                ),
                                ReUsableWidgets().textOutput(
                                    "Type of the course",
                                    Alignment.centerLeft,
                                    TextAlign.left,
                                    18,
                                    true,
                                    Colors.black),
                                ReUsableWidgets().textOutput(
                                    documents["lister"][2],
                                    Alignment.centerLeft,
                                    TextAlign.left,
                                    16,
                                    false,
                                    Colors.black),
                                SizedBox(
                                  height: 2*sizedBoxHeight,
                                ),
                              ],
                            ),
                          )),
                    ),
                  ),
                );
              }).toList(),
            );
          }
        },
      );
}
