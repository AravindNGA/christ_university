import 'package:flutter/material.dart';

class Testing_UI extends StatefulWidget {
  const Testing_UI({Key? key}) : super(key: key);

  @override
  _Testing_UIState createState() => _Testing_UIState();
}

class _Testing_UIState extends State<Testing_UI> {


  @override
  Widget build(BuildContext context) {

    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    print(deviceWidth);
    print(deviceHeight);

    /*Widget titleCardsTest() {
      return Column(
        children: [
          Container(
              height: 110,
              child: GestureDetector(
                  onTap: () {
                    //Navigator.pushNamed(context, routeName);
                  },
                  child: Card(
                    elevation: 8,
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Center(
                            child: Column(children: [
                              Icon(
                                Icons.ac_unit,
                                color: Colors.white,
                                size: 30,
                              ),
                              SizedBox(height: 20),
                              Text("OOOS",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ))
                            ]))),
                    color: Colors.teal,
                  )))
        ],
      );
    }*/

    return Scaffold(
      body: SafeArea(
        child : GridView.count(
          primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(8),
              child: const Text("He'd have you all unravel at the"),
              color: Colors.teal[100],
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: const Text('Heed not the rabble'),
              color: Colors.teal[200],
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: const Text('Sound of screams but the'),
              color: Colors.teal[300],
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: const Text('Who scream'),
              color: Colors.teal[400],
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: const Text('Revolution is coming...'),
              color: Colors.teal[500],
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: const Text('Revolution, they...'),
              color: Colors.teal[600],
            ),
          ],
        )
      ),
    );

  }
}
