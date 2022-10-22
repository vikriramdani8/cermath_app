import 'dart:convert';

import 'package:cermath_app/constants/constant.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ServiceLogin{
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

    login(data) async {
        var fullUrl = _url + "/login";
        return await http.post(
          Uri.parse(fullUrl),
          body: data,
        );
    }

    register(data) async {
      var fullUrl = _url + "/users";
      return await http.post(
          Uri.parse(fullUrl),
          body: data
      );
    }

    information(id, data) async {
      await getToken();
      var fullUrl = _url + "/users/$id";
      return await http.put(Uri.parse(fullUrl),
          body: data, headers: setHeaders());
    }

}