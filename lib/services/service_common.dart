import 'dart:convert';

import 'package:cermath_app/constants/constant.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ServiceCommon {
  final String _url = ApiConstants.baseUrl;
  var _token = "";
  setHeaders() =>
      {'accept': 'application/json', 'Authorization': 'Bearer $_token'};

  getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userPref = prefs.getString('user');
    bool? login = prefs.getBool('login');

    if (login == true && userPref != null) {
      var userMap = jsonDecode(userPref);
      _token = userMap['token'];
    }
  }

  getClass() async {
    await getToken();
    var fullUrl = _url + "/class";
    return await http.get(Uri.parse(fullUrl), headers: setHeaders());
  }

  getUserType() async {
    await getToken();
    var fullUrl = _url + "/usertype";
    return await http.get(Uri.parse(fullUrl), headers: setHeaders());
  }

  getGender() async {
    await getToken();
    var fullUrl = _url + "/gender";
    return await http.get(Uri.parse(fullUrl), headers: setHeaders());
  }

  getProfil(userId) async {
    await getToken();
    var fullUrl = "$_url/users/profile/${userId.toString()}";
    return await http.get(Uri.parse(fullUrl), headers: setHeaders());
  }

  updateProfile(String userId, data) async {
    await getToken();
    var fullUrl = "$_url/users/changeProfile/$userId";
    return await http.put(Uri.parse(fullUrl), body: data, headers: setHeaders(),
    );
  }
}
