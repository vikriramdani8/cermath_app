import 'dart:convert';

import 'package:cermath_app/common/style/style_color.dart';
import 'package:cermath_app/common/widget/widget_shared.dart';
import 'package:cermath_app/common/style/style_common.dart';
import 'package:cermath_app/common/style/style_text.dart';
import 'package:cermath_app/common/widget/widget_alert.dart';
import 'package:cermath_app/models/model_information.dart';
import 'package:cermath_app/models/model_user.dart';
import 'package:cermath_app/services/service_common.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileEdit extends StatefulWidget {
  const ProfileEdit({Key? key}) : super(key: key);

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {

  @override
  void initState(){
    super.initState();
    checkAuth();
  }

  StyleText styleText = new StyleText();
  StyleColor styleColor = new StyleColor();
  StyleCommon styleCommon = new StyleCommon();
  WidgetShared widgetShared = new WidgetShared();
  WidgetAlert widgetAlert = new WidgetAlert();

  List<Classes> classList = [];
  List<UserTypes> userTypeList = [];
  List<Gender> genderList = [];

  ModelUser? modelUser;

  var _genderValue = "";
  var _userTypeValue = "";
  var _classValue = "";
  var _token = "";

  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController gender = TextEditingController();
  TextEditingController usertype = TextEditingController();
  TextEditingController classes = TextEditingController();

  Future<void> checkAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userPref = prefs.getString('user');
    var userMap = jsonDecode(userPref!);
    if(userMap != null){
      _token = userMap['token'];
      modelUser = ModelUser.fromJson(userMap);
      getGender();
    }
  }

  Future<void> getGender() async {
    var responses = await ServiceCommon().getGender();
    var resultBody = json.decode(responses.body);

    if(resultBody['success']){
      Iterable data = resultBody['data'];
      genderList = List<Gender>.from(data.map((model) => Gender.fromJson(model)));
      _genderValue = genderList[0].id.toString();

      getUserType();
    } else {
      widgetAlert.showErrorSnackbar(resultBody['message'], context);
    }
  }

  Future<void> getUserType() async {
    var responses = await ServiceCommon().getUserType();
    var resultBody = json.decode(responses.body);

    if(resultBody['success']){
      Iterable data = resultBody['data'];
      userTypeList = List<UserTypes>.from(data.map((model) => UserTypes.fromJson(model)));
      _userTypeValue = userTypeList[0].id.toString();

      getClass();
    }
  }

  Future<void> getClass() async {
    var responses = await ServiceCommon().getClass();
    var resultBody = json.decode(responses.body);

    if(resultBody['success']){
      Iterable data = resultBody['data'];
      classList = List<Classes>.from(data.map((model) => Classes.fromJson(model)));
      _classValue = classList[0].id.toString();
      setState(() {});
    }
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
            )
        ),
        title: Text(
          'Edit Profile',
          style: styleText.openSansBold(
              color: Colors.white,
              size: 20.0,
              weightfont: true
          )
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: width,
          height: height-150,
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(bottom: 5),
                child: Text(
                  'Username',
                  style: styleText.openSansBold(
                      color: Colors.black54,
                      size: 15.0,
                      weightfont: false
                  ),
                ),
              ),
              Container(
                child: TextField(
                  controller: username,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 5),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    labelText: "Username",
                    prefixIcon: const Icon(Icons.person),
                    border: styleCommon.myinputborder(true),
                    enabledBorder: styleCommon.myinputborder(true),
                    focusedBorder: styleCommon.myfocusborder(true),
                    focusColor: Colors.white,
                  ),
                ),
              ),
              widgetShared.divider(20.0, Colors.transparent),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(bottom: 5),
                child: Text(
                  'Email',
                  style: styleText.openSansBold(
                      color: Colors.black54,
                      size: 15.0,
                      weightfont: false
                  ),
                ),
              ),
              Container(
                child: TextField(
                  controller: email,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 5),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    labelText: "Email",
                    prefixIcon: const Icon(Icons.mail),
                    border: styleCommon.myinputborder(true),
                    enabledBorder: styleCommon.myinputborder(true),
                    focusedBorder: styleCommon.myfocusborder(true),
                    focusColor: Colors.white,
                  ),
                ),
              ),
              widgetShared.divider(20.0, Colors.transparent),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(bottom: 5),
                child: Text(
                  'Gender',
                  style: styleText.openSansBold(
                      color: Colors.black54,
                      size: 15.0,
                      weightfont: false
                  ),
                ),
              ),
              FormField(
                builder: (FormFieldState<String> state) {
                  return InputDecorator(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      errorStyle: TextStyle(color: Colors.redAccent, fontSize: 16.0),
                      border: styleCommon.myinputborder(true),
                      enabledBorder: styleCommon.myinputborder(true),
                      focusedBorder: styleCommon.myfocusborder(true),
                    ),
                    isEmpty: _genderValue == '',
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isDense: true,
                        items: genderList.map((data) => DropdownMenuItem<String>(
                          value: data.id.toString(),
                          child: Text(data.value),
                        )).toList(),
                        value: _genderValue,
                        onChanged: (str) {
                          setState(() {
                            _genderValue = str.toString();
                          });
                        },
                      ),
                    )
                  );
                }
              ),
              widgetShared.divider(30.0, Colors.transparent),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(bottom: 5),
                child: Text(
                  'Tipe Pengguna',
                  style: styleText.openSansBold(color: Colors.black54, size: 15.0, weightfont: false),
                ),
              ),
              FormField(
                  builder: (FormFieldState<String> state) {
                    return InputDecorator(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          errorStyle: TextStyle(color: Colors.redAccent, fontSize: 16.0),
                          border: styleCommon.myinputborder(true),
                          enabledBorder: styleCommon.myinputborder(true),
                          focusedBorder: styleCommon.myfocusborder(true),
                        ),
                        isEmpty: _userTypeValue == '',
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isDense: true,
                            items: userTypeList.map((data) => DropdownMenuItem<String>(
                              value: data.id.toString(),
                              child: Text(data.value),
                            )).toList(),
                            value: _userTypeValue,
                            onChanged: (str) {
                              setState(() {
                                _userTypeValue = str.toString();
                              });
                            },
                          ),
                        )
                    );
                  }
              ),
              widgetShared.divider(30.0, Colors.transparent),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(bottom: 5),
                child: Text(
                  'Kelas',
                  style: styleText.openSansBold(color: Colors.black54, size: 15.0, weightfont: false),
                ),
              ),
              FormField(
                  builder: (FormFieldState<String> state) {
                    return InputDecorator(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          errorStyle: TextStyle(color: Colors.redAccent, fontSize: 16.0),
                          border: styleCommon.myinputborder(true),
                          enabledBorder: styleCommon.myinputborder(true),
                          focusedBorder: styleCommon.myfocusborder(true),
                        ),
                        isEmpty: _classValue == '',
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isDense: true,
                            items: classList.map((data) => DropdownMenuItem<String>(
                              value: data.id.toString(),
                              child: Text('Kelas '+data.value),
                            )).toList(),
                            value: _classValue,
                            onChanged: (str) {
                              setState(() {
                                _classValue = str.toString();
                              });
                            },
                          ),
                        )
                    );
                  }
              ),
              widgetShared.divider(30.0, Colors.transparent),
              Center(
                  child: InkWell(
                    child: Container(
                      width: 180,
                      height: 53,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white
                      ),
                      child: Center(
                        child: Text(
                          'Simpan Informasi',
                          style: styleText.openSansBold(
                            color: Colors.black45,
                            size: 16.0,
                            weightfont: true
                          )
                        ),
                      ),
                    ),
                    onTap: () {
                      print('huhuu');
                    },
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
