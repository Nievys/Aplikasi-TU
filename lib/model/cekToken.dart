import 'dart:io';

class cekToken {
  final String message;
  final int account_id;

  cekToken({
    required this.message,
    required this.account_id,
  });

  factory cekToken.fromJson(Map<String, dynamic> json) {
    return cekToken(
      message: json["message"],
      account_id: json["id"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "message": message,
      "id": account_id,
    };
  }
}