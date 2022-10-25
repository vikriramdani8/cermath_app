import 'dart:async';
import 'dart:convert';
import 'package:cermath_app/common/style/style_color.dart';
import 'package:cermath_app/common/style/style_common.dart';
import 'package:cermath_app/common/style/style_text.dart';
import 'package:cermath_app/common/widget/widget_alert.dart';
import 'package:cermath_app/common/widget/widget_shared.dart';
import 'package:cermath_app/features/homepage/quiz/quiz_list_widget.dart';
import 'package:cermath_app/models/model_user.dart';
import 'package:cermath_app/routing/routes-helper.dart';
import 'package:cermath_app/services/service_materi.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizList extends StatefulWidget {
  const QuizList({Key? key}) : super(key: key);

  @override
  State<QuizList> createState() => _QuizListState();
}

class _QuizListState extends State<QuizList> {

  StyleText styleText = new StyleText();
  StyleColor styleColor = new StyleColor();
  StyleCommon styleCommon = new StyleCommon();
  WidgetShared widgetShared = new WidgetShared();
  WidgetAlert widgetAlert = new WidgetAlert();
  QuizListWidget quizListWidget = new QuizListWidget();

  var lessonId = "";
  var lessonName = "";

  settingArgument(BuildContext ctx) {
    final arguments = (ModalRoute.of(ctx)?.settings.arguments ?? <String, dynamic>{}) as Map;
    if (lessonId != arguments['lessonId']) {
      lessonId = arguments['lessonId'];
      lessonName = arguments['lessonName'];
    }
  }

  ModelUser? modelUser;
  Future<void> checkAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userPref = prefs.getString('user');
    bool? login = prefs.getBool('login');

    if (login == true && userPref != null) {
      var userMap = jsonDecode(userPref);
      modelUser = ModelUser.fromJson(userMap);
    }
  }

  Future<void> getListQuiz(lessonId) async {
    await checkAuth();
    var responses = await ServiceMateri().getListQuizByLessonId(modelUser?.users_id, lessonId);
    var resultBody = json.decode(responses.body);
    return resultBody['data'];
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    settingArgument(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: styleColor.colorPurple,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 100,
              width: width,
              decoration: BoxDecoration(color: styleColor.colorPurple,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ]
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widgetShared.divider(20.0, Colors.transparent),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Latihan Soal',
                          style: styleText.openSansBold(
                              color: Colors.white,
                              size: 20.0,
                              weightfont: true),
                        ),
                        Text(
                          lessonName,
                          style: styleText.openSansBold(
                              color: Colors.white,
                              size: 18.0,
                              weightfont: false),
                        )
                      ],
                    ),
                  ),
                ]
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  FutureBuilder(
                    future: getListQuiz(lessonId),
                    builder: (Context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          return Center(
                            child: InkWell(
                              onTap: () {
                                setState(() {});
                              },
                            ),
                          );
                        }
                        if (snapshot.hasData) {
                          List data = snapshot.data as List;
                          return quizListWidget.listQuizData(data, height);
                        }
                      }
                      return Center(child: CircularProgressIndicator());
                    }
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
