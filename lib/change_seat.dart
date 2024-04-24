import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_session/flutter_session.dart';
import 'dart:convert';
import 'package:rflutter_alert/rflutter_alert.dart';

class ChangeSeat extends StatefulWidget {
  @override
  _ChangeSeatState createState() => _ChangeSeatState();
}

class _ChangeSeatState extends State<ChangeSeat> {
  int uId;
  String uFirstName;
  String uLastName;
  String tableId;
  String restoId;
  String outletId;
  List<String> type = [];
  String _newTable = '';
  int _buttonState = 0;

  Widget setUpButtonChild() {
    if (_buttonState == 0) {
      return Text("CHANGE SEAT",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold));
    } else if (_buttonState == 1) {
      return Container(
        height: 17.0,
        width: 15.0,
        child: CircularProgressIndicator(
          strokeWidth: 3.0,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    } else {
      return Icon(Icons.error_outline, color: Colors.white);
    }
  }

  _openPopup(context, String msg) async {
    await Alert(
      context: context,
      title: "Seat change status",
      content: Column(
        children: [
          Text(
            msg,
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
      buttons: [
        DialogButton(
            color: Color(0xFFf45123),
            child: Text("OKAY", style: TextStyle(color: Colors.white)),
            onPressed: () {
              Navigator.pop(context);
            })
      ],
    ).show();
  }

  Future<dynamic> changeTable(String oldTable, String newTable) async {
    //print(uId);
    try {
      final response = await http.post(
          "https://www.sigmancomp.com/PHPRest/api/menu/changeSeat.php",
          body: {
            "oldTable": oldTable,
            "newTable": newTable,
            'rId': restoId.toString(),
            'oId': outletId.toString(),
            'uId': uId.toString(),
          });
      if (response.statusCode == 200) {
        setState(() {
          _buttonState = 0;
        });
        if (response.body == 'true') {
          await _openPopup(context, "Seat changed");
          Navigator.pop(context);
        } else {
          _openPopup(context, "Seat change failed");
        }
      } else {
        setState(() {
          _buttonState = 0;
        });
        _openPopup(context, "Seat change failed");
      }
    } catch (e) {
      setState(() {
        _buttonState = 0;
      });
      _openPopup(context, "Seat change failed");
    }
  }

  /*Future _showAlert(BuildContext context, String message) async {
    return showDialog(
        context: context,
        child: new AlertDialog(
          title: new Text(message),
          actions: <Widget>[
            new FlatButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Okay'),
            )
            //onPressed: () => Navigator.of(context, rootNavigator: true).pop(), child: Text('Okay'))
          ],
        ));
  }*/

  Future getFreeTable() async {
    final response = await http.post(
        "https://www.sigmancomp.com/PHPRest/api/menu/getFreeSeat.php",
        body: {
          'rId': restoId.toString(),
          'oId': outletId.toString(),
        });
    var result = json.decode(response.body);
    setState(() {
      _newTable = result[0]["TableId"];
      for (var i = 0; i < result.length; i++) {
        type.add(result[i]["TableId"]);
      }
    });
  }

  void setUserData() async {
    this.uId = await FlutterSession().get("uId");
    this.tableId = await FlutterSession().get("tableId");
    this.uFirstName = await FlutterSession().get("uFirstName");
    this.uLastName = await FlutterSession().get("uLastName");
    this.restoId = await FlutterSession().get("restaurantId");
    this.outletId = await FlutterSession().get("outletId");
    getFreeTable();
  }

  @override
  void initState() {
    super.initState();
    setUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: Text('CHANGE SEAT')),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text(
                    'Select New Table',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton(
                  underline: Container(
                    height: 2.0,
                    color: Colors.grey,
                  ),
                  hint: Text('Select New Table'), // Not necessary for Option 1
                  value: _newTable,
                  onChanged: (newValue) {
                    setState(() {
                      _newTable = newValue;
                    });
                  },
                  items: type.map((value) {
                    return DropdownMenuItem(
                      child: new Text(value),
                      value: value,
                    );
                  }).toList(),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      _buttonState = 1;
                    });
                    await changeTable(tableId, _newTable);
                  },
                  child: Container(
                    width: 150.0,
                    height: 35.0,
                    decoration: BoxDecoration(
                      color: Color(0xFFf45123),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Center(
                      child: setUpButtonChild(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    Navigator.pop(context, true);
                  },
                  child: Container(
                    width: 150.0,
                    height: 35.0,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Center(
                        child: Text('Go Back',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold))),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
