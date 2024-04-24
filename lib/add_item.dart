import 'package:flutter/material.dart';

class AddItem extends StatefulWidget {
  const AddItem({Key key}) : super(key: key);

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  TextEditingController name=TextEditingController();
  TextEditingController quantity=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ADD ITEM'),
        centerTitle: true,
      ),
      body:SafeArea(
        child: Column(
          children: [
            TextField(
              controller: name,
              decoration: InputDecoration(
                labelText: 'Enter the item name '
              ),
            ),
            TextField(
              controller: quantity,
              decoration: InputDecoration(
                  labelText: 'Enter the quantity '
              ),
            )
          ],
        ),
      ),
    );
  }
}
