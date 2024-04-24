import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  _openPopup(context){
    Alert(
      context: context,
      title: "Registration successful",
      buttons:[
        DialogButton(child: Text("Okay"), onPressed:  (){
          Navigator.pop(context);
        })
      ],
    ).show();
  }

  @override
  void initState(){
    super.initState();
    _openPopup(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Thanks for showing interest in our app. Please note that all the features of your app can be enabled if you send us your menu details."
                  "You can share the information to the email id given below."
                  "After sharing the information app will be updated within 3-4 hours."),
            ),
          ),
          Container(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("You can contact us by following methoods"),
                  Padding(
                      padding: EdgeInsets.all(1.0),
                      child: Wrap(
                        children: [
                          Icon(
                            Icons.mail,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            "contact@buybyeq.com",
                            style: TextStyle(
                                color: Colors.black),
                          ),
                        ],
                      )),
                  Padding(
                      padding: EdgeInsets.all(1.0),
                      child: Wrap(
                        children: [
                          Icon(
                            Icons.mail,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            "jyoti.nayak@sigmancomp.com",
                            style: TextStyle(
                                color: Colors.black),
                          ),
                        ],
                      )),
                  Padding(
                      padding: EdgeInsets.all(1.0),
                      child: Wrap(
                        children: [
                          Icon(
                            Icons.phone,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            "9861094684",
                            style: TextStyle(
                                color: Colors.black),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text("Don't want to configure right away? No worries."),
                  Text("Login with your id and password and have a look at the application with dummy data"),
                  TextButton(
                    child: Text("Get Demo"),
                    onPressed: (){
                        Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          )
        ],
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
      readOnly: true,
      controller: controller,
      obscureText: obscureValue,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon),
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
      ),
    );
  }
}