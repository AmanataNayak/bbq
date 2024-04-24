import 'package:flutter/material.dart';

class Stock extends StatefulWidget {
  const Stock({Key key}) : super(key: key);

  @override
  State<Stock> createState() => _StockState();
}

class _StockState extends State<Stock> {

  final Future<String> _calculation = Future<String>.delayed(
    const Duration(seconds: 2),
        () => 'Data Loaded',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PURCHASE HISTORY'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Color(0xFFBF360C),
              margin: EdgeInsets.fromLTRB(10, 5, 10, 0),
              child: Table(
                // defaultColumnWidth: FixedColumnWidth(52.0),
                border: TableBorder.all(
                    color: Colors.black, style: BorderStyle.solid, width: 2),
                children: [
                  TableRow(children: [
                    Column(children: [
                      Text('Item Name', style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white
                      ))
                    ]),
                    Column(children: [
                      Text('Unit', style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white
                      ))
                    ]),
                    Column(children: [
                      Text('Remaining Unit', style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white
                      ))
                    ]),
                  ]),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: _calculation,
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
                            // defaultColumnWidth: FixedColumnWidth(52.0),
                            border: TableBorder.all(
                              width: 1,
                              color: Colors.black,
                              style: BorderStyle.solid,
                            ),
                            children: [
                              TableRow(children: [
                                Column(children: [
                                  Text('R', style: TextStyle(fontSize: 20.0))
                                ]),
                                Column(children: [
                                  Text('I', style: TextStyle(fontSize: 20.0))
                                ]),
                                Column(children: [
                                  Text('C', style: TextStyle(fontSize: 20.0))
                                ]),
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
