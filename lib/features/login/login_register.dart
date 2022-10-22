import 'dart:convert';

import 'package:cermath_app/common/style/style_color.dart';
import 'package:cermath_app/common/style/style_common.dart';
import 'package:cermath_app/common/style/style_text.dart';
import 'package:cermath_app/common/widget/widget_alert.dart';
import 'package:cermath_app/common/widget/widget_shared.dart';
import 'package:cermath_app/services/service_login.dart';
import 'package:flutter/material.dart';

class LoginRegister extends StatefulWidget {
  const LoginRegister({Key? key}) : super(key: key);

  @override
  State<LoginRegister> createState() => _LoginRegisterState();
}

class _LoginRegisterState extends State<LoginRegister> {

  StyleText styleText = new StyleText();
  StyleColor styleColor = new StyleColor();
  StyleCommon styleCommon = new StyleCommon();
  WidgetShared widgetShared = new WidgetShared();
  WidgetAlert widgetAlert = new WidgetAlert();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  var messageName = "";
  var messageEmail = "";
  var messagePassword = "";

  void checkValidation(){
    FocusScope.of(context).requestFocus(FocusNode());
    var checkValidation = true;

    messageName = nameController.text == "" ? "Nama tidak boleh kosong" : "";
    messageEmail = emailController.text == "" ? "Email tidak boleh kosong" : "";
    messagePassword = passwordController.text == "" ? "Password tidak boleh kosong" : "";

    checkValidation = nameController.text != "" && emailController.text != "" && passwordController.text != "";

    setState(() {});

    if(checkValidation == true) {
      registerAccount(nameController.text, emailController.text, passwordController.text);
    }
  }

  Future<void> registerAccount(String fullname, String email, String password) async {
    var body = {
      "fullname": fullname,
      "email": email,
      "password": password
    };

    widgetAlert.showLoaderDialog(context);
    var responses = await ServiceLogin().register(body);
    var resultBody = json.decode(responses.body);

    Future.delayed(const Duration(milliseconds: 1000), () async {
      Navigator.of(context, rootNavigator: true).pop();
      if(resultBody['success']){
        widgetAlert.showSuccesSnackbar(resultBody['message'], context);
        Future.delayed(const Duration(milliseconds: 2000), () {
          Navigator.of(context, rootNavigator: true).pop();
        });
      } else {
        widgetAlert.showErrorSnackbar(resultBody['message'], context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.transparent,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'cerMath',
                        style: styleText.openSansBold(color: styleColor.colorPurple, size: 35.00, weightfont: true)
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          'Buat Akun Gratis',
                          style: styleText.openSansBold(color: styleColor.colorRed, size: 20.00, weightfont: false)
                      ),
                    ),
                    widgetShared.divider(60.0, Colors.transparent),
                    // Field Nama
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(bottom: 5),
                      child: Text(
                        'Nama',
                        style: styleText.openSansBold(color: Colors.black54, size: 15.00, weightfont: false),
                      ),
                    ),
                    Container(
                      child: TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 5),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          labelText: "Nama",
                          prefixIcon: Icon(Icons.account_circle_rounded),
                          border: styleCommon.myinputborder(true),
                          enabledBorder: styleCommon.myinputborder(true),
                          focusedBorder: styleCommon.myfocusborder(true),
                          focusColor: Colors.white,
                        ),
                      ),
                    ),
                    if(messageName != "") Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        messageName,
                        style: styleText.openSansBold(color: Colors.redAccent, size: 14.0, weightfont: false),
                      ),
                    ),
                    widgetShared.divider(20.0, Colors.transparent),
                    // Field Email
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(bottom: 5),
                      child: Text(
                        'Email',
                        style: styleText.openSansBold(color: Colors.black54, size: 15.00, weightfont: false),
                      ),
                    ),
                    Container(
                      child: TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 5),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          labelText: "Email",
                          prefixIcon: Icon(Icons.email),
                          border: styleCommon.myinputborder(true),
                          enabledBorder: styleCommon.myinputborder(true),
                          focusedBorder: styleCommon.myfocusborder(true),
                          focusColor: Colors.white,
                        ),
                      ),
                    ),
                    if(messageEmail != "") Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        messageEmail,
                        style: styleText.openSansBold(color: Colors.redAccent, size: 14.0, weightfont: false),
                      ),
                    ),
                    widgetShared.divider(20.0, Colors.transparent),
                    // Field Password
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(bottom: 5),
                      child: Text(
                        'Password',
                        style: styleText.openSansBold(color: Colors.black54, size: 15.00, weightfont: false),
                      ),
                    ),
                    Container(
                      child: TextField(
                        controller: passwordController,
                        obscureText: true,
                        obscuringCharacter: "*",
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 5),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          labelText: "Password",
                          prefixIcon: Icon(Icons.lock),
                          border: styleCommon.myinputborder(true),
                          enabledBorder: styleCommon.myinputborder(true),
                          focusedBorder: styleCommon.myfocusborder(true),
                          focusColor: Colors.white,
                        ),
                      ),
                    ),
                    if(messagePassword != "") Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        messagePassword,
                        style: styleText.openSansBold(color: Colors.redAccent, size: 14.0, weightfont: false),
                      ),
                    ),
                    widgetShared.divider(20.0, Colors.transparent),
                    // Button Register
                    Container(
                      height: 70,
                      child: Center(
                          child: InkWell(
                            child: Container(
                              width: 170,
                              height: 60,
                              decoration: styleCommon.buttonLogin(),
                              child: Center(
                                child: Text(
                                  'Buat Akun',
                                  style: styleText.openSansBold(color: Colors.black54, size: 18.0, weightfont: true),
                                ),
                              ),
                            ),
                            onTap: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              checkValidation();
                            },
                          )
                      ),
                    ),

                  ],
                ),
              )
            )
          )
        )
    );
  }
}
