import 'package:buybyeq/add_item.dart';
import 'package:buybyeq/daily_use.dart';
import 'package:buybyeq/daily_used_items.dart';
import 'package:buybyeq/purchaseEntry.dart';
import 'package:buybyeq/purchase_history.dart';
import 'package:buybyeq/stock.dart';
import 'package:flutter/material.dart';

class Inventory extends StatefulWidget {
  const Inventory({Key key}) : super(key: key);

  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(children: [
          Padding(padding: EdgeInsets.fromLTRB(0, 60, 0, 0)),
          ListTile(
            title: Center(
                child: Text(
              'ADD ITEM',
              style: TextStyle(color: Colors.black),
            )),
            onTap: (){
              Navigator.push(
                  context,MaterialPageRoute(builder: (context)=> AddItem()
              ));
            },
          ),
          ListTile(
            title: Center(
                child: Text(
              'PURCHASE ENTRY',
              style: TextStyle(color: Colors.black),
            )),
            onTap: (){
              Navigator.push(
                context,MaterialPageRoute(builder: (context)=> PurchaseEntry()
              ));
            },
          ),
          ListTile(
            title: Center(
                child: Text(
              'DAILY USE',
              style: TextStyle(color: Colors.black),
            )),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => DailyUse()));
            },
          ),
          ListTile(
            title: Center(
                child: Text(
              'PURCHASE HISTORY',
              style: TextStyle(color: Colors.black),
            )),
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (
                          context)=> PurchaseHistory()
                  )
              );
            },
          ),
          ListTile(
            title: Center(
                child: Text(
              'STOCK',
              style: TextStyle(color: Colors.black),
            )),
            onTap: (){
              Navigator.push(
                context,
              MaterialPageRoute(builder: (context)=>Stock()
              ));
            },
          ),
          // ListTile(
          //   title: Center(
          //       child: Text(
          //     'FIXED ASSETS',
          //     style: TextStyle(color: Colors.black),
          //   )),
          // ),
          ListTile(
            title: Center(
                child: Text(
              'DAILY USED ITEM REPORT',
              style: TextStyle(color: Colors.black),
            )),
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context)=>DailyUsedItems())
              );
            },
          ),
        ]),
      ),
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("Inventory"),
        centerTitle: true,
      ),
      body: Column(
        children: const [
          Center(
            child: Text(
              "INVENTORY",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
