import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internshala/login.dart';
import 'package:internshala/screens/googleprovider.dart';
import 'package:internshala/screens/mainPage.dart';
import 'package:internshala/signupgoogle.dart';
import 'package:internshala/spash.dart';
import 'package:provider/provider.dart';

class GoogleLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (contex) => GoogleSingnInProvider(),
        child: StreamBuilder(
          stream: FirebaseAuth.instance.onAuthStateChanged,
          builder: (context, snapshot) {
            final provider = Provider.of<GoogleSingnInProvider>(context);
            if(snapshot.connectionState==ConnectionState.waiting){
              return SplasScreen();
            }
            else if (provider.isSigningIn) {
              return SplasScreen();
            } else if (snapshot.hasData) {
              return MainPage();
            } else {
              return SignupGoogle();
            }
          },
        ),
      ),
    );
  }
}
