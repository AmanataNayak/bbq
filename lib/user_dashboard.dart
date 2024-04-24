import 'package:buybyeq/add_printer.dart';
import 'package:buybyeq/admin_dashboard.dart';
import 'package:buybyeq/daily_report.dart';
import 'package:buybyeq/inventory.dart';
import 'package:buybyeq/onlineOrder.dart';
import 'package:buybyeq/order_report.dart';
import 'package:buybyeq/purchaseEntry.dart';
import 'package:buybyeq/purchase_history.dart';
import 'package:buybyeq/stock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'add_item.dart';
import 'daily_use.dart';
import 'daily_used_items.dart';
import 'seat_selection.dart';
import 'login_page.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const userDashCardColor = Color(0xFFf45123);
const inactiveDashCardColor = Colors.grey;
const companyName = "Restaurant management made easier";
const companyAddress = "Bhubaneswar";
const companyContactNumber = "9861094684";
const companyEmail = "contact@buybyeq.com";
const headingTextSize = 30.0;
const smallHeadingTextSize = 30.0;
const extraSmallHeadingTextSize = 19.0;
const bigIconSize = 100.0;
const smallIconSize = 50.0;

class UserDashboard extends StatefulWidget {
  @override
  _UserDashboardState createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  var restoId;
  bool showReport = false,showInventory=false;
  String restoName;
  void setUserData() async {
    // this.uId = await FlutterSession().get("uId");
    // this.uFirstName = await FlutterSession().get("uFirstName");
    // this.uLastName = await FlutterSession().get("uLastName");
    // this.restoId = await FlutterSession().get("restaurantId");
    // this.outletId = await FlutterSession().get("outletId");
    // this.subscriptionId = await FlutterSession().get("subscriptionId");
    this.restoName = await FlutterSession().get("restoName");
  }
  _openPopup(context) {
    Alert(
      context: context,
      title: "Demo tour",
      content: Column(
        children: [
          Text(
            "This is a demo tour, some of app features will not be available.",
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
      buttons: [
        DialogButton(
            color: Color(0xFFf45123),
            child: Text("Proceed", style: TextStyle(color: Colors.white)),
            onPressed: () {
              Navigator.pop(context);
            })
      ],
    ).show();
  }

  inactiveItems(context) {
    Alert(
      context: context,
      title: "Demo app",
      content: Column(
        children: [
          Text(
            "Feature disabled",
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
      buttons: [
        DialogButton(
            color: Color(0xFFf45123),
            child: Text("Okay", style: TextStyle(color: Colors.white)),
            onPressed: () {
              Navigator.pop(context);
            })
      ],
    ).show();
  }

  void showAlert() async {
    this.restoId = await FlutterSession().get("restaurantId");
    if (restoId == "1") {
      _openPopup(context);
    }
  }

  @override
  void initState() {
    super.initState();
    setUserData();
    showAlert();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        drawer: Drawer(
          child: Column(
            children: [
              Expanded(
                child: ListView(

                  children: [
                    UserAccountsDrawerHeader(
                      currentAccountPicture: Image.asset('images/logo.png'),
                      accountName: Text(restoName!=null ? restoName : ''),
                      // accountEmail: Text('amanatanaya@gmail.com'),
                    ),
                    ListTile(
                        leading: Icon(
                          Icons.print,
                          color: Colors.black,
                        ),
                        title: Text(
                          "Settle Bill",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AdminDashboard()));
                        }),
                    Divider(
                      color: Colors.black,
                    ),
                    ListTile(
                        leading: Icon(
                          Icons.print,
                          color: Colors.black,
                        ),
                        title: Text(
                          "Add Printer",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AddPrinter()));
                        }),
                    Divider(
                      color: Colors.black,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.note_outlined,
                      ),
                      title: Text(
                        "REPORTS",
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        setState(() {
                          showReport = !showReport;
                        });
                      },
                    ),
                    showReport ? Divider(color: Colors.black) : Container(),
                    showReport
                        ? ListTile(
                        title: Text(
                          "Daily Report",
                          style: TextStyle(color: Colors.black),
                        ),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => DailyReport()));
                        })
                        : Container(),
                    // showReport
                    //     ? ListTile(
                    //         title: Text(
                    //           "Item Report",
                    //           style: TextStyle(color: Colors.black),
                    //         ),
                    //         onTap: () {
                    //           Navigator.push(
                    //               context,
                    //               MaterialPageRoute(
                    //                   builder: (context) => ItemReport()));
                    //         })
                    //     : Container(),
                    showReport
                        ? ListTile(
                        title: Text("Order Report", style: TextStyle(color: Colors.black)),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => OrderReport()));
                        })
                        : Container(),
                    Divider(color: Colors.black),
                    ListTile(
                      leading: Icon(
                        Icons.note_outlined,
                      ),
                      title: const Text('Online Orders', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => OnlineOrder()));
                      },
                    ),
                    /*ListTile(
                    leading: Icon(
                      Icons.note_outlined,
                    ),
                    title: const Text('In House Order', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => InHouseOrder()));
                    },
                  ),*/
                    ListTile(
                      leading: Icon(
                        Icons.note_outlined,
                      ),
                      title: const Text('Inventory', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                      onTap: () {
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => Inventory()));
                        setState(() {
                          showInventory=!showInventory;
                        });
                      },
                    ),
                    Divider(
                      color: Colors.black,
                    ),
                    showInventory?ListTile(
                      title: Text(
                        'ADD ITEM',
                        style: TextStyle(color: Colors.black),
                      ),
                      onTap: (){
                        Navigator.push(
                            context,MaterialPageRoute(builder: (context)=> AddItem()
                        ));
                      },
                    ):Container(),
                    showInventory?ListTile(
                      title: Text(
                        'PURCHASE ENTRY',
                        style: TextStyle(color: Colors.black),
                      ),
                      onTap: (){
                        Navigator.push(
                            context,MaterialPageRoute(builder: (context)=> PurchaseEntry()
                        ));
                      },
                    ):Container(),
                    showInventory?ListTile(
                      title: Text(
                        'DAILY USE',
                        style: TextStyle(color: Colors.black),
                      ),
                      onTap: () {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => DailyUse()));
                      },
                    ):Container(),
                    showInventory?ListTile(
                      title: Text(
                        'PURCHASE HISTORY',
                        style: TextStyle(color: Colors.black),
                      ),
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (
                                    context)=> PurchaseHistory()
                            )
                        );
                      },
                    ):Container(),
                    showInventory?ListTile(
                      title: Text(
                        'STOCK',
                        style: TextStyle(color: Colors.black),
                      ),
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context)=>Stock()
                            ));
                      },
                    ):Container(),
                    // ListTile(
                    //   title: Center(
                    //       child: Text(
                    //     'FIXED ASSETS',
                    //     style: TextStyle(color: Colors.black),
                    //   )),
                    // ),
                    showInventory?ListTile(
                      title: Text(
                        'DAILY USED ITEM REPORT',
                        style: TextStyle(color: Colors.black),
                      ),
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context)=>DailyUsedItems())
                        );
                      },
                    ):Container(),
                    showInventory?Divider(
                      color: Colors.black,
                    ):Container(),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Colors.black,
                  ),
                  title: Text(
                    "Logout",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    FlutterSession().set("uId", 0);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => LoginPage(),
                      ),
                          (route) => false,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: Text('DASHBOARD'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ReusableCard(
                  cardColor: userDashCardColor,
                  cardChild: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(
                        "images/logo.png",
                        height: 100.0,
                        width: 200.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            companyName,
                            style: TextStyle(
                              fontSize: extraSmallHeadingTextSize,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    /*Expanded(
                      child: ReusableCard(
                        cardColor: inactiveDashCardColor,
                        cardChild: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(FontAwesomeIcons.hotel,
                                size: bigIconSize, color: Colors.white),
                            SizedBox(
                              height: 15.0,
                            ),
                            Text(
                              'Hotel',
                              style: TextStyle(
                                  fontSize: smallHeadingTextSize,
                                  color: Colors.white),
                            )
                          ],
                        ),
                        cardFunction: () {
                          inactiveItems(context);
                        },
                      ),
                    ),*/
                    Expanded(
                      child: ReusableCard(
                        cardColor: userDashCardColor,
                        cardChild: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(FontAwesomeIcons.pizzaSlice,
                                size: bigIconSize, color: Colors.white),
                            SizedBox(
                              height: 15.0,
                            ),
                            Text(
                              'Restaurant',
                              style: TextStyle(
                                  fontSize: smallHeadingTextSize,
                                  color: Colors.white),
                            )
                          ],
                        ),
                        cardFunction: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SeatSelection()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              /*Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: ReusableCard(
                        cardColor: inactiveDashCardColor,
                        cardChild: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              FontAwesomeIcons.box,
                              size: bigIconSize,
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Text(
                              'Takeaway',
                              style: TextStyle(
                                  fontSize: smallHeadingTextSize,
                                  color: Colors.white),
                            )
                          ],
                        ),
                        cardFunction: () {
                          inactiveItems(context);
                        },
                      ),
                    ),
                    Expanded(
                      child: ReusableCard(
                        cardColor: inactiveDashCardColor,
                        cardChild: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              FontAwesomeIcons.table,
                              size: bigIconSize,
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Text(
                              'Reservation',
                              style: TextStyle(
                                  fontSize: smallHeadingTextSize,
                                  color: Colors.white),
                            )
                          ],
                        ),
                        cardFunction: () {
                          inactiveItems(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),*/
              // Expanded(
              //     child: CarouselSlider(
              //         items: [
              //       Container(
              //         child: Column(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: <Widget>[
              //             Icon(FontAwesomeIcons.book,
              //                 size: smallIconSize, color: Colors.grey),
              //             Text(
              //               'Reports',
              //               style: TextStyle(
              //                   fontSize: smallHeadingTextSize,
              //                   color: Colors.grey),
              //             ),
              //             Text(
              //               'Coming Soon',
              //               style: TextStyle(
              //                   fontSize: extraSmallHeadingTextSize,
              //                   color: Colors.black),
              //             )
              //           ],
              //         ),
              //       ),
              //       Container(
              //         child: Column(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: <Widget>[
              //             Icon(FontAwesomeIcons.store,
              //                 size: smallIconSize, color: Colors.grey),
              //             Text(
              //               'Inventory',
              //               style: TextStyle(
              //                   fontSize: smallHeadingTextSize,
              //                   color: Colors.grey),
              //             ),
              //             Text(
              //               'Coming Soon',
              //               style: TextStyle(
              //                   fontSize: extraSmallHeadingTextSize,
              //                   color: Colors.black),
              //             )
              //           ],
              //         ),
              //       ),
              //     ],
              //         options: CarouselOptions(
              //           initialPage: 0,
              //           enableInfiniteScroll: true,
              //           reverse: false,
              //           autoPlay: true,
              //           autoPlayInterval: Duration(seconds: 3),
              //           autoPlayAnimationDuration: Duration(milliseconds: 800),
              //           autoPlayCurve: Curves.fastOutSlowIn,
              //           scrollDirection: Axis.horizontal,
              //         )))
            ],
          ),
        ));
  }
}

class ReusableCard extends StatelessWidget {
  const ReusableCard(
      {Key key, @required this.cardColor, this.cardChild, this.cardFunction})
      : super(key: key);
  final cardColor;
  final cardChild;
  final cardFunction;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: cardFunction,
      child: Container(
        margin: EdgeInsets.all(10.0),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: cardChild,
      ),
    );
  }
}

/*class ReusableCard extends StatelessWidget {
  const ReusableCard(
      {Key key, @required this.cardColor, this.cardChild, this.cardFunction})
      : super(key: key);
  final cardColor;
  final cardChild;
  final cardFunction;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: GestureDetector(
        child: cardChild,
        onTap: cardFunction,
      ),
    );
  }
}*/
