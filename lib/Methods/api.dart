import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Network{
  final String _url = 'http://192.168.0.101:8080/api/auth';
  var token;

  _getToken() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String? tokenString = localStorage.getString('token');

    if (tokenString != null) {
      token = jsonDecode(tokenString)['token'];
    } else {
      token = null;
    }
  }

  auth(data, apiURL) async {
    if (apiURL == null) {
      throw Exception("apiURL cannot be null");
    }
    var fullUrl = Uri.parse(_url + apiURL);
    return await http.post(
      fullUrl,
      body: jsonEncode(data),
      headers: _setHeaders(),
    );
  }

  getData(apiURL) async {
    if (apiURL == null) {
      throw Exception("apiURL cannot be null");
    }
    var fullUrl = Uri.parse(_url + apiURL);
    await _getToken();
    return await http.get(
      fullUrl,
      headers: _setHeaders(),
    );
  }

  _setHeaders() => {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  };
}