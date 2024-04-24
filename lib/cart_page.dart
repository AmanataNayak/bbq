import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'user_order_summary.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  var uId;
  var tableId = '0';
  var waiterId;
  var uFirstName;
  var uLastName;
  var contactNo;
  var progressStatus = "Stop";
  int _bottomNavBarIndex;
  Future<List<CartItems>> cart;
  int orderTotal = 0;
  int dataCheck = 0;
  var subscriptionId;

  // void decrement(AsyncSnapshot snapshot, int index) {
  //   setState(() {
  //     snapshot.data[index].counter =
  //         (int.parse(snapshot.data[index].counter) - 1).toString();
  //   });
  // }

  // void increment(AsyncSnapshot snapshot, int index) {
  //   setState(() {
  //     snapshot.data['quantity'][index] =
  //         (int.parse(snapshot.data['quantity'][index]) + 1).toString();
  //   });
  // }

  // Future<dynamic> addToCart(
  //     int uId, String iId, int quantity, String tId) async {
  //   if (true) {
  //     final response = await http.post(
  //         "https://www.buybyeq.com/bbq_server/PHPRest/api/cart/add.php",
  //         body: {
  //           "uId": uId.toString(),
  //           "iId": iId.toString(),
  //           "iQuantity": quantity.toString(),
  //           "tId": tId.toString(),
  //         });
  //     // //print(response.body);
  //     return 1;
  //   }
  // }

  Future addNewToCart(int uId, List<String> iId, List<String> quantity,
      List<String> names, List<String> prices, String tableId) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('items', iId);
    await prefs.setStringList('quantity', quantity);
    await prefs.setStringList('itemNames', names);
    await prefs.setStringList('price', prices);
  }

  // Future<dynamic> delFromCart(
  //     String uId, String iId, int quantity, String tId) async {
  //   if (true) {
  //     final response = await http.post(
  //         "https://www.buybyeq.com/bbq_server/PHPRest/api/cart/del.php",
  //         body: {
  //           "uId": uId.toString(),
  //           "iId": iId.toString(),
  //           "iQuantity": quantity.toString(),
  //           "tId": tId.toString(),
  //         });
  //     return 1;
  //   }
  // }

  Future<List<CartItems>> getCartItems(String tId, String uId) async {
    final response = await http.post(
        "https://www.buybyeq.com/bbq_server/PHPRest/api/cart/readCart.php",
        body: {
          "tId": tId.toString(),
          "uId": uId,
        });
    // //print(response.body);
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);

      var items = list.map((items) => CartItems.fromJson(items)).toList();
      if (items.length > 0) {
        var sum = 0;
        for (int l = 0; l < items.length; l++) {
          sum = sum + (int.parse(items[l].counter) * int.parse(items[l].price));
        }
        setState(() {
          dataCheck = 1;
          orderTotal = sum;
        });
      } else {
        setState(() {
          dataCheck = 0;
        });
      }
      return items;
    } else {
      // //print('method Error!!');
      throw Exception('Failed to Load');
    }
  }

  Future<dynamic> addToOrder(int uId, var tId) async {
    setState(() {
      progressStatus = 'Start';
    });
    String iId;
    String quantity;
    String price;

    for (int i = 0; i < map['items'].length; i++) {
      if (i == 0) {
        iId = map['items'][0];
        quantity = map['quantity'][0];
        price = map['price'][0];
      } else {
        iId += "," + map['items'][i];
        quantity += "," + map['quantity'][i];
        price += "," + map['price'][i];
      }
    }
    var waiterId = waiters['id'][waiters['name'].indexOf(dropDownValue) - 1];
    if (true) {
      final response = await http.post(
          "https://www.buybyeq.com/bbq_server/PHPRest/api/order/addOrder.php",
          body: {
            "uId": uId.toString(),
            "tableId": tId.toString(),
            "iId": iId,
            "iQuantity": quantity,
            "iPrice": price,
            "rId": subscriptionId,
            "orderId": "",
            "waiterId": waiterId
            // "waiterId": waiters['id'][waiters['name'].indexOf(dropDownValue)],
          });
      setState(() {
        progressStatus = 'Stop';
      });
      //print(price);
      //print("End");
      if (response.statusCode == 200) {
        return true;
      }
    }
  }

  /*void _onItemTap(int index) async {
    if (tableId == '0') {
      if (index == 0) {
        Navigator.pop(context);
      } else if (index == 2) {
        var result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MainUserOrderDetails(
                  tableNo: int.parse(tableId),
                  uId: uId,
                  uFirstName: uFirstName,
                  uLastName: uLastName)),
        );
        if (result == false) {
          Navigator.pop(context, false);
        }
      }
    } else {
      if (index == 0) {
        Navigator.pop(context, false);
      } else if (index == 1) {
        Navigator.pop(context);
      } else if (index == 3) {
        var result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MainUserOrderDetails(
                  tableNo: int.parse(tableId),
                  uId: uId,
                  uFirstName: uFirstName,
                  uLastName: uLastName)),
        );
        if (result == false) {
          Navigator.pop(context, false);
        } else if (result == true) {
          Navigator.pop(context);
        }
      }
    }
  }*/

  void updateUserData(dynamic uId, dynamic uFirstName, dynamic uLastName,
      dynamic tableId, dynamic waiterId) {
    this.uId = uId;
    this.uLastName = uLastName;
    this.uFirstName = uFirstName;
    this.tableId = tableId;
    this.waiterId = waiterId;
  }

  Padding tblNo() {
    if (tableId != '0') {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          height: 70.0,
          decoration: BoxDecoration(
            color: Colors.deepOrangeAccent,
          ),
          child: Center(
            child: Text(
              'You are currently serving at Table No : ' + tableId.toString(),
              style: TextStyle(
                  fontSize: 19,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(4.0),
      );
    }
  }

  List<BottomNavigationBarItem> bottomNav() {
    if (tableId == '0') {
      setState(() {
        _bottomNavBarIndex = 1;
      });
      return [
        BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: 'Menu'),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Cart',
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.playlist_add_check), label: 'Order')
      ];
    } else {
      setState(() {
        _bottomNavBarIndex = 2;
      });
      return [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: 'Menu'),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Cart',
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.playlist_add_check), label: 'Order')
      ];
    }
  }

  void setUserData() async {
    this.uId = await FlutterSession().get("uId");
    this.tableId = await FlutterSession().get("tableId");
    this.waiterId = await FlutterSession().get("waiterId");
    this.uFirstName = await FlutterSession().get("uFirstName");
    this.uLastName = await FlutterSession().get("uLastName");
    this.contactNo = await FlutterSession().get("contactNo");
    this.subscriptionId = await FlutterSession().get("subscriptionId");
    cart = getCartItems(tableId, uId.toString());
    //category = getCategories();
    //items = getMenuItems(uId);
  }

  List<dynamic> waiterNames = ['Waiter Name'];
  String dropDownValue = "Waiter Name";
  TextEditingController mobileNo = TextEditingController();

  Map waiters;
  Future getWaitersName() async {
    final res = await http.post(
        Uri.parse(
            "https://www.buybyeq.com/bbq_server/PHPRest/api/menu/getWaiter.php"),
        body: {
          'rId': subscriptionId,
        });
    //print(jsonDecode(res.body));
    // return jsonDecode(res.body);
    //
    final waiter = jsonDecode(res.body);
    List waiterList = [
      waiterNames[0],
    ];
    List waiterId = [];
    for (int i = 0; i < waiter.length; i++) {
      waiterList.add(waiter[i]['UserFirstName']);
      waiterId.add(waiter[i]['UserId']);
    }
    waiters = {'name': waiterList, 'id': waiterId};
    return waiters;
  }

  Map map;

  Future getToCart() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> items = prefs.getStringList('items');
    final List<String> quantity = prefs.getStringList('quantity');
    final List<String> names = prefs.getStringList('itemNames');
    final List<String> prices = prefs.getStringList('price');
    setState(() {
      map = {
        'name': names,
        'items': items,
        'quantity': quantity,
        'price': prices
      };
    });
  }

  Future<void> _showDeleteDialog(String msg) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('AlertDialog Title'),
          content: Text(msg),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Ok', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Widget getCartList() {
    if (map != null) {
      if (map['name'] != null) {
        return Expanded(
            child: ListView.builder(
                itemCount: map['name'].length,
                itemBuilder: (context, index) {
                  String name = map['name'][index];

                  if (name.length > 20) {
                    name = name.substring(0, 20) + "...";
                  }
                  return Dismissible(
                    key: ValueKey(map['items'][index]),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.redAccent,
                      child:
                          Icon(Icons.delete, color: Colors.white, size: 30.0),
                      padding: const EdgeInsets.all(8.0),
                      margin: const EdgeInsets.all(8.0),
                    ),
                    onDismissed: (direction) {
                      setState(() {
                        map['quantity'].removeAt(index);
                        map['name'].removeAt(index);
                        map['price'].removeAt(index);
                        map['items'].removeAt(index);
                      });

                      addNewToCart(uId, map['items'], map['quantity'],
                          map['name'], map['price'], tableId);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(15)),
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        style: TextStyle(fontSize: 17),
                                      ),
                                      Text("Rs. " + map['price'][index]),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                Row(children: [
                                  Builder(
                                    builder: (BuildContext context) {
                                      if (int.parse(map['quantity'][index]) >
                                          1) {
                                        return IconButton(
                                            onPressed: () {
                                              setState(() {
                                                map['quantity'][index] =
                                                    (int.parse(map['quantity']
                                                                [index]) -
                                                            1)
                                                        .toString();
                                              });
                                              addNewToCart(
                                                  uId,
                                                  map['items'],
                                                  map['quantity'],
                                                  map['name'],
                                                  map['price'],
                                                  tableId);
                                            },
                                            icon: Icon(Icons.remove));
                                      } else {
                                        return Container();
                                      }
                                    },
                                  ),
                                  Text(map['quantity'][index]),
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          //print(map['quantity'][index]);
                                          map['quantity'][index] = (int.parse(
                                                      map['quantity'][index]) +
                                                  1)
                                              .toString();
                                        });
                                        addNewToCart(
                                            uId,
                                            map['items'],
                                            map['quantity'],
                                            map['name'],
                                            map['price'],
                                            tableId);
                                      },
                                      icon: Icon(Icons.add)),
                                ]),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }));
      } else {
        return Expanded(
            child: Center(
                child: Text(
          "No Item Selected",
          style: TextStyle(fontSize: 25),
        )));
      }
    } else {
      return Expanded(
          child: Center(
              child: Text(
        "No Item Selected",
        style: TextStyle(fontSize: 25),
      )));
    }
  }

  @override
  void initState() {
    super.initState();
    setUserData();
    getToCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text('CART'),
        ),
      ),
      body: SafeArea(
        child: Column(children: [
          tblNo(),
          FutureBuilder(
              future: getWaitersName(),
              builder: (context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                }
                return DropdownButton(
                  isExpanded: true,
                  value: dropDownValue,
                  icon: const Icon(Icons.arrow_drop_down),
                  iconSize: 30,
                  elevation: 16,
                  style: const TextStyle(color: Colors.black),
                  onChanged: (String newValue) {
                    setState(() {
                      dropDownValue = newValue;
                    });
                  },
                  items: snapshot.data['name']
                      .map<DropdownMenuItem<String>>((value) {
                    return DropdownMenuItem<String>(
                      // onTap: (){
                      //   setState(() {
                      //     waiterId=snapshot.data['id'][snapshot.data['name'].indexOf(value)];
                      //   });
                      //   //print(waiterId);
                      // },
                      value: value,
                      child: Center(
                          child: Text(value, style: TextStyle(fontSize: 20))),
                    );
                  }).toList(),
                );
              }),
          SizedBox(
            height: 10,
          ),
          // TextField(
          //   controller: mobileNo,
          //   keyboardType: TextInputType.number,
          //   decoration: InputDecoration(
          //     labelText: 'Enter Customer Mobile Number',
          //   ),
          // ),
          getCartList(),
          // Container(
          //   width: 200,
          //   height: 50.0,
          //   margin: EdgeInsets.only(bottom: 5.0),
          //   decoration: BoxDecoration(
          //     color: Color(0xFFf45123),
          //     borderRadius: BorderRadius.circular(20.0),
          //   ),
          //   child: Center(
          //       child: Text(
          //     'Place Order',
          //     style: TextStyle(
          //         fontWeight: FontWeight.bold,
          //         color: Colors.white,
          //         fontSize: 20.0),
          //   )),
          // ),

          /*GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 200,
                      height: 50.0,
                      margin: EdgeInsets.only(bottom: 5.0),
                      decoration: BoxDecoration(
                        color: Color(0xFFf45123),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Center(
                          child: Text(
                        'Add more items',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20.0),
                      )),
                    ),
                  ),*/
        ]),
      ),
      floatingActionButton: SizedBox(
        width: 200.0,
        child: FloatingActionButton.extended(
          onPressed: () async {
            if (dropDownValue != 'Waiter Name') {
              if (map['items'] == null) {
                _showDeleteDialog("Add Item first");
              } else {
                await addToOrder(uId, tableId);
                Navigator.pop(context, "summary");
              }
            } else {
              _showDeleteDialog("Select Waiter First");
            }
          },
          label: progressStatus == "Start"
              ? Text(
                  'Please wait....',
                  style: TextStyle(fontSize: 20),
                )
              : Text(
                  'Place Order',
                  style: TextStyle(fontSize: 20),
                ),
          backgroundColor: Colors.deepOrangeAccent,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class CartItems {
  final String itemId;
  final String description;
  final String name;
  final String price;
  final String discount;
  final String path;
  String counter;

  CartItems(
      {this.itemId,
      this.description,
      this.name,
      this.price,
      this.discount,
      this.counter,
      this.path});

  factory CartItems.fromJson(Map<String, dynamic> json) {
    return CartItems(
      itemId: json['ItemId'],
      description: json['Description'],
      name: json['ItemName'],
      price: json['Price'],
      discount: json['DiscountPercentage'],
      counter: json['Quantity'],
      path: json['Path'],
    );
  }
}

/*
Row(
children: <Widget>[
Expanded(
child: Image.asset(
snapshot.data[index].path)),
Padding(
padding: const EdgeInsets.all(8.0),
child: Text(snapshot.data[index].name),
),
Column(
children: <Widget>[
Text(snapshot.data[index].price),
Row(
children: <Widget>[
FlatButton(
child: Icon(Icons.remove),
onPressed: () async {
if (int.parse(snapshot
    .data[index].counter) >
0) {
decrement(snapshot, index);
await delFromCart(
uId,
snapshot
    .data[index].itemId,
int.parse(snapshot
    .data[index]
    .counter));
setState(() {
cart = getCartItems(uId);
});
}
}),
Text(snapshot.data[index].counter
    .toString()),
FlatButton(
child: Icon(Icons.add),
onPressed: () {
increment(snapshot, index);
addToCart(
uId,
snapshot.data[index].itemId,
int.parse(snapshot
    .data[index].counter));
},
)
],
)
],
)
],
),*/
