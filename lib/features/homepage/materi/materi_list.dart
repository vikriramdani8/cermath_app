import 'dart:async';
import 'dart:convert';
import 'package:cermath_app/common/style/style_color.dart';
import 'package:cermath_app/common/style/style_common.dart';
import 'package:cermath_app/common/style/style_text.dart';
import 'package:cermath_app/common/widget/widget_alert.dart';
import 'package:cermath_app/common/widget/widget_shared.dart';
import 'package:cermath_app/services/service_materi.dart';
import 'package:flutter/material.dart';

class ListMateri extends StatefulWidget {
  const ListMateri({Key? key}) : super(key: key);

  @override
  State<ListMateri> createState() => _ListMateriState();
}

class _ListMateriState extends State<ListMateri> {

  StyleText styleText = new StyleText();
  StyleColor styleColor = new StyleColor();
  StyleCommon styleCommon = new StyleCommon();
  WidgetShared widgetShared = new WidgetShared();
  WidgetAlert widgetAlert = new WidgetAlert();

  var lessonId = "";
  var lessonName = "";
  var jumlahSubMateri = 0;

  settingArgument(BuildContext ctx) {
    final arguments =
    (ModalRoute.of(ctx)?.settings.arguments ?? <String, dynamic>{}) as Map;

    if (lessonId != arguments['lessonId']) {
      lessonId = arguments['lessonId'];
      lessonName = arguments['lessonName'];
      getLengthMateri(lessonId);
    }
  }

  Future<void> getLengthMateri(lessonId) async {
    var responses = await ServiceMateri().getSubMateriByLessonId(lessonId);
    var resultBody = json.decode(responses.body);
    List data = resultBody['data'] as List;
    jumlahSubMateri = data.length;

    setState(() {});
  }

  Future<void> getSubMateri(lessonId) async {
    var responses = await ServiceMateri().getSubMateriByLessonId(lessonId);
    var resultBody = json.decode(responses.body);

    return resultBody['data'];
  }

  @override
  Widget build(BuildContext context) {
    settingArgument(context);

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: styleColor.colorPurple,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 100,
                width: width,
                decoration: BoxDecoration(color: styleColor.colorPurple, boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ]),
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
                              lessonName,
                              style: styleText.openSansBold(
                                  color: Colors.white,
                                  size: 20.0,
                                  weightfont: true),
                            ),
                            Text(
                              jumlahSubMateri.toString() + ' Modul',
                              style: styleText.openSansBold(
                                  color: Colors.white,
                                  size: 18.0,
                                  weightfont: false),
                            )
                          ],
                        ),
                      )
                    ]),
              ),
              widgetShared.divider(15.0, Colors.transparent),
              Container(
                height: 70,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    InkWell(
                      child: Container(
                        width: 130,
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 0,
                                blurRadius: 2,
                                offset: Offset(0, 0), // changes
                              )
                            ]),
                        alignment: Alignment.center,
                        child: Text(
                          'Latihan Soal',
                          style: styleText.openSansBold(
                            color: styleColor.colorRed,
                            size: 16.0,
                            weightfont: false
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/quizList',
                          arguments: {
                            'lessonId': lessonId,
                            'lessonName': lessonName
                          },
                        );
                      },
                    ),
                  ],
                )),
              Container(
                height: 600,
                width: double.infinity,
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder(
                      future: getSubMateri(lessonId),
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

                            return Expanded(
                                child: ListView.builder(
                                    itemCount: data.length,
                                    itemBuilder: (context, i) {
                                      return Container(
                                        height: 100,
                                        width: double.infinity,
                                        margin: EdgeInsets.only(bottom: 20),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:  const BorderRadius.all(
                                              Radius.circular(20)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.5),
                                              spreadRadius: 0,
                                              blurRadius: 2,
                                              offset: Offset(0,1), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                  padding: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.circular(25),
                                                      color: Colors.transparent
                                                  ),
                                                  child: widgetShared.base64ToImage(
                                                      base64: data[i]
                                                      ['sublessonImage'])),
                                            ),
                                            Expanded(
                                                flex: 3,
                                                child: InkWell(
                                                  onTap: () {
                                                    Navigator.pushNamed(
                                                      context,
                                                      '/materiPdf',
                                                      arguments: {
                                                        'sublessonName': data[i]['sublessonName'],
                                                        'sublessonId': data[i]['sublessonId'],
                                                      },
                                                    );
                                                  },
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                    mainAxisSize:
                                                    MainAxisSize.max,
                                                    children: [
                                                      Text(
                                                        data[i]['sublessonName'],
                                                        textAlign: TextAlign.left,
                                                        style: styleText.openSansBold(
                                                            color: Colors.black87,
                                                            size: 16.0,
                                                            weightfont: true),
                                                      ),
                                                      Text(
                                                        data[i][
                                                        'sublessonDescription'],
                                                        textAlign: TextAlign.left,
                                                        overflow:
                                                        TextOverflow.ellipsis,
                                                        style: styleText.openSansBold(
                                                            color: Colors.black87,
                                                            size: 13.0,
                                                            weightfont: false),
                                                      ),
                                                    ],
                                                  ),
                                                ))
                                          ],
                                        ),
                                      );
                                    }
                                )
                            );
                          }
                        }
                        return const Center(child: CircularProgressIndicator());
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
