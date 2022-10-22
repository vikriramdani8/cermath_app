class Classes {
  final int id;
  final String value;

  Classes({
    required this.id,
    required this.value
  });

  factory Classes.fromJson(dynamic json){
    return Classes(
        id: json['classId'] ?? "",
        value: json['className'] ?? ""
    );
  }
}

class Gender {
  final int id;
  final String value;

  Gender({
    required this.id,
    required this.value
  });

  factory Gender.fromJson(dynamic json){
    return Gender(
        id: json['genderId'] ?? "",
        value: json['genderName'] ?? ""
    );
  }
}

class UserTypes {
  final int id;
  final String value;

  UserTypes({
    required this.id,
    required this.value
  });

  factory UserTypes.fromJson(dynamic json){
    return UserTypes(
        id: json['usertypeId'] ?? "",
        value: json['usertypeName'] ?? ""
    );
  }
}