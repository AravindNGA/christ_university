import 'package:christ_university/activities/facultymodules/facultyregistration/academic_details.dart';
import 'package:christ_university/utils/resuable_widgets.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:intl/intl.dart';

class ActivityReporting extends StatefulWidget {
  const ActivityReporting({Key? key}) : super(key: key);

  @override
  _ActivityReportingState createState() => _ActivityReportingState();
}

List<String> names = [];
var initialValue = "", personName;

final reports = [
  "Academic Training",
  "Activity Report",
  "Alumni Report",
  "Best Practices Innovation",
  "Corporate Interface",
  "External Fest",
  "Research Colloquium",
  "Social Out reach"
];

var departmentChosen, specializationChosen;

var Department = [
  "Choose Program",
  "BBA",
  "BBA Honors",
  "	BBA (BA)",
  "	BBA (DS)",
  "	BBA (F & IB)"
      "BBA (FTH)",
  "BBA (T & TM)",
  "BHM",
  "MBA",
  "MBA Executive",
  "MTTM",
  "PhD"
];

var defaultDropDownDepartment = "Choose Program";

var defaultDropDownSpecialization = "Choose Specialization";

var specialization = [
  "Choose Specialization",
  "Business Analytics",
  "Economics and Quantitative Techniques",
  "Finance",
  "Human Resources",
  "Lean Operations and Systems",
  "Marketing",
  "Strategy & Leadership"
];

final campuses = [
  CampusCheckBoxState(title: 'Bangalore Bannerghatta road Campus'),
  CampusCheckBoxState(title: 'Bangalore Central Campus'),
  CampusCheckBoxState(title: 'Bangalore Kengeri Campus'),
  CampusCheckBoxState(title: 'Delhi NCR Campus'),
  CampusCheckBoxState(title: 'Pune Lavasa Campus'),
];

final fieldText = TextEditingController();
final summaryFieldText = TextEditingController();

void clearText() {
  fieldText.clear();
}

DateTime startDate = DateTime.now();
DateTime endDate = DateTime.now();

String summary = "";

int _value = 0;



class _ActivityReportingState extends State<ActivityReporting> {

  onSubmit(){

    print(campusSel);
  }

  var campusSel = [];

