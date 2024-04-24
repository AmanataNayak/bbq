import 'package:buybyeq/ItemReport.dart';
import 'package:buybyeq/add_printer.dart';
import 'package:buybyeq/daily_report.dart';
import 'package:buybyeq/order_report.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'admin_order_summary.dart';
import 'package:flutter_session/flutter_session.dart';
import 'inhouseOrder.dart';
import 'inventory.dart';
import 'login_page.dart';
import 'onlineOrder.dart';

class Tables {
  final String tableId;
  final String status;
  final String waiterId;
  final String label;

  Tables({this.tableId, this.status, this.waiterId, this.label});

  factory Tables.fromJson(Map<String, dynamic> json) {
    return Tables(
      tableId: json['TableId'],
      status: json['Status'],
      waiterId: json['WaiterId'],
      label: json['Label'],
    );
  }
}

class AdminDashboard extends StatefulWidget {
  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  Future<List<Tables>> tables;
  var uId;
  var uFirstName;
  var uLastName;
  String mobInput;
  var restoId;
  var outletId;
  var subscriptionId;
  bool showReport = false;
  Color drawer_text_color = Colors.black;
  String restoName;
  void setUserData() async {
    this.uId = await FlutterSession().get("uId");
    this.uFirstName = await FlutterSession().get("uFirstName");
    this.uLastName = await FlutterSession().get("uLastName");
    this.restoId = await FlutterSession().get("restaurantId");
    this.outletId = await FlutterSession().get("outletId");
    this.subscriptionId = await FlutterSession().get("subscriptionId");
    this.restoName = await FlutterSession().get("restoName");
    setState(() {
      tables = getSeat();
    });
  }

  Future<List<Tables>> getSeat() async {
    final response = await http.post("https://www.buybyeq.com/bbq_server/PHPRest/api/menu/getSeat.php", body: {
      "rId": this.subscriptionId.toString(),
      "oId": this.outletId.toString(),
    });

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      var items = list.map((items) => Tables.fromJson(items)).toList();
      return items;
    } else {
      //print('Error!!');
      throw Exception('Failed to Load Post');
    }
  }

  @override
  void initState() {
    super.initState();
    setUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  UserAccountsDrawerHeader(
                    currentAccountPicture: Image.asset('images/logo.png'),
                    accountName: Text(restoName),
                    // accountEmail: Text('amanatanaya@gmail.com'),
                  ),
                  ListTile(
                      leading: Icon(
                        Icons.print,
                        color: Colors.black,
                      ),
                      title: Text(
                        "Add Printer",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AddPrinter()));
                      }),
                  Divider(
                    color: Colors.black,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.note_outlined,
                    ),
                    title: Text(
                      "REPORTS",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      setState(() {
                        showReport = !showReport;
                      });
                    },
                  ),
                  showReport ? Divider(color: Colors.black) : Container(),
                  showReport
                      ? ListTile(
                          title: Text(
                            "Daily Report",
                            style: TextStyle(color: Colors.black),
                          ),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => DailyReport()));
                          })
                      : Container(),
                  // showReport
                  //     ? ListTile(
                  //         title: Text(
                  //           "Item Report",
                  //           style: TextStyle(color: Colors.black),
                  //         ),
                  //         onTap: () {
                  //           Navigator.push(
                  //               context,
                  //               MaterialPageRoute(
                  //                   builder: (context) => ItemReport()));
                  //         })
                  //     : Container(),
                  showReport
                      ? ListTile(
                          title: Text("Order Report", style: TextStyle(color: Colors.black)),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => OrderReport()));
                          })
                      : Container(),
                  Divider(color: Colors.black),
                  ListTile(
                    leading: Icon(
                      Icons.note_outlined,
                    ),
                    title: const Text('Online Orders', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => OnlineOrder()));
                    },
                  ),
                  /*ListTile(
                    leading: Icon(
                      Icons.note_outlined,
                    ),
                    title: const Text('In House Order', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => InHouseOrder()));
                    },
                  ),*/
                  ListTile(
                    leading: Icon(
                      Icons.note_outlined,
                    ),
                    title: const Text('Inventory', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Inventory()));
                    },
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ListTile(
                leading: Icon(
                  Icons.logout,
                  color: Colors.black,
                ),
                title: Text(
                  "Logout",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  FlutterSession().set("uId", 0);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => LoginPage(),
                    ),
                    (route) => false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('DASHBOARD'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              tables = getSeat();
            });
          },
          child: Column(
            children: [
              Expanded(
                child: FutureBuilder<List<Tables>>(
                  future: tables,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text(snapshot.error.toString()));
                    }
                    return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                if (snapshot.data[index].status != '0') {
                                  FlutterSession().set("tableId", snapshot.data[index].tableId);
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => AdminOrderSummary()));
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: (snapshot.data[index].status == '0') ? Colors.green : Color(0xFFf45123),
                                ),
                                child: Center(
                                  child: Text(
                                    snapshot.data[index].label.toString(),
                                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          );
                        });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
