// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'login_page.dart';
import 'cart_page.dart';
import 'tabPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

const inputDeco = InputDecoration(
    hintText: 'Search Item Name',
    prefixIcon: Icon(Icons.search),
    hintStyle: TextStyle(color: Colors.black54, fontSize: 18),
    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(15.0)),
    )
    // enabledBorder: OutlineInputBorder(
    //   borderSide: BorderSide(color: Colors.black12, width: 2.0),
    //   borderRadius: BorderRadius.all(Radius.circular(5.0)),
    // ),
    // focusedBorder: OutlineInputBorder(
    //   borderSide: BorderSide(color: Colors.black12, width: 2.0),
    //   borderRadius: BorderRadius.all(Radius.circular(5.0)),
    // ),
    );
const userButtonColor = Color(0xFFf45123);
const companyName = "BuyByeQ-Restaurant";
const companyAddress = "Bhubaneswar";
const companyContactNumber = "1234569871";
const companyEmail = "buybyeq@gmail.com";
const itemNameTextSize = 28.0;
const priceTextSize = 28.0;
const bigIconSize = 80.0;
const inactiveButtonColor = Colors.grey;

class MainMenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MenuPage();
  }
}

class MenuPage extends StatefulWidget {
  final int uId;
  final String uFirstName;
  final String uLastName;
  final String restoId;
  final String outletId;
  int cartItemCount = 0;
  MenuPage(
      {Key key,
      @required this.uId,
      @required this.uFirstName,
      @required this.uLastName,
      @required this.restoId,
      @required this.outletId});
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  int uId;
  var tableId;
  var waiterId;
  var restoId;
  var outletId;
  String uFirstName;
  String uLastName;
  int cartItemCount = 0;
  String selectedCategory = "All";
  TextEditingController searchText = new TextEditingController();
  Future<List<MenuCategories>> category;
  Future<List<MenuItems>> items;
  Color colors = Colors.green;
  void setUserData() async {
    this.tableId = await FlutterSession().get("tableId");
    this.waiterId = await FlutterSession().get("waiterId");
    category = getCategories();
    items = getMenuItems(uId, tableId);
  }

  void updateUserData(dynamic uId, dynamic uFirstName, dynamic uLastName,
      dynamic rId, dynamic oId) {
    this.uId = uId;
    this.uLastName = uLastName;
    this.uFirstName = uFirstName;
    this.restoId = rId;
    this.outletId = oId;
  }

  /*void _onItemTap(int index) async {
    if (tableId == '0') {
      if (index == 1) {
        var result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainCart()),
        );
      } else if (index == 2) {
        var result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainUserOrderDetails()),
        );
        if (result == false) {
          Navigator.pop(context);
        } else if (result == 'cart') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MainCart()),
          );
        }
      }
    } else {
      if (index == 0) {
        Navigator.pop(context, false);
      } else if (index == 2) {
        var result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainCart()),
        );
        if (result == false) {
          Navigator.pop(context);
        }
      } else if (index == 3) {
        var result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainUserOrderDetails()),
        );
        if (result == false) {
          Navigator.pop(context);
        } else if (result == 'cart') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MainCart()),
          );
        }
      }
    }
  }*/

  List<String> listIId = [];
  List<String> quantity = [];
  List<String> itemNames = [];
  List<String> prices = [];

