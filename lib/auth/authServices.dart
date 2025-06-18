import 'dart:convert';
import 'dart:developer';
import 'package:aplikasikkp/model/cekToken.dart';
import 'package:aplikasikkp/model/userLogin.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/authResponse.dart';

class StorageService {
  final _storage = const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: 'token');
  }
}

class authServices {
  //static final String baseUrl = 'http://192.168.0.100:12000/api';
  static final String baseUrl = 'http://10.74.80.224:12000/api';
  var token;

  Future<loginData> loginjwt(data) async {
    var response = await http.post(
      Uri.parse("$baseUrl/auth/request/jwt"),
      body: jsonEncode(data),
      headers: _setHeaders(),
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> isidata = jsonDecode(response.body);
      loginData user = loginData.fromJson(isidata);
      return user;
    } else {
      throw Exception("Failed to login");
    }
  }

  Future<cekToken> checkLogin(token) async {
    print(token);
    var response = await http.post(
      Uri.parse("$baseUrl/cekToken"),
      headers: _setHeaders(),
      body: jsonEncode({"token": token}),
    );
    log("${response.statusCode}");
    if (response.statusCode == 200) {
      Map<String, dynamic> isidata = jsonDecode(response.body);
      cekToken hasiltoken = cekToken.fromJson(isidata);
      return hasiltoken;
    } else {
      throw Exception("Failed to login");
    }
  }

  Future<Map<String, dynamic>> getData(String apiURL) async {
    if (apiURL == null) {
      throw Exception("apiURL cannot be null");
    }
    var fullUrl = Uri.parse(baseUrl + apiURL);
    await _getToken();

    var response = await http.get(
      fullUrl,
      headers: _setHeaders(),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return {"success": false, "message": "Failed to fetch data"};
    }
  }

  _getToken() async {
    Uri.parse("$baseUrl/login");
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String? tokenString = localStorage.getString('token');

    if (tokenString != null) {
      token = jsonDecode(tokenString)['token'];
    } else {
      token = null;
    }
  }

  _setHeaders() => {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };
}