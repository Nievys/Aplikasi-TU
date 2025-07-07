import 'dart:convert';
import 'package:aplikasikkp/model/transaksi.dart';
import 'package:aplikasikkp/model/transaksiResponse.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'localDB.dart';

class TransactionStorageService {
  final localDB inilocalDB;

  TransactionStorageService(this.inilocalDB);

  Future<void> saveTransactions(List<transaksi> transactions) async {
    for (var trx in transactions) {
      await inilocalDB.insertTransaction(trx);
    }
  }
  Future<void> deleteAllTransactions() async {
    await inilocalDB.deleteAllTransaction();
  }
}

class transaksiServices {
  static final String baseUrl = 'http://192.168.0.101:12000/api';
  //static final String baseUrl = 'http://10.74.80.224:12000/api';
  var token;

  Future<transaksiResponse> getAllTransaction(data) async {
    var response = await http.post(
      Uri.parse("$baseUrl/transaction"),
      body: jsonEncode(data),
      headers: _setHeaders(),
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> isidata = jsonDecode(response.body);
      transaksiResponse user = transaksiResponse.fromJson(isidata);
      return user;
    } else {
      throw Exception("failed");
    }
  }

  _setHeaders() => {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  Future<String> updateConfirmation(Map<String, dynamic> data) async {
    var response = await http.post(
      Uri.parse("$baseUrl/verifikasi-spp"),
      body: jsonEncode(data),
      headers: _setHeaders(),
    );
    if (response.statusCode == 200) {
      return("Success");
    } else {
      throw Exception("Failed");
    }
  }
}