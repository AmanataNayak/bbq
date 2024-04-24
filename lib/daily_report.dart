import 'dart:convert';

import 'package:buybyeq/filter.dart';
import 'package:buybyeq/view_order_summary_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class DailyReport extends StatefulWidget {
  const DailyReport({Key key}) : super(key: key);

  @override
  State<DailyReport> createState() => _DailyReportState();
}

class _DailyReportState extends State<DailyReport> {
  var outletId;
  var restoId;
  Future orderReports;
  DateTime dateTimeStart;
  DateFormat formatterStart;
  String formattedStart = '';
  bool isData = false;
  DateTime dateTimeEnd;
  DateFormat formatterEnd;
  String formattedEnd = '';
  var isFiltered = false;

  void setuserData() async {
    outletId = await FlutterSession().get("outletId");
    restoId = await FlutterSession().get('subscriptionId');
    setState(() {
      orderReports = getDailyReport();
    });
  }

  String todayDate =
      (DateFormat('yyyy-MM-dd').format(DateTime.now())).toString();
  Future getDailyReport() async {
    print(todayDate);
    final response = await http.post(
        'https://www.buybyeq.com/bbq_server/PHPRest/api/report/getDailyReport.php',
        body: {'rId': restoId, 'orderDate': todayDate});
    print(json.decode(response.body).length);
    if (jsonDecode(response.body).length > 0) {
      setState(() {
        isData = true;
      });
    }

    return json.decode(response.body);
  }

  Padding child(String col, Color color) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(children: [
        Text(
          col == null ? 'Order not complete' : col,
          style: TextStyle(color: color),
        )
      ]),
    );
  }

  bool checkDate(String date) {
    if (formattedStart == '' && formattedEnd == '') {
      return false;
    } else {
      if (DateTime.parse(date).isAfter(DateTime.parse(formattedStart)) &&
          DateTime.parse(date).isBefore(DateTime.parse(formattedEnd))) {
        return true;
      } else {
        return false;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    setuserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DAILY REPORT"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     ElevatedButton.icon(
            //       onPressed: () {
            //         showDatePicker(
            //                 context: context,
            //                 initialDate: dateTimeStart == null
            //                     ? DateTime.now()
            //                     : dateTimeStart,
            //                 firstDate: DateTime(2001),
            //                 lastDate: DateTime(2029))
            //             .then((date) {
            //           setState(() {
            //             dateTimeStart = date;
            //             formatterStart = DateFormat('yyyy-MM-dd');
            //             formattedStart = formatterStart.format(dateTimeStart);
            //           });
            //         });
            //       },
            //       icon: Icon(
            //         Icons.calendar_today_outlined,
            //         color: Colors.white,
            //       ),
            //       label: Text(dateTimeStart == null
            //           ? 'Pick start date'
            //           : formattedStart),
            //     ),
            //     SizedBox(
            //       width: 10,
            //     ),
            //     ElevatedButton.icon(
            //       onPressed: () {
            //         showDatePicker(
            //                 context: context,
            //                 initialDate: dateTimeEnd == null
            //                     ? DateTime.now()
            //                     : dateTimeEnd,
            //                 firstDate: DateTime(2001),
            //                 lastDate: DateTime(2029))
            //             .then((date) {
            //           dateTimeEnd = date;
            //           formatterEnd = DateFormat('yyyy-MM-dd');
            //           setState(() {
            //             formattedEnd = formatterEnd.format(dateTimeEnd);
            //           });
            //         });
            //       },
            //       label: Text(
            //           dateTimeEnd == null ? 'Pick end date' : formattedEnd),
            //       icon: Icon(
            //         Icons.calendar_today_outlined,
            //         color: Colors.white,
            //       ),
            //     ),
            //     Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: TextButton(
            //           style: TextButton.styleFrom(backgroundColor: Colors.blue),
            //           onPressed: () {
            //             setState(() {
            //               isFiltered = true;
            //             });
            //           },
            //           child: Text(
            //             "Filter",
            //             style: TextStyle(color: Colors.white),
            //           )),
            //     ),
            //   ],
            // ),
            isData
                ? Container(
                    color: Color(0xFFBF360C),
                    margin: EdgeInsets.fromLTRB(10, 5, 10, 0),
                    child: Table(
                      border: TableBorder.all(
                        width: 1,
                        color: Colors.black,
                        style: BorderStyle.solid,
                      ),
                      children: [
                        TableRow(children: [
                          child('ORDER ID', Colors.white),
                          child('ORDER TYPE', Colors.white),
                          child('TABLE NO', Colors.white),
                          child('TOTAL AMOUNT', Colors.white),
                        ])
                      ],
                    ),
                  )
                : Center(
                    child: Text(
                      'No Order Placed Today',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    ),
                  ),
            Expanded(
              child: FutureBuilder(
                future: orderReports,
                builder: (context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text("Something went wrong"),
                    );
                  }
                  // else if (isFiltered) {
                  //   if (snapshot.data.length > 0) {
                  //     return Container(
                  //       margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  //       child: ListView.builder(
                  //           itemCount: snapshot.data.length,
                  //           itemBuilder: (context, index) {
                  //             snapshot.data[index]['OrderDate'] = snapshot
                  //                 .data[index]['OrderDate']
                  //                 .substring(0, 10);
                  //             if (checkDate(
                  //               snapshot.data[index]['OrderDate'],
                  //             )) {
                  //               return Table(
                  //                 border: TableBorder.all(
                  //                   width: 1,
                  //                   color: Colors.black,
                  //                   style: BorderStyle.solid,
                  //                 ),
                  //                 children: [
                  //                   TableRow(children: [
                  //                     child(snapshot.data[index]['OrderDate'],
                  //                         Colors.black),
                  //                     child(snapshot.data[index]['OrderId'],
                  //                         Colors.black),
                  //                     child(
                  //                         snapshot.data[index]['TotalAmount'] ==
                  //                                 null
                  //                             ? 'NULL'
                  //                             : snapshot.data[index]
                  //                                 ['TotalAmount'],
                  //                         Colors.black),
                  //                     Padding(
                  //                       padding: const EdgeInsets.all(8.0),
                  //                       child: TextButton(
                  //                         style: TextButton.styleFrom(
                  //                             backgroundColor: Colors.blue),
                  //                         onPressed: () {
                  //                           Navigator.push(
                  //                               context,
                  //                               MaterialPageRoute(
                  //                                   settings: RouteSettings(
                  //                                       arguments:
                  //                                           snapshot.data[index]
                  //                                               ['OrderId']),
                  //                                   builder: (context) =>
                  //                                       ViewOrderSummary()));
                  //                         },
                  //                         child: Text('VIEW'),
                  //                       ),
                  //                     )
                  //                   ])
                  //                 ],
                  //               );
                  //             } else {
                  //               return Container();
                  //             }
                  //           }),
                  //     );
                  //   }
                  //}
                  else if (snapshot.data == 0) {
                    Center(child: Text('No Order Is Placed Today'));
                  }
                  return Container(
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return Table(
                            border: TableBorder.all(
                              width: 1,
                              color: Colors.black,
                              style: BorderStyle.solid,
                            ),
                            children: [
                              TableRow(children: [
                                child(snapshot.data[index]['orderId'],
                                    Colors.black),
                                child(snapshot.data[index]['orderType'],
                                    Colors.black),
                                child(snapshot.data[index]['tableNo'],
                                    Colors.black),
                                child(snapshot.data[index]['totalAmount'],
                                    Colors.black),
                              ])
                            ],
                          );
                        }),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
