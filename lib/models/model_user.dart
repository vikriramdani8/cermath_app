import 'dart:convert';

class ModelUser{
    final String users_id;
    final int usertype_id;
    final int class_id;
    final int gender_id;
    final String username;
    final String email;
    final String password;
    final String fullname;
    final String phone;

    ModelUser({
      required this.users_id,
      required this.usertype_id,
      required this.class_id,
      required this.gender_id,
      required this.username,
      required this.email,
      required this.password,
      required this.fullname,
      required this.phone,
    });

    factory ModelUser.fromJson(Map<String, dynamic> json) {
      return ModelUser(
          users_id: json['users_id'] ?? '',
          usertype_id: json['usertype_id'] ?? 0,
          class_id: json['class_id'] ?? 0,
          gender_id: json['gender_id'] ?? 0,
          username: json['username'] ?? '',
          email: json['email'] ?? '',
          password: json['password'] ?? '',
          fullname: json['fullname'] ?? '',
          phone: json['phone'] ?? ''
      );
    }
}