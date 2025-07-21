import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:aplikasikkp/model/transaksi.dart';
import 'package:aplikasikkp/model/transaksiResponse.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'localDB.dart';

class TransactionStorageService {
  final localDB inilocalDB;

  TransactionStorageService(this.inilocalDB);

  Future<void> saveTransactions(List<transaksi> transactions) async {
    for (var trx in transactions) {
      //log('Akan menyimpan id: ${trx.idTransaksi}, Bukti Pembayaran: ${trx.bukti_pembayaran}');
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

  Future<String> uploadBuktiPembayaran({
    required String token,
    required String idTransaksi,
    required File buktiPembayaran,
  }) async {
    var uri = Uri.parse("$baseUrl/upload_bukti_pembayaran");

    var request = http.MultipartRequest('POST', uri);
    request.fields['token'] = token;
    request.fields['id_transaksi'] = idTransaksi;

    request.files.add(await http.MultipartFile.fromPath(
      'bukti_pembayaran',
      buktiPembayaran.path,
    ));

    request.headers.addAll({
      'Accept': 'application/json',
    });

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return "Success";
    } else {
      return "Failed: ${response.body}";
    }
  }

  Future<File?> downloadAndSavePDF(String token, String idTransaksi) async {
    try {
      final dir = await getTemporaryDirectory();
      final filePath = '${dir.path}/struk_$idTransaksi.pdf';
      final file = File(filePath);

      final dio = Dio();
      final response = await dio.post(
        "$baseUrl/download_struk",
        data: {
          'token': token,
          'id_transaksi': idTransaksi,
        },
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode == 200) {
        await file.writeAsBytes(response.data);
        log('PDF saved at: $filePath');
        log('File exists: ${await file.exists()}');
        return file;
      } else {
        log('Gagal download PDF: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      log('Error saat download PDF: $e');
      return null;
    }
  }
}