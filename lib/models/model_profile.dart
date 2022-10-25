import 'dart:convert';

class ModelProfil{
  final String users_id;
  final String fullname;
  final String class_name;
  final String email;
  final String usertype_name;
  final String score;
  final String telepon;

  ModelProfil({
    required this.users_id,
    required this.fullname,
    required this.class_name,
    required this.email,
    required this.usertype_name,
    required this.score,
    required this.telepon
  });

  factory ModelProfil.fromJson(Map<String, dynamic> json) {
    return ModelProfil(
        users_id: json['users_id'] ?? '',
        fullname: json['fullname'] ?? '',
        class_name: json['class_name'] ?? '',
        email: json['email'] ?? '',
        usertype_name: json['usertype_name'] ?? '',
        score: json['score'] ?? '',
        telepon: json['phone'] ?? ''
    );
  }
}