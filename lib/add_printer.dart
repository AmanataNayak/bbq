import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';

class AddPrinter extends StatefulWidget {
  const AddPrinter({Key key}) : super(key: key);

  @override
  State<AddPrinter> createState() => _AddPrinterState();
}

class _AddPrinterState extends State<AddPrinter> {
  TextEditingController ip = TextEditingController();

  void set(String ip) {
    FlutterSession().set("ip", ip);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Printer"),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: ip,
              decoration: InputDecoration(
                  labelText: "Add Printer",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  )),
            ),
            TextButton(
                onPressed: () {
                  print(ip.text);
                  set(ip.text);
                },
                child: Text("Save"))
          ],
        ),
      )),
    );
  }
}
