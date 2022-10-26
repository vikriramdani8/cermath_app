import 'dart:async';
import 'dart:convert';
import 'package:cermath_app/common/style/style_color.dart';
import 'package:cermath_app/common/style/style_common.dart';
import 'package:cermath_app/common/style/style_text.dart';
import 'package:cermath_app/common/widget/widget_alert.dart';
import 'package:cermath_app/common/widget/widget_shared.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

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

  Widget shimmerLeaderboard(width){
    return SizedBox(
      width: width,
      height: 400,
      child: Shimmer.fromColors(
        baseColor: Colors.black12,
        highlightColor: Colors.white60,
        child: ListView.builder(
          itemBuilder: (_, __) => Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                containerShimmer(width),
              ],
            ),
          ),
          itemCount: 5,
        ),
      ),
    );
  }

  Widget containerShimmer(width){
    return Container(
      width: width,
      padding: const EdgeInsets.only(
        left: 20
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 60,
            height: 60.0,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                Radius.circular(50)
              )
            ),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: width-15-60-50,
                height: 15,
                color: Colors.white,
              ),
              const SizedBox(height: 10),
              Container(
                width: 70,
                height: 15,
                color: Colors.white,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget listFriend(List data, height) {
    return Container(
      height: height,
      padding: EdgeInsets.all(20),
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: data.length,
        itemBuilder: (context, i) {
          return Container(
            width: double.infinity,
            height: 80,
            padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                    flex: 4,
                    child: Row(
                      children: [
                        Container(
                          width: 55,
                          height: 55,
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(30)
                          ),
                        ),
                        Container(
                          height: double.infinity,
                          padding: EdgeInsets.only(left: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                data[i]['username'],
                                style: styleText.openSansBold(color: Colors.black, size: 17.0, weightfont: true),
                              ),
                              Text(
                                data[i]['fullname'],
                                style: styleText.openSansBold(color: Colors.grey.shade400, size: 16.0, weightfont: false),
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                ),
                Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                          height: 50,
                          child: Icon(
                            Icons.person_add,
                            color: styleColor.colorRed,
                            size: 30,
                          )
                      ),
                    )
                )
              ],
            ),
          );
        }
      ),
    );
  }
}