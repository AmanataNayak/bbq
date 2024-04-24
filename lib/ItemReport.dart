import 'dart:convert';

import 'package:buybyeq/filter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ItemReport extends StatefulWidget {
  const ItemReport({Key key}) : super(key: key);

  @override
  State<ItemReport> createState() => _ItemReportState();
}

class _ItemReportState extends State<ItemReport> {
  List<String> categories = [];
  List<String> IDs = [];
  bool isFilter = true;
  var restoId;
  var outletId;
  String newVal = '';

  void setuserData() async {
    outletId = await FlutterSession().get("outletId");
    restoId = await FlutterSession().get('subscriptionId');
    getCategories();
  }

  Future getItemReport() async {
    final response = await http.post(
        "https://www.buybyeq.com/bbq_server/PHPRest/api/report/getItemReport.php",
        body: {'oId': outletId, 'sId': restoId});
    return json.decode(response.body);
  }

  Future getCategories() async {
    final response = await http.post(
        "https://www.buybyeq.com/bbq_server/PHPRest/api/menu/readCategory.php",
        body: {
          'rId': restoId,
          'oId': outletId,
        });
    List data = jsonDecode(response.body);
    setState(() {
      newVal = data[0]['CategoryId'];
    });
    for (int i = 0; i < data.length; i++) {
      categories.add(data[i]['CategoryName']);
      IDs.add(data[i]['CategoryId']);
    }
  }

  @override
  void initState() {
    super.initState();
    setuserData();
  }

  TableRow tableRow(
      String firstCol, String secondCol, String thirdCol, Color color) {
    return TableRow(children: [
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(children: [
          Text(
            firstCol,
            style: TextStyle(color: color),
          )
        ]),
      ),
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(children: [
          Text(
            secondCol,
            style: TextStyle(color: color),
          )
        ]),
      ),
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(children: [
          Text(
            thirdCol,
            style: TextStyle(color: color),
          )
        ]),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Item Report"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Filter(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButton(
                    // Initial Value
                    value: newVal,

                    // Down Arrow Icon
                    icon: const Icon(Icons.keyboard_arrow_down),

                    // Array list of items
                    items: categories.map((items) {
                      return DropdownMenuItem(
                        value: IDs[categories.indexOf(items)],
                        child: Text(items.toString()),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        newVal = newValue;
                      });
                    },
                  ),
                  TextButton(
                      style: TextButton.styleFrom(backgroundColor: Colors.blue),
                      onPressed: () {},
                      child: Text(
                        "Filter",
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              ),
            ),
            Container(
              color: Color(0xFFBF360C),
              margin: EdgeInsets.fromLTRB(10, 5, 10, 0),
              child: Table(
                border: TableBorder.all(
                  width: 1,
                  color: Colors.black,
                  style: BorderStyle.solid,
                ),
                children: [
                  tableRow('CATEGORY', 'ITEM NAME', 'QUANTITY', Colors.white)
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: getItemReport(),
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
                              tableRow(
                                  'CATEGORY',
                                  snapshot.data[index]['Name'],
                                  snapshot.data[index]['Quantity'],
                                  Colors.black),
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
