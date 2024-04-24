import 'package:flutter/material.dart';

class OnlineOrder extends StatefulWidget {
  const OnlineOrder({Key key}) : super(key: key);

  @override
  State<OnlineOrder> createState() => _OnlineOrderState();
}

class _OnlineOrderState extends State<OnlineOrder> {
  Widget display(String s) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Order ID: $s",
        ),
        const Text("Item List"),
        Row(
          children: [
            const Spacer(),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.call,
                  color: Colors.green,
                )),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.call_end,
                  color: Colors.red,
                ))
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("Online"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const Text(
            'SWIGGY',
            style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
          ),
          Divider(),
          display("1104"),
          Divider(),
          display("110412"),
          SizedBox(
            height: 100.0,
          ),
          Divider(
            height: 1.0,
            color: Colors.black,
          ),
          const Text(
            'ZOMATO',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          Divider(),
          display("20220"),
          Divider(),
          display("113204")
        ],
      ),
    );
  }
}
