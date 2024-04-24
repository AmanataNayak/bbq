import 'dart:convert';

import 'package:buybyeq/admin_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_pdf/pdf.dart';

class BillScreen extends StatefulWidget {
  const BillScreen({Key key}) : super(key: key);

  @override
  State<BillScreen> createState() => _BillScreenState();
}

enum DiscountType { Percentage, Amount }

class _BillScreenState extends State<BillScreen> {
  int uId;
  String uFirstName;
  String uLastName;
  Future<List<OrderItems>> order;
  double orderTotal = 0.0;
  String tableId = '0';
  String waiterId;
  String oId = '';
  String oStatus = '';
  String user = 'waiter';
  String outletId;
  var subscriptionId;
  String restoName = '';
  String location = '';
  double total_price = 0;
  double GST = 0.0;
  List orders = [];

  //Text Input
  TextEditingController cash = TextEditingController();
  TextEditingController trasactionId = TextEditingController();
  TextEditingController card = TextEditingController();
  TextEditingController upi = TextEditingController();

  var items = ['CASH', 'CARD', 'UPI', 'SPLIT'];
  String dropdownValue = 'CASH';
  DiscountType _character = DiscountType.Percentage;
  String date =
      "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year} ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second} ";

  Future<List<OrderItems>> getOrder() async {
    final response = await http.post(
        "https://www.buybyeq.com/bbq_server/PHPRest/api/order/table_read.php",
        body: {
          "tId": tableId,
          "rId": subscriptionId,
        });

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      if (list.isNotEmpty) {
        orders = list.map((items) => OrderItems.fromJson(items)).toList();
        var sum = 0.0;
        String oI = orders[0].orderId;
        String oID = orders[0].orderId;
        for (int l = 0; l < orders.length; l++) {
          GST +=
              (double.parse(orders[l].cgst)) + (double.parse(orders[l].sgst));
          total_price +=
              (double.parse(orders[l].price) * int.parse(orders[l].counter));
          if (oI != orders[l].orderId) {
            oID = oID + ',' + orders[l].orderId;
            oI = orders[l].orderId;
          }
          sum = sum +
              (int.parse(orders[l].counter) * double.parse(orders[l].price));
        }
        setState(() {
          oId = oID;
          oStatus = 'Food Preparing';
          orderTotal = sum;
          tableId = orders[0].tableNo;
          waiterId = orders[0].tableNo;
        });
        GST = GST / orders.length;
        return orders;
      } else {
        return null;
      }
    } else {
      //print('method Error!!');
      throw Exception('Failed to Load');
    }
  }

  Future<dynamic> completeOrder(
    String tId,
    String totalAmount,
    String gst,
    String paymentType,
    String receivedamount,
    String cashReceived,
    String transactionIdCard,
    String transactionIdUPI,
  ) async {
    print("$paymentType $cashReceived $transactionIdCard $transactionIdUPI");
    if (true) {
      // print("hlw $gst, $totalAmount $receivedamount");
      final response = await http.post(
          "https://www.buybyeq.com/bbq_server/PHPRest/api/order/complete_mobile.php",
          body: {
            "tId": tId,
            "rId": subscriptionId,
            "totalAmount": totalAmount,
            "gst": gst,
            "receivedAmount": receivedamount,
            'paymentType': paymentType,
            'cashReceived': cashReceived,
            'trasactionIdCard': transactionIdCard,
            'transactionIdUPI': transactionIdUPI
          });
      return true;
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
    this.location = await FlutterSession().get("address");
    this.restoName = await FlutterSession().get("restoName");

    order = getOrder();
  }

  @override
  void initState() {
    super.initState();
    setUserData();
  }

  @override
  Widget build(BuildContext context) {
    final isChecked = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Bill'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width,
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Text(restoName)),
                Center(child: Text(location)),
                Divider(
                  color: Colors.black,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Bill Number: $oId"),
                    Text("Date: $date"),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text("Table No:$tableId"),
                Divider(
                  color: Colors.black,
                ),
                Table(children: [
                  TableRow(children: [
                    Column(children: [Text('Item Name')]),
                    Column(children: [Text('Quantity')]),
                    Column(children: [Text('Price')]),
                    Column(children: [Text('value')]),
                  ]),
                ]),
                Flexible(
                  flex: 2,
                  child: FutureBuilder<dynamic>(
                    builder: (context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }

                      // WHEN THE CALL IS DONE BUT HAPPENS TO HAVE AN ERROR
                      if (snapshot.hasError) {
                        return Center(child: Text(snapshot.error.toString()));
                      }
                      // print(snapshot.data);
                      return ListView.builder(
                        padding: EdgeInsets.all(5),
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          String name = snapshot.data[index].name;
                          if (name.length > 30) {
                            name = name.substring(0, 30);
                          }
                          return Table(
                            children: [
                              TableRow(children: [
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [Text(name)]),
                                Column(children: [
                                  Text("${snapshot.data[index].counter} ")
                                ]),
                                Column(children: [
                                  Text("${snapshot.data[index].price}")
                                ]),
                                Column(children: [
                                  Text(
                                      (int.parse(snapshot.data[index].counter) *
                                              double.parse(
                                                  snapshot.data[index].price))
                                          .toString())
                                ]),
                              ]),
                            ],
                          );
                          // return Container(
                          //   // decoration: BoxDecoration(
                          //   //   //color: Colors.grey.shade300,
                          //   //   border: Border.all(color: Colors.grey),
                          //   // ),
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.start,
                          //     children: <Widget>[
                          //       Text(name),
                          //       Spacer(),
                          //       Text("${snapshot.data[index].counter} "),
                          //       SizedBox(
                          //         width: 20,
                          //       ),
                          //       Text(snapshot.data[index].price),
                          //       SizedBox(width: 20),
                          //       Text((int.parse(snapshot.data[index].counter) *
                          //               double.parse(snapshot.data[index].price))
                          //           .toString())
                          //     ],
                          //   ),
                          // );
                        },
                      );
                    },
                    future: order,
                  ),
                ),
                Divider(
                  color: Colors.black,
                ),
                // Column(
                //   children: [
                //     ListTile(
                //       title: const Text('Percentage'),
                //       leading: Radio(
                //         value: DiscountType.Percentage,
                //         groupValue: _character,
                //         onChanged: (DiscountType value) {
                //           setState(() {
                //             _character = value;
                //           });
                //         },
                //       ),
                //     ),
                //     ListTile(
                //       title: const Text('Amount'),
                //       leading: Radio(
                //         value: DiscountType.Amount,
                //         groupValue: _character,
                //         onChanged: (DiscountType value) {
                //           setState(() {
                //             _character = value;
                //           });
                //         },
                //       ),
                //     ),
                //   ],
                // ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    children: [
                      // Expanded(
                      //   child: TextField(
                      //     onSubmitted: (value) {
                      //       if (_character == DiscountType.Percentage) {
                      //         setState(() {
                      //           total_price = total_price -
                      //               (total_price / double.parse(value));
                      //         });
                      //       } else {
                      //         setState(() {
                      //           total_price = total_price - double.parse(value);
                      //         });
                      //       }
                      //       print("$value ,$_character, $total_price");
                      //     },
                      //     decoration: InputDecoration(
                      //         hintText: 'DISCOUNT',
                      //         border: OutlineInputBorder(
                      //             borderRadius: BorderRadius.circular(20))),
                      //   ),
                      // ),
                      Expanded(
                        child: TextField(
                          controller: cash,
                          decoration: InputDecoration(
                              hintText: 'Amount Received',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20))),
                        ),
                      ),

                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("TOTAL"),
                          Text("GST"),
                          Text("GRAND TOTAL"),
                        ],
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text((total_price).toString()),
                          Text(isChecked ? (GST).toString() : '0'),
                          Text(isChecked
                              ? (total_price + (total_price * GST / 100))
                                  .toString()
                              : total_price.toString()),
                        ],
                      ),
                    ],
                  ),
                ),
                // DropdownButton<String>(
                //   dropdownColor: Color(0xFFf45123),
                //   isExpanded: true,
                //   value: dropdownValue,
                //   icon: const Icon(Icons.keyboard_arrow_down),
                //   items: items.map((String items) {
                //     return DropdownMenuItem(
                //       value: items,
                //       child: Center(
                //           child: Text(
                //         items,
                //       )),
                //     );
                //   }).toList(),
                //   onChanged: (String newValue) {
                //     setState(() {
                //       dropdownValue = newValue;
                //     });
                //   },
                // ),
                // dropdownValue != 'SPLIT'
                //     ? TextField(
                //         controller:
                //             dropdownValue == 'CASH' ? cash : trasactionId,
                //         decoration: InputDecoration(
                //             hintText: dropdownValue == 'CASH'
                //                 ? 'Enter the amount'
                //                 : 'Enter The Trasaction Id',
                //             border: OutlineInputBorder(
                //                 borderRadius: BorderRadius.circular(20))),
                //       )
                //     : Row(
                //         children: [
                //           Expanded(
                //             child: TextField(
                //               controller: cash,
                //               decoration: InputDecoration(
                //                   hintText: 'CASH',
                //                   border: OutlineInputBorder(
                //                       borderRadius: BorderRadius.circular(20))),
                //             ),
                //           ),
                //           Expanded(
                //             child: TextField(
                //               controller: card,
                //               decoration: InputDecoration(
                //                   hintText: 'CARD',
                //                   border: OutlineInputBorder(
                //                       borderRadius: BorderRadius.circular(20))),
                //             ),
                //           ),
                //           Expanded(
                //             child: TextField(
                //               controller: upi,
                //               decoration: InputDecoration(
                //                   hintText: 'ONLINE',
                //                   border: OutlineInputBorder(
                //                       borderRadius: BorderRadius.circular(20))),
                //             ),
                //           )
                //         ],
                //       ),
                // dropdownValue == 'SPLIT'
                //     ? TextField(
                //         controller: trasactionId,
                //         decoration: InputDecoration(
                //             hintText: 'Enter the trasaction id',
                //             border: OutlineInputBorder(
                //                 borderRadius: BorderRadius.circular(20))),
                //       )
                //     : Visibility(
                //         child: Container(),
                //         visible: false,
                //       ),
                Center(
                  child: TextButton(
                    onPressed: () async {
                      String total = isChecked
                          ? (total_price + (total_price * GST / 100)).toString()
                          : total_price.toString();
                      String gst = isChecked ? ((GST).toString()) : '0';
                      var result = await completeOrder(
                          tableId.toString(),
                          total,
                          isChecked
                              ? (total_price * GST / 100).toString()
                              : '0',
                          '1',
                          cash.text,
                          cash.text,
                          '0',
                          '0');

                      if (result == true || result == null) {
                        Navigator.popUntil(context, (route) => route.isFirst);
                      }
                    },
                    child: Text("Complete Order",
                        style: TextStyle(color: Colors.white)),
                  ),
                )
              ],
            ),
          ),
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

  OrderItems(
      {this.tableNo,
      this.name,
      this.price,
      this.discount,
      this.counter,
      this.orderTotal,
      this.orderId,
      this.cgst,
      this.sgst});

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
    );
  }
}
