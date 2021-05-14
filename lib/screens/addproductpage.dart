import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internshala/size_config.dart';

class AddProductPage extends StatefulWidget {
  static final String routename = '/add-product-page';

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  Map<String, String> _userdata = {
    'name': '',
    'description': '',
  };
  File _pickedImage;
  var _controller = TextEditingController();
  final GlobalKey<FormState> _forrmkey = GlobalKey();
  void _sendMessage() async {
    _controller.clear();
    final isValid = _forrmkey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _forrmkey.currentState.save();
      final user = await FirebaseAuth.instance.currentUser();
      final userData =
          await Firestore.instance.collection('users').document(user.uid).get();

      final ref = FirebaseStorage.instance
          .ref()
          .child('product_image')
          .child(user.uid + '.jpg');

      await ref.putFile(_pickedImage).onComplete;

      final url = await ref.getDownloadURL();

      Firestore.instance.collection('products').add(
        {
          'userId': user.uid,
          'productName': _userdata['name'],
          'productImage': url,
          'description': _userdata['description'],
        },
      );
    }
  }

  Future<void> showChoice(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Change Profile Picture?"),
            content: Text("Which source you want to use Camera or Gallery?"),
            actions: [
              FlatButton(
                  child: Text(
                    "Gallery",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () {
                    getImageGallery();
                    Navigator.of(context).pop();
                  }),
              FlatButton(
                  child: Text(
                    "Camera",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () {
                    getImageCamera();
                    Navigator.of(context).pop();
                  })
            ],
          );
        });
  }

  Future getImageCamera() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );
    final pickedImageFile = File(pickedImage.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });
  }

  Future getImageGallery() async {
    final image = await ImagePicker.pickImage(source: ImageSource.gallery);
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );
    final pickedImageFile = File(pickedImage.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });
  }

  // @override
  // void didChangeDependencies() {
  //   // TODO: implement didChangeDependencies
  //   super.didChangeDependencies();
  //   final productId = ModalRoute.of(context).settings.arguments as String;
  //     if (productId != null) {
  //       // _editProduct = Provider.of<Products>(context).findbyId(productId);
  //       // print("product is " + _editProduct.id);
  //       // _initialValue = {
  //       //   'title': _editProduct.title,
  //       //   'description': _editProduct.description,
  //       //   'price': _editProduct.price.toString(),
  //       // };
  //       // _imageUrlController.text = _editProduct.imageUrl;
  //      _userdata = {
  //         'name': 'Savan',
  //         'description': 'This is the description.',
  //       };
  //     }
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Add Product"),
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          SizeConfig().init(constraints);
          var maxH = SizeConfig.heightMultiplier * 100;
          var maxW = SizeConfig.widthMultiplier * 100;
          return Column(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: Color(0xffdadada),
                backgroundImage: _pickedImage != null
                    ? FileImage(
                        _pickedImage,
                      )
                    : null,
              ),
              SizedBox(
                height: 10,
              ),
              FlatButton.icon(
                color: Theme.of(context).accentColor,
                onPressed: () => showChoice(context),
                icon: Icon(
                  Icons.image,
                ),
                label: Text('Add image'),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 20 * maxH / 647),
                  padding: EdgeInsets.only(
                      left: 20 * maxW / 360,
                      right: 20 * maxW / 360,
                      top: 10 * maxH / 647),
                  child: Form(
                    key: _forrmkey,
                    child: SingleChildScrollView(
                      physics:
                          // (MediaQuery.of(context).viewInsets.bottom) ==
                          //         0
                          AlwaysScrollableScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            maxHeight: maxH * 0.7, maxWidth: maxW),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // deliveryOptionChosen == DeliveryOptions.Delivery

                              //  Expanded(
                              //     child:
                              Container(
                                margin: EdgeInsets.only(
                                    top: 5 * maxH / 647,
                                    bottom: 5 * maxH / 647),
                                padding: EdgeInsets.fromLTRB(
                                    15 * maxW / 360, 0, 5 * maxW / 360, 0),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey,
                                        width: 1 * maxW / 360),
                                    top: BorderSide(
                                        color: Colors.grey,
                                        width: 1 * maxW / 360),
                                    right: BorderSide(
                                        color: Colors.grey,
                                        width: 1 * maxW / 360),
                                    left: BorderSide(
                                        color: Colors.grey,
                                        width: 1 * maxW / 360),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey[350],
                                        blurRadius: 0.0046 * maxH)
                                  ],
                                  borderRadius:
                                      BorderRadius.circular(3 * maxH / 647),
                                  color: Colors.white,
                                ),
                                child: TextFormField(
                                  style: TextStyle(fontSize: 15 * maxH / 647),
                                  initialValue: _userdata['name'],
                                  //  maxLines: 3,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Name',
                                    contentPadding: EdgeInsets.all(0),
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Name should not be empty";
                                    }
                                  },
                                  onSaved: (value) {
                                    //_userdata['address'] = value;
                                    _userdata['name'] = value;
                                    print("Name of Product:");
                                    print(_userdata['name']);
                                  },
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: 5 * maxH / 647,
                                    bottom: 5 * maxH / 647),
                                padding: EdgeInsets.fromLTRB(
                                    15 * maxW / 360, 0, 5 * maxW / 360, 0),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey,
                                        width: 1 * maxW / 360),
                                    top: BorderSide(
                                        color: Colors.grey,
                                        width: 1 * maxW / 360),
                                    right: BorderSide(
                                        color: Colors.grey,
                                        width: 1 * maxW / 360),
                                    left: BorderSide(
                                        color: Colors.grey,
                                        width: 1 * maxW / 360),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey[350],
                                        blurRadius: 0.0046 * maxH)
                                  ],
                                  borderRadius:
                                      BorderRadius.circular(3 * maxH / 647),
                                  color: Colors.white,
                                ),
                                child: TextFormField(
                                  style: TextStyle(fontSize: 15 * maxH / 647),
                                  initialValue: _userdata['description'],
                                  maxLines: 2,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Description',
                                    contentPadding: EdgeInsets.all(0),
                                  ),
                                  validator: (value) {
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _userdata['description'] = value;
                                  },
                                ),
                              )
                            ]),
                      ),
                    ),
                  ),
                ),
              ),
              RaisedButton(
                child: Text('Add Product'),
                onPressed: _sendMessage,
              ),
              // Container(
              //   margin: EdgeInsets.only(top: 16 * maxH / 647),
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(5),
              //     boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 6)],
              //   ),
              //   child: InkWell(
              //     // child: CircleAvatar(
              //     //   backgroundColor: greyLight,
              //     //   radius: maxW * 0.26,
              //     //   // size.width / 3.6,
              //     child: (isPresent)
              //         ? Center(
              //             child: CircularProgressIndicator(),
              //           )
              //         : Container(
              //             width: maxW * 0.4,
              //             height: maxH * 0.2,
              //             padding: EdgeInsets.all(2 * maxW / 360),
              //             decoration: BoxDecoration(
              //                 borderRadius:
              //                     BorderRadius.circular(5 * maxH / 647),
              //                 border: Border(
              //                     bottom: BorderSide(width: 1.0 * maxW / 360),
              //                     top: BorderSide(width: 1.0 * maxW / 360),
              //                     right: BorderSide(width: 1.0 * maxW / 360),
              //                     left: BorderSide(width: 1.0 * maxW / 360))),
              //             child: userdata.image == null
              //                 ? Image.asset("assets/images/profile.jpg")
              //                 : CachedNetworkImage(
              //                     imageUrl: userdata.image,
              //                     // height: maxH * 0.17,
              //                     // width: maxW * 0.3,
              //                     placeholder: (context, url) => Image.asset(
              //                       "assets/images/profile.jpg",
              //                     ),
              //                     imageBuilder: (context, image) => Image(
              //                       image: image,
              //                       fit: BoxFit.cover,
              //                     ),
              //                     errorWidget: (context, url, error) =>
              //                         Image.asset(
              //                       "assets/images/profile.jpg",
              //                     ),
              //                   ),
              //           )
              //     // : imageFromPreferences == null
              //     //     ? Container(
              //     //         width: maxW * 0.4,
              //     //         height: maxH * 0.2,
              //     //         padding: EdgeInsets.all(2),
              //     //         decoration: BoxDecoration(
              //     //             borderRadius:
              //     //                 BorderRadius.circular(5),
              //     //             border: Border(
              //     //                 bottom: BorderSide(width: 1.0),
              //     //                 top: BorderSide(width: 1.0),
              //     //                 right: BorderSide(width: 1.0),
              //     //                 left: BorderSide(width: 1.0))),
              //     //         child: Image.asset(
              //     //             "assets/images/profile.jpg"),
              //     //       )
              //     // :
              //     // Stack(
              //     //     children: <Widget>[
              //     // Container(
              //     //     width: maxW * 0.4,
              //     //     padding: EdgeInsets.all(2),
              //     //     decoration: BoxDecoration(
              //     //         borderRadius:
              //     //             BorderRadius.circular(5),
              //     //         border: Border(
              //     //             bottom: BorderSide(width: 1.0),
              //     //             top: BorderSide(width: 1.0),
              //     //             right: BorderSide(width: 1.0),
              //     //             left: BorderSide(width: 1.0))),
              //     //     child: ColorFiltered(
              //     //       colorFilter: _isedit
              //     //           ? ColorFilter.mode(
              //     //               Colors.black, BlendMode.hue)
              //     //           : ColorFilter.mode(
              //     //               Colors.transparent,
              //     //               BlendMode.plus),
              //     //       child: imageFromPreferences
              //     //     ),
              //     //   ),
              //     ,
              //     onTap: () {
              //       showChoice(context);
              //     },
              //   ),
              // ),
              // Expanded(child: ,)
            ],
          );
        }),
      ),
    );
  }
}
