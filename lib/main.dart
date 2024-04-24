import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login_page.dart';
import 'package:flutter_session/flutter_session.dart';
import 'user_dashboard.dart';
import 'admin_dashboard.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String token = await FlutterSession().get("role");
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(BuyByeQM(
    check: token,
  ));
}

class BuyByeQM extends StatefulWidget {
  final String check;
  BuyByeQM({Key keyl, @required this.check});

  @override
  _BuyByeQMState createState() => _BuyByeQMState();
}

class _BuyByeQMState extends State<BuyByeQM> {
  String token;

  void updateToken(dynamic check) {
    print(check);
    this.token = check;
  }

  @override
  void initState() {
    super.initState();
    updateToken(widget.check);
  }

  @override
  Widget build(BuildContext context) {
    /*if(){
      token == "cashier"
    }
    else if(){

    }*/
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        primaryColor: Color(0xFFf45123),
        primaryTextTheme: TextTheme(
          headline6: GoogleFonts.robotoSlab(),
        ),
        accentColor: Colors.purple,
        textTheme: TextTheme(
          bodyText2: GoogleFonts.robotoSlab(color: Colors.black),
          subtitle1: GoogleFonts.robotoSlab(color: Colors.black),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            primary: Colors.black,
            backgroundColor: Color(0xFFf9572a),
          ),
        ),
      ),
      home: token == "waiter"
          ? UserDashboard()
          : token == "cashier"
              ? AdminDashboard()
              : LoginPage(),
    );
  }
}
