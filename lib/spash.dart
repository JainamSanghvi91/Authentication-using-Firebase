import 'package:flutter/material.dart';
import 'package:internshala/size_config.dart';
class SplasScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, snapshot) {
        SizeConfig().init(snapshot);
        var maxW=snapshot.maxWidth;
        return Scaffold(
          body: Center(child: Container(width:maxW*0.8 ,child: Image.asset('assets/images/add_product.png')))
        );
      }
    );
  }
}