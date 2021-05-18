import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:internshala/googlelogin.dart';
import 'package:internshala/screens/addproductpage.dart';
import 'package:internshala/screens/authScreen.dart';
import 'package:internshala/screens/mainPage.dart';
import 'package:internshala/spash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(
      title: 'Inventroy',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        // backgroundColor: Colors.red,
        // accentColor: Colors.redAccent,
        // accentColorBrightness: Brightness.dark,
        // buttonTheme: ButtonTheme.of(context).copyWith(
        //   buttonColor: Colors.red,
        //   textTheme: ButtonTextTheme.primary,
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(30),
        //   ),
        // ),
        // visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: GoogleLogin(),
      // home: StreamBuilder(
      //   stream: FirebaseAuth.instance.onAuthStateChanged,
      //   builder: (context, userSnapshot) {
      //     if (userSnapshot.connectionState == ConnectionState.waiting) {
      //       return SplasScreen();
      //     }
      //     if (userSnapshot.hasData) {
      //       return MainPage();
      //     }
      //     return AuthScreen();
      //   },
      // ),
      routes: {
        AddProductPage.routename: (ctx) => AddProductPage(),
      },
    );
  }
}
