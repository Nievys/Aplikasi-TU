import 'package:aplikasikkp/model/userLogin.dart';

class loginData {
  final String token;
  final userLogin userWhoLogged;
  final String decryptKey;

  loginData({
    required this.token,
    required this.userWhoLogged,
    required this.decryptKey,
  });

  factory loginData.fromJson(Map<String, dynamic> json) {
    return loginData(
      token: json["token"],
      userWhoLogged: userLogin.fromJson(json["payload"]["user"]),
      decryptKey: json["decryption_key"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "token": token,
      "payload": {
        "user": userWhoLogged.toJson(),
      },
      "decryption_key": decryptKey,
    };
  }
}
