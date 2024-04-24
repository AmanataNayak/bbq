import 'dart:async';
import 'package:flutter/material.dart';
import 'menu_page.dart';
import 'cart_page.dart';
import 'user_order_summary.dart';
import 'seat_selection.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:badges/badges.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

int _currentIndex;

class TabPage extends StatefulWidget {
  final int uId;
  final String uFirstName;
  final String uLastName;
  final String restoId;
  final String outletId;
  final int ind;
  TabPage(
      {Key key,
      @required this.uId,
      @required this.uFirstName,
      @required this.uLastName,
      @required this.restoId,
      @required this.outletId,
      @required this.ind});
  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  int uId;
  var tableId;
  var waiterId;
  String uFirstName;
  String uLastName;
  var restoId;
  var outletId;
  List<Widget> _children;
  int cartItemCount = 0;
  Timer _timer;

  Future<List<MenuItems>> getMenuItems(int uId, String tableId) async {
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
      // //print('Error!!');
      throw Exception('Failed to Load Post');
    }
  }

  void onTabTapped(int index) {
    if (index == 0) {
      Navigator.pop(context);
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  void updateUserData(dynamic uId, dynamic uFirstName, dynamic uLastName,
      dynamic ind, dynamic rId, dynamic oId) {
    this.uId = uId;
    this.uLastName = uLastName;
    this.uFirstName = uFirstName;
    this.restoId = rId;
    this.outletId = oId;
    _currentIndex = ind;
  }

  void setUserData() async {
    this.tableId = await FlutterSession().get("tableId");
    this.waiterId = await FlutterSession().get("waiterId");
    getMenuItems(uId, tableId);
  }

  int count = 0;
  Future getCartNumber() async {
    var prefs = await SharedPreferences.getInstance();
    List<String> quantity = prefs.getStringList('quantity');
    // //print("quantity is $quantity");
    count = 0;
    for (int i = 0; i < quantity.length; i++) {
      count += int.parse(quantity[i]);
    }
  }

  @override
  void initState() {
    super.initState();
    updateUserData(widget.uId, widget.uFirstName, widget.uLastName, widget.ind,
        widget.restoId, widget.outletId);
    setUserData();
    _children = [
      SeatSelection(),
      MenuPage(
        uId: uId,
        uFirstName: uFirstName,
        uLastName: uLastName,
        restoId: restoId,
        outletId: outletId,
      ),
      CartPage(),
      UserOrderSummary(),
    ];
    _timer = Timer.periodic(
        Duration(seconds: 1), (timer) => getMenuItems(uId, tableId));
  }

  @override
  void dispose() {
    if (_timer.isActive) _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getCartNumber();
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.event_seat),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: <Widget>[
                Badge(
                  badgeContent: Text(
                    count.toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                  child: Icon(Icons.shopping_cart),
                )
              ],
            ),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Invoice',
          ),
        ],
      ),
      body: _children[_currentIndex],
    );
  }
}
