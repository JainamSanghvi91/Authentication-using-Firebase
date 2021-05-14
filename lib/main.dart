import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internshala/screens/addproductpage.dart';
import 'package:internshala/screens/authScreen.dart';
import 'package:internshala/screens/mainPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData(
        primarySwatch: Colors.red,
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
      home: StreamBuilder(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (context, userSnapshot) {
          if (userSnapshot.hasData) {
            return MainPage();
          }
          return AuthScreen();
        },
      ),
      routes: {
        AddProductPage.routename: (ctx) => AddProductPage(),

      },
    );
  }
}
