import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FacultyPublicationData extends StatefulWidget {
  const FacultyPublicationData({Key? key}) : super(key: key);

  @override
  _FacultyPublicationDataState createState() => _FacultyPublicationDataState();
}

var researchJournal, TitleOfThePaper;

DateTime dopCurrentDate = DateTime.now();

var dopMM, dopDD, dopYYYY;

var passDOB = false;

final _fromKey = GlobalKey<FormState>();
const sizedBoxHeight = 20.0;

class _FacultyPublicationDataState extends State<FacultyPublicationData> {


  Future<void> _DOBSelectDate(BuildContext context) async {

    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: dopCurrentDate,
        firstDate: DateTime(1930),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != dopCurrentDate)
      setState(() {
        dopCurrentDate = pickedDate;
        passDOB = true;

        var newDate = DateFormat.yMMMMd().format(dopCurrentDate).toString().split(" ");
        dopMM = newDate[0];
        dopDD = int.parse(newDate[1].replaceFirst(",", ""));
        dopYYYY = int.parse(newDate[2]);
      });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Publication Details"),
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
                      child: Text("Research Journal",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold))),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "Enter Research Journal",
                      labelText: "Research Journal Name",
                    ),
                    validator: (value) {
                      if (!value!.isNotEmpty) {
                        return "Enter Organization Name";
                      } else {
                        researchJournal = value;
                        return null;
                      }
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "Enter Title of the paper",
                      labelText: "Title of the paper",
                    ),
                    validator: (value) {
                      if (!value!.isNotEmpty) {
                        return "Enter Organization Location";
                      } else {
                        TitleOfThePaper = value;
                        return null;
                      }
                    },
                  ),
                  SizedBox(height : sizedBoxHeight),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                            DateFormat.yMMMMd().format(dopCurrentDate).toString()),
                      ),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () => _DOBSelectDate(context),
                          child: Text('Select date'),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height : sizedBoxHeight),
                  
                  Align(
                    alignment: Alignment.centerRight,
                    child: Material(
                      elevation: 2,
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(6),
                      child: InkWell(
                        onTap: () => add(),
                        child: AnimatedContainer(
                          duration: Duration(seconds: 1),
                          height: 45,
                          alignment: Alignment.center,
                          child: Text("Add",
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
    );
  }

  add() {

  }
}
