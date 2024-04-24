import 'dart:io';
import 'package:buybyeq/bill_screen.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_session/flutter_session.dart';
import 'package:intl/intl.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:whatsapp_share/whatsapp_share.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class AdminOrderSummary extends StatefulWidget {
  @override
  State<AdminOrderSummary> createState() => _AdminOrderSummaryState();
}

class _AdminOrderSummaryState extends State<AdminOrderSummary> {
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
  String restoname;
  String address;
  var subscriptionId;
  double total_price = 0;
  double GST = 0.0;
  List orders = [];
  String message;
  String mobileNo;
  String ip;
  bool isChecked = true;
  String date =
      "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year} ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second} ";
  TextEditingController _textFieldController = new TextEditingController();
  File file;

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
        genBill(orders);
        return orders;
      } else {
        return null;
      }
    } else {
      //print('method Error!!');
      throw Exception('Failed to Load');
    }
  }

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
      var sendResult = await WhatsappShare.share(
        text: "Thank you for visiting $restoname\n $address \n $message",
        linkUrl: '',
        phone: "91$mobileNo",
      );
      if (!sendResult) {
        _openPopup(context, "Can not share bill right now. Try again later");
      }
    } else {
      _openPopup(context, "Can not share bill right now. Try again later");
    }
  }

  Future<void> sendBill(path) async {
    final val = await WhatsappShare.isInstalled(package: Package.whatsapp);
    final val2 =
        await WhatsappShare.isInstalled(package: Package.businessWhatsapp);
    if (val || val2) {
      // _createPDF(path);
      shareWhatsapp();
    } else {
      _openPopup(context, 'Whatsapp not installed');
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
    this.restoname = await FlutterSession().get("restoName");
    this.address = await FlutterSession().get("address");
    this.ip = await FlutterSession().get("ip");
    order = getOrder();
  }

  Widget tableRow(BuildContext context, String text) {
    return Column(
      children: [
        Text(text),
      ],
    );
  }

  void testReceipt(NetworkPrinter printer) {
    printer.text('$restoname',
        styles: PosStyles(align: PosAlign.center, bold: true));
    printer.text('$address', styles: PosStyles(align: PosAlign.center));
    // printer.text('Tel: 1234569871', styles: PosStyles(align: PosAlign.center));
    // printer.text('Web: buybyeq@gmail.com',
    //     styles: PosStyles(align: PosAlign.center));
    printer.hr(ch: '-');
    printer.row([
      PosColumn(
          text: 'Bill Number: $oId',
          width: 4,
          styles: PosStyles(align: PosAlign.left)),
      PosColumn(
        text: 'Date: $date',
        width: 6,
        styles: PosStyles(align: PosAlign.right),
      ),
    ]);
    printer.text("Table No: $tableId",
        styles: PosStyles(align: PosAlign.center));
    printer.hr(ch: '-');
    printer.row([
      PosColumn(
        text: 'Item',
        width: 4,
        styles: PosStyles(align: PosAlign.left, underline: true),
      ),
      PosColumn(
        text: 'Qty',
        width: 2,
        styles: PosStyles(align: PosAlign.center, underline: true),
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

    for (int i = 0; i < orders.length; i++) {
      printer.row([
        PosColumn(
          text: orders[i].name,
          width: 4,
          styles: PosStyles(align: PosAlign.left, underline: true),
        ),
        PosColumn(
          text: orders[i].counter,
          width: 2,
          styles: PosStyles(align: PosAlign.center, underline: true),
        ),
        PosColumn(
          text: orders[i].price,
          width: 4,
          styles: PosStyles(align: PosAlign.center, underline: true),
        ),
        PosColumn(
          text: (double.parse(orders[i].price) * int.parse(orders[i].counter))
              .toString(),
          width: 2,
          styles: PosStyles(align: PosAlign.center, underline: true),
        ),
      ]);
    }
    printer.text("TOTAL:$total_price",
        styles: PosStyles(align: PosAlign.right));
    printer.text("GST:$GST", styles: PosStyles(align: PosAlign.right));
    printer.text("GRAND TOTAL:${(total_price + (total_price * GST / 100))}",
        styles: PosStyles(align: PosAlign.right));
    printer.text('Thank you!', styles: PosStyles(align: PosAlign.center));
    printer.feed(2);
    printer.cut();
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
                  GST = 0;
                  total_price = 0;
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
      temp = temp +
          'Total(inclusive tax): ' +
          (isChecked
              ? (total_price + (total_price * GST / 100)).toString()
              : total_price.toString());
    }
    setState(() {
      message = temp;
    });
  }

  void _createPDF(path) {
    //Create a PDF document.
    PdfDocument document = PdfDocument();
    PdfPage page = document.pages.add();

    PdfLayoutResult layoutResult = PdfTextElement(
            text: "Here Your order Details\n$message",
            font: PdfStandardFont(PdfFontFamily.helvetica, 12),
            brush: PdfSolidBrush(PdfColor(0, 0, 0)))
        .draw(
            page: page,
            bounds: Rect.fromLTWH(
                0, 0, page.getClientSize().width, page.getClientSize().height),
            format: PdfLayoutFormat(layoutType: PdfLayoutType.paginate));
    page.graphics.drawLine(
        PdfPen(PdfColor(255, 0, 0)),
        Offset(0, layoutResult.bounds.bottom + 10),
        Offset(page.getClientSize().width, layoutResult.bounds.bottom + 10));
    var bytes = document.save();
    document.dispose();
    setState(() {
      file = File('$path/Output.pdf');
    });
//Write PDF data
    // await file.writeAsBytes(document.save(), flush: true);
    file.writeAsBytes(bytes, flush: true);
    // document.dispose();
  }

  Padding bottomButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            // decoration: BoxDecoration(color: Colors.blue.shade300),
            child: ElevatedButton(
              onPressed: () async {
                const PaperSize paper = PaperSize.mm80;
                final profile = await CapabilityProfile.load();
                final printer = NetworkPrinter(paper, profile);

                final PosPrintResult res =
                    await printer.connect(ip, port: 9100);
                if (res == PosPrintResult.success) {
                  testReceipt(printer);
                  printer.disconnect();
                }
              },
              style: ElevatedButton.styleFrom(
                  primary: Colors.lightGreen,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0))),
              child: Text(
                'Printer',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
          Container(
            child: ElevatedButton(
              onPressed: () async {
                Directory directory = await getApplicationDocumentsDirectory();
                print("Direcory is $directory");
                String path = directory.path;
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('TextField AlertDemo'),
                      content: TextField(
                        keyboardType: TextInputType.number,
                        controller: _textFieldController,
                        decoration:
                            InputDecoration(hintText: "TextField in Dialog"),
                      ),
                      actions: [
                        TextButton(
                          child: new Text('SUBMIT'),
                          onPressed: () {
                            setState(() {
                              mobileNo = _textFieldController.text;
                            });
                            sendBill(path);
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                  primary: Colors.lightGreen,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0))),
              child: Text(
                'Share on Wp',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                ),
              ),
            ),
          )
        ],
      ),
    );
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
        title: Text('ORDER INFO'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Center(child: Text("$"),),
            Flexible(
              flex: 2,
              child: FutureBuilder<dynamic>(
                builder: (context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  }
                  return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        String name = snapshot.data[index].name;
                        if (name.length > 30) {
                          name = name.substring(0, 30);
                        }
                        // print(snapshot.data[index].orderDetailsId);
                        return GestureDetector(
                          onTap: () {
                            _showDeleteDialog(
                                name, snapshot.data[index].orderDetailsId);
                          },
                          child: Container(
                            height: 50.0,
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            decoration: BoxDecoration(
                              //color: Colors.grey.shade300,
                              border: Border.all(color: Colors.grey),
                            ),
                            child: ListTile(
                              title: Text(
                                  "${snapshot.data[index].counter} * $name"),
                              trailing: Text((int.parse(
                                          snapshot.data[index].counter) *
                                      double.parse(snapshot.data[index].price))
                                  .toString()),
                            ),
                          ),
                        );
                      });
                },
                future: order,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("GST "),
                  Checkbox(
                      value: isChecked,
                      onChanged: (bool value) {
                        setState(() {
                          isChecked = value;
                        });
                      }),
                  Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("TOTAL"),
                      Text("GST % "),
                      Text("GRAND TOTAL"),
                    ],
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(total_price.toString()),
                      Text(isChecked ? (GST).toString() : '0'),
                      Text(isChecked
                          ? (total_price + (total_price * GST / 100)).toString()
                          : total_price.toString()),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              //decoration: BoxDecoration(color: Colors.blue.shade300),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BillScreen(),
                        settings: RouteSettings(arguments: isChecked)),
                  );
                },
                style: ElevatedButton.styleFrom(
                    primary: Colors.lightGreen,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0))),
                child: Text(
                  'Settle Bill',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
            bottomButtons(),
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
