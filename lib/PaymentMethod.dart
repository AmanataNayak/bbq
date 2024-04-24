import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaymentMethod extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainPaymentMethodPage();
  }
}

class MainPaymentMethodPage extends StatefulWidget {
  final int uId;
  final String uFirstName;
  final String uLastName;
  final String orderId;
  final String tableNo;
  final String totalAmount;

  MainPaymentMethodPage(
      {Key key,
      @required this.tableNo,
      @required this.uId,
      @required this.uFirstName,
      @required this.uLastName,
      @required this.orderId,
      @required this.totalAmount});

  @override
  _MainPaymentMethodPageState createState() => _MainPaymentMethodPageState();
}

enum PaymentType { cash, online }

class _MainPaymentMethodPageState extends State<MainPaymentMethodPage> {
  int uId;
  String uFirstName;
  String uLastName;
  String orderId;
  String tableNo;
  String totalAmount;
  String changeValue = 'Cash';
  String returnValue = '';
  TextEditingController cashController = TextEditingController();
  TextEditingController receiptNumber = TextEditingController();
  int _bottomNavBarIndex = 2;
  //PaymentMethod _method = PaymentMethod.cash;
  //PaymentType _method = PaymentType.cash;
  List<String> type = ['Cash', 'Card', 'UPI'];
  String _paymentType = 'Cash';

  Future<dynamic> completeOrder(String oUId, String tId) async {
    if (true) {
      final response = await http.post(
          "https://www.sigmancomp.com/PHPRest/api/order/complete.php",
          body: {
            "uId": oUId,
            "tId": tId,
          });
      return 1;
    }
  }

  void _onItemTap(int index) {
    setState(() {
      _bottomNavBarIndex = index;
    });
  }

  void updateUserData(dynamic uId, dynamic uFirstName, dynamic uLastName,
      dynamic orderId, dynamic tableNo, dynamic totalAmount) {
    this.uId = uId;
    this.uLastName = uLastName;
    this.uFirstName = uFirstName;
    this.orderId = orderId;
    this.tableNo = tableNo;
    this.totalAmount = totalAmount;
  }

  Column paymentProcess(String pType) {
    if (pType == 'Cash') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 80.0),
                  child: TextField(
                    decoration: InputDecoration(hintText: 'Total Cash'),
                    onChanged: (String value) {
                      if (int.parse(cashController.text) >
                          int.parse(totalAmount)) {
                        int change = int.parse(cashController.text) -
                            int.parse(totalAmount);
                        setState(() {
                          returnValue = change.toString();
                        });
                      }
                    },
                    controller: cashController,
                  ),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, top: 8.0, right: 0.0, bottom: 8.0),
                child: Text(
                  'Change to return : ',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  returnValue,
                  style: TextStyle(fontSize: 20.0),
                ),
              )
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
                  await completeOrder(orderId, tableNo);
                  Navigator.pop(context, false);
                },
                child: Container(
                  width: 150.0,
                  height: 35.0,
                  decoration: BoxDecoration(
                    color: Color(0xFFf45123),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Center(
                      child: Text('Complete',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold))),
                ),
              ),
            ],
          )
        ],
      );
    } else if (pType == 'Card') {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 80.0),
                  child: TextField(
                    decoration:
                        InputDecoration(hintText: 'Enter Receipt Number'),
                    onChanged: (String value) {},
                    controller: receiptNumber,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  await completeOrder(orderId, tableNo);
                  Navigator.pop(context, false);
                },
                child: Container(
                  width: 150.0,
                  height: 35.0,
                  decoration: BoxDecoration(
                    color: Color(0xFFf45123),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Center(
                      child: Text('Complete',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold))),
                ),
              ),
            ],
          )
        ],
      );
    } else {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 80.0),
                  child: TextField(
                    decoration:
                        InputDecoration(hintText: 'Enter Transaction Id'),
                    onChanged: (String value) {},
                    controller: receiptNumber,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  await completeOrder(orderId, tableNo);
                  Navigator.pop(context, false);
                },
                child: Container(
                  width: 150.0,
                  height: 35.0,
                  decoration: BoxDecoration(
                    color: Color(0xFFf45123),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Center(
                      child: Text(
                    'Complete',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )),
                ),
              )
            ],
          )
        ],
      );
    }
  }

