import 'package:flutter/material.dart';
import 'menu_page.dart';
import 'change_seat.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'tabPage.dart';

class UserOrderSummary extends StatefulWidget {
  @override
  _UserOrderSummaryState createState() => _UserOrderSummaryState();
}

class _UserOrderSummaryState extends State<UserOrderSummary> {
  int uId;
  String uFirstName;
  String uLastName;
  int _bottomNavBarIndex = 3;
  Future<List<OrderItems>> order;
  double orderTotal = 0.0;
  String tableId = '0';
  String waiterId;
  String oId = '';
  String oStatus = '';
  String user = 'waiter';
  String outletId;
  var subscriptionId;

  /*void _onItemTap(int index) async {
    if (tableNo == '0') {
      if (index == 1) {
        Navigator.pop(context, 'cart');
      } else if (index == 0) {
        Navigator.pop(context, false);
      }
    } else {
      if (index == 1) {
        Navigator.pop(context, true);
      } else if (index == 2) {
        Navigator.pop(context, 'cart');
      } else if (index == 0) {
        Navigator.pop(context, false);
      }
    }
  }*/
  Future deleteItem(oDId) async {
    print("$subscriptionId $oDId");
    final response = await http.post(
        "https://www.buybyeq.com/bbq_server/PHPRest/api/order/deleteOrderItem.php",
        body: {
          'restaurantId': subscriptionId.toString(),
          'orderDetailsId': oDId,
        });
    print(response.body);
  }

