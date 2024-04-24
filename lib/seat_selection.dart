import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'tabPage.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SeatSelection extends StatefulWidget {
  @override
  _SeatSelectionState createState() => _SeatSelectionState();
}

class _SeatSelectionState extends State<SeatSelection> {
  var uId;
  var uFirstName;
  var uLastName;
  String mobInput;
  var restoId;
  var outletId;
  var subscriptionId;
  TextEditingController mobNumber = new TextEditingController();
  Future<List<Tables>> tables;

  void setUserData() async {
    this.uId = await FlutterSession().get("uId");
    this.uFirstName = await FlutterSession().get("uFirstName");
    this.uLastName = await FlutterSession().get("uLastName");
    this.restoId = await FlutterSession().get("restaurantId");
    this.outletId = await FlutterSession().get("outletId");
    this.subscriptionId = await FlutterSession().get("subscriptionId");
    setState(() {
      tables = getSeat();
    });
  }

  Future<List<Tables>> getSeat() async {
    final response = await http.post(
        "https://www.buybyeq.com/bbq_server/PHPRest/api/menu/getSeat.php",
        body: {
          "rId": this.subscriptionId.toString(),
          "oId": this.outletId.toString(),
        });

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      var items = list.map((items) => Tables.fromJson(items)).toList();
      print(items);
      return items;
    } else {
      //print('Error!!');
      throw Exception('Failed to Load Post');
    }
  }

  Future deleteCart() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.remove('items');
    await prefs.remove('quantity');
    await prefs.remove('itemNames');
    await prefs.remove('price');
  }

  @override
  void initState() {
    super.initState();
    setUserData();
  }

  @override
  Widget build(BuildContext context) {
    deleteCart();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('SELECT SEAT'),
          ],
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              tables = getSeat();
            });
          },

          // onRefresh: (){},
          child: Column(
            children: [
              //RefreshIndicator(child: ListView(), onRefresh: getSeat),
              Expanded(
                child: FutureBuilder<List<Tables>>(
                  future: tables,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.length > 0) {
                        return GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3),
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () async {
                                    if (snapshot.data[index].status == '0') {
                                      /*FlutterSession().set(
                                        "tableId", snapshot.data[index].tableId);
                                    FlutterSession().set("waiterId",
                                        snapshot.data[index].waiterId);

                                    var result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MenuPage(
                                              uId: uId,
                                              uFirstName: uFirstName,
                                              uLastName: uLastName),
                                        ));
                                    if (true) {
                                      setState(() {
                                        tables = getSeat();
                                      });
                                    }*/
                                      FlutterSession().set("tableId",
                                          snapshot.data[index].tableId);
                                      FlutterSession().set("waiterId",
                                          snapshot.data[index].waiterId);
                                      // setState(() {
                                      //   mobInput = '';
                                      // });
                                      var result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => TabPage(
                                              uId: uId,
                                              uFirstName: uFirstName,
                                              uLastName: uLastName,
                                              restoId: subscriptionId,
                                              outletId: outletId,
                                              ind: 1,
                                            ),
                                          ));
                                      // await _openPopup(context);
                                      // FlutterSession().set("contactNo", mobInput);
                                      // if (mobInput.length > 9) {
                                      //   var result = await Navigator.push(
                                      //       context,
                                      //       MaterialPageRoute(
                                      //         builder: (context) => TabPage(

                                      //           uId: uId,
                                      //           uFirstName: uFirstName,
                                      //           uLastName: uLastName,
                                      //           restoId: restoId,
                                      //           outletId: outletId,
                                      //           ind: 1,
                                      //         ),
                                      //       ));
                                      if (result == null ||
                                          result == false ||
                                          result == true) {
                                        setState(() {
                                          tables = getSeat();
                                        });
                                      } else if (result == 'summary') {
                                        deleteCart();
                                        var result = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => TabPage(
                                                uId: uId,
                                                uFirstName: uFirstName,
                                                uLastName: uLastName,
                                                restoId: subscriptionId,
                                                outletId: outletId,
                                                ind: 3,
                                              ),
                                            ));
                                      }
                                      //       if (result == null ||
                                      //           result == false ||
                                      //           result == true) {
                                      //         setState(() {
                                      //           tables = getSeat();
                                      //         });
                                      //       } else if (result == 'summary') {
                                      //         var result = await Navigator.push(
                                      //             context,
                                      //             MaterialPageRoute(
                                      //               builder: (context) => TabPage(
                                      //                 uId: uId,
                                      //                 uFirstName: uFirstName,
                                      //                 uLastName: uLastName,
                                      //                 restoId: restoId,
                                      //                 outletId: outletId,
                                      //                 ind: 3,
                                      //               ),
                                      //             ));
                                      //         if (result == null ||
                                      //             result == false ||
                                      //             result == true) {
                                      //           setState(() {
                                      //             tables = getSeat();
                                      //           });
                                      //         }
                                      //       }
                                      //     }
                                      //   }
                                      // } else {
                                      //   FlutterSession().set("tableId",
                                      //       snapshot.data[index].tableId);
                                      //   FlutterSession().set("waiterId",
                                      //       snapshot.data[index].waiterId);
                                      //   var result = await Navigator.push(
                                      //       context,
                                      //       MaterialPageRoute(
                                      //         builder: (context) => TabPage(
                                      //           uId: uId,
                                      //           uFirstName: uFirstName,
                                      //           uLastName: uLastName,
                                      //           restoId: restoId,
                                      //           outletId: outletId,
                                      //           ind: 3,
                                      //         ),
                                      //       ));

                                      /*
                                    var result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MainUserOrderDetails(
                                                  tableNo: int.parse(snapshot
                                                      .data[index].tableId))),
                                    );
                                    if (result == null || result == false) {
                                      setState(() {
                                        tables = getSeat();
                                      });
                                    } else if (result == true) {
                                      var result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MainHome(
                                                tableId:
                                                    snapshot.data[index].tableId,
                                                waiterId: snapshot
                                                    .data[index].waiterId)),
                                      );
                                      if (result == null ||
                                          result == true ||
                                          result == false) {
                                        setState(() {
                                          tables = getSeat();
                                        });
                                      }
                                    } else if (result == 'cart') {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MainCart(
                                                tableId:
                                                    snapshot.data[index].tableId,
                                                waiterId: snapshot
                                                    .data[index].waiterId)),
                                      );
                                    }*/
                                    } else {
                                      FlutterSession().set("tableId",
                                          snapshot.data[index].tableId);
                                      FlutterSession().set("waiterId",
                                          snapshot.data[index].waiterId);
                                      var result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => TabPage(
                                              uId: uId,
                                              uFirstName: uFirstName,
                                              uLastName: uLastName,
                                              restoId: subscriptionId,
                                              outletId: outletId,
                                              ind: 3,
                                            ),
                                          ));
                                      if (result == null ||
                                          result == false ||
                                          result == true) {
                                        setState(() {
                                          tables = getSeat();
                                        });
                                      }
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                      color:
                                          (snapshot.data[index].status == '0')
                                              ? Colors.green
                                              : Color(0xFFf45123),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Text(
                                          snapshot.data[index].label.toString(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            });
                      } else {
                        return Container(
                          child: Center(
                            child: Text(
                                "You have to configure your account first!"),
                          ),
                        );
                      }
                    } else if (snapshot.hasError) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                              child: FittedBox(
                                  child: Text(
                            "Something wrong with our server.",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25),
                          ))),
                          Center(
                              child: Text("Try again Later.",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25)))
                        ],
                      );
                    }
                    //return Center(child: Text("Loading..."));
                    return Center(
                        child: CircularProgressIndicator(
                            //valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFf45123))
                            ));
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
