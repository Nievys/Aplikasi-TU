// widget/PopupMenuWidget.dart
import 'package:aplikasikkp/pages/Konfirmasi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class PopupMenuWidget extends StatelessWidget {
  final Color iconColor;
  final Color backgroundColor;

  const PopupMenuWidget({
    Key? key,
    required this.iconColor,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      icon: Icon(Icons.menu_rounded, color: iconColor, size: 26),
      color: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      onSelected: (value) {
        switch (value) {
          case 0:
            Get.to(() => const Konfirmasi());
            break;
          case 1:
            //Get.offAll(() => const LoginPage()); // Logout ke halaman login
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 0,
          child: Text("Konfirmasi Pembayaran", style: GoogleFonts.poppins()),
        ),
        PopupMenuItem(
          value: 1,
          child: Text("Logout", style: GoogleFonts.poppins()),
        ),
      ],
    );
  }
}
