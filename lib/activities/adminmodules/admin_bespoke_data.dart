import 'package:flutter/material.dart';

class AdminBespokeData extends StatefulWidget {

  final String dataRequest;

  const AdminBespokeData({Key? key, required this.dataRequest})
      : super(key: key);

  @override
  _AdminBespokeDataState createState() => _AdminBespokeDataState();

}

var names = ['this1','this2','this3','this4','this5','this6','this7'];

class _AdminBespokeDataState extends State<AdminBespokeData> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title : Text(widget.dataRequest)
      ),
      body: ListView.builder(
          itemBuilder: (context, position){
            return Card(
              child : Padding(padding : EdgeInsets.all(20), child: Text(names[position]))
            );
          }, itemCount: names.length,
      ),
    );
  }
}
