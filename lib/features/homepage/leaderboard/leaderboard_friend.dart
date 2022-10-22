import 'package:flutter/material.dart';
import 'package:cermath_app/common/style/style_color.dart';
import 'package:cermath_app/common/widget/widget_shared.dart';
import 'package:cermath_app/common/style/style_common.dart';
import 'package:cermath_app/common/style/style_text.dart';
import 'package:cermath_app/common/widget/widget_alert.dart';

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
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
                      padding: EdgeInsets.symmetric(
                        vertical: 30,
                        horizontal: 40
                      ),
                      child: TextField(
                        controller: searchUser,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
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
                height: height-170-70,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 20
                      ),
                      child: Text(
                        '3581 Hasil',
                        style: styleText.openSansBold(
                          color: Colors.black87,
                          size: 19.0,
                          weightfont: true
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 30),
                      width: double.infinity,
                      height: height-170-70-100,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey.shade400,
                              width: 1
                          ),
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              height: 80,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 10
                              ),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                        width: 1,
                                        color: Colors.grey.shade300,
                                      )
                                  )
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
                                                  'maman',
                                                  style: styleText.openSansBold(color: Colors.black, size: 17.0, weightfont: true),
                                                ),
                                                Text(
                                                  'maman125',
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
                                        onTap: () {},
                                        child: Container(
                                            height: 50,
                                            child: Icon(
                                              Icons.person_add,
                                              color: styleColor.colorRed,
                                              size: 30,
                                            )
                                        ),
                                      )
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
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
