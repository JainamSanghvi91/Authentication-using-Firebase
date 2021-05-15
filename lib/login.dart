// import 'package:app/screen/login/termsAndCondition.dart';
// import 'package:flushbar/flushbar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:internshala/colors.dart';
import 'dart:io';
import 'dart:math';

import 'package:internshala/size_config.dart';

class Login extends StatefulWidget {
  static const String routename = "/login";
  Login(
    this.submitFn,
    this.isLoading,
  );

  final bool isLoading;
  final void Function(
    String email,
    String password,
    String username,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _forrmkey2 = GlobalKey();
var _isLogin = true;
    String _userEmail = '';
    String _userName = '';
    String _password = '';
  

 

  // var _isLoading = false;
  // var isLoad = false;
  // var iserror = false;
  // final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final details =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

    final h = SizeConfig.heightMultiplier * 100;
    final w = SizeConfig.widthMultiplier * 100;

    
    void submit() {
      final isValid = _forrmkey2.currentState.validate();
      FocusScope.of(context).unfocus();

      if (isValid) {
        _forrmkey2.currentState.save();
        widget.submitFn(
          _userEmail.trim(),
          _password.trim(),
          _userName.trim(),
          _isLogin,
          context,
        );
      }
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        print("constraints is stored in sizeconfig");
        print("Max ht: ${constraints.maxHeight}");
        print("Max width: ${constraints.maxWidth}");
        var maxh = SizeConfig.heightMultiplier * 100;
        print("Maximum ht: ${maxh}");
        var maxw = constraints.maxWidth;
        return SingleChildScrollView(
          physics: (MediaQuery.of(context).viewInsets == 0)
              ? NeverScrollableScrollPhysics()
              : AlwaysScrollableScrollPhysics(),
          child: Form(
            key: _forrmkey2,
            child: Column(
              children: [
                Container(
                  height: 2 * maxh / 8.5,
                  child: Column(
                    children: [
                      Expanded(child: Container(),),
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: EdgeInsets.only(
                              top: maxh * 0.04, bottom: maxh * 0.04),
                          child: FittedBox(
                            child: Text(
                              "Inventory",
                              style: (TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.w400,
                                fontSize: 36 * maxh / 647,
                              )),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 3.5 * maxh / 8.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      //Flexible(
                      //child:
                      Container(
                        width: maxw * 0.8,
                        //height: maxh * 0.09,
                        padding: EdgeInsets.only(
                            right: 5 * maxw / 360,
                            left: 5 * maxw / 360,
                            top: 5 * maxh / 647,
                            bottom: 5 * maxh / 647),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: greyDark,
                                blurRadius: 5.0 * maxh / 647,
                              ),
                            ],
                            color: white,
                            borderRadius:
                                BorderRadius.circular(10 * maxh / 647)),
                        child: TextFormField(
                          key: ValueKey('email'),
                          cursorColor: primaryGreen,
                          decoration: InputDecoration(
                            //helperText: ' ',
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            errorStyle: TextStyle(
                              color: orange,
                              fontSize: 12 * maxh / 647,
                            ),
                            hintText: 'Email',
                            prefixIcon: Icon(
                              Icons.call,
                              color: Colors.black38,
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value.isEmpty || !value.contains('@')) {
                              return 'Enter valid email address!';
                            }
                          },
                          onSaved: (value) {
                            _userEmail = value;
                          },
                        ),
                      ),
                      SizedBox(
                        height: maxh * 0.02,
                      ),
                      if (!_isLogin)
                        Container(
                          width: maxw * 0.8,
                          //height: maxh * 0.09,
                          padding: EdgeInsets.only(
                              right: 5 * maxw / 360,
                              left: 5 * maxw / 360,
                              top: 5 * maxh / 647,
                              bottom: 5 * maxh / 647),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: greyDark,
                                  blurRadius: 5.0 * maxh / 647,
                                ),
                              ],
                              color: white,
                              borderRadius:
                                  BorderRadius.circular(10 * maxh / 647)),
                          child: TextFormField(
                            key: ValueKey('username'),
                            cursorColor: primaryGreen,
                            decoration: InputDecoration(
                              //helperText: ' ',
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent)),
                              errorStyle: TextStyle(
                                color: orange,
                                fontSize: 12 * maxh / 647,
                              ),
                              hintText: 'Username',
                              prefixIcon: Icon(
                                Icons.person,
                                color: Colors.black38,
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value.isEmpty || value.length < 4) {
                                return 'Username must be atleast 4 characters long!';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _userName = value;
                            },
                          ),
                        ),
                      // ),
                      SizedBox(
                        height: maxh * 0.02,
                      ),
                      Flexible(
                        child: Container(
                          padding: EdgeInsets.only(
                              right: 5 * maxw / 360,
                              left: 5 * maxw / 360,
                              top: 5 * maxh / 647,
                              bottom: 5 * maxh / 647),
                          width: maxw * 0.8,
                          //height: maxh * 0.07,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: greyDark,
                                  blurRadius:
                                      5.0 * maxh / 647, // soften the shadow
                                ),
                              ],
                              color: white,
                              borderRadius:
                                  BorderRadius.circular(10 * maxh / 647)),
                          child: TextFormField(
                            cursorColor: greyDark,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent)),
                              errorStyle: TextStyle(
                                color: orange,
                                fontSize: 12 * maxh / 647,
                              ),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.black38,
                              ),
                              hintText: 'Password',
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value.isEmpty || value.length < 6) {
                                return 'Password must be atleast 6 characters long!';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _password = value;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 3 * maxh / 8.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: (widget.isLoading)
                            ? CircularProgressIndicator()
                            : Container(
                                width: maxw * 0.8,
                                height: maxh * 0.07,
                                child: RaisedButton(
                                  child: Text(
                                    _isLogin ? 'Login' : 'Sign Up',
                                    style: TextStyle(
                                        color: white,
                                        fontSize: 20 * maxh / 647,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () => submit(),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          30 * maxh / 647)),
                                  color: Colors.orange[300],
                                ),
                              ),
                      ),
                      SizedBox(height:10*maxh/647),
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Flexible(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _forrmkey2.currentState.reset();
                                    _isLogin = !_isLogin;
                                  });
                                },
                                child: Text(
                                  _isLogin
                                      ? 'Create new account'
                                      : 'I already have an account',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
