import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class OrderStatus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainOrderStatusPage(),
    );
  }
}

class MainOrderStatusPage extends StatefulWidget {
  int uId;
  String uFirstName;
  String uLastName;
  String tableId;
  String waiterId;

  MainOrderStatusPage(
      {Key key,
      @required this.uId,
      @required this.uFirstName,
      @required this.uLastName,
      @required this.tableId,
      @required this.waiterId});
  @override
  _MainOrderStatusPageState createState() => _MainOrderStatusPageState();
}

class _MainOrderStatusPageState extends State<MainOrderStatusPage> {
  int uId;
  String uFirstName;
  String uLastName;
  String tableId;
  String waiterId;
  int _bottomNavBarIndex = 3;

  void updateUserData(dynamic uId, dynamic uFirstName, dynamic uLastName,
      dynamic tableId, dynamic waiterId) {
    this.uId = uId;
    this.uLastName = uLastName;
    this.uFirstName = uFirstName;
    this.tableId = tableId;
    this.waiterId = waiterId;
  }

  void _onItemTap(int index) {
    setState(() {
      _bottomNavBarIndex = index;
    });
  }

  /*Future _showAlert(BuildContext context, String message) async {
    return showDialog(
        context: context,
        child: new AlertDialog(
          title: new Text(message),
          actions: <Widget>[
            new FlatButton(
                onPressed: () => Navigator.pop(context), child: Text('Okay'))
          ],
        ));
  }*/

  @override
  void initState() {
    super.initState();
    updateUserData(widget.uId, widget.uFirstName, widget.uLastName,
        widget.tableId, widget.waiterId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        title: Row(
          children: <Widget>[
            /*FlatButton(
                onPressed:(){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>OrderSummaryPage()),
                  );
                },
                child: Icon(Icons.arrow_back)),*/
            Expanded(child: Center(child: Text('99 North Restaurant'))),
            TextButton(
              child: Icon(Icons.home),
              onPressed: () {
                Navigator.pop(context, true);
              },
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        currentIndex: _bottomNavBarIndex,
        onTap: _onItemTap,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: 'Menu'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.playlist_add_check), label: 'Order')
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
              ),
              height: 150,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Order Placed',
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.fastfood,
                    size: 50.0,
                  ),
                ],
              ),
            ),
            Container(
              height: 150,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.check_circle_outline,
                          size: 80.0, color: Colors.green),
                      Text(
                        'Your order has been placed',
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            /*Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: GestureDetector(
                onTap: () async {
                  var trackResult = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MainTrackOrderPage(
                            uId: uId,
                            uFirstName: uFirstName,
                            uLastName: uLastName)),
                  );
                  if (trackResult = !false) {
                    Navigator.pop(context, true);
                  }
                },
                child: Container(
                  width: 150,
                  height: 30.0,
                  decoration: BoxDecoration(
                    color: Colors.deepOrange.shade200,
                  ),
                  child: Center(
                      child: Text(
                    'Track Order',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                  )),
                ),
              ),
            ),*/
            Container(
              height: 50,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Or',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Go back to Home',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
