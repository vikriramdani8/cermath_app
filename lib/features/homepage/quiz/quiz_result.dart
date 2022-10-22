import 'dart:async';
import 'dart:convert';
import 'package:cermath_app/common/style/style_color.dart';
import 'package:cermath_app/common/style/style_common.dart';
import 'package:cermath_app/common/style/style_text.dart';
import 'package:cermath_app/common/widget/widget_alert.dart';
import 'package:cermath_app/common/widget/widget_shared.dart';
import 'package:cermath_app/features/homepage/quiz/quiz_list_widget.dart';
import 'package:cermath_app/models/model_result.dart';
import 'package:cermath_app/services/service_materi.dart';
import 'package:circle_progress_bar/circle_progress_bar.dart';
import 'package:flutter/material.dart';

class QuizResult extends StatefulWidget {
  const QuizResult({Key? key}) : super(key: key);

  @override
  State<QuizResult> createState() => _QuizResultState();
}

class _QuizResultState extends State<QuizResult> {

  StyleText styleText = new StyleText();
  StyleColor styleColor = new StyleColor();
  StyleCommon styleCommon = new StyleCommon();
  WidgetShared widgetShared = new WidgetShared();
  WidgetAlert widgetAlert = new WidgetAlert();
  QuizListWidget quizListWidget = new QuizListWidget();

  ModelResult? modelResult;
  DateTime today = new DateTime.now();
  String dateSlug = "";
  double resultQuiz = 0;

  settingArgument(BuildContext ctx) {
    final arguments =
    (ModalRoute.of(ctx)?.settings.arguments ?? <String, dynamic>{}) as Map;

    dateSlug ="${today.day.toString().padLeft(2,'0')}/${today.month.toString().padLeft(2,'0')}/${today.year.toString()}";

    if (modelResult?.quizId != arguments['quizId']) {
      modelResult = ModelResult(
          quizId: arguments['quizId'],
          userId: arguments['userId'],
          quizName: arguments['quizName'],
          score: int.parse(arguments['score']) ,
          correctAnswer: int.parse(arguments['correctAnswer']),
          wrongAnswer: int.parse(arguments['wrongAnswer']),
          notAnswer: int.parse(arguments['notAnswer'])
      );
    }

    var totalQuestion = modelResult!.correctAnswer+modelResult!.wrongAnswer+modelResult!.notAnswer;
    resultQuiz = (modelResult!.correctAnswer/totalQuestion);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    settingArgument(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Latihan'),
        backgroundColor: styleColor.colorPurple,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: Container(
            width: size.width,
            height: size.height*0.6,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 0,
                  blurRadius: 3,
                  offset: Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  modelResult!.quizName,
                  style: styleText.openSansBold(
                      color: styleColor.colorGrey,
                      size: 18.0,
                      weightfont: true
                  ),
                ),
                Text(
                  dateSlug.toString(),
                  style: styleText.openSansBold(
                      color: styleColor.colorGrey,
                      size: 16.0,
                      weightfont: false
                  ),
                ),
                widgetShared.divider(20.0, Colors.transparent),
                SizedBox(
                  width: 100,
                  child: CircleProgressBar(
                      foregroundColor: resultQuiz > 0.6 ? Colors.greenAccent : Colors.redAccent,
                      backgroundColor: Colors.black12,
                      value: resultQuiz,
                      child: Center(
                        child: AnimatedCount(
                          style: styleText.openSansBold(
                              color: styleColor.colorGrey,
                              size: 25.0,
                              weightfont: true
                          ),
                          count: resultQuiz*100,
                          unit: '%',
                          fractionDigits: 0,
                          duration: const Duration(milliseconds: 500),
                        ),
                      )
                  ),
                ),
                widgetShared.divider(20.0, Colors.transparent),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Total Score: ",
                      style: styleText.openSansBold(
                          color: styleColor.colorGrey,
                          size: 18.0,
                          weightfont: false
                      ),
                    ),
                    Text(
                      modelResult!.score.toString(),
                      style: styleText.openSansBold(
                          color: styleColor.colorGrey,
                          size: 18.0,
                          weightfont: true
                      ),
                    ),
                  ],
                ),
                widgetShared.divider(20.0, Colors.transparent),
                widgetShared.divider(1.0, Colors.black45),
                widgetShared.divider(30.0, Colors.transparent),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    widgetShared.analisisResult(
                        Colors.greenAccent,
                        "Benar",
                        modelResult!.correctAnswer.toString()
                    ),
                    widgetShared.analisisResult(
                        styleColor.colorRed,
                        "Salah",
                        modelResult!.wrongAnswer.toString()
                    ),
                    widgetShared.analisisResult(
                        Colors.grey,
                        "Dilewati",
                        modelResult!.notAnswer.toString()
                    )
                  ],
                ),
                widgetShared.divider(40.0, Colors.transparent),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                    context, '/quizTest',
                                    arguments: {
                                      'quizId': modelResult!.quizId
                                    },
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  side: BorderSide(
                                    color: styleColor.colorRed,
                                  ),
                                  padding: EdgeInsets.all(15),
                                ),
                                child: Text(
                                  "Kerjakan ulang",
                                  style: styleText.openSansBold(
                                      color: styleColor.colorRed,
                                      size: 16.0,
                                      weightfont: false),
                                )
                            ),
                          )
                      ),
                      Expanded(
                        child: Padding(
                            padding: EdgeInsets.all(5),
                            child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: styleColor.colorRed,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  side: BorderSide(
                                    color: styleColor.colorRed,
                                  ),
                                  padding: EdgeInsets.all(15),
                                ),
                                child: Text(
                                  "Selesai",
                                  style: styleText.openSansBold(
                                    color: Colors.white,
                                    size: 16.0,
                                    weightfont: false
                                  ),
                                )
                            )
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}
