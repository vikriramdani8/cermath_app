import 'package:flutter/material.dart';

class StyleCommon{
  OutlineInputBorder myinputborder(bool align) {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Colors.blueGrey,
          width: 0,
        ));
  }

  OutlineInputBorder myfocusborder(bool align) {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Colors.blueGrey,
          width: 0,
        ));
  }

  BoxDecoration buttonLogin(){
    return BoxDecoration(
        border: Border.all(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(30),
        color: Colors.white
    );
  }

  BoxDecoration cardWithBoxShadow(){
    return BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0,
            blurRadius: 2,
            offset: Offset(0,1), // changes position of shadow
          ),
        ],
        borderRadius: const BorderRadius.all(Radius.circular(15),
        )
    );
  }

  InputDecoration fieldDecorationPassword(label){
    return InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 5),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelText: label,
        prefixIcon: Icon(
          Icons.lock,
          color: Colors.grey[500]!,
        ),
        border: myinputborder(true),
        enabledBorder: myinputborder(true),
        focusedBorder: myfocusborder(true),
        focusColor: Colors.white,
    );
  }
}