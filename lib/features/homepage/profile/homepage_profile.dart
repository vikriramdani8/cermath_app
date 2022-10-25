import 'dart:async';
import 'dart:convert';
import 'package:cermath_app/models/model_profile.dart';
import 'package:cermath_app/models/model_user.dart';
import 'package:cermath_app/services/service_common.dart';
import 'package:cermath_app/services/service_login.dart';
import 'package:flutter/material.dart';

import 'package:cermath_app/common/style/style_color.dart';
import 'package:cermath_app/common/widget/widget_shared.dart';
import 'package:cermath_app/common/style/style_common.dart';
import 'package:cermath_app/common/style/style_text.dart';
import 'package:cermath_app/common/widget/widget_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomepageProfile extends StatefulWidget {
  const HomepageProfile({Key? key}) : super(key: key);

  @override
  State<HomepageProfile> createState() => _HomepageProfileState();
}

class _HomepageProfileState extends State<HomepageProfile> {

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

  ModelUser? modelUser;
  ModelProfil? modelProfil;
  var _loading = true;

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
      print(resultBody['data']);
      modelProfil = ModelProfil.fromJson(resultBody['data']);
      _loading = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: _loading ?
      Center(
        child: widgetShared.showLoading(),
      ) :
      SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 70,
              padding: const EdgeInsets.all(10),
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
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    color: Colors.transparent,
                  ),
                  Text(
                      'Profil',
                      style: styleText.openSansBold(
                          color: Colors.white,
                          size: 23.0,
                          weightfont: true
                      )
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      width: 50,
                      height: 50,
                      color: Colors.transparent,
                      child: const Icon(
                        Icons.settings,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 130,
              padding: const EdgeInsets.symmetric(horizontal: 20),
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(45)
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        modelProfil?.fullname == null ?
                        Text("-") :
                        Text(
                          modelProfil!.fullname,
                          style: styleText.openSansBold(
                              color: Colors.black87,
                              size: 18.0,
                              weightfont: true
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          height: 30,
                          decoration: BoxDecoration(
                            color: styleColor.colorRed,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Kelas ${modelProfil?.class_name == null? '-' : modelProfil!.class_name}",
                            style: styleText.openSansBold(
                                color: Colors.white,
                                size: 16.0,
                                weightfont: false
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Text(
                'Informasi',
                style: styleText.openSansBold(
                    color: Colors.black87,
                    size: 19.0,
                    weightfont: true
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: 20
              ),
              child: Container(
                width: (width*0.5)-30,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.grey.shade500,
                        width: 1
                    ),
                    borderRadius: BorderRadius.circular(20)
                ),
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Email',
                      style: styleText.openSansBold(
                          color: Colors.black87,
                          size: 15.0,
                          weightfont:false
                      ),
                    ),
                    Text(
                      modelProfil?.email == null ? '' : modelProfil!.email,
                      style: styleText.openSansBold(
                          color: Colors.black87,
                          size: 15.0,
                          weightfont:true
                      ),
                    ),
                    widgetShared.divider(15.0, Colors.transparent),
                    Text(
                      'Telepon',
                      style: styleText.openSansBold(
                          color: Colors.black87,
                          size: 15.0,
                          weightfont:false
                      ),
                    ),
                    Text(
                      modelProfil?.telepon == null ||
                      modelProfil?.telepon == '' ? '-' :
                      modelProfil!.telepon,
                      style: styleText.openSansBold(
                          color: Colors.black87,
                          size: 15.0,
                          weightfont:true
                      ),
                    ),
                    widgetShared.divider(15.0, Colors.transparent),
                    Text(
                      'Tipe User',
                      style: styleText.openSansBold(
                          color: Colors.black87,
                          size: 15.0,
                          weightfont:false
                      ),
                    ),
                    Text(
                      modelProfil?.usertype_name == null ? '' : modelProfil!.usertype_name,
                      style: styleText.openSansBold(
                          color: Colors.black87,
                          size: 15.0,
                          weightfont:true
                      ),
                    )
                  ],
                ),
              ),
            ),
            widgetShared.divider(1.0, Colors.grey),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Text(
                'Statistik',
                style: styleText.openSansBold(
                    color: Colors.black87,
                    size: 19.0,
                    weightfont: true
                ),
              ),
            ),
            Padding(
            padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 20
            ),
            child: Container(
              width: (width*0.5)-30,
              height: 80,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.grey.shade500,
                      width: 1
                  ),
                  borderRadius: BorderRadius.circular(20)
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Total Exp',
                    style: styleText.openSansBold(
                        color: Colors.black87,
                        size: 15.0,
                        weightfont:false
                    ),
                  ),
                  Text(
                    modelProfil?.score == null ||
                    modelProfil?.score == '' ? '0' :
                    modelProfil!.score,
                    style: styleText.openSansBold(
                        color: Colors.black87,
                        size: 18.0,
                        weightfont:true
                    ),
                  )
                ],
              ),
            ),
          ),
            widgetShared.divider(1.0, Colors.grey),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Text(
                'Pengaturan Akun',
                style: styleText.openSansBold(
                    color: Colors.black87,
                    size: 19.0,
                    weightfont: true
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  InkWell(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Edit Profil',
                          style: styleText.openSansBold(
                              color: Colors.black87,
                              size: 17.0,
                              weightfont: false
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.black87,
                          size: 16,
                        )
                      ],
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/editProfile',
                      );
                    },
                  ),
                  widgetShared.divider(15.0, Colors.transparent),
                  InkWell(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Ubah Kata Sandi',
                          style: styleText.openSansBold(
                              color: Colors.black87,
                              size: 17.0,
                              weightfont: false
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.black87,
                          size: 16,
                        )
                      ],
                    ),
                    onTap: () {
                      // Navigator.push(context, MaterialPageRoute(builder: (context) {
                      //   return EditPassword();
                      // }));
                    },
                  ),
                  widgetShared.divider(15.0, Colors.transparent),
                  InkWell(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Keluar',
                          style: styleText.openSansBold(
                              color: Colors.black87,
                              size: 17.0,
                              weightfont: false
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.black87,
                          size: 16,
                        )
                      ],
                    ),
                    onTap: () async {
                      SharedPreferences preferences = await SharedPreferences.getInstance();
                      await preferences.clear();
                      Navigator.pushNamedAndRemoveUntil(
                          context, "/login", (r) => false
                      );
                    },
                  )
                ],
              ),
            ),
            widgetShared.divider(20.0, Colors.transparent)
          ],
        ),
      )
    );
  }
}
