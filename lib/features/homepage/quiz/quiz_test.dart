import 'dart:async';
import 'dart:convert';
import 'package:cermath_app/common/style/style_color.dart';
import 'package:cermath_app/common/style/style_common.dart';
import 'package:cermath_app/common/style/style_text.dart';
import 'package:cermath_app/common/widget/widget_alert.dart';
import 'package:cermath_app/common/widget/widget_shared.dart';
import 'package:cermath_app/features/homepage/quiz/quiz_list_widget.dart';
import 'package:cermath_app/models/model_user.dart';
import 'package:cermath_app/services/service_materi.dart';
import 'package:cermath_app/services/service_quiz.dart';
import 'package:flutter/material.dart';

import 'package:flutter_tex/flutter_tex.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizTest extends StatefulWidget {
  const QuizTest({Key? key}) : super(key: key);

  @override
  State<QuizTest> createState() => _QuizTestState();
}

class _QuizTestState extends State<QuizTest> {

  @override
  void initState(){
    super.initState();
    checkAuth();
  }

  StyleText styleText = new StyleText();
  StyleColor styleColor = new StyleColor();
  StyleCommon styleCommon = new StyleCommon();
  WidgetShared widgetShared = new WidgetShared();
  WidgetAlert widgetAlert = new WidgetAlert();
  QuizListWidget quizListWidget = new QuizListWidget();

  var quizId = "";
  var currentIndex = 0;
  var selectedOptions = "";
  var quizName = "";
  List<dynamic> quizList = [];
  List<dynamic> answerList = [];
  List<dynamic> correctList = [];

  int currentQuizIndex = 0;
  String selectedOptionId = "";
  bool isWrong = false;
  ModelUser? modelUser;

  settingArgument(BuildContext ctx) {
    final arguments =
        (ModalRoute.of(ctx)?.settings.arguments ?? <String, dynamic>{}) as Map;

    if (quizId != arguments['quizId']) {
      quizId = arguments['quizId'];

      getListQuestion(quizId);
    }
  }