  Future<void> _showMyDialog(
      AsyncSnapshot snapshot, int index, Color color) async {
    TextEditingController quantityNo = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('AlertDialog Title'),
          content: TextField(
            keyboardType: TextInputType.number,
            controller: quantityNo,
            decoration: InputDecoration(
              labelText: 'Enter quantity',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              child: const Text(
                'Ok',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                setState(() {
                  color = Colors.indigo;
                });

                if (quantityNo.text == "") {
                  quantity.add('1');
                } else {
                  quantity.add(quantityNo.text);
                }
                listIId.add(snapshot.data[index].itemId);
                itemNames.add(snapshot.data[index].name);
                prices.add(snapshot.data[index].price);
                addToCart(uId, listIId, quantity, itemNames, prices, tableId);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDeleteDialog(List<String> listId, List<String> listName,
      List<String> price, remItemId, Color color) async {
    int index = listIId.indexOf(remItemId);
    //print(listId);
    //print(listName);
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('AlertDialog Title'),
          content: Text("Remove ${listName[index]}?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              child: const Text(
                'Ok',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                setState(() {
                  color = Colors.green;
                });
                quantity.removeAt(index);
                listId.removeAt(index);
                listName.removeAt(index);
                //print(quantity);
                //print(listId);
                //print(listName);
                addToCart(uId, listId, quantity, listName, price, tableId);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  // Future<dynamic> addToCart(
  //     int uId, String iId, String quantity, String tableId) async {
  //   if (true) {
  //     final response = await http.post(
  //         "https://www.buybyeq.com/bbq_server/PHPRest/api/cart/add.php",
  //         body: {
  //           "uId": uId.toString(),
  //           "iId": iId.toString(),
  //           "iQuantity": quantity,
  //           "tId": tableId,
  //         });
  //     return 1;
  //   }
  // }

  Future addToCart(int uId, List<String> iId, List<String> quantityList,
      List<String> names, List<String> prices, String tableId) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('items', iId);
    await prefs.setStringList('quantity', quantityList);
    await prefs.setStringList('itemNames', names);
    await prefs.setStringList('price', prices);
  }

  void increment(AsyncSnapshot snapshot, int index) {
    setState(() {
      snapshot.data[index].counter =
          (int.parse(snapshot.data[index].counter) + 1).toString();
    });
  }

  void decrement(AsyncSnapshot snapshot, int index) {
    setState(() {
      snapshot.data[index].counter = '0';
    });
  }

  Future<List<MenuCategories>> getCategories() async {
    final response = await http.post(
        "https://www.buybyeq.com/bbq_server/PHPRest/api/menu/readCategory.php",
        body: {
          'rId': restoId.toString(),
          'oId': outletId.toString(),
        });

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      var category =
          list.map((category) => MenuCategories.fromJson(category)).toList();
      return category;
    } else {
      throw Exception('Failed to Load Post');
    }
  }

  Future<List<dynamic>> getSuggestions(
      String pattern, String rId, String oId) async {
    final response = await http.post(
        "https://www.buybyeq.com/bbq_server/PHPRest/api/menu/getSearch.php",
        body: {
          "str": pattern,
          "rId": rId,
          "oId": oId,
        });

    if (response.statusCode == 200) {
      Iterable suggestion = json.decode(response.body);
      /*var category = list.map((category) => MenuCategories.fromJson(category))
          .toList();*/
      return suggestion;
    } else {
      //print('Error!!');
      throw Exception('Failed to Load Post');
    }
  }

  Future<List<MenuItems>> getMenuItemsByCategory(
      String categoryName, int uId, String tableId) async {
    final response = await http.post(
        "https://www.buybyeq.com/bbq_server/PHPRest/api/menu/readMenuByName.php",
        body: {
          'catName': categoryName,
          'uId': uId.toString(),
          'tId': tableId.toString(),
          'rId': restoId.toString(),
          'oId': outletId.toString(),
        });

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      var items = list.map((items) => MenuItems.fromJson(items)).toList();
      return items;
    } else {
      //print('Error!!');
      throw Exception('Failed to Load Post');
    }
  }

  Future<List<MenuItems>> getMenuItems(int uId, String tableId) async {
    //print(uId);
    final response = await http.post(
        "https://www.buybyeq.com/bbq_server/PHPRest/api/menu/readMenu.php",
        body: {
          'uId': uId.toString(),
          'tId': tableId.toString(),
          'rId': restoId.toString(),
          'oId': outletId.toString(),
        });

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);

      var items = list.map((items) => MenuItems.fromJson(items)).toList();
      int badgeCount = 0;
      for (int j = 0; j < items.length; j++) {
        badgeCount = badgeCount + int.parse(items[j].counter);
      }
      setState(() {
        cartItemCount = badgeCount;
      });
      return items;
    } else {
      //print('Error!!');
      throw Exception('Failed to Load Post');
    }
  }

  void sharedPrefCheck() async {
    var prefs = await SharedPreferences.getInstance();
    var check = await prefs.containsKey("items");
    if (check) {
      listIId = await prefs.getStringList("items");
    }
  }

  Future getToCart() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey("items")) {
      final List<String> items = prefs.getStringList('items');
      final List<String> quantityList = prefs.getStringList('quantity');
      final List<String> names = prefs.getStringList('itemNames');
      final List<String> price = prefs.getStringList('price');
      listIId.addAll(items);
      quantity.addAll(quantityList);
      itemNames.addAll(names);
      prices.addAll(price);
    }
  }

  @override
  void initState() {
    getToCart();
    super.initState();
    updateUserData(widget.uId, widget.uFirstName, widget.uLastName,
        widget.restoId, widget.outletId);
    setUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: Drawer(
      //   child: ListView(
      //     // Important: Remove any padding from the ListView.
      //     padding: EdgeInsets.zero,
      //     children: <Widget>[
      //       DrawerHeader(
      //         decoration: BoxDecoration(
      //           color: Colors.blue,
      //         ),
      //         child: Text('Menu'),
      //       ),
      //       ListTile(
      //         title: Text(
      //           'Log Out',
      //           style: TextStyle(color: Color(0xFFf45123)),
      //         ),
      //         onTap: () {
      //           FlutterSession().set("uId", 0);
      //           Navigator.pushAndRemoveUntil(
      //             context,
      //             MaterialPageRoute(
      //               builder: (BuildContext context) => LoginPage(),
      //             ),
      //             (route) => false,
      //           );
      //         },
      //       ),
      //     ],
      //   ),
      // ),
      // appBar: AppBar(centerTitle: true, title: Text("Menu")
      //     /*GestureDetector(
      //           onTap: () async {
      //             var cartResult = await Navigator.push(
      //               context,
      //               MaterialPageRoute(builder: (context) => CartPage()),
      //             );
      //             if (cartResult == true) {
      //               setState(() {
      //                 items = getMenuItems(uId, tableId);
      //               });
      //             } else if (cartResult == false) {
      //               Navigator.pop(context);
      //             } else {
      //               setState(() {
      //                 items = getMenuItems(uId, tableId);
      //               });
      //             }
      //           },
      //           child: Badge(
      //             badgeContent: Text(
      //               cartItemCount.toString(),
      //               style: TextStyle(color: Colors.white),
      //             ),
      //             child: Icon(Icons.shopping_cart),
      //           ),
      //         )*/
      //     ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('MENU'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
              //height: 30.0,
              child: TypeAheadField(
                textFieldConfiguration: TextFieldConfiguration(
                    autofocus: false, decoration: inputDeco),
                suggestionsCallback: (pattern) {
                  return getSuggestions(
                      pattern, restoId.toString(), outletId.toString());
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    leading: Icon(Icons.shopping_cart),
                    title: Text(suggestion['ItemName']),
                    subtitle: Text('Rs. ${suggestion['Price']}'),
                  );
                },
                onSuggestionSelected: (suggestion) {
                  // addToCart(uId, suggestion['ItemId'], quantity, itemNames,
                  //     prices, tableId);
                  // {ItemId: 6, ItemName: Veg Burger, Description: null, Price: 50, DiscountPercentage: 5, Path: images/burger.jpeg}
                  if (!listIId.contains(suggestion['ItemId'])) {
                    setState(() {
                      listIId.add(suggestion['ItemId']);
                      itemNames.add(suggestion['ItemName']);
                      prices.add(suggestion['Price']);
                      quantity.add('1');
                    });
                  }
                  // //print();

                  addToCart(uId, listIId, quantity, itemNames, prices, tableId);
                  ////print(suggestion);
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 50.0,
              child: FutureBuilder<List<MenuCategories>>(
                future: category,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        //  shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          String name = snapshot.data[index].name;
                          // if(name.length>9){
                          //   name=snapshot.data[index].name.substring(0,9);
                          // }
                          return Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedCategory = snapshot.data[index].name;
                                  if (snapshot.data[index].name == "ALL") {
                                    items = getMenuItems(uId, tableId);
                                  }
                                  ////print("${snapshot.data[index].name}");
                                  else {
                                    items = getMenuItemsByCategory(
                                        "${snapshot.data[index].name}",
                                        uId,
                                        tableId);
                                  }
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Color(0xFFf45123),
                                    borderRadius: BorderRadius.circular(60)),
                                width: name.length.toDouble() * 15,
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Center(
                                      child: Text(
                                    name,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                        color: Colors.white),
                                  )),
                                ),
                              ),
                            ),
                          );
                        });
                  } else if (snapshot.hasError) {
                    return Text("Error");
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ),
            Expanded(
              child: FutureBuilder<List<MenuItems>>(
                future: items,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1.6,
                                  color: listIId
                                          .contains(snapshot.data[index].itemId)
                                      ? Colors.orangeAccent
                                      : Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(15)
                                // color: listIId.contains(snapshot.data[index].itemId)?Colors.indigo:Colors.white,
                                ),
                            margin: EdgeInsets.all(5.0),
                            child: ListTile(
                              title: Padding(
                                padding: EdgeInsets.all(3),
                                child: Text(
                                  snapshot.data[index].name,
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              subtitle: Padding(
                                padding: EdgeInsets.all(3),
                                child: Text(
                                  "Rs. ${snapshot.data[index].price}",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              onTap: () {
                                if (!listIId
                                    .contains(snapshot.data[index].itemId)) {
                                  _showMyDialog(snapshot, index, colors);
                                } else {
                                  _showDeleteDialog(listIId, itemNames, prices,
                                      snapshot.data[index].itemId, colors);
                                }
                              },
                            ),
                          );
                          // return GestureDetector(
                          //   onTap: () {

                          //
                          //   child: Padding(
                          //     padding: const EdgeInsets.symmetric(
                          //         vertical: 5.0, horizontal: 5.0),
                          //     child: Container(
                          //       height: 50.0,
                          //       padding: EdgeInsets.symmetric(horizontal: 10.0),
                          //       decoration: BoxDecoration(
                          //         color: Colors.red,
                          //         border: Border.all(),
                          //         borderRadius: BorderRadius.circular(10)
                          //       ),
                          //       //color: Colors.grey.shade200,
                          //       child: Row(
                          //         mainAxisAlignment:
                          //             MainAxisAlignment.spaceBetween,
                          //         //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //         children: <Widget>[
                          //           Flexible(
                          //             child: Text(
                          //               "${snapshot.data[index].name}",
                          //               maxLines: 1,
                          //               overflow: TextOverflow.ellipsis,
                          //               style: TextStyle(
                          //                   fontSize: itemNameTextSize,
                          //                   fontWeight: FontWeight.bold,
                          //                   color: Colors.white
                          //               ),
                          //               //softWrap: false,
                          //             ),
                          //           ),
                          //           Container(
                          //             child: Text(
                          //               "Rs. ${snapshot.data[index].price}",
                          //               maxLines: 1,
                          //               overflow: TextOverflow.ellipsis,
                          //               softWrap: false,
                          //               style:
                          //                   TextStyle(fontSize: priceTextSize),
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          // );
                        });
                  } else if (snapshot.hasError) {
                    return Text("Snapshot error");
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuItems {
  final String itemId;
  final String description;
  final String name;
  final String price;
  final String discount;
  final String path;
  Color color = Colors.white;
  String counter;

  MenuItems(
      {this.itemId,
      this.description,
      this.name,
      this.price,
      this.discount,
      this.path,
      this.counter,
      this.color});

  factory MenuItems.fromJson(Map<dynamic, dynamic> json) {
    return MenuItems(
      itemId: json['ItemId'],
      description: json['Description'],
      name: json['ItemName'],
      price: json['Price'],
      discount: json['DiscountPercentage'],
      path: json['Path'],
      counter: json['quantity'],
    );
  }

  getIndex() {}
}

class MenuCategories {
  final String description;
  final String name;

  MenuCategories({this.description, this.name});

  factory MenuCategories.fromJson(Map<String, dynamic> json) {
    return MenuCategories(
      description: json['Description'],
      name: json['CategoryName'],
    );
  }
}

/*

TextButton(
onPressed: () {},
child: Text('Add to Cart'),
style: ButtonStyle(
padding: MaterialStateProperty.all<
    EdgeInsets>(
EdgeInsets.symmetric(
horizontal: 30.0),
),
shape: MaterialStateProperty.all<
    RoundedRectangleBorder>(
RoundedRectangleBorder(
borderRadius:
BorderRadius.circular(30.0),
side:
BorderSide(color: Colors.red),
),
),
),
),*/

/*
Text(
'ADD TO CART',
style:
TextStyle(color: Colors.white),
),*/
