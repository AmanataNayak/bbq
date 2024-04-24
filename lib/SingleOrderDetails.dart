import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';

class SingleOrderDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainSingleOrderDetails();
  }
}

class MainSingleOrderDetails extends StatefulWidget {
  final String orderId;
  MainSingleOrderDetails({Key key, @required this.orderId});
  @override
  _MainSingleOrderDetailsState createState() => _MainSingleOrderDetailsState();
}

class _MainSingleOrderDetailsState extends State<MainSingleOrderDetails> {
  String orderId;
  int orderTotal = 0;
  Future<List<OrderItems>> order;

  void updateUserData(dynamic orderId) {
    setState(() {
      this.orderId = orderId;
    });
  }

  void printKOT() async {
    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paper, profile);

    final PosPrintResult res =
        await printer.connect('192.168.0.123', port: 9100);
    //print(res);

    if (res == PosPrintResult.success) {
      testReceipt(printer);
      printer.disconnect();

      //print('Print result: ${res.msg}');
    } else {
      //print('Print error: ${res.msg}');
    }
  }

  void testReceipt(NetworkPrinter printer) {
    printer.text('Order Id',
        styles: PosStyles(align: PosAlign.center, bold: true));
    printer.row([
      PosColumn(
        text: 'Qty',
        width: 2,
        styles: PosStyles(align: PosAlign.left, underline: true),
      ),
      PosColumn(
        text: 'Item',
        width: 4,
        styles: PosStyles(align: PosAlign.right, underline: true),
      ),
    ]);

    for (int i = 0; i < 5; i++) {
      printer.row([
        PosColumn(
          text: 'Qty',
          width: 2,
          styles: PosStyles(align: PosAlign.left, underline: true),
        ),
        PosColumn(
          text: 'Item',
          width: 4,
          styles: PosStyles(align: PosAlign.right, underline: true),
        ),
      ]);
    }
    printer.text(DateTime.now().toString(),
        styles: PosStyles(align: PosAlign.center));
    printer.feed(2);
    printer.cut();
  }

  Future<List<OrderItems>> getOrder(String oId) async {
    final response = await http.post(
        "https://www.sigmancomp.com/PHPRest/api/order/table_read_single.php",
        body: {
          "oId": oId,
        });
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      var items = list.map((items) => OrderItems.fromJson(items)).toList();
      var sum = 0;
      for (int l = 0; l < items.length; l++) {
        sum = sum + (int.parse(items[l].counter) * int.parse(items[l].price));
      }
      setState(() {
        orderTotal = sum;
      });
      return items;
    } else {
      //print('method Error!!');
      throw Exception('Failed to Load');
    }
  }

  @override
  void initState() {
    super.initState();
    updateUserData(widget.orderId);
    order = getOrder(orderId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
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
                ],
              ),
            ),
            ListTile(
              title: Text('Logout'),
              onTap: () {},
            )
          ],
        ),
      ),
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 80.0,
          ),
          Expanded(child: Text('ORDER INFO')),
        ],
      )),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Text(
              'ITEM/S IN THIS ORDER',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: FutureBuilder<List<OrderItems>>(
                future: order,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        //  shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 3.0),
                            child: Container(
                              height: 50.0,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text(snapshot.data[index].name),
                                  Text(
                                      "${snapshot.data[index].counter} * ${snapshot.data[index].price}"),
                                  Text(snapshot.data[index].price),
                                ],
                              ),
                            ),
                          );
                        });
                  } else if (snapshot.hasError) {
                    return Text("can't connect ro server!");
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
              child: Container(
                height: 50.0,
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
                height: 50.0,
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
                height: 50.0,
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
                height: 50.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text('Discount'),
                    Text((orderTotal * 5 / 100).toString()),
                  ],
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.symmetric(vertical: BorderSide(width: 2.0))),
                height: 50.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text('Total Amount'),
                    Text(((orderTotal +
                            (orderTotal * 18 / 100) -
                            (orderTotal * 5 / 100))
                        .round()
                        .toString())),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: Color(0xFFf45123),
                      borderRadius: BorderRadius.circular(10.0)),
                  child: TextButton(
                    onPressed: () {
                      printKOT();
                    },
                    child: Text(
                      'Print',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
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

  OrderItems(
      {this.tableNo,
      this.name,
      this.price,
      this.discount,
      this.counter,
      this.orderTotal,
      this.orderId});

  factory OrderItems.fromJson(Map<String, dynamic> json) {
    return OrderItems(
        tableNo: json['tableNo'],
        name: json['name'],
        counter: json['quantity'],
        price: json['Price'],
        discount: json['DiscountPercentage'],
        orderTotal: json['TotalAmount'],
        orderId: json['OrderId']);
  }
}
