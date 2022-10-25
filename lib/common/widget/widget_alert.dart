import 'package:cermath_app/common/style/style_color.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class WidgetAlert{

  showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(margin: const EdgeInsets.only(left: 7),child:Text("Loading..." )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }

  showSuccesSnackbar(String msg, BuildContext context) {
    final snackBar = SnackBar(
      duration: Duration(seconds: 3),
      content: Text(msg.toString()),
      backgroundColor: Colors.green,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  showErrorSnackbar(String msg, BuildContext context) {
    final snackBar = SnackBar(
      duration: Duration(seconds: 3),
      content: Text(msg.toString()),
      backgroundColor: Colors.red,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

}