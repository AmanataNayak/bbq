import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DailyUse extends StatefulWidget {
  const DailyUse({Key key}) : super(key: key);

  @override
  State<DailyUse> createState() => _DailyUseState();
}

class _DailyUseState extends State<DailyUse> {
  var dropdownvalue = 'Kilogram';
  var units = ['Kilogram', 'Gram', 'Liter', 'ml'];
  TextEditingController dateInput = TextEditingController();
  TextEditingController itemName = TextEditingController();
  TextEditingController usedQuantity = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('DAILY USE'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Center(
                  child: Text(
                "ADD USED ITEM DATA",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
              TextField(
                controller: itemName,
                decoration: InputDecoration(
                    labelText: 'ITEM NAME',
                    labelStyle: TextStyle(fontWeight: FontWeight.bold)),
              ),
              TextField(
                controller: usedQuantity,
                decoration: InputDecoration(
                    labelText: 'USED QUANTITY',
                    labelStyle: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 100, 0),
                    child: Text(
                      'Unit:',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  DropdownButton(
                    value: dropdownvalue,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: units.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    // After selecting the desired option,it will
                    // change button value to selected value
                    onChanged: (String newValue) {
                      setState(() {
                        dropdownvalue = newValue;
                      });
                    },
                  ),
                ],
              ),
              Center(
                  child: TextField(
                  controller: dateInput,
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
                    dateInput.text =
                        formattedDate;
                  });
                },
              )),
              Center(
                  child:ElevatedButton(
                    child: Text('SAVE'),
                    onPressed: (){},
                  )
              )
            ],
          ),
        ));
  }
}
