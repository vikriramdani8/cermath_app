import 'dart:convert';

import 'package:cermath_app/models/model_user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import 'package:cermath_app/common/style/style_text.dart';
import 'package:cermath_app/common/style/style_color.dart';
import 'package:cermath_app/common/widget/widget_shared.dart';

class LoginFirstLaunch extends StatelessWidget {
  LoginFirstLaunch({super.key});

  StyleText styleText = new StyleText();
  StyleColor styleColor = new StyleColor();
  WidgetShared widgetShared = new WidgetShared();

  ModelUser? modelUser;

  Future<void> checkAuth(context) async {
    final prefs = await SharedPreferences.getInstance();
    bool? userlogin = prefs.getBool('login');

    if(userlogin == true){
      String? userPref = prefs.getString('user');
      var userMap = jsonDecode(userPref!);
      modelUser = ModelUser.fromJson(userMap);

      if(userMap['usertype_id'] == null ||
        userMap['class_id'] == null ||
        userMap['gender_id'] == null){
        Navigator.pushNamedAndRemoveUntil(context, "/loginInformation", (r) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(context, "/homePage", (r) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    checkAuth(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                height: 300,
                child: Image.asset('assets/images/math.png')
            ),
            Container(
              child: Text(
                'Selamat datang di cerMath',
                style: styleText.openSansBold(color: styleColor.colorGrey, size: 31.00, weightfont: false)
              ),
            ),
            widgetShared.divider(30.00, styleColor.colorGrey),
            Container(
              child: Text(
                'Aplikasi ini membantu siswa SMP belajar tentang basic materi dan mengasah skil Matematika',
                style: styleText.openSansBold(color: styleColor.colorGrey, size: 14.00, weightfont: false)
              ),
            ),
            widgetShared.divider(40.00, Colors.transparent),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/login', arguments: 'hello i am from first page!');
              },
              child: Container(
                width: 200,
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(40))
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 110,
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Mulai',
                        style: styleText.openSansBold(color: styleColor.colorGrey, size: 20.00, weightfont: false)
                      )
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black87,
                          ),
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.black87
                      ),
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 25,
                      ),
                    )
                  ]
                )
              ),
            )
          ],
        )
      ),
    );
  }
}