/*  void _onChangedOne(bool newValue) => setState((){
    cashMethod = newValue;
    //print(cashMethod);
  });

  void _onChangedTwo(bool newValue) => setState((){
    onlineMethod = newValue;
    //print(onlineMethod);
  });*/

  @override
  void initState() {
    super.initState();
    updateUserData(widget.uId, widget.uFirstName, widget.uLastName,
        widget.orderId, widget.tableNo, widget.totalAmount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      /*drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      child: Icon(
                        Icons.sentiment_satisfied,
                        size: 80.0,
                      ),
                      backgroundColor: Colors.grey.shade200,
                      radius: 55.0,
                    ),
                    Text(
                      "Das",
                      style: TextStyle(
                        fontSize: 15.0,
                      ),
                    )
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Home'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.list),
                title: Text('My Order'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.shopping_cart),
                title: Text('My Cart'),
                onTap: () {},
              ),
              Divider(
                color: Colors.black,
              ),
              ListTile(
                leading: Icon(Icons.event),
                title: Text('Event'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.photo),
                title: Text('Gllery'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.calendar_today),
                title: Text('Parties'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.photo_album),
                title: Text('Tournaments'),
                onTap: () {},
              ),
              Divider(
                color: Colors.grey,
              ),
              ListTile(
                leading: Icon(Icons.highlight_off),
                title: Text('Logout'),
                onTap: () {},
              )
            ],
          ),
        ),*/
      appBar: AppBar(
          title: Row(
        children: <Widget>[
          Expanded(child: Center(child: Text('PAYMENT METHOD'))),
        ],
      )),
      /*bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.grey,
          currentIndex: _bottomNavBarIndex,
          onTap: _onItemTap,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home), title: Text('Home')),
            BottomNavigationBarItem(
                icon: Icon(Icons.fastfood), title: Text('Menu')),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              title: Text('Cart'),
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.playlist_add_check), title: Text('Order'))
          ],
        ),*/

      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 1.0,
            ),
            /*Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                    height: 70.0,
                    decoration: BoxDecoration(
                      color: Colors.deepOrangeAccent,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Center(
                          child: Text('You are currently dining in Table No : '+tableNo.toString()),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Text('Order ID : '+orderId.toString()),
                            Text('Order Status : Food Preparing')
                          ],
                        )
                      ],
                    )
                ),
              ),*/
            Padding(
              padding: EdgeInsets.all(4.0),
              child: Text(
                'Invoice Amount : ' + totalAmount.toString(),
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Payment Method'),
                SizedBox(
                  width: 30.0,
                ),
                DropdownButton(
                  underline: Container(
                    color: Colors.grey,
                    height: 1.5,
                  ),
                  style: TextStyle(color: Colors.lightBlue, fontSize: 18.0),
                  // Not necessary for Option 1
                  value: _paymentType,
                  onChanged: (newValue) {
                    setState(() {
                      _paymentType = newValue;
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
            paymentProcess(_paymentType),
            /*Container(
                decoration: BoxDecoration(
                    color: Colors.blue.shade300
                ),
                child: FlatButton(
                  onPressed: () async {
                    if(_method==PaymentType.online){
                      var results = await Navigator.push(context, MaterialPageRoute(builder:(context)=>MainPaymentStatusPage(uId:uId)));
                      if(results==null){
                        Navigator.pop(
                            context,false);
                      }
                    }
                    else if(_method==PaymentType.cash){
                      var results = await Navigator.push(context, MaterialPageRoute(builder:(context)=>MainCashPayment(uId:uId,tableNo: tableNo,totalAmount: totalAmount,)));
                      if(results==null){
                        Navigator.pop(
                            context,false);
                      }

                    }

                  },
                  child: Text('Proceed',style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                  ),),
                ),
              ),*/
          ],
        ),
      ),
    );
  }
}
