import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'contact.dart';

const unselectedInputBorderColor = Colors.black12;
const selectedInputBorderColor = Colors.red;

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController fName = new TextEditingController();
  TextEditingController lName = new TextEditingController();
  TextEditingController mobile = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController confPassword = new TextEditingController();

  _openPopup(context,String msg){
    Alert(
      context: context,
      title: msg,
      buttons:[
        DialogButton(child: Text("Okay"), onPressed:  (){
          Navigator.pop(context);
        })
      ],
    ).show();
  }

  Future<dynamic> addUser() async {
    if(true){final response = await http.post(
        "https://buybyeq.com/PHPRest/api/login/register.php",
        body: {
          "email": email.text,
          "password": password.text,
          "fName": fName.text,
          "lName": lName.text,
          "mobile": mobile.text,
        });

    if(response.statusCode==200){
      var jsonData = jsonDecode(response.body);
      if (jsonData["check"] == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ContactPage(),
          ),
        );
      }
      else if (jsonData["check"] == false) {
        _openPopup(context,"User already exists");
      }
      else {
        _openPopup(context,"Try again");
      }
    }
    else {
      _openPopup(context,"Try again");
    }}
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Center(
          child: Text('BuyByeQ'),
        ),
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width,
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: IntrinsicHeight(
            child: Container(
              child: DecoratedBox(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("images/login_image.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ReusableInputBox(
                          controller: fName,
                          selectedColor: selectedInputBorderColor,
                          unselectedColor: unselectedInputBorderColor,
                          hintText: 'First Name',
                          icon: Icons.account_circle,
                          obscureValue: false,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ReusableInputBox(
                          controller: lName,
                          selectedColor: selectedInputBorderColor,
                          unselectedColor: unselectedInputBorderColor,
                          hintText: 'Last Name',
                          icon: Icons.account_circle,
                          obscureValue: false,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ReusableInputBox(
                          controller: email,
                          selectedColor: selectedInputBorderColor,
                          unselectedColor: unselectedInputBorderColor,
                          hintText: 'Email Address',
                          icon: Icons.email,
                          obscureValue: false,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ReusableInputBox(
                          controller: mobile,
                          selectedColor: selectedInputBorderColor,
                          unselectedColor: unselectedInputBorderColor,
                          hintText: 'Mobile Number',
                          icon: Icons.phone_android,
                          obscureValue: false,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ReusableInputBox(
                          controller: password,
                          selectedColor: selectedInputBorderColor,
                          unselectedColor: unselectedInputBorderColor,
                          hintText: 'Password',
                          icon: Icons.vpn_key,
                          obscureValue: true,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ReusableInputBox(
                          controller: confPassword,
                          selectedColor: selectedInputBorderColor,
                          unselectedColor: unselectedInputBorderColor,
                          hintText: 'Confirm Password',
                          icon: Icons.vpn_key,
                          obscureValue: true,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextButton(
                          onPressed: () {
                            addUser();
                          },
                          child: Text('REGISTER'),
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.symmetric(
                                  horizontal: 50.0, vertical: 15.0),
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                side: BorderSide(color: Colors.red),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                    ],
                  )),
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
