import 'dart:convert';
import 'dart:io' as Io;

import 'package:cermath_app/common/style/style_color.dart';
import 'package:cermath_app/common/style/style_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:loading_indicator/loading_indicator.dart';

class WidgetShared {

  StyleText styleText = new StyleText();
  StyleColor styleColor = new StyleColor();

  Widget showLoading(){
    return Center(
      child: Container(
        width: 150,
        height: 150,
        child: LoadingIndicator(
          indicatorType: Indicator.pacman,
          strokeWidth: 1,
          colors: styleColor.kDefaultRainbowColors,
          pathBackgroundColor: Colors.white,
        ),
      ),
    );
  }

  Widget divider(height, color){
    return Divider(
      height: height,
      color: color,
    );
  }

  Widget base64ToImage({required String base64}){
    if(base64 != ""){
      final splitted = base64.split(',');
      Uint8List bytes = Base64Decoder().convert(splitted[1]);
      return Image.memory(bytes);
    } else {
      return Container();
    }
  }

  Widget circleWithColor(color) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle
      ),
    );
  }

  Widget analisisResult(color, option, result){
    return Container(
      width: 70,
      height: 100,
      child: Container(
        child: Column(
          children: [
            circleWithColor(color),
            divider(5.0, Colors.transparent),
            Text(
              option,
              style: styleText.poppinsBold(
                  color: Colors.black87,
                  size: 16.0,
                  weightfont: false
              ),
            ),
            divider(5.0, Colors.transparent),
            Text(
              result,
              style: styleText.poppinsBold(
                  color: Colors.black87,
                  size: 20.0,
                  weightfont: true
              ),
            )
          ],
        ),
      ),
    );
  }
}