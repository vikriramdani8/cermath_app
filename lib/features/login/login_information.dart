import 'dart:convert';

import 'package:cermath_app/models/model_information.dart';
import 'package:cermath_app/models/model_user.dart';
import 'package:cermath_app/services/service_common.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cermath_app/services/service_login.dart';
import 'package:cermath_app/common/style/style_common.dart';
import 'package:cermath_app/common/style/style_text.dart';
import 'package:cermath_app/common/widget/widget_alert.dart';
import 'package:cermath_app/common/style/style_color.dart';
import 'package:cermath_app/common/widget/widget_shared.dart';

class LoginInformation extends StatefulWidget {
  const LoginInformation({Key? key}) : super(key: key);

  @override
  State<LoginInformation> createState() => _LoginInformationState();
}

class _LoginInformationState extends State<LoginInformation> {

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

  TextEditingController genderController = TextEditingController();
  TextEditingController userTypeController = TextEditingController();
  TextEditingController classController = TextEditingController();

  List<Classes> classList = [];
  List<UserTypes> userTypeList = [];
  List<Gender> genderList = [];

  ModelUser? modelUser;

  var _genderValue = "";
  var _userTypeValue = "";
  var _classValue = "";
  var _token = "";
  var _loading = true;

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

      _loading = false;
      setState(() {});
    }
  }

  Future<void> updateInformation(String gender, String usertype, String classid) async{
    var data = {
      "usertype": usertype,
      "gender": gender,
      "classid": classid
    };

    widgetAlert.showLoaderDialog(context);
    var responses = await ServiceLogin().information(modelUser?.users_id, data);
    var resultBody = json.decode(responses.body);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userPref = prefs.getString('user');

    var userMap = jsonDecode(userPref!);
    userMap['gender_id'] = int.parse(gender);
    userMap['usertype_id'] = 1;
    userMap['class_id'] = int.parse(classid);

    prefs.setString('user', jsonEncode(userMap));

    Future.delayed(const Duration(milliseconds: 1000), () async {
      Navigator.of(context, rootNavigator: true).pop();
      if(resultBody['success']){
        widgetAlert.showSuccesSnackbar(resultBody['message'], context);
        Future.delayed(const Duration(milliseconds: 3000), () {
          Navigator.pushNamedAndRemoveUntil(context, "/homePage", (r) => false);
        });
      } else {
        widgetAlert.showErrorSnackbar(resultBody['message'], context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _loading ? Colors.white : styleColor.colorPurple,
        body: _loading ?
        Center(
          child: widgetShared.showLoading(),
        ) :
        SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: styleColor.colorPurple,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                widgetShared.divider(100.0, Colors.transparent),
                Container(
                  height: 100,
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          'cerMath',
                          style: styleText.poppinsBold(color: Colors.white, size: 35.00, weightfont: true)
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          'Mohon isi semua informasi',
                          style: styleText.poppinsBold(color: Colors.white, size: 20.00, weightfont: false)
                        ),
                      ),
                    ],
                  ),
                ),
                widgetShared.divider(70.0, Colors.transparent),
                Container(
                  height: MediaQuery.of(context).size.height-270,
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30)
                      ),
                      color: Colors.white
                  ),
                  child: Column(
                    children: [
                      widgetShared.divider(50.0, Colors.transparent),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(bottom: 5),
                        child: Text(
                          'Gender',
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
                      Container(
                        height: 70,
                        child: Center(
                            child: InkWell(
                              child: Container(
                                width: 200,
                                height: 60,
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
                                    style: styleText.openSansBold(color: Colors.black45, size: 18.0, weightfont: true),
                                  ),
                                ),
                              ),
                              onTap: () {
                                updateInformation(_genderValue, _userTypeValue, _classValue);
                              },
                            )
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        )
    );
  }
}

