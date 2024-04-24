import 'package:flutter/material.dart';

class InHouseOrder extends StatefulWidget {
  const InHouseOrder({Key key}) : super(key: key);

  @override
  State<InHouseOrder> createState() => _InHouseOrderState();
}

class _InHouseOrderState extends State<InHouseOrder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("Menu"),
        centerTitle: true,
      ),
      body: Column(
        children: [
            Container(  
                  margin: const EdgeInsets.all(20),  
                  child: Table(  
                    defaultColumnWidth: const FixedColumnWidth(120.0),  
                    border: TableBorder.all(  
                        color: Colors.black,  
                        style: BorderStyle.solid,  
                        width: 2),  
                    children: [  
                      TableRow( children: [  
                        Column(children: [Text('Order ID', style: TextStyle(fontSize: 20.0))]),  
                        Column(children:[Text('Accept', style: TextStyle(fontSize: 20.0))]),  
                        Column(children:[Text('Reject ', style: TextStyle(fontSize: 20.0))]),  
                      ]),  
                      TableRow( children: [  
                        Column(children:const [Text('1')]),  
                        Column(children:[IconButton(onPressed: (){}, icon: const Icon(Icons.call,color: Colors.green,)
                      ),]),  
                        Column(children:[ IconButton(onPressed: (){}, icon: const Icon(Icons.call_end,color: Colors.red,))]),  
                      ]),  
                      TableRow( children: [  
                        Column(children:[Text('2')]),  
                        Column(children:[
                            IconButton(onPressed: (){}, icon:   const   Icon(Icons.call,color: Colors.green,)
                            ),
                          ]),  
                        Column(children:[ IconButton(onPressed: (){}, icon: const Icon(Icons.call_end,color: Colors.red,))]),  
                      ]),  
                      TableRow( children: [  
                        Column(children:[
                          Text('3'),
                        ]),  
                        Column(children:[
                          IconButton(onPressed: (){}, icon: const   Icon(Icons.call,color: Colors.green,)
                          ),
                        ]),  
                        Column(children:[ IconButton(onPressed: (){}, icon: const Icon(Icons.call_end,color: Colors.red,))]),  
                      ]),  
                    ],  
                  ),  
                ),  
        ],
      ),
    );  
  }
}