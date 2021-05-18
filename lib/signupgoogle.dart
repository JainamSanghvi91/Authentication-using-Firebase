import 'package:flutter/material.dart';
import 'package:internshala/screens/googleprovider.dart';
import 'package:provider/provider.dart';

class SignupGoogle extends StatefulWidget {
  @override
  _SignupGoogleState createState() => _SignupGoogleState();
}

class _SignupGoogleState extends State<SignupGoogle> {
  bool _isloading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(builder: (context, constraints) {
        var maxW = constraints.maxWidth;
        var maxH = constraints.maxHeight;
        return Container(
          width: maxW,
                  child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    "Inventory",
                    style: TextStyle(color: Colors.orange, fontSize: 42),
                  ),
                  Image.asset('assets/images/add_product.png',width: maxW*0.6,)
                ],
              ),
              Container(
                margin: EdgeInsets.only(
                    top: 20 * maxH / 647,
                    left: 10 * maxW / 360,
                    right: 10 * maxW / 360),
                width: maxW*0.7,
                
                height: maxH * 0.07,
                child: (_isloading)
                    ? Center(child: CircularProgressIndicator())
                    : InkWell(
                        child: Container(
                          decoration: BoxDecoration(
                    border: Border(
                      bottom:
                          BorderSide(color: Colors.grey, width: 1 * maxW / 360),
                      top: BorderSide(color: Colors.grey, width: 1 * maxW / 360),
                      right:
                          BorderSide(color: Colors.grey, width: 1 * maxW / 360),
                      left: BorderSide(color: Colors.grey, width: 1 * maxW / 360),
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30 * maxH / 647)),
                                                child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Image.asset(
                                'assets/images/g.png',
                                height: 35*maxH/647,
                              ),
                              Text(
                                "Sign In with Google",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18 * maxH / 647,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            _isloading = true;
                          });
                          final provider = Provider.of<GoogleSingnInProvider>(
                              context,
                              listen: false);
                          provider.login();
                          setState(() {
                            _isloading = false;
                          });
                        },
                      ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
