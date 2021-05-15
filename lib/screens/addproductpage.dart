import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internshala/errordialouge.dart';
import 'package:internshala/size_config.dart';

class AddProductPage extends StatefulWidget {
  static final String routename = '/add-product-page';

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  bool _isLoading = false;
  Map<String, String> _userdata = {
    'name': '',
    'description': '',
    'id': '',
    'image': '',
  };
  bool isfirst = true;
  int from = 0;

  void showSubmitRequestSnackBar(BuildContext context, String msg) async {
    Flushbar(
      flushbarPosition: FlushbarPosition.BOTTOM,
      icon: Transform.scale(
          scale: 0.8, child: SvgPicture.asset("assets/images/right.svg")),
      messageText: Text(msg, style: TextStyle(color: Colors.green)),
      backgroundColor: Colors.grey[300],
      duration: Duration(seconds: 2),
    )..show(context).then((r) {
        Navigator.of(context).pop();
      });
  }

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
      if (from == 0) {
        if(_pickedImage==null){
          showErrorDialoug(1, "Please select the Image!", context);
          return;
        }
        setState(() {
        _isLoading = true;
      });
        final ref = FirebaseStorage.instance
            .ref()
            .child('product_image')
            .child(_pickedImage.path);
        await ref.putFile(_pickedImage).onComplete;
        final url = await ref.getDownloadURL();
        DocumentReference docRef =
            await Firestore.instance.collection('products').add(
          {
            'userId': user.uid,
            'productName': _userdata['name'],
            'productImage': url,
            'description': _userdata['description'],
          },
        );
        showSubmitRequestSnackBar(context, "Successfully added!");
      } else {
        var url;
        setState(() {
        _isLoading = true;
      });
        if (_pickedImage != null) {
          final ref = FirebaseStorage.instance
              .ref()
              .child('product_image')
              .child(_pickedImage.path);
          await ref.putFile(_pickedImage).onComplete;
          url = await ref.getDownloadURL();
        } else {
          url = _userdata['image'];
        }
        print("id is ${_userdata['id']}");
        await Firestore.instance
            .collection('products')
            .document(_userdata['id'])
            .updateData({
          'userId': user.uid,
          'productName': _userdata['name'],
          'productImage': url,
          'description': _userdata['description'],
        });
        showSubmitRequestSnackBar(context, "Successfully updated!");
      }
      setState(() {
        _isLoading = false;
      });
      // print(docRef.documentID);
    }
  }

  Future<void> showChoice(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Change Product Image?"),
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
      _userdata['image'] = '';
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
      _userdata['image'] = '';
      _pickedImage = pickedImageFile;
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (isfirst) {
      final productId =
          ModalRoute.of(context).settings.arguments as Map<String, String>;
      if (productId != null) {
        // _editProduct = Provider.of<Products>(context).findbyId(productId);
        // print("product is " + _editProduct.id);
        // _initialValue = {
        //   'title': _editProduct.title,
        //   'description': _editProduct.description,
        //   'price': _editProduct.price.toString(),
        // };
        // _imageUrlController.text = _editProduct.imageUrl;
        from = 1;
        _userdata = {
          'name': productId['name'],
          'description': productId['desc'],
          'image': productId['image'],
          'id': productId['id'],
        };
      }
      isfirst = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
    icon: Icon(Icons.arrow_back, color: Colors.white,),
    onPressed: () => Navigator.of(context).pop(),
  ), 
        title: Text(from == 0 ? "Add Product" : "Edit Product",style: TextStyle(color: Colors.white,)),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        var maxH = SizeConfig.heightMultiplier * 100;
        var maxW = SizeConfig.widthMultiplier * 100;
        print("maxH is ${maxH} ${maxW}");
        return SingleChildScrollView(
          physics: (MediaQuery.of(context).viewInsets == 0)
              ? NeverScrollableScrollPhysics()
              : AlwaysScrollableScrollPhysics(),
          child: Form(
            key: _forrmkey,
            child: Column(
              children: [
                Container(
                  height: 2 * maxH / 8.5,
                  child: GestureDetector(
                    onTap: () {
                      showChoice(context);
                    },
                    child: CircleAvatar(
                        radius: 55,
                        backgroundColor: Color(0xffFDCF09),
                        child: _userdata['image'] == ""
                            ? _pickedImage != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.file(
                                      _pickedImage,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    width: 100,
                                    height: 100,
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.grey[800],
                                    ),
                                  )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.network(
                                  _userdata['image'],
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              )),
                  ),
                ),
                Container(
                  height: 2.4* maxH / 8.5,
                  child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: 25 * maxH / 647,
                            bottom: 5 * maxH / 647,
                            left: 10 * maxW / 360,
                            right: 10 * maxW / 360),
                        padding: EdgeInsets.fromLTRB(
                            15 * maxW / 360, 0, 5 * maxW / 360, 0),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                                color: Colors.grey, width: 1 * maxW / 360),
                            top: BorderSide(
                                color: Colors.grey, width: 1 * maxW / 360),
                            right: BorderSide(
                                color: Colors.grey, width: 1 * maxW / 360),
                            left: BorderSide(
                                color: Colors.grey, width: 1 * maxW / 360),
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
                            bottom: 5 * maxH / 647,
                            left: 10 * maxW / 360,
                            right: 10 * maxW / 360),
                        padding: EdgeInsets.fromLTRB(
                            15 * maxW / 360, 0, 5 * maxW / 360, 0),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                                color: Colors.grey, width: 1 * maxW / 360),
                            top: BorderSide(
                                color: Colors.grey, width: 1 * maxW / 360),
                            right: BorderSide(
                                color: Colors.grey, width: 1 * maxW / 360),
                            left: BorderSide(
                                color: Colors.grey, width: 1 * maxW / 360),
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
                            if (value.isEmpty) {
                              return "Description should not be empty";
                            }
                          },
                          onSaved: (value) {
                            _userdata['description'] = value;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    height: 3 * maxH / 8.5,
                                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,

                                      children: [
                                        Flexible(
                                          child: Container(
                          margin: EdgeInsets.only(top: 20*maxH/647,left: 10 * maxW / 360,
                            right: 10 * maxW / 360),
                          width: maxW ,
                          height: maxH * 0.07,
                          child:(_isLoading)
                      ? Center(child: CircularProgressIndicator())
                      :  RaisedButton(
                            child: Text(
                              from == 0 ? 'Add Product' : "Update Product",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20 * maxH / 647,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () => _sendMessage(),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                          BorderRadius.circular(30 * maxH / 647)),
                            color: Colors.orange,
                          ),
                        ),
                                        ),
                                      ],
                                    ),
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
            ),
          ),
        );
      }),
    );
  }
}
