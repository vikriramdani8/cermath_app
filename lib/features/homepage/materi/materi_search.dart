import 'dart:async';
import 'dart:convert';
import 'package:cermath_app/common/style/style_color.dart';
import 'package:cermath_app/common/style/style_common.dart';
import 'package:cermath_app/common/style/style_text.dart';
import 'package:cermath_app/common/widget/widget_alert.dart';
import 'package:cermath_app/common/widget/widget_shared.dart';
import 'package:cermath_app/features/homepage/materi/materi_search_widget.dart';
import 'package:cermath_app/models/model_user.dart';
import 'package:cermath_app/services/service_materi.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MateriSearch extends StatefulWidget {
  const MateriSearch({Key? key}) : super(key: key);

  @override
  State<MateriSearch> createState() => _MateriSearchState();
}

class _MateriSearchState extends State<MateriSearch> {
  TextEditingController editingController = TextEditingController();
  var classId = '';
  var className = '';

  var isLoading = true;
  var dataMateri = <dynamic>[];
  var items = <dynamic>[];

  StyleText styleText = new StyleText();
  StyleColor styleColor = new StyleColor();
  StyleCommon styleCommon = new StyleCommon();
  WidgetShared widgetShared = new WidgetShared();
  WidgetAlert widgetAlert = new WidgetAlert();
  WidgetMateri widgetMateri = new WidgetMateri();

  settingArgument(BuildContext ctx) {
    final arguments =
    (ModalRoute.of(ctx)?.settings.arguments ?? <String, dynamic>{}) as Map;

    if (classId != arguments['classId']) {
      classId = arguments['classId'] ?? '1';
      className = arguments['className'] ?? '7';

      getMateri(classId);
    }
  }

  Future<void> getMateri(classes) async {
    var responses = await ServiceMateri().getAllMateriByClass(classes);
    var resultBody = json.decode(responses.body);
    dataMateri = resultBody['data'];
    items.addAll(dataMateri);
    isLoading = false;

    setState(() {});
  }

  void filterSearchResults(String query) {
    List<dynamic> dummySearchList = <dynamic>[];
    dummySearchList.addAll(dataMateri);

    if(query.isNotEmpty) {
      List<dynamic> dummyListData = <dynamic>[];
      dummySearchList.forEach((item) {
        if(item['lessonName'].toLowerCase().contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(dataMateri);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    settingArgument(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Materi Kelas $className',
          style: styleText.openSansBold(
            color: Colors.white,
            size: 18.0,
            weightfont: true
          ),
        ),
        backgroundColor: styleColor.colorPurple ,
      ),
      body:
      isLoading ?
      widgetShared.showLoading() :
      Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  filterSearchResults(value);
                },
                controller: editingController,
                decoration: const InputDecoration(
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                padding: EdgeInsets.all(15),
                itemBuilder: (context, index) {
                  return Container(
                    height: 100,
                    margin: EdgeInsets.only(bottom: 20),
                    padding: EdgeInsets.all(15),
                    decoration: styleCommon.cardWithBoxShadow(),
                    child: widgetMateri.materiCard(
                        context,
                        items[index]['lessonId'],
                        items[index]['lessonName'],
                        items[index]['lessonImage'],
                        ''
                    )
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
