import 'dart:convert';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;
import 'package:esc_pos_printer/esc_pos_printer.dart';

class ViewOrderSummary extends StatefulWidget {
  const ViewOrderSummary({Key key}) : super(key: key);

  @override
  State<ViewOrderSummary> createState() => _ViewOrderSummaryState();
}

class _ViewOrderSummaryState extends State<ViewOrderSummary> {
  String orderId = '1';
  String restoId;
  String tableNo;
  String restoname;
  Future bill;
  String location;
  List orders;
  double total_price = 0;

  Future getBill() async {
    final response = await http.post(
        'https://www.buybyeq.com/bbq_server/PHPRest/api/report/getOrderReportByOrderId.php',
        body: {
          'orderId': orderId,
          'rId': restoId,
        });
    for (int i = 0; i < (json.decode(response.body)).length; i++) {
      total_price += (double.parse((json.decode(response.body))[i]['Price']) *
          int.parse((json.decode(response.body))[i]['quantity']));
    }
    setState(() {
      tableNo = json.decode(response.body)[0]['tableNo'];
    });
    return json.decode(response.body);
  }

  // void testReceipt(NetworkPrinter printer) {
  //   printer.text('$restoname',
  //       styles: PosStyles(align: PosAlign.center, bold: true));
  //   printer.text('$location', styles: PosStyles(align: PosAlign.center));
  //   // printer.text('Tel: 1234569871', styles: PosStyles(align: PosAlign.center));
  //   // printer.text('Web: buybyeq@gmail.com',
  //   //     styles: PosStyles(align: PosAlign.center));
  //   printer.hr(ch: '-');
  //   printer.row([
  //     PosColumn(
  //         text: 'Bill Number: $orderId',
  //         width: 4,
  //         styles: PosStyles(align: PosAlign.left)),
  //   ]);
  //   printer.text("Table No: $tableNo",
  //       styles: PosStyles(align: PosAlign.center));
  //   printer.hr(ch: '-');
  //   printer.row([
  //     PosColumn(
  //       text: 'Item',
  //       width: 4,
  //       styles: PosStyles(align: PosAlign.left, underline: true),
  //     ),
  //     PosColumn(
  //       text: 'Qty',
  //       width: 2,
  //       styles: PosStyles(align: PosAlign.center, underline: true),
  //     ),
  //     PosColumn(
  //       text: 'Price',
  //       width: 4,
  //       styles: PosStyles(align: PosAlign.center, underline: true),
  //     ),
  //     PosColumn(
  //       text: 'Total',
  //       width: 2,
  //       styles: PosStyles(align: PosAlign.center, underline: true),
  //     ),
  //   ]);

  //   for (int i = 0; i < orders.length; i++) {
  //     printer.row([
  //       PosColumn(
  //         text: orders[i]['name'],
  //         width: 4,
  //         styles: PosStyles(align: PosAlign.left, underline: true),
  //       ),
  //       PosColumn(
  //         text: orders[i]['quantity'],
  //         width: 2,
  //         styles: PosStyles(align: PosAlign.center, underline: true),
  //       ),
  //       PosColumn(
  //         text: orders[i]['price'],
  //         width: 4,
  //         styles: PosStyles(align: PosAlign.center, underline: true),
  //       ),
  //       PosColumn(
  //         text: (double.parse(orders[i].price) * int.parse(orders[i].counter))
  //             .toString(),
  //         width: 2,
  //         styles: PosStyles(align: PosAlign.center, underline: true),
  //       ),
  //     ]);
  //   }
  //   // printer.text("TOTAL:$total_price",
  //   //     styles: PosStyles(align: PosAlign.right));
  //   // printer.text("GST:$GST", styles: PosStyles(align: PosAlign.right));
  //   // printer.text("GRAND TOTAL:${(total_price + (total_price * GST / 100))}",
  //   //     styles: PosStyles(align: PosAlign.right));
  //   printer.text('Thank you!', styles: PosStyles(align: PosAlign.center));
  //   printer.feed(2);
  //   printer.cut();
  // }

  void setOrderId(ctx) {
    setState(() {
      orderId = ModalRoute.of(ctx).settings.arguments;
    });
  }

  void setUserData() async {
    this.restoname = await FlutterSession().get("restoName");
    this.restoId = await FlutterSession().get('subscriptionId');
    this.location = await FlutterSession().get("address");
    bill = getBill();
  }

  @override
  void initState() {
    super.initState();
    setUserData();
  }

  @override
  Widget build(BuildContext context) {
    setOrderId(context);

    return Scaffold(
        appBar: AppBar(
          title: Text("Order Details"),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Center(
              child: Text(restoname,
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Center(
              child: Text(location),
            ),
            Divider(
              color: Colors.black,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Bill Number:$orderId'),
                  Text('Table No:$tableNo')
                ],
              ),
            ),
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
            Expanded(
              child: FutureBuilder(
                future: bill,
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Something went wrong"));
                  }
                  return ListView.builder(
                      padding: EdgeInsets.all(5),
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        String name = snapshot.data[index]['name'];
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
                                Text("${snapshot.data[index]['quantity']} ")
                              ]),
                              Column(children: [
                                Text("${snapshot.data[index]['Price']}")
                              ]),
                              Column(children: [
                                Text((int.parse(
                                            snapshot.data[index]['quantity']) *
                                        double.parse(
                                            snapshot.data[index]['Price']))
                                    .toString())
                              ]),
                            ]),
                          ],
                        );
                      });
                },
              ),
            ),
            Divider(
              color: Colors.black,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("TOTAL"),
                    ],
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(total_price.toString()),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
