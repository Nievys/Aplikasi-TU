import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Network {
  final String _url = 'http://192.168.166.224:8000/api/auth';
  var token;

  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String? tokenString = localStorage.getString('token');

    if (tokenString != null) {
      token = jsonDecode(tokenString)['token'];
    } else {
      token = null;
    }
  }

  Future<Map<String, dynamic>> auth(data, String apiURL) async {
    if (apiURL == null) {
      throw Exception("apiURL cannot be null");
    }
    var fullUrl = Uri.parse(_url + apiURL);

    var response = await http.post(
      fullUrl,
      body: jsonEncode(data),
      headers: _setHeaders(),
    );

    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      return {
        "success": body['success'] ?? false,
        "message": body['message'] ?? "Unknown error",
        "token": body['token'] ?? null,
        "user": body['user'] != null ? {
          "id": body['user']['id'] ?? null,
          "name": body['user']['name'] ?? "",
          "email": body['user']['email'] ?? "",
          "role": body['user']['role'] ?? "",
        } : null,
        "role": body['role'] ?? null,
      };
    } else {
      return {
        "success": false,
        "message": "Server error: ${response.statusCode}"
      };
    }
  }

  Future<Map<String, dynamic>> getData(String apiURL) async {
    if (apiURL == null) {
      throw Exception("apiURL cannot be null");
    }
    var fullUrl = Uri.parse(_url + apiURL);
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

  _setHeaders() => {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  };
}