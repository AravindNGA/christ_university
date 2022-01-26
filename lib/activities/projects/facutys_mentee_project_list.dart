import 'package:christ_university/utils/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:christ_university/utils/resuable_widgets.dart';

class MenteesProjectData extends StatefulWidget {

  final String projectType;

  const MenteesProjectData({Key? key, required this.projectType}) : super(key: key);

  @override
  _MenteesProjectDataState createState() => _MenteesProjectDataState();
}


class _MenteesProjectDataState extends State<MenteesProjectData> {

  @override
  Widget build(BuildContext context) {

    String type = widget.projectType;

    return Scaffold(
      appBar: AppBar(
        title : Text("${type} Registration"),
      ),
    );
  }
}
