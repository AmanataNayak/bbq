import 'package:buybyeq/admin_order_summary.dart';
import 'package:flutter/material.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:whatsapp_share/whatsapp_share.dart';

class InvoicePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainInvoicePage();
  }
}

class MainInvoicePage extends StatefulWidget {
  final int uId;
  final String uFirstName;
  final String uLastName;
  final String tId;
  MainInvoicePage(
      {Key key,
      @required this.uId,
      @required this.uFirstName,
      @required this.uLastName,
      @required this.tId});
  @override
  _MainInvoicePageState createState() => _MainInvoicePageState();
}

class _MainInvoicePageState extends State<MainInvoicePage> {
  int uId;
  String uFirstName;
  String uLastName;
  int _bottomNavBarIndex = 3;
  Future<List<OrderItems>> order;
  String mobileNo = '';
  int orderTotal = 0;
  String tableNo;
  String waiterNo;
  String oId = '';
  String oStatus = '';
  String restoId;
  String outletId;
  String user = 'waiter';
  String message = '';

  _openPopup(context, String textMsg) {
    Alert(
      context: context,
      title: "Send bill failed",
      content: Column(
        children: [
          Text(
            textMsg,
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
      buttons: [
        DialogButton(
            color: Color(0xFFf45123),
            child: Text("Okay", style: TextStyle(color: Colors.white)),
            onPressed: () {
              Navigator.pop(context);
            })
      ],
    ).show();
  }

  Future<void> shareWhatsapp() async {
    if (message != '' && mobileNo != '') {
      //print(mobileNo);
      var sendResult = await WhatsappShare.share(
        text: message,
        linkUrl: 'https://buybyeq.com/',
        phone: mobileNo,
      );
      if (!sendResult) {
        _openPopup(context, "Can not share bill right now. Try again later");
      }
    } else {
      _openPopup(context, "Can not share bill right now. Try again later");
    }
  }

  Future<void> shareFile() async {
    await WhatsappShare.shareFile(
      text: 'Whatsapp share text',
      phone: '919702850974',
      filePath: ['images/goku2.jpg'],
    );
  }

  Future<void> sendBill() async {
    final val = await WhatsappShare.isInstalled(package: Package.whatsapp);
    if (val) {
      shareWhatsapp();
    } else {
      _openPopup(context, 'Whatsapp not installed');
    }
  }

  String date = DateFormat('yyyy-MM-dd').format(DateTime.now());

  void testReceipt(NetworkPrinter printer) {
    printer.text('BUYBYEQ',
        styles: PosStyles(align: PosAlign.center, bold: true));
    printer.text('Bhubaneshwar', styles: PosStyles(align: PosAlign.center));
    printer.text('Tel: 1234569871', styles: PosStyles(align: PosAlign.center));
    printer.text('Web: buybyeq@gmail.com',
        styles: PosStyles(align: PosAlign.center));
    printer.hr(ch: '-');
    printer.row([
      PosColumn(
        text: 'Qty',
        width: 2,
        styles: PosStyles(align: PosAlign.center, underline: true),
      ),
      PosColumn(
        text: 'Item',
        width: 4,
        styles: PosStyles(align: PosAlign.left, underline: true),
      ),
      PosColumn(
        text: 'Price',
        width: 4,
        styles: PosStyles(align: PosAlign.center, underline: true),
      ),
      PosColumn(
        text: 'Total',
        width: 2,
        styles: PosStyles(align: PosAlign.center, underline: true),
      ),
    ]);

    for (int i = 0; i < 5; i++) {
      printer.row([
        PosColumn(
          text: 'Qty',
          width: 2,
          styles: PosStyles(align: PosAlign.center, underline: true),
        ),
        PosColumn(
          text: 'Item',
          width: 4,
          styles: PosStyles(align: PosAlign.left, underline: true),
        ),
        PosColumn(
          text: 'Price',
          width: 4,
          styles: PosStyles(align: PosAlign.center, underline: true),
        ),
        PosColumn(
          text: 'Total',
          width: 2,
          styles: PosStyles(align: PosAlign.center, underline: true),
        ),
      ]);
    }
    printer.text('Thank you!', styles: PosStyles(align: PosAlign.center));
    printer.text(DateTime.now().toString(),
        styles: PosStyles(align: PosAlign.center));
    printer.feed(2);
    printer.cut();
  }

  Future<dynamic> updateOrderStatus(String tableNo) async {
    final response = await http.post(
        "https://www.sigmancomp.com/PHPRest/api/order/UpdateOrderStatus.php",
        body: {
          "tId": tableNo,
        });
  }

  Future<List<OrderItems>> getOrderDet(String tId, String oId) async {
    final response = await http.post(
        "https://www.sigmancomp.com/PHPRest/api/order/table_read.php",
        body: {
          "oId": oId,
          "tId": tId,
        });
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      var items = list.map((items) => OrderItems.fromJson(items)).toList();
      var sum = 0;
      String oI = items[0].orderId;
      String oID = items[0].orderId;
      for (int l = 0; l < items.length; l++) {
        if (oI != items[l].orderId) {
          oID = oID + ',' + items[l].orderId;
          oI = items[l].orderId;
        }
        sum = sum + (int.parse(items[l].counter) * int.parse(items[l].price));
      }
      setState(() {
        oId = oID;
        oStatus = 'Food Preparing';
        orderTotal = (sum + (13 * sum) / 100).round().toInt();
        tableNo = items[0].tableNo;
        waiterNo = items[0].tableNo;
        mobileNo = '91' + items[items.length - 1].contact;
      });
      genBill(items);
      return items;
    } else {
      throw Exception('Failed to Load');
    }
  }

  void updateUserData(
      dynamic uId, dynamic uFirstName, dynamic uLastName, dynamic tId) {
    this.uId = uId;
    this.uLastName = uLastName;
    this.uFirstName = uFirstName;
    this.tableNo = tId;
  }

  void setUserData() async {
    this.restoId = await FlutterSession().get("restaurantId");
    this.outletId = await FlutterSession().get("outletId");
    order = getOrderDet(tableNo, outletId);
  }

  void genBill(var items) {
    var temp = '';
    if (items.length > 0) {
      for (int l = 0; l < items.length; l++) {
        temp = temp +
            items[l].name +
            ' ' +
            items[l].counter +
            '*' +
            items[l].price +
            '\n';
      }
      temp = temp + 'Total(inclusive tax): ' + orderTotal.toString();
    }
    setState(() {
      message = temp;
    });
    sendBill();
  }

  @override
  void initState() {
    super.initState();
    updateUserData(widget.uId, widget.uFirstName, widget.uLastName, widget.tId);
    setUserData();
    updateOrderStatus(tableNo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 150.0,
            ),
            Container(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'BBQ Restaurant',
                        style: TextStyle(fontSize: 25.0),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'XYZ Street, Bhubaneshwar',
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Ph:011-111-111-111',
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Bill No.:'),
                Text('1234'),
                SizedBox(
                  width: 20.0,
                ),
                Text('Date:'),
                Text(date),
              ],
            ),
            SizedBox(
              height: 50.0,
            ),
            /*Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      'Sr#',
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text('1'),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text('2'),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Item',
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text('Wrap'),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text('Veg Burger'),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Qty',
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text('1'),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text('2'),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Price',
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text('45'),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text('90'),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Amount',
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text('45'),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text('180'),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 40.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      'Discount',
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      'Net Amount',
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      'Payment',
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                SizedBox(
                  width: 10.0,
                ),
                Column(
                  children: [
                    Text('225'),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text('22'),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text('203'),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text('-'),
                  ],
                ),
                SizedBox(
                  width: 50.0,
                )
              ],
            )*/
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
              child: Container(
                height: 40.0,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Item'),
                    Text('Quantity'),
                    Text('Price'),
                  ],
                ),
              ),
            ),
            Container(
              child: FutureBuilder<List<OrderItems>>(
                future: order,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 3.0),
                            child: Container(
                              height: 50.0,
                              decoration: BoxDecoration(
                                  //color: Colors.grey.shade300,
                                  ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    snapshot.data[index].name,
                                  ),
                                  Text(
                                      "${snapshot.data[index].counter} * ${snapshot.data[index].price}"),
                                  Text(snapshot.data[index].price),
                                ],
                              ),
                            ),
                          );
                        });
                  } else if (snapshot.hasError) {
                    return Text("No order placed");
                  }
                  return Text("Loading...");
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
              child: Container(
                height: 40.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text('Order Total'),
                    SizedBox(
                      width: 20.0,
                    ),
                    Text("Rs. " + (orderTotal).toString()),
                  ],
                ),
              ),
            ),
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
  final String contact;

  OrderItems(
      {this.tableNo,
      this.name,
      this.price,
      this.discount,
      this.counter,
      this.orderTotal,
      this.orderId,
      this.contact});

  factory OrderItems.fromJson(Map<String, dynamic> json) {
    return OrderItems(
      tableNo: json['tableNo'],
      name: json['name'],
      counter: json['quantity'],
      price: json['Price'],
      discount: json['DiscountPercentage'],
      orderTotal: json['TotalAmount'],
      orderId: json['OrderId'],
      contact: json['Contact'],
    );
  }
}