  Future<void> _showDeleteDialog(itemName, oDId) async {
    //print(listId);
    //print(listName);
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('AlertDialog Title'),
          content: Text("Delete $itemName ?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, 'Cancel');
              },
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              child: const Text(
                'Ok',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                deleteItem(oDId);
                setState(() {
                  order = getOrder();
                });
                Navigator.pop(context, 'Ok');
              },
            ),
          ],
        );
      },
    );
  }

  Future<List<OrderItems>> getOrder() async {
    //print("Start");
    final response = await http.post(
        "https://www.buybyeq.com/bbq_server/PHPRest/api/order/table_read.php",
        body: {
          "tId": tableId,
          "rId": subscriptionId,
        });
    //print(response.body);
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      if (list.isNotEmpty) {
        var items = list.map((items) => OrderItems.fromJson(items)).toList();
        var sum = 0.0;
        String oI = items[0].orderId;
        String oID = items[0].orderId;
        for (int l = 0; l < items.length; l++) {
          if (oI != items[l].orderId) {
            oID = oID + ',' + items[l].orderId;
            oI = items[l].orderId;
          }
          sum = sum +
              (int.parse(items[l].counter) * double.parse(items[l].price));
        }
        setState(() {
          oId = oID;
          oStatus = 'Food Preparing';
          orderTotal = sum;
          tableId = items[0].tableNo;
          waiterId = items[0].tableNo;
        });
        return items;
      } else {
        return null;
      }
    } else {
      //print('method Error!!');
      throw Exception('Failed to Load');
    }
  }

  Future<dynamic> completeOrder(String tId) async {
    if (true) {
      final response = await http.post(
          "https://www.buybyeq.com/bbq_server/PHPRest/api/order/clear_mobile.php",
          body: {"tId": tId, "rId": subscriptionId, "oId": oId});
      return true;
    }
  }

  void updateUserData(
      dynamic uId, dynamic uFirstName, dynamic uLastName, dynamic tableNo) {
    this.uId = uId;
    this.uLastName = uLastName;
    this.uFirstName = uFirstName;
    this.tableId = tableNo.toString();
  }

  Future<dynamic> updateStatus(int uId, int tId) async {
    if (true) {
      final response = await http.post(
          "https://www.buybyeq.com/bbq_server/PHPRest/api/order/UpdatePaymentStatus.php",
          body: {
            "uId": uId.toString(),
            "tId": tId.toString(),
          });
      return 1;
    }
  }

  // Container makePayment() {
  //   if (user == 'waiter') {
  //     return Container(
  //         //decoration: BoxDecoration(color: Colors.blue.shade300),
  //         child: ElevatedButton(
  //       onPressed: () async {
  //         updateStatus(uId, int.parse(tableId));
  //         Navigator.pop(context);
  //       },
  //       child: Text(
  //         'Submit',
  //         style: TextStyle(
  //           color: Colors.white,
  //           fontSize: 15.0,
  //         ),
  //       ),
  //       style: ElevatedButton.styleFrom(
  //         primary: Colors.lightGreen,
  //         shape:
  //             RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
  //       ),
  //     ));
  //   } else {
  //     return Container(
  //       //decoration: BoxDecoration(color: Colors.blue.shade300),
  //       child: ElevatedButton(
  //         style: ElevatedButton.styleFrom(
  //             primary: Colors.lightGreen,
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(15.0))),
  //         onPressed: () async {
  //           var results = await Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                   /*
  //                   builder: (context) => MainPaymentMethodPage(
  //                       uId: uId,
  //                       uFirstName: uFirstName,
  //                       uLastName: uLastName,
  //                       orderId: oId.toString(),
  //                       tableNo: tableNo,
  //                       totalAmount: (orderTotal +
  //                               (orderTotal * 18 / 100) -
  //                               (orderTotal * 5 / 100))
  //                           .round()
  //                           .toString())*/
  //                   ));
  //           if (results == false) {
  //             Navigator.pop(context, false);
  //           }
  //         },
  //         child: Text(
  //           'Make Payment',
  //           style: TextStyle(
  //             color: Colors.white,
  //             fontSize: 15.0,
  //           ),
  //         ),
  //       ),
  //     );
  //   }
  // }

  Center tblInfo() {
    if (tableId != '0') {
      return Center(
        child: Text(
          'You are currently serving at Table No : ' + tableId.toString(),
          style: TextStyle(fontSize: 20.0, color: Colors.white),
        ),
      );
    } else {
      return Center(
        child: Text(
          'Thank you for ordering',
          style: TextStyle(fontSize: 20.0),
        ),
      );
    }
  }

  Row bottomButtons() {
    if (oId != '') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          /*Container(
            //decoration: BoxDecoration(color: Colors.blue.shade300),
            child: RaisedButton(
              onPressed: () async {
                var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TabPage(
                        uId: uId,
                        uFirstName: uFirstName,
                        uLastName: uLastName,
                        ind: 1,
                      ),
                    ));
                if (result == null || result == false || result == true) {
                  setState(() {
                    setUserData();
                  });
                }
              },
              color: Colors.lightGreen,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              child: Text(
                'Add more Items',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),*/
          // Container(
          //   //decoration: BoxDecoration(color: Colors.blue.shade300),
          //   child: ElevatedButton(
          //     onPressed: () async {
          //       var cartResult = await Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => ChangeSeat(),
          //         ),
          //       );
          //       if (cartResult == true || cartResult == null) {
          //         Navigator.pop(context);
          //       }
          //     },
          //     style: ElevatedButton.styleFrom(
          //         primary: Colors.lightGreen,
          //         shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(15.0))),
          //     child: Text(
          //       'Change Table',
          //       style: TextStyle(
          //         color: Colors.white,
          //         fontSize: 15.0,
          //       ),
          //     ),
          //   ),
          // ),
          Container(
            // decoration: BoxDecoration(color: Colors.blue.shade300),
            child: ElevatedButton(
              onPressed: () async {
                var result = await completeOrder(tableId.toString());
                if (result == true || result == null) {
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                  primary: Colors.lightGreen,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0))),
              child: Text(
                'Clear Table',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return Row();
    }
  }

  void setUserData() async {
    this.uId = await FlutterSession().get("uId");
    this.tableId = await FlutterSession().get("tableId");
    this.waiterId = await FlutterSession().get("waiterId");
    this.uFirstName = await FlutterSession().get("uFirstName");
    this.uLastName = await FlutterSession().get("uLastName");
    this.outletId = await FlutterSession().get("outletId");
    this.subscriptionId = await FlutterSession().get("subscriptionId");
    order = getOrder();
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
        title: Center(
          child: Text('ORDER SUMMARY'),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 1.0,
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                  padding: EdgeInsets.all(4.0),
                  //height: 70.0,
                  decoration: BoxDecoration(
                    color: Colors.deepOrangeAccent,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      tblInfo(),
                      for (var s in oId.split(','))
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Text('Order ID : ' + s.toString()),
                            Text('Order Status : ' + oStatus)
                          ],
                        ),
                    ],
                  )),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'ITEM/S IN THIS ORDER',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(
              height: 5,
            ),
            Expanded(
              child: FutureBuilder<List<OrderItems>>(
                future: order,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.length > 0) {
                      return GestureDetector(
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            //  shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              String name = snapshot.data[index].name;
                              if (name.length > 30) {
                                name = name.substring(0, 30);
                              }
                              return GestureDetector(
                                onTap: () {
                                  _showDeleteDialog(name,
                                      snapshot.data[index].orderDetailsId);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 3.0),
                                  child: Container(
                                    height: 50.0,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.0),
                                    decoration: BoxDecoration(
                                      //color: Colors.grey.shade300,
                                      border: Border.all(color: Colors.grey),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                            "${snapshot.data[index].counter} * $name"),
                                        //Text(
                                        //  "${snapshot.data[index].counter} * ${snapshot.data[index].price}"),
                                        Text((double.parse(snapshot
                                                    .data[index].price) *
                                                int.parse(snapshot
                                                    .data[index].counter))
                                            .toString()),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      );
                    } else {
                      return Text("No order placed");
                    }
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ),
            /*Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
              child: Container(
                height: 40.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text('Payment Summary'),
                  ],
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
              child: Container(
                height: 40.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text('Order Total'),
                    Text((orderTotal).toString()),
                  ],
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
              child: Container(
                height: 40.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text('Tax(18%)'),
                    Text((orderTotal * 18 / 100).toString()),
                  ],
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
              child: Container(
                decoration: BoxDecoration(
                    //border: Border.symmetric(vertical: BorderSide(width: 2.0))
                    ),
                height: 50.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text('Total Amount'),
                    Wrap(
                      children: [
                        Text(
                          ((orderTotal + (orderTotal * 18 / 100))
                              .round()
                              .toString()),
                          style:
                              TextStyle(decoration: TextDecoration.lineThrough),
                        ),
                        Text(
                          ((orderTotal +
                                  (orderTotal * 18 / 100) -
                                  (orderTotal * 5 / 100))
                              .round()
                              .toString()),
                          style: TextStyle(fontSize: 30.0),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),*/
            bottomButtons(),
            SizedBox(
              height: 5.0,
            )
          ],
        ),
      ),
    );
  }
}

class OrderItems {
  final String tableNo;
  final String name;
  final String counter;
  final String price;
  final String discount;
  final String orderTotal;
  final String orderId;
  final String cgst;
  final String sgst;
  final String orderDetailsId;

  OrderItems(
      {this.tableNo,
      this.name,
      this.price,
      this.discount,
      this.counter,
      this.orderTotal,
      this.orderId,
      this.cgst,
      this.sgst,
      this.orderDetailsId});

  factory OrderItems.fromJson(Map<String, dynamic> json) {
    return OrderItems(
        tableNo: json['tableNo'],
        name: json['name'],
        counter: json['quantity'],
        price: json['Price'],
        discount: json['DiscountPercentage'],
        orderTotal: json['TotalAmount'],
        orderId: json['OrderId'],
        cgst: json['Cgst'],
        sgst: json['Sgst'],
        orderDetailsId: json['OrderDetailsId']);
  }
}