  Widget CampusCheckerBox(CampusCheckBoxState checkBoxState) =>
      CheckboxListTile(
        controlAffinity: ListTileControlAffinity.platform,
        onChanged: (value) =>
            setState(() {
              checkBoxState.checkValue = value as bool;
              if(checkBoxState.checkValue){
                campusSel.add(checkBoxState.title);
                print("${checkBoxState.title} added");
              }else{
                campusSel.removeAt(campusSel.indexOf(checkBoxState.title));
                print("${checkBoxState.title} removed");
              }
            }),
        value: checkBoxState.checkValue,
        title: Text(
          checkBoxState.title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        activeColor: Colors.teal,
      );

  Widget CardRadioButtons(int cardValue, String reportTitle) => Card(
    child: Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Radio(
              value: cardValue,
              groupValue: _value,
              onChanged: (value) {
                setState(() {
                  _value = cardValue;
                  ;
                });
              }),
          SizedBox(width: sizedBoxHeight),
          Text(reportTitle)
        ],
      ),
    ),
  );

  Future<void> _selectDate(BuildContext context, bool dateStart) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: dateStart ? startDate : endDate,
        firstDate: DateTime(1930),
        lastDate: DateTime(2050));
    if (pickedDate != null)
      setState(() {
        if (dateStart) {
          startDate = pickedDate;
        } else {
          endDate = pickedDate;
        }

        //passDOB = true;

        /*var newDate = DateFormat.yMMMMd().format(currentDate).toString().split(" ");
        dobMM = newDate[0];
        dobDD = int.parse(newDate[1].replaceFirst(",", ""));
        dobYYYY = int.parse(newDate[2]);*/
      });
  }

  Widget ConditionBasedActivityReport(int value){
    if(value == 0){
      return Text(reports[0]);
    }else if(value == reports[1]){

      return Text(reports[1]);

    }
    return Text(reports[value]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: IntroductionScreen(
        done: Row(
          children: [
            Text("Submit"),
            SizedBox(width: 10),
            Icon(Icons.done)
          ],
        ),
        onDone: () {
          onSubmit();
        },
        next: Row(
          children: [
            Text("Next"),
            SizedBox(width: 10),
            Icon(Icons.navigate_next),
          ],
        ),
        nextFlex: 0,
        skipFlex: 0,
        pages: [
          PageViewModel(
              reverse: true,
              title: 'Type of your Report',
              body:
                  'Select the report you want to fill and \nnclick on the next button',
              footer: Column(
                children: [
                  Divider(),
                  for (var i in reports) CardRadioButtons(reports.indexOf(i), i)
                ],
              )
          ),
          PageViewModel(
              title: 'Select Campus',
              body: 'Click on the campus names \nfor all that apply',
              footer: Column(
                children: [
                  Divider(),
                  for (var i in campuses) CampusCheckerBox(i)
                ],
              )),
          PageViewModel(
            title: 'Department & Specialization',
            body:
                'Select Your Department & Specialization from the dropdown boxes',
            footer: Column(
              children: [
                Divider(),
                ReUsableWidgets().textOutput("Select Your Program",
                    Alignment.centerLeft, TextAlign.left, 18, true, Colors.black),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: DropdownButton(
                    icon: Icon(Icons.keyboard_arrow_down_rounded),
                    value: defaultDropDownDepartment,
                    items: Department.map((String? item) {
                      return DropdownMenuItem(value: item, child: Text(item!));
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        defaultDropDownDepartment = value!;
                        if (value != defaultDropDownDepartment) {
                          departmentChosen = defaultDropDownDepartment;
                          print(_value);
                        }
                      });
                    },
                  ),
                ),
                SizedBox(height: 20),
                ReUsableWidgets().textOutput("Select Your Specialization",
                    Alignment.centerLeft, TextAlign.left, 18, true, Colors.black),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: DropdownButton(
                    icon: Icon(Icons.keyboard_arrow_down_rounded),
                    value: defaultDropDownSpecialization,
                    items: specialization.map((String? item) {
                      return DropdownMenuItem(value: item, child: Text(item!));
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        defaultDropDownSpecialization = value!;
                        if (value != "Choose") {
                          specializationChosen = defaultDropDownSpecialization;
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          PageViewModel(
              title: 'About Activity',
              body: 'Enter details about the activity',
              footer: Column(
                children: [
                  Divider(),

                  TextFormField(
                    controller: fieldText,
                    decoration: InputDecoration(
                      hintText: "Enter Event Name/Topic",
                      labelText: "Name/Topic of the Event",
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ReUsableWidgets().textOutput("Start Date",
                      Alignment.centerLeft, TextAlign.left, 18, true, Colors.black),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                            DateFormat.yMMMMd().format(startDate).toString()),
                      ),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () => _selectDate(context, true),
                          child: Text('Select Start date'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ReUsableWidgets().textOutput("End Date", Alignment.centerLeft,
                      TextAlign.left, 18, true, Colors.black),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                            DateFormat.yMMMMd().format(endDate).toString()),
                      ),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () => _selectDate(context, false),
                          child: Text('Select End date'),
                        ),
                      ),
                    ],
                  ),
                  TextFormField(
                    controller: fieldText,
                    decoration: InputDecoration(
                      hintText: "Enter Organization Name",
                      labelText: "Institutes Partnered with (If any)",
                    ),
                  ),
                ],
              )),
          PageViewModel(
              title: 'Faculty In charge',
              body: 'Enter details faculty who were involved in organizing and staffing the event',
              footer: Column(
                children: [
                  Divider(),
                  ReUsableWidgets().textOutput("Name of the Faculty",
                      Alignment.centerLeft, TextAlign.left, 18, true, Colors.black),
                  TextFormField(
                    controller: fieldText,
                    decoration: InputDecoration(
                      hintText: "Enter Faculty Name",
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        if (fieldText.text.isNotEmpty) {
                          names.add(fieldText.text);
                          clearText();
                          setState(() {
                            for (var i in names) Text('$i');
                            print(names);
                          });
                        }
                      },
                      child: Padding(
                          padding: EdgeInsets.all(10), child: Text('Add')),
                    ),
                  ),
                ],
              )),
          PageViewModel(
              title: 'Resource Person/ Consultant',
              body: 'Enter details Resource Person/ Consultant who were involved during the event',
              footer: Column(
                children: [
                  Divider(),
                  ReUsableWidgets().textOutput("Name of the Faculty",
                      Alignment.centerLeft, TextAlign.left, 18, true, Colors.black),
                  TextFormField(
                    controller: fieldText,
                    decoration: InputDecoration(
                      hintText: "Enter Faculty Name",
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        if (fieldText.text.isNotEmpty) {
                          names.add(fieldText.text);
                          clearText();
                          setState(() {
                            for (var i in names) Text('$i');
                            print(names);
                          });
                        }
                      },
                      child: Padding(
                          padding: EdgeInsets.all(10), child: Text('Add')),
                    ),
                  ),
                ],
              )),
          PageViewModel(
              title: 'About the Event',
              body: 'A brief summary of the event \n(In less than 600 words)',
              footer: Column(
                children: [
                  Divider(),
                  ReUsableWidgets().textOutput("Name/Topic of the Event",
                      Alignment.centerLeft, TextAlign.left, 18, true, Colors.black),
                  TextFormField(
                    maxLines: 15,
                    decoration: InputDecoration(
                      hintText: "Summary on the event",
                      counter : Text("${summary.length.toString()}/600"),
                    ),
                    onChanged: (value){
                      setState(() {
                        summary = value;
                      });
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              )),
        ],
      )),
    );
  }
}

class CampusCheckBoxState{
  final String title;
  bool checkValue;

  CampusCheckBoxState({
    required this.title,
    this.checkValue = false});

}