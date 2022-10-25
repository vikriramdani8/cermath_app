import 'dart:async';
import 'dart:convert';
import 'package:cermath_app/common/style/style_color.dart';
import 'package:cermath_app/common/style/style_common.dart';
import 'package:cermath_app/common/style/style_text.dart';
import 'package:cermath_app/common/widget/widget_alert.dart';
import 'package:cermath_app/common/widget/widget_shared.dart';
import 'package:flutter/material.dart';

class LeaderboardWidget{
  StyleText styleText = new StyleText();
  StyleColor styleColor = new StyleColor();
  StyleCommon styleCommon = new StyleCommon();
  WidgetShared widgetShared = new WidgetShared();
  WidgetAlert widgetAlert = new WidgetAlert();

  Widget listleaderBoard(List data, heigth) {
    return Container(
      height: heigth,
      child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: data.length,
          itemBuilder: (context, i) {
            return Container(
              height: 80,
              decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1.0, color: Colors.grey.shade300),
                  )
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 10),
                    child: Text(
                      (i+1).toString(),
                      style: styleText.openSansBold(color: Colors.black87, size: 18.0, weightfont: true),
                    ),
                  ),
                  Container(
                    width: 80,
                    alignment: Alignment.center,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(35)
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data[i]['followingName'],
                          style: styleText.openSansBold(color: Colors.black87, size: 17.0, weightfont: true),
                        ),
                        Text(
                          '${data[i]['score'] ?? 0} XP',
                          style: styleText.openSansBold(color: Colors.black87, size: 16.0, weightfont: false),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          }
      ),
    );
  }
}