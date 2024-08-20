
class Usermodel {
  bool? status;
  int? responseCode;
  String? message;
  Data? data;

  Usermodel({this.status, this.responseCode, this.message, this.data});

  Usermodel.fromJson(Map<String, dynamic> json) {
    if(json["status"] is bool) {
      status = json["status"];
    }
    if(json["response_code"] is int) {
      responseCode = json["response_code"];
    }
    if(json["message"] is String) {
      message = json["message"];
    }
    if(json["data"] is Map) {
      data = json["data"] == null ? null : Data.fromJson(json["data"]);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["status"] = status;
    _data["response_code"] = responseCode;
    _data["message"] = message;
    if(data != null) {
      _data["data"] = data?.toJson();
    }
    return _data;
  }
}

class Data {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? country;
  String? password;
  String? profileImage;
  String? createdAt;

  Data({this.id, this.name, this.email, this.phone, this.country, this.password, this.profileImage, this.createdAt});

  Data.fromJson(Map<String, dynamic> json) {
    if(json["id"] is String) {
      id = json["id"];
    }
    if(json["name"] is String) {
      name = json["name"];
    }
    if(json["email"] is String) {
      email = json["email"];
    }
    if(json["phone"] is String) {
      phone = json["phone"];
    }
    if(json["country"] is String) {
      country = json["country"];
    }
    if(json["password"] is String) {
      password = json["password"];
    }
    if(json["profile_image"] is String) {
      profileImage = json["profile_image"];
    }
    if(json["created_at"] is String) {
      createdAt = json["created_at"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["email"] = email;
    _data["phone"] = phone;
    _data["country"] = country;
    _data["password"] = password;
    _data["profile_image"] = profileImage;
    _data["created_at"] = createdAt;
    return _data;
  }
}