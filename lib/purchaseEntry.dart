import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PurchaseEntry extends StatefulWidget {
  const PurchaseEntry({Key key}) : super(key: key);

  @override
  State<PurchaseEntry> createState() => _PurchaseEntryState();
}

class _PurchaseEntryState extends State<PurchaseEntry> {
  var itemCategory='DAIRY';
  var itemCategories=['DAIRY','MILK'];
  var vendor='RELIANCE';
  var vendors=['RELIANCE','TATA'];
  var itemName='MILK';
  var itemNames=['MILK','CHOCOLATE'];
  var itemUnit='KG';
  var itemUnits=['KG','G','L','ml'];


  TextEditingController date=TextEditingController();
  Widget input(String label){
    return TextField(
      decoration: InputDecoration(
        labelText: label
      ),
    );
  }
  Padding child(String col, Color color) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(children: [
        Text(
          col,
          style: TextStyle(color: color),
        )
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Purchase Entry"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: Text(
                'ADD PURCHASE ITEM DATA',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            input('RECEIPT NUMBER'),
            Row(
              children: [
                Text('ITEM CATEGORY',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                SizedBox(
                  width: 60,
                ),
                DropdownButton(
                  value:itemCategory,
                  items: itemCategories.map((String category){
                    return DropdownMenuItem(
                      value:category,
                      child: Text(category),
                    );
                  }).toList(),
                ),
              ],
            ),
            Row(
              children: [
                Text('VENDOR NAME',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                SizedBox(
                  width: 63,
                ),
                DropdownButton(
                  value:vendor,
                  items: vendors.map((String category){
                    return DropdownMenuItem(
                      value:category,
                      child: Text(category),
                    );
                  }).toList(),
                ),
              ],
            ),
            Row(
              children: [
                Text('ITEM NAME',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                SizedBox(
                  width: 90,
                ),
                DropdownButton(
                  value:itemName,
                  items: itemNames.map((String category){
                    return DropdownMenuItem(
                      value:category,
                      child: Text(category),
                    );
                  }).toList(),
                ),
              ],
            ),
            Row(
              children: [
                Text('ITEM UNITS',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                SizedBox(
                  width: 90,
                ),
                DropdownButton(
                  value:itemUnit,
                  items: itemUnits.map((String category){
                    return DropdownMenuItem(
                      value:category,
                      child: Text(category),
                    );
                  }).toList(),
                ),
              ],
            ),
            input('ITEM UNIT PRICE'),
            input('PURCHASE QUANTITY'),
            input('PURCHASE PRICE'),
            Center(
                child: TextField(
                  controller: date,
                  decoration: InputDecoration(
                      icon: Icon(Icons.calendar_today),
                      labelText: "DATE"),
                  readOnly: true,
                  onTap: () async {
                    DateTime pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2022),
                        lastDate: DateTime(
                            2100));
                    String formattedDate =
                    DateFormat('yyyy-MM-dd').format(pickedDate);
                    setState(() {
                      date.text =
                          formattedDate;
                    });
                  },
                )),
            Center(
              child:ElevatedButton(
                child: Text('SAVE'),
                onPressed: (){
                  Navigator.pop(context);
                },
              )
            )
          ],
        ),
      ),
    );
  }
}
