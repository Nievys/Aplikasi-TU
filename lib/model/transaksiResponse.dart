import 'package:aplikasikkp/model/transaksi.dart';

class transaksiResponse {
  final String message;
  final List<transaksi> dataTransaksi;

  transaksiResponse({
    required this.message,
    required this.dataTransaksi,
  });

  factory transaksiResponse.fromJson(Map<String, dynamic> json) {
    var dataList = json["data"] as List;
    List<transaksi> parsedTransactions = dataList
        .map((item) => transaksi.fromJson(item as Map<String, dynamic>))
        .toList();
    return transaksiResponse(
      message: json["message"],
      dataTransaksi:parsedTransactions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "message": message,
      "data": dataTransaksi.map((e) => e.toJson()).toList(),
    };
  }
}