  void getListQuestion(quizId) async {
    var responses = await ServiceMateri().getListQuizQuestionByQuizId(quizId);
    var resultBody = json.decode(responses.body);

    setState(() {
      quizName = resultBody['data']['quizName'];
      quizList = resultBody['data']['listQuiz'];
      quizList.forEach((element) {
        answerList.add("");
        correctList.add(false);
      });
    });
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Apakah kamu yakin?'),
        content: const Text('Ingin mengakhiri latihan soal'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Tidak'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Ya'),
          ),
        ],
      ),
    )) ?? false;
  }

  Future<void> checkAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userPref = prefs.getString('user');
    var userMap = jsonDecode(userPref!);
    if(userMap != null){
      modelUser = ModelUser.fromJson(userMap);
    }
  }

  Future<void> submitQuiz(num score, int correctAnswer, int wrongAnswer, int notAnswer) async{
    var data = {
      "quizId": quizId,
      "userId": modelUser?.users_id,
      "score": score.toString(),
      "correctAnswer": correctAnswer.toString(),
      "wrongAnswer": wrongAnswer.toString(),
      "notAnswer": notAnswer.toString()
    };

    widgetAlert.showLoaderDialog(context);
    var responses = await ServiceQuiz().submitQuiz(data);
    var resultBody = json.decode(responses.body);

    Future.delayed(const Duration(milliseconds: 1000), () async {
      Navigator.of(context, rootNavigator: true).pop();
      if(resultBody['success']){
        Navigator.pushReplacementNamed(
          context,
          "/quizResult",
          arguments: {
            ...data,
            "quizName": quizName
          }
        );
      } else {
        widgetAlert.showErrorSnackbar(resultBody['message'], context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    settingArgument(context);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('Quiz'),
            backgroundColor: styleColor.colorPurple,
          ),
          body: quizList.isEmpty
              ? const Center(
            child: CircularProgressIndicator(),
          )
              : ListView(
            physics: const ScrollPhysics(),
            children: <Widget>[
              Row(
                children: [],
              ),
              Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   '${currentIndex + 1}. ${quizList[currentIndex]['questionName']}',
                    //   style: styleText.openSansBold(
                    //       color: Colors.black87,
                    //       size: 18.0,
                    //       weightfont: false
                    //   ),
                    // ),
                    TeXView(
                      child: TeXViewDocument(
                        '${currentIndex + 1}. ${quizList[currentIndex]['questionName']}',
                      ),
                      style: TeXViewStyle(
                        backgroundColor: Colors.transparent,
                        contentColor: Colors.black
                      ),
                    ),
                    Center(
                        child: Container(
                          width: 150,
                          child: widgetShared.base64ToImage(
                              base64: quizList[currentIndex]['questionImage'].toString()
                          ),
                        )),
                    Column(
                      children: [
                        QuizOptions(
                          onPressed: () {
                            setState(() {
                              selectedOptions =
                              quizList[currentIndex]['answer1'];
                              answerList[currentIndex] = selectedOptions;
                              correctList[currentIndex] = selectedOptions ==
                                  quizList[currentIndex]['correctAnswer'];
                            });
                          },
                          option: "A",
                          answer: '${quizList[currentIndex]['answer1']}',
                          colorRound: selectedOptions ==
                              quizList[currentIndex]['answer1'] ?
                              styleColor.colorPurple : styleColor.colorRed,
                          colorOption: Colors.white,
                        ),
                        QuizOptions(
                          onPressed: () {
                            setState(() {
                              selectedOptions =
                              quizList[currentIndex]['answer2'];
                              answerList[currentIndex] = selectedOptions;
                              correctList[currentIndex] = selectedOptions ==
                                  quizList[currentIndex]['correctAnswer'];
                              correctList[currentIndex] = selectedOptions ==
                                  quizList[currentIndex]['correctAnswer'];
                            });
                          },
                          option: "B",
                          answer: '${quizList[currentIndex]['answer2']}',
                          colorRound: selectedOptions ==
                              quizList[currentIndex]['answer2'] ?
                              styleColor.colorPurple : styleColor.colorRed,
                          colorOption: Colors.white,
                        ),
                        QuizOptions(
                          onPressed: () {
                            setState(() {
                              selectedOptions =
                              quizList[currentIndex]['answer3'];
                              answerList[currentIndex] = selectedOptions;
                              correctList[currentIndex] = selectedOptions ==
                                  quizList[currentIndex]['correctAnswer'];
                            });
                          },
                          option: "C",
                          answer: '${quizList[currentIndex]['answer3']}',
                          colorRound: selectedOptions ==
                              quizList[currentIndex]['answer3'] ?
                          styleColor.colorPurple : styleColor.colorRed,
                          colorOption: Colors.white,
                        ),
                        QuizOptions(
                          onPressed: () {
                            setState(() {
                              selectedOptions =
                              quizList[currentIndex]['answer4'];
                              answerList[currentIndex] = selectedOptions;
                              correctList[currentIndex] = selectedOptions ==
                                  quizList[currentIndex]['correctAnswer'];
                            });
                          },
                          option: "D",
                          answer: '${quizList[currentIndex]['answer4']}',
                          colorRound: selectedOptions ==
                              quizList[currentIndex]['answer4'] ?
                          styleColor.colorPurple : styleColor.colorRed,
                          colorOption: Colors.white,
                        ),
                       ],
                    )
                  ],
                ),
              ),
            ],
          ),
          bottomSheet: Container(
            padding: const EdgeInsets.all(20),
            color: Colors.white,
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                    width: size.width * 0.4,
                    child: currentIndex != 0 ?
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        side: const BorderSide(
                          color: Colors.black12,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          if (currentIndex != 0) {
                            currentIndex--;
                            selectedOptions = answerList[currentIndex];
                          }
                        });
                      },
                      child: Text(
                        'Sebelumnya',
                        style: styleText.openSansBold(
                            color: styleColor.colorRed,
                            size: 15.0,
                            weightfont: false
                        ),
                      ),
                    ) :
                    const Divider(color: Colors.transparent)
                ),
                Container(
                  width: size.width * 0.4,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: styleColor.colorRed,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.all(15),
                    ),
                    onPressed: () {
                      setState(() {
                        if (currentIndex == quizList.length - 1) {
                          var correctAnswer = 0;
                          var wrongAnswer = 0;
                          var notAnswer = 0;
                          num score = 0;

                          for(var i = 0; i < quizList.length; i++){
                            notAnswer = answerList[i] == "" ? notAnswer+1 : notAnswer;
                            if(answerList[i] != ""){
                              score = correctList[i] ? score+quizList[i]['questionScore'] : score;
                              correctAnswer = correctList[i] ? correctAnswer+1 : correctAnswer;
                              wrongAnswer = !correctList[i] ? wrongAnswer+1 : wrongAnswer;
                            }
                          }

                          submitQuiz(score, correctAnswer, wrongAnswer, notAnswer);
                        } else {
                          answerList[currentIndex] = selectedOptions;
                          currentIndex++;
                          selectedOptions = answerList[currentIndex].toString();
                        }
                      });
                    },
                    child: Text(
                      currentIndex == quizList.length - 1
                          ? 'Selesai'
                          : 'Selanjutnya',
                      style: styleText.openSansBold(
                          color: Colors.white,
                          size: 15.0,
                          weightfont: false
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
      )
    );
  }
}

class QuizOptions extends StatelessWidget {

  final String? option;
  final String? answer;
  final Color? colorOption;
  final Color? colorRound;
  final Color? backgroundOption;
  final void Function()? onPressed;

   QuizOptions({
     Key? key,
     this.option,
     this.answer,
     this.colorOption,
     this.colorRound,
     this.backgroundOption,
     this.onPressed
  }) : super(key: key);

  StyleText styleText = new StyleText();

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10
        ),
        decoration: BoxDecoration(
            color: backgroundOption,
            border: Border.all(
              color: Colors.black26,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: colorRound,
                  borderRadius: const BorderRadius.all(Radius.circular(20))
              ),
              child: Center(
                child: Text(
                  option.toString(),
                  style: TextStyle(
                    color: colorOption,
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                  ),
                ),
              ),
            ),
            const SizedBox(width: 15),
            Flexible(
             child: Text(
               answer.toString(),
               style: styleText.openSansBold(
                   color: Colors.black87,
                   size: 17.0,
                   weightfont: false
               ),
             ),
            )
          ],
        ),
      ),
    );
  }
}
