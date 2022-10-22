import 'dart:async';
import 'dart:convert';
import 'package:cermath_app/common/style/style_common.dart';
import 'package:cermath_app/common/style/style_text.dart';
import 'package:cermath_app/common/widget/widget_alert.dart';
import 'package:cermath_app/models/model_user.dart';
import 'package:cermath_app/services/service_login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cermath_app/common/style/style_color.dart';
import 'package:cermath_app/common/widget/widget_shared.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

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

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  ModelUser? modelUser;
  var messageEmail = "";
  var messagePassword = "";

  void loginValidation(){
    FocusScope.of(context).requestFocus(FocusNode());
    var checkValidation = true;

    messageEmail = emailController.text == "" ? "Email tidak boleh kosong" : "";
    messagePassword = passwordController.text == "" ? "Password tidak boleh kosong" : "";
    checkValidation = emailController.text != "" && passwordController.text != "";

    setState(() {});
    if(checkValidation){
        loginAuth(emailController.text, passwordController.text);
    }
  }

  Future<void> checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    bool? userlogin = prefs.getBool('login');

    if (userlogin == true) {
      String? userPref = prefs.getString('user');
      var userMap = jsonDecode(userPref!);
      modelUser = ModelUser.fromJson(userMap);

      if (userMap['usertype_id'] == null ||
        userMap['class_id'] == null ||
        userMap['gender_id'] == null) {
        Navigator.pushNamedAndRemoveUntil(context, "/information", (r) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(context, "/homePage", (r) => false);
      }
    }
  }

  Future<void> loginAuth(String email, String password) async {
    var body = {
      "email": email,
      "password": password
    };

    widgetAlert.showLoaderDialog(context);
    var responses = await ServiceLogin().login(body);
    var resultBody = json.decode(responses.body);

    Future.delayed(const Duration(milliseconds: 1000), () async {
      Navigator.of(context, rootNavigator: true).pop();
      if(resultBody['success']){
        
        SharedPreferences prefs = await SharedPreferences.getInstance();
        Map<String, dynamic> user = resultBody['data'];
        prefs.setString('user', jsonEncode(user));
        bool result = await prefs.setBool('login', true);

        if(result){
          if(user['usertype_id'] == null || user['class_id'] == null || user['gender_id'] == null){
            Navigator.pushNamedAndRemoveUntil(context, "/loginInformation", (r) => false);
          } else {
            Navigator.pushNamedAndRemoveUntil(context, "/homePage", (r) => false);
          }
        } else {
          widgetAlert.showErrorSnackbar("Login failed", context);
        }

      } else {
        widgetAlert.showErrorSnackbar(resultBody['message'], context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: GestureDetector(
            onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
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
                            style: styleText.poppinsBold(color: styleColor.colorPurple, size: 35.00, weightfont: true)
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Login untuk melanjutkan',
                            style: styleText.poppinsBold(color: styleColor.colorPurple, size: 20.00, weightfont: false)
                          ),
                        ),
                        widgetShared.divider(60.00, Colors.transparent),
                        // Email
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(bottom: 5),
                          child: Text(
                            'Email',
                            style: styleText.poppinsBold(color: Colors.black54, size: 15.00, weightfont: false),
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
                        widgetShared.divider(20.00, Colors.transparent),
                        // Password
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(bottom: 5),
                          child: Text(
                            'Password',
                            style: styleText.openSansBold(color: Colors.black54, size: 15.00, weightfont: false)
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
                        Container(
                            padding: const EdgeInsets.only(top: 5),
                            alignment: Alignment.centerLeft,
                            child: InkWell(
                              child: Text(
                                'Lupa Password?',
                                style: styleText.openSansBold(color: styleColor.colorPurple, size: 15.00, weightfont: false)
                              ),
                              onTap: () {
                                print("tapped on container");
                              },
                            )
                        ),
                        widgetShared.divider(50.00, Colors.transparent),
                        // Button Login
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
                                      'Login',
                                      style: styleText.openSansBold(color: Colors.black54, size: 18.00, weightfont: true)
                                    ),
                                  ),
                                ),
                                onTap: () async {
                                  loginValidation();
                                },
                              )
                          ),
                        ),
                        widgetShared.divider(50.00, Colors.transparent),
                        Container(
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Belum Punya Akun?',
                                  style: styleText.openSansBold(color: Colors.black87, size: 14.0, weightfont: true)
                                ),
                                InkWell(
                                  child: Text(
                                    ' Daftar disini',
                                    style: styleText.openSansBold(color: styleColor.colorRed, size: 14.0, weightfont: true)
                                  ),
                                  onTap: () {
                                    FocusScope.of(context).requestFocus(FocusNode());
                                    Navigator.of(context).pushNamed('/register', arguments: 'hello i am from first page!');
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
              ),
            )
        )
    );
  }
}
