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
  LeaderboardWidget leaderboardWidget = new LeaderboardWidget();

  Future<void> checkAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userPref = prefs.getString('user');
    bool? login = prefs.getBool('login');

    if (login == true && userPref != null) {
      var userMap = jsonDecode(userPref);
      modelUser = ModelUser.fromJson(userMap);
    }
  }

  Future<void> getFriend(search) async {
    var bodySearch = {
      "search": search
    };

    var responses = await ServiceLeaderboard().getFriend(modelUser?.users_id, bodySearch);
    var resultBody = json.decode(responses.body);

    return resultBody['data'];
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
                              return leaderboardWidget.listFriend(data, scrollHeight);
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

// child: Column(
//   mainAxisSize: MainAxisSize.max,
//   crossAxisAlignment: CrossAxisAlignment.stretch,
//   children: [
//     Container(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 30,
//         vertical: 20
//       ),
//       child: Text(
//         '3581 Hasil',
//         style: styleText.openSansBold(
//           color: Colors.black87,
//           size: 19.0,
//           weightfont: true
//         ),
//       ),
//     ),
//     Container(
//       margin: EdgeInsets.symmetric(horizontal: 30),
//       width: double.infinity,
//       height: height-170-70-100,
//       decoration: BoxDecoration(
//           border: Border.all(
//               color: Colors.grey.shade400,
//               width: 1
//           ),
//           borderRadius: BorderRadius.circular(20)
//       ),
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
//             FutureBuilder(
//               future: getFriend(searchUser.text),
//               builder: (Context, snapshot) {
//                 if(snapshot.connectionState == ConnectionState.done) {
//                   if (snapshot.hasError) {
//                     return Center(
//                       child: InkWell(
//                         onTap: () {
//                           setState(() {});
//                         },
//                       ),
//                     );
//                   }
//                   if (snapshot.hasData) {
//                     List data = snapshot.data as List;
//                     return leaderboardWidget.listFriend(data);
//                   }
//                 }
//                 return CircularProgressIndicator();
//               },
//             )
//           ],
//         ),
//       )
//     )
//   ],
// ),
