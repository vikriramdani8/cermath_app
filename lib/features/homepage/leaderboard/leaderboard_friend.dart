import 'dart:convert';

import 'package:cermath_app/features/homepage/leaderboard/leaderboard_widget.dart';
import 'package:cermath_app/models/model_user.dart';
import 'package:cermath_app/services/service_leaderboard.dart';
import 'package:flutter/material.dart';
import 'package:cermath_app/common/style/style_color.dart';
import 'package:cermath_app/common/widget/widget_shared.dart';
import 'package:cermath_app/common/style/style_common.dart';
import 'package:cermath_app/common/style/style_text.dart';
import 'package:cermath_app/common/widget/widget_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeaderboardFriend extends StatefulWidget {
  const LeaderboardFriend({Key? key}) : super(key: key);

  @override
  State<LeaderboardFriend> createState() => _LeaderboardFriendState();
}

class _LeaderboardFriendState extends State<LeaderboardFriend> {

  StyleText styleText = new StyleText();
  StyleColor styleColor = new StyleColor();
  StyleCommon styleCommon = new StyleCommon();
  WidgetShared widgetShared = new WidgetShared();
  WidgetAlert widgetAlert = new WidgetAlert();

  TextEditingController searchUser = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkAuth();
  }

  ModelUser? modelUser;
  var _loading = true;
  LeaderboardWidget leaderboardWidget = new LeaderboardWidget();

  Future<void> checkAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userPref = prefs.getString('user');
    bool? login = prefs.getBool('login');

    if (login == true && userPref != null) {
      var userMap = jsonDecode(userPref);
      modelUser = ModelUser.fromJson(userMap);
      _loading = false;
    }
  }

  Future<void> getFriend(search) async {
    var bodySearch = {
      "search": search,
      "userId": modelUser?.users_id
    };

    var responses = await ServiceLeaderboard().getFriend(modelUser?.users_id, bodySearch);
    var resultBody = json.decode(responses.body);

    return resultBody['data'];
  }

  Future<void> followUser(data) async {
    var body = {
      "userId": modelUser!.users_id,
      "followingId": data['usersId']
    };

    var responses = await ServiceLeaderboard().followUser(body);
    var resultBody = json.decode(responses.body);

    if(resultBody['success']){
      widgetAlert.showSuccesSnackbar("Berhasil mengikuti ${data['username']}", context);
      Future.delayed(const Duration(milliseconds: 1000), () async {
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var limitHeight = (170/height)*100;
    var scrollHeight = ((100-limitHeight-5)/100)*height;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 170,
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
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: 24,
                              )
                          ),
                        ),
                        Text(
                          'Temukan Teman',
                          style: styleText.openSansBold(
                            color: Colors.white,
                            weightfont: true,
                            size: 20.0
                          )
                        ),
                        Container(
                          width: 50,
                          height: 50,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 30,
                        horizontal: 40
                      ),
                      child: TextField(
                        controller: searchUser,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 10
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          hintText: "Cari berdasarkan username/email",
                          border: styleCommon.myinputborder(true),
                          enabledBorder: styleCommon.myinputborder(true),
                          focusedBorder: styleCommon.myfocusborder(true),
                          focusColor: Colors.white,
                          fillColor: Colors.white,
                          filled: true
                        ),
                      ),
                    )
                  ],
                ),
              ),
              _loading ?
              SizedBox() :
              Container(
                width: width,
                height: scrollHeight,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FutureBuilder(
                        future: getFriend(searchUser.text),
                        builder: (Context, snapshot) {
                          if(snapshot.connectionState == ConnectionState.done) {
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
                              return data.length == 0 ?
                              leaderboardWidget.listNotFound() :
                              // leaderboardWidget.listFriend(data, scrollHeight);
                              Container(
                                height: scrollHeight,
                                padding: EdgeInsets.all(20),
                                child: ListView.builder(
                                    physics: BouncingScrollPhysics(),
                                    itemCount: data.length,
                                    itemBuilder: (context, i) {
                                      return FriendList(
                                        index: i,
                                        fullname: data[i]['fullname'],
                                        userId: data[i]['usersId'],
                                        username: data[i]['username'],
                                        onPressed: () => {
                                          followUser(data[i])
                                        },
                                      );
                                    }
                                ),
                              );
                            }
                          }
                          return Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: leaderboardWidget.shimmerLeaderboard(width),
                          );
                        },
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class FriendList extends StatelessWidget {
  final void Function()? onPressed;
  final int index;
  final String username;
  final String fullname;
  final String userId;

  FriendList({
    Key? key,
    required this.index,
    required this.onPressed,
    required this.username,
    required this.fullname,
    required this.userId
  }) : super(key: key);

  StyleColor styleColor = new StyleColor();
  StyleText styleText = new StyleText();

  @override
  Widget build(BuildContext context) {
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
                          username,
                          style: styleText.openSansBold(color: Colors.black, size: 17.0, weightfont: true),
                        ),
                        Text(
                          fullname,
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
                onTap: onPressed,
                child: Container(
                    margin: EdgeInsets.all(10),
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            width: 1,
                            color: Colors.white60
                        ),
                        borderRadius: const BorderRadius.all(
                            Radius.circular(5)
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: Offset(0, 1), // changes position of shadow
                          ),
                        ]
                    ),
                    child: Container(
                      child: Icon(
                        Icons.person_add,
                        color: styleColor.colorRed,
                        size: 20,
                      ),
                    )
                ),
              )
          )
        ],
      ),
    );
  }
}
