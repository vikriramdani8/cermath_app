import 'package:cermath_app/common/style/style_color.dart';
import 'package:cermath_app/common/style/style_common.dart';
import 'package:cermath_app/common/style/style_text.dart';
import 'package:cermath_app/common/widget/widget_alert.dart';
import 'package:cermath_app/common/widget/widget_shared.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class WidgetMateri{
  StyleText styleText = new StyleText();
  StyleColor styleColor = new StyleColor();
  StyleCommon styleCommon = new StyleCommon();
  WidgetShared widgetShared = new WidgetShared();
  WidgetAlert widgetAlert = new WidgetAlert();

  Widget materiCard(BuildContext context, lessonId, lessonName, lessonImage, className) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/listMateri',
          arguments: {
            'lessonId': lessonId,
            'lessonName': lessonName
          },
        );
      },
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            child: widgetShared.base64ToImage(base64: lessonImage),
          ),
          SizedBox(width: 10),
          Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lessonName,
                    style: styleText.openSansBold(
                        color: styleColor.colorGrey,
                        size: 14.0,
                        weightfont: true
                    ),
                  ),
                  const Divider(
                    height: 2,
                  ),
                  className == '' ?
                  SizedBox() :
                  Text(
                      'Kelas: $className',
                      style: styleText.openSansBold(
                          color: styleColor.colorGrey,
                          size: 15.0,
                          weightfont: false
                      ),
                  )
                ],
              )
          )
        ],
      ),
    );
  }
}