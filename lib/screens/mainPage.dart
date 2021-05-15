import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internshala/screens/addproductpage.dart';
import 'package:internshala/size_config.dart';
import 'package:internshala/widgets/productlist.dart';
import 'package:sweetalert/sweetalert.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      SizeConfig().init(constraints);
      var maxW=constraints.maxWidth;
      var maxH=constraints.maxHeight;
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Inventory',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
                icon: Icon(Icons.exit_to_app, color: Colors.white),
                onPressed: () => {
                      SweetAlert.show(context,
                          title: "Confirmation",
                          subtitle: "   Are you sure you want to logout?",

                          // subtitlePadding: EdgeInsets.all(8.0),
                          style: SweetAlertStyle.confirm,
                          // ignore: missing_return
                          showCancelButton: true, onPress: (bool isConfirm) {
                        if (isConfirm) {
                          Navigator.of(context).pop();

                          FirebaseAuth.instance.signOut();
                          return false;
                        }
                      })
                    }),
          ],
        ),
        body: FutureBuilder(
          future: FirebaseAuth.instance.currentUser(),
          builder: (ctx, futureSnapshot) {
            if (futureSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return StreamBuilder(
                stream: Firestore.instance
                    .collection('products')
                    .where("userId", isEqualTo: futureSnapshot.data.uid)
                    // .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (ctx, chatSnapshot) {
                  if (chatSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final chatDocs = chatSnapshot.data.documents;
                  final user = FirebaseAuth.instance.currentUser;
                  void remover(String id) {
                    Firestore.instance
                        .collection('products')
                        .document(id)
                        .delete();
                  }
                  return Container(      
               padding: EdgeInsets.only(top: 10),
                    child: chatDocs.length == 0
                        ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(child: Container(width: maxW*0.6,child: Image.asset('assets/images/add_product.png'))),
                            Text("Add Product to your Inventory!",style: TextStyle(fontSize: 16*maxH/647)),
                          ],
                        )
                        : ListView.builder(
                            // reverse: true,
                            itemCount: chatDocs.length,
                            itemBuilder: (ctx, index) {
                              return ProductList(
                                  remover: remover,
                                  id: chatDocs[index].documentID,
                                  image: chatDocs[index]['productImage'],
                                  name: chatDocs[index]['productName'],
                                  desc: chatDocs[index]['description']);
                              // (chatDocs[index]['productName']);
                            }

                            // MessageBubble(
                            //   chatDocs[index]['text'],
                            //   chatDocs[index]['userId'] == futureSnapshot.data.uid,
                            //   chatDocs[index]['username'],
                            //   chatDocs[index]['userImage'],
                            //   key: ValueKey(chatDocs[index]
                            //       .documentID), // key just for efficently updating the list of messages
                            // ),
                            ),
                  );
                });
          },
        ),
        floatingActionButton: FloatingActionButton(
            // backgroundColor: primaryGreen,
            foregroundColor: Colors.white,
            child: Icon(Icons.add),
            onPressed: () =>
                Navigator.of(context).pushNamed(AddProductPage.routename)),
      );
    });
  }
}
