import 'dart:convert';

import 'package:cermath_app/constants/constant.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ServiceMateri{
  final String _url = ApiConstants.baseUrl;
  var _token = "";
  setHeaders() => {'accept': 'application/json', 'Authorization': 'Bearer $_token'};

  getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userPref = prefs.getString('user');
    bool? login = prefs.getBool('login');

    if (login == true && userPref != null) {
      var userMap = jsonDecode(userPref);
      _token = userMap['token'];
    }
  }

  getMateriByClass(classes) async {
    var fullrl = _url + "/materi/lessonByClass/" + classes.toString();
    return await http.get(Uri.parse(fullrl));
  }

  getAllMateriByClass(classes) async {
    var fullrl = _url + "/materi/allLessonByClass/" + classes.toString();
    return await http.get(Uri.parse(fullrl));
  }

  getSubMateriByLessonId(lessonId) async {
    var fullrl = _url + "/lesson/listsublesson/" + lessonId.toString();
    return await http.get(Uri.parse(fullrl));
  }

  getListQuizByLessonId(userId, lessonId) async {
    await getToken();
    var fullrl = _url + "/quiz/list/${userId.toString()}/${lessonId.toString()}";
    return await http.get(Uri.parse(fullrl), headers: setHeaders());
  }

  getListQuizQuestionByQuizId(quizId) async {
    var fullrl = _url + "/materi/quiz/" + quizId.toString();
    return await http.get(Uri.parse(fullrl));
  }
}