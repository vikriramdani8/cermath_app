import 'dart:async';
import 'dart:convert';
import 'package:cermath_app/common/style/style_color.dart';
import 'package:cermath_app/common/style/style_common.dart';
import 'package:cermath_app/common/style/style_text.dart';
import 'package:cermath_app/common/widget/widget_alert.dart';
import 'package:cermath_app/common/widget/widget_shared.dart';
import 'package:flutter/material.dart';

class QuizListWidget{
  StyleText styleText = new StyleText();
  StyleColor styleColor = new StyleColor();
  StyleCommon styleCommon = new StyleCommon();
  WidgetShared widgetShared = new WidgetShared();
  WidgetAlert widgetAlert = new WidgetAlert();

  Widget listQuizData(List data, height){
    return Container(
      height: height - 220,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: data.length,
        itemBuilder: (context, i) {
          return Container(
            width: double.infinity,
            height: 180,
            margin: EdgeInsets.only(bottom: 20),
            child: Row(
              crossAxisAlignment:
              CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    color: Colors.transparent,
                    padding: EdgeInsets.only(right: 10),
                    child: const Image(
                      image: AssetImage(
                          'assets/images/math.png'
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Material(
                    elevation: 3,
                    borderRadius:
                    BorderRadius.circular(20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 4,
                            child: Container(
                              alignment: Alignment.bottomLeft,
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                data[i]['quizName'],
                                style: styleText.openSansBold(
                                  color: Colors.black87,
                                  size: 18.0,
                                  weightfont: false
                                ),
                              ),
                            )
                          ),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.only(
                                      left: 10
                                  ),
                                  child: Text(
                                    'Jumlah Soal: ${data[i]['jumlahSoal']}',
                                    style: styleText.openSansBold(
                                        color: Colors.black87,
                                        size: 13.0,
                                        weightfont: false
                                    ),
                                  ),
                                ),
                                widgetShared.divider(5.0, Colors.transparent),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.only(
                                      left: 10
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const Image(
                                        image: AssetImage('assets/images/target_score.png'),
                                        width: 25,
                                      ),
                                      Text(
                                          ' ${data[i]['maxScore'].toString()} XP',
                                          style: styleText.openSansBold(
                                              color: Colors.black87,
                                              size: 16.0,
                                              weightfont: true
                                          ),
                                      )
                                    ],
                                  ),
                                  // child:
                                ),
                                widgetShared.divider(5.0, Colors.transparent),
                              ],
                            )
                          ),
                          widgetShared.divider(1.0, styleColor.colorGrey),
                          Expanded(
                            flex: 3,
                            child: Container(
                              color: Colors.transparent,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  data[i]['maxLatestScore'] != null ?
                                  Text(
                                    'Skor: ${data[i]['maxLatestScore'].toString()} XP',
                                    style: styleText.openSansBold(
                                        color: styleColor.colorGrey,
                                        size: 14.0,
                                        weightfont: false
                                    ),
                                  ) :
                                  SizedBox(),
                                  ElevatedButton(
                                    onPressed:() {
                                      Navigator.pushNamed(
                                        context, '/quizTest',
                                        arguments: {
                                          'quizId': data[i]['quizId']
                                        },
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: styleColor.colorRed,
                                      elevation: 3,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 30
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20)
                                      )
                                    ),
                                    child: const Text("Mulai"),
                                  )
                                ],
                              ),
                            )
                          )
                        ],
                      ),
                    ),
                  )
                )
              ],
            ),
          );
        }
      )
    );
  }
}