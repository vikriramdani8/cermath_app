import 'dart:async';
import 'dart:convert';
import 'package:cermath_app/features/homepage/leaderboard/leaderboard_widget.dart';
import 'package:cermath_app/models/model_profile.dart';
import 'package:cermath_app/models/model_user.dart';
import 'package:cermath_app/services/service_common.dart';
import 'package:cermath_app/services/service_leaderboard.dart';
import 'package:flutter/material.dart';

import 'package:cermath_app/common/style/style_color.dart';
import 'package:cermath_app/common/widget/widget_shared.dart';
import 'package:cermath_app/common/style/style_common.dart';
import 'package:cermath_app/common/style/style_text.dart';
import 'package:cermath_app/common/widget/widget_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomepageLeaderboard extends StatefulWidget {
  const HomepageLeaderboard({Key? key}) : super(key: key);

  @override
  State<HomepageLeaderboard> createState() => _HomepageLeaderboardState();
}

class _HomepageLeaderboardState extends State<HomepageLeaderboard> {

  StyleText styleText = new StyleText();
  StyleColor styleColor = new StyleColor();
  StyleCommon styleCommon = new StyleCommon();
  WidgetShared widgetShared = new WidgetShared();
  WidgetAlert widgetAlert = new WidgetAlert();
  ModelUser? modelUser;
  ModelProfil? modelProfil;

  var _loading = true;
  LeaderboardWidget leaderboardWidget = new LeaderboardWidget();

  @override
  void initState() {
    super.initState();
    checkAuth();
  }

  Future<void> checkAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userPref = prefs.getString('user');
    bool? login = prefs.getBool('login');

    if (login == true && userPref != null) {
      var userMap = jsonDecode(userPref);
      modelUser = ModelUser.fromJson(userMap);
      getProfilData();
    }
  }

  Future<void> getProfilData() async {
    var responses = await ServiceCommon().getProfil(modelUser?.users_id);
    var resultBody = json.decode(responses.body);

    if(resultBody['success']){
      modelProfil = ModelProfil.fromJson(resultBody['data']);
      _loading = false;
      setState(() {});
    }
  }

  Future<void> getLeaderboard(lessonId) async {
    var responses = await ServiceLeaderboard().getLeaderboard(lessonId);
    var resultBody = json.decode(responses.body);
    return resultBody['data'];
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var heightList = height-90-200-kBottomNavigationBarHeight-50;

    return SafeArea(
        child: _loading ?
        widgetShared.showLoading() :
        Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 200,
              width: width,
              decoration: BoxDecoration(
                  color: styleColor.colorPurple,
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          color: Colors.transparent,
                        ),
                        Text(
                            'Leaderboard',
                            style: styleText.openSansBold(color: Colors.white, size: 21.0, weightfont: true)
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/leaderboardFriend',
                            );
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30)
                            ),
                            child: Icon(
                              Icons.person_add,
                              color: styleColor.colorRed,
                              size: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Profile
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(45)
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                modelUser!.fullname,
                                style: styleText.openSansBold(color: Colors.white, size: 18.0, weightfont: true),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                height: 30,
                                decoration: BoxDecoration(
                                  color: styleColor.colorRed,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '${modelProfil!.score} XP',
                                  style: styleText.openSansBold(color: Colors.white, size: 17.0, weightfont: false),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              height: 90,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 130,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      border: Border.all(
                          color: Colors.grey,
                          width: 1
                      ),
                    ),
                    child: Text(
                      'Rank Score',
                      style: styleText.openSansBold(
                          color: Colors.black87,
                          size: 17.0,
                          weightfont: false
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: heightList,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FutureBuilder(
                      future: getLeaderboard('278617e6-db41-4cb6-858a-e117bc415a7b'),
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
                            return leaderboardWidget.listleaderBoard(data, heightList);
                          }
                        }
                        return Center(child: CircularProgressIndicator());
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        )
    );
  }
}

