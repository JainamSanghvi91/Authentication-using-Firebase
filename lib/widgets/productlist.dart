import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:internshala/product.dart';
import 'package:internshala/screens/addproductpage.dart';
import 'package:internshala/size_config.dart';
import 'package:sweetalert/sweetalert.dart';

class ProductList extends StatelessWidget {
  const ProductList({
    Key key,
    @required this.name,
    @required this.desc,
    @required this.id,
    @required this.remover,
    @required this.image,
  }) : super(key: key);

  final String name;
  final String desc;
  final String image;
  final String id;
  final Function remover;

  @override
  Widget build(BuildContext context) {
    print("image is ${image}");
    return LayoutBuilder(
      builder: (context, constraints) {
        var maxW = SizeConfig.heightMultiplier * 100;
        var maxH = SizeConfig.widthMultiplier * 100;
        print("productlist $maxW $maxH");
        return Container(
          margin: EdgeInsets.only(left: 1 * maxW / 360, right: 1 * maxW / 360),
          padding: EdgeInsets.only(left: 2 * maxW / 360, right: 2 * maxW / 360),
          height: maxH * 0.25,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      flex: 6,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2 * maxW / 360,
                            vertical: 2 * maxH / 647),
                        width: min(maxW * 0.28, constraints.maxHeight * 0.8),
                        height: min(maxW * 0.28, constraints.maxHeight * 0.8),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(8 * maxH / 647),
                            child: Image.network(
                              image,
                              fit: BoxFit.contain,
                            )),
                        // ClipRRect(
                        //   borderRadius: BorderRadius.circular(4 * maxH / 647),
                        //   child: CachedNetworkImage(
                        //     imageUrl: image == null ? "" : image,
                        //     placeholder: (context, url) => SvgPicture.asset(
                        //       "assets/images/right.svg",
                        //       fit: BoxFit.contain,
                        //     ),
                        //     imageBuilder: (context, image) => Image(
                        //       image: image,
                        //       fit: BoxFit.contain,
                        //     ),
                        //     errorWidget: (context, url, error) =>
                        //         SvgPicture.asset(
                        //       "assets/images/right.svg",
                        //       fit: BoxFit.contain,
                        //     ),
                        //   ),
                        // ),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(8.0 * maxH / 647)),
                      ),
                    ),
                    Expanded(
                      flex: 12,
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 2 * maxW / 360, top: 4 * maxH / 647),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              // flex: 3,
                              child: Text(
                                // "Bina Provison  msddj ksfjvkfjv",
                                name,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 32 * maxH / 647),
                              ),
                            ),
                            SizedBox(
                              height: 4 * maxH / 647,
                            ),
                            Flexible(
                              // flex: 2,
                              child: Text(
                                // "Kanal Road, Near Vardhman, Morbi-363641 smnxsajcjcdncsc ndmcm s hwbdjshcjsd jvhjdvfjdh bjdfh  jdhbdjf dhfbvdjbjf j dhb",
                                
                                desc,
                                                                overflow: TextOverflow.ellipsis,

                                maxLines: 2,
                                style: TextStyle(fontSize: 24 * maxH / 647),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: (){
                              SweetAlert.show(context,
                              title: "Confirmation",
                              subtitle: "   Are you sure you want to delete?",
                              
                              // subtitlePadding: EdgeInsets.all(8.0),
                              style: SweetAlertStyle.confirm,
                              // ignore: missing_return
                              showCancelButton: true,
                              onPress: (bool isConfirm) {
                              if (isConfirm) {
                                remover(id);
                                Navigator.of(context).pop();
                                return false;
                              }
                            });
                             
                            },
                            child: Icon(
                              Icons.close,
                              size: 32*maxH/647,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Product product = Product(
                                  id: id,
                                  desc: desc,
                                  imageurl: image,
                                  name: name);
                              Navigator.of(context).pushNamed(
                                  AddProductPage.routename,
                                  arguments: {
                                    'id': id,
                                    'desc': desc,
                                    'image': image,
                                    'name': name
                                  });
                            },
                            child: Icon(
                              Icons.edit,
                              size: 32*maxH/647,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Divider(
                thickness: 1,
                color: Colors.grey[600],
              )
            ],
          ),
        );
      },
    );
  }
}
