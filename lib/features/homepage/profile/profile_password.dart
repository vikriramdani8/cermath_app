import 'dart:async';
import 'dart:convert';
import 'package:cermath_app/models/model_user.dart';
import 'package:cermath_app/services/service_common.dart';
import 'package:flutter/material.dart';

import 'package:cermath_app/common/style/style_color.dart';
import 'package:cermath_app/common/widget/widget_shared.dart';
import 'package:cermath_app/common/style/style_common.dart';
import 'package:cermath_app/common/style/style_text.dart';
import 'package:cermath_app/common/widget/widget_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePassword extends StatefulWidget {
  const ProfilePassword({Key? key}) : super(key: key);

  @override
  State<ProfilePassword> createState() => _ProfilePasswordState();
}

class _ProfilePasswordState extends State<ProfilePassword> {

  StyleText styleText = new StyleText();
  StyleColor styleColor = new StyleColor();
  StyleCommon styleCommon = new StyleCommon();
  WidgetShared widgetShared = new WidgetShared();
  WidgetAlert widgetAlert = new WidgetAlert();

  TextEditingController passwordLama = TextEditingController();
  TextEditingController passwordBaru = TextEditingController();
  TextEditingController passwordBaruConfirm = TextEditingController();

  ModelUser? modelUser;

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
    }
  }

  void validasiEditPassword() async {
    var checkValidation = true;
    checkValidation = passwordLama.text != "" && passwordBaru.text != "" && passwordBaruConfirm.text != "";

    if(checkValidation){
      if(passwordBaru.text == passwordBaruConfirm.text){
       editPassword();
      } else {
        widgetAlert.showErrorSnackbar("Konfirmasi password tidak sesuai", context);
      }
    } else {
      widgetAlert.showErrorSnackbar("Field tidak boleh kosong", context);
    }
  }

  Future<void> editPassword() async{
    var body = {
      "passwordLama" : passwordLama.text,
      "passwordBaru" : passwordBaru.text,
    };

    widgetAlert.showLoaderDialog(context);
    var responses = await ServiceCommon().updatePassword(body, modelUser!.users_id);
    var resultBody = json.decode(responses.body);

    Future.delayed(const Duration(milliseconds: 1000), () async {
      Navigator.of(context, rootNavigator: true).pop();
      if(resultBody['success']){
        widgetAlert.showSuccesSnackbar(resultBody['message'], context);
        Future.delayed(const Duration(milliseconds: 3000), () {
          Navigator.of(context, rootNavigator: true).pop();
        });
      } else {
        widgetAlert.showErrorSnackbar(resultBody['message'], context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: styleColor.colorPurple,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 24,
            )),
        title: Text('Edit Password',
            style: styleText.openSansBold(
                color: Colors.white, size: 20.0, weightfont: true)),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: width,
          height: height-AppBar().preferredSize.height-40,
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              widgetShared.label('Password Lama'),
              TextField(
                controller: passwordLama,
                obscureText: true,
                obscuringCharacter: "*",
                readOnly: false,
                decoration: styleCommon.fieldDecorationPassword('Password Lama')
              ),
              widgetShared.label('Password Baru'),
              TextField(
                  controller: passwordBaru,
                  obscureText: true,
                  obscuringCharacter: "*",
                  readOnly: false,
                  decoration: styleCommon.fieldDecorationPassword('Password Baru')
              ),
              widgetShared.label('Konfirmasi Password Baru'),
              TextField(
                  controller: passwordBaruConfirm,
                  obscureText: true,
                  obscuringCharacter: "*",
                  readOnly: false,
                  decoration: styleCommon.fieldDecorationPassword('Konfirmasi Password Baru')
              ),
              widgetShared.divider(30.0, Colors.transparent),
              Center(
                  child: InkWell(
                    child: Container(
                      width: 140,
                      height: 50,
                      decoration: styleCommon.buttonLogin(),
                      child: Center(
                        child: Text(
                            'Simpan',
                            style: styleText.openSansBold(color: Colors.black54, size: 18.00, weightfont: true)
                        ),
                      ),
                    ),
                    onTap: () async {
                      validasiEditPassword();
                    },
                  )
              ),
            ],
          ),
        )
      ),
    );
  }
}

