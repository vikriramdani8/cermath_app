import 'dart:async';
import 'dart:convert';
import 'package:cermath_app/features/homepage/dashboard/homepage_dashboard_widget.dart';
import 'package:cermath_app/models/model_information.dart';
import 'package:cermath_app/models/model_materi.dart';
import 'package:cermath_app/models/model_user.dart';
import 'package:cermath_app/services/service_common.dart';
import 'package:cermath_app/services/service_materi.dart';
import 'package:flutter/material.dart';

import 'package:cermath_app/common/style/style_color.dart';
import 'package:cermath_app/common/widget/widget_shared.dart';
import 'package:cermath_app/common/style/style_common.dart';
import 'package:cermath_app/common/style/style_text.dart';
import 'package:cermath_app/common/widget/widget_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:shimmer/shimmer.dart';

class HomepageDashboard extends StatefulWidget {
  const HomepageDashboard({Key? key}) : super(key: key);

  @override
  State<HomepageDashboard> createState() => _HomepageDashboardState();
}

class _HomepageDashboardState extends State<HomepageDashboard> {

  @override
  void initState() {
    super.initState();
    checkAuth();
  }

  StyleText styleText = new StyleText();
  StyleColor styleColor = new StyleColor();
  StyleCommon styleCommon = new StyleCommon();
  WidgetShared widgetShared = new WidgetShared();
  WidgetAlert widgetAlert = new WidgetAlert();
  HomepageDashboardWidget widgetDashboard = new HomepageDashboardWidget();

  ModelUser? modelUser;

  List<Classes> classList = [];
  List<ModelMateri> listMateri = [];

  var _classValue = "";
  var _loading = true;

  Future<void> checkAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userPref = prefs.getString('user');
    bool? login = prefs.getBool('login');

    if (login == true && userPref != null) {
      var userMap = jsonDecode(userPref);
      modelUser = ModelUser.fromJson(userMap);
      _classValue = userMap['class_id'].toString();

      getClass();
      getMateri(userMap['class_id']);
    }
  }

  Future<void> getClass() async {
    var responses = await ServiceCommon().getClass();
    Map<String, dynamic> resultBody = json.decode(responses.body);
    if (resultBody['success']) {
      Iterable data = resultBody['data'];
      classList = List<Classes>.from(data.map((model) => Classes.fromJson(model)));
      setState(() {});
    }
  }
  Future<void> getMateri(classes) async {
    var responses = await ServiceMateri().getMateriByClass(classes);
    var resultBody = json.decode(responses.body);
    List<dynamic> rawMateri = resultBody['data'];
    listMateri = [];

    rawMateri.forEach((element) {
      listMateri.add(ModelMateri(
          idMateri: element['lessonId'],
          namaMateri: element['lessonName'],
          imageMateri: element['lessonImage'],
          kelas: element['classId']));
    });

    if (rawMateri.length % 3 == 2) {
      listMateri
          .add(ModelMateri(idMateri: "", namaMateri: "", imageMateri: "", kelas: 0));
    }

    _loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      width: width,
      height: height - 100,
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 100,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Text(
                        'Hi, ${modelUser?.fullname}',
                        style: styleText.openSansBold(color: styleColor.colorRed, size: 20.0, weightfont: true)
                      ),
                    ),
                    Container(
                      width: 130,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          isExpanded: true,
                          hint: Row(
                            children: const [
                              Expanded(
                                child: Text(
                                  'Select Item',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          items: classList.map((data) => DropdownMenuItem<String>(
                            value: data.id.toString(),
                            child: Text(
                              "Kelas " + data.value,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          )).toList(),
                          value: _classValue != "" ? _classValue :  "1",
                          onChanged: (value) {
                            setState(() {
                              _classValue = value as String;
                              getMateri(_classValue);
                            });
                          },
                          icon: const Icon(
                            Icons.arrow_forward_ios_outlined,
                          ),
                          iconSize: 14,
                          iconEnabledColor: Colors.white,
                          iconDisabledColor: Colors.grey,
                          buttonHeight: 50,
                          buttonWidth: 130,
                          buttonPadding:
                          const EdgeInsets.only(left: 14, right: 14),
                          buttonDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: styleColor.colorRed,
                          ),
                          buttonElevation: 2,
                          itemHeight: 40,
                          itemPadding:
                          const EdgeInsets.only(left: 14, right: 14),
                          dropdownMaxHeight: 200,
                          dropdownWidth: 130,
                          dropdownDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: styleColor.colorRed,
                          ),
                          dropdownElevation: 2,
                          scrollbarRadius: const Radius.circular(40),
                          scrollbarThickness: 6,
                          scrollbarAlwaysShow: true,
                        ),
                      )
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                decoration: BoxDecoration(
                    color: styleColor.colorPurple,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      child: Text(
                        "Let's learn together",
                        style: styleText.openSansBold(
                            color: Colors.white, size: 18.0, weightfont: true),
                      ),
                    ),
                    widgetShared.divider(20.00, Colors.transparent),
                    InkWell(
                      onTap: () async {
                        Navigator.pushNamed(context, "/materiSearchAll");
                      },
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          'Cari topik materi',
                          style: styleText.openSansBold(
                              color: Colors.grey,
                              size: 15.0,
                              weightfont: false),
                        ),
                      ),
                    ),
                    widgetShared.divider(20.00, Colors.transparent),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Text(
                        'Kategori Materi',
                        style: styleText.openSansBold(
                          color: Colors.black87,
                          size: 19.0,
                          weightfont: true
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/materiSearch',
                          arguments: {
                            'classId': _classValue,
                            'className': classList[int.parse(_classValue)-1].value
                          },
                        );
                      },
                      child: Text(
                        'Lihat Semua',
                        style: styleText.openSansBold(
                            color: Colors.blueGrey,
                            size: 17.0,
                            weightfont: false
                        ),
                      ),
                    )
                  ],
                ),
              ),
              widgetShared.divider(20.0, Colors.transparent),
              _loading ?
              widgetDashboard.shimmerMateri(width)
              : widgetDashboard.kategoriMateri(listMateri: listMateri, context: context)
            ],
          ),
        )
      ),
    );
  }
}
