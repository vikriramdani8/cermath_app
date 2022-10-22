import 'dart:async';
import 'dart:convert';
import 'package:cermath_app/common/style/style_color.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MateriPdf extends StatefulWidget {
  const MateriPdf({Key? key}) : super(key: key);

  @override
  State<MateriPdf> createState() => _MateriPdfState();
}

class _MateriPdfState extends State<MateriPdf> {

  var subLessonId = "";
  var subLessonName = "";
  StyleColor styleColor = new StyleColor();

  settingArgument(BuildContext ctx) {
    final arguments =
    (ModalRoute.of(ctx)?.settings.arguments ?? <String, dynamic>{}) as Map;
    if (subLessonId != arguments['sublessonId']) {
      subLessonName = arguments['sublessonName'];
      subLessonId = arguments['sublessonId'];
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    settingArgument(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(subLessonName),
        backgroundColor: styleColor.colorPurple,
      ),
      body: WebView(
        initialUrl: "https://www.cermath.tech/login/showPdf/"+subLessonId,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
