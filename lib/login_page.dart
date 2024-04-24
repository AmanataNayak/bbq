import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_session/flutter_session.dart';
import 'user_dashboard.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'admin_dashboard.dart';
import 'RegistrationPage.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

const unselectedInputBorderColor = Colors.black12;
const selectedInputBorderColor = Colors.red;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoggedIn = false;
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  int _buttonState = 0;

  _openPopup(context, String msg) {
    Alert(
      context: context,
      title: "Login failed",
      content: Column(
        children: [
          Text(
            msg,
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
      buttons: [
        DialogButton(
            color: Color(0xFFf45123),
            child: Text(
              "Okay",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.pop(context);
            })
      ],
    ).show();
  }

  /*void autoLogIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userId = prefs.getString('userId');

    if (userId != null) {
      setState(() {
        isLoggedIn = true;
      });
      return;
    }
  }*/

  Future<dynamic> checkLogin() async {
    try {
      if (email.text != '' && password.text != '') {
        final response = await http.post(
            "https://www.buybyeq.com/bbq_server/PHPRest/api/login/read.php",
            body: {
              "email": email.text,
              "password": password.text,
            });

        if (response.statusCode == 200) {
          var jsonData = jsonDecode(response.body);
          if (jsonData["check"] == true) {
            var session = FlutterSession();
            print(jsonData['role']);
            await session.set("uId", int.parse(jsonData["uId"]));
            await session.set("uFirstName", jsonData["uFirstName"]);
            await session.set("uLastName", jsonData["uLastName"]);
            await session.set("restaurantId", jsonData["restaurantId"]);
            await session.set("outletId", jsonData["outletId"]);
            await session.set("subscriptionId", jsonData['restoIdMain']);
            await session.set("restoName", jsonData['restoName']);
            await session.set("address", jsonData['address']);
            await session.set("role", jsonData['role']);
            if (jsonData["role"] == "waiter") {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => UserDashboard(),
                  // builder: (context) => AdminDashboard(),
                ),
              );
            } else if (jsonData["role"] == "cashier") {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => AdminDashboard(),
                ),
              );
            }
          } else {
            setState(() {
              _buttonState = 0;
            });
            _openPopup(context, "Wrong email/password !");
          }
        } else {
          setState(() {
            _buttonState = 0;
          });
          _openPopup(context, "Try again");
        }
      } else {
        setState(() {
          _buttonState = 0;
        });
        _openPopup(context, "Email and Password required");
      }
    } catch (e) {
      setState(() {
        _buttonState = 0;
      });
      _openPopup(context, "Try again");
    }
  }

  Widget setUpButtonChild() {
    if (_buttonState == 0) {
      return Text(
        "LOGIN",
        style: TextStyle(color: Colors.white),
      );
    } else if (_buttonState == 1) {
      return Container(
        height: 17.0,
        width: 15.0,
        child: CircularProgressIndicator(
          strokeWidth: 3.0,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    } else {
      return Icon(Icons.error_outline, color: Colors.white);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Center(
          child: Text('BuyByeQ'),
        ),
      ),
      body: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width,
          minHeight: MediaQuery.of(context).size.height,
        ),
        child: IntrinsicHeight(
          child: Container(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.amberAccent,
                image: DecorationImage(
                    image: AssetImage('images/login_image.jpg'),
                    fit: BoxFit.cover),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFEAF6F6),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                    ),
                    child: Column(
                      children: [
                        Center(
                          child: Image.asset(
                            'images/logo.png',
                            height: 100,
                            width: 100,
                          ),
                        ),
                        Center(
                            child: Text(
                          'Login',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 40,
                          ),
                        )),
                        Divider(
                          indent: 130,
                          endIndent: 130,
                          thickness: 2,
                          color: Color(0xFFf45123),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('User ID'),
                        TextField(
                          controller: email,
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Text('Password'),
                        TextField(
                          controller: password,
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Center(
                    child: TextButton(
                      onPressed: () async {
                        setState(() {
                          _buttonState = 1;
                        });
                        await checkLogin();
                      },
                      child: setUpButtonChild(),
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.symmetric(
                              horizontal: 50.0, vertical: 15.0),
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            side: BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ReusableInputBox extends StatelessWidget {
  ReusableInputBox(
      {@required this.controller,
      @required this.selectedColor,
      @required this.unselectedColor,
      @required this.hintText,
      @required this.icon,
      @required this.obscureValue,
      @required this.textDeco});
  final unselectedColor;
  final selectedColor;
  final icon;
  final hintText;
  final obscureValue;
  final controller;
  final textDeco;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureValue,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        /*border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),8*/
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
      ),
    );
  }
}

class HorizontalOrLine extends StatelessWidget {
  const HorizontalOrLine({
    this.label,
    this.height,
  });

  final String label;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Expanded(
        child: new Container(
            margin: const EdgeInsets.only(left: 10.0, right: 0.0),
            child: Divider(
              color: Colors.black,
              height: height,
            )),
      ),
      //Text(label),
      Container(
          decoration: BoxDecoration(
            border: Border.all(width: 1.0, color: Colors.grey),
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          )),
      Expanded(
        child: new Container(
            margin: const EdgeInsets.only(left: 0.0, right: 10.0),
            child: Divider(
              color: Colors.black,
              height: height,
            )),
      ),
    ]);
  }
}
