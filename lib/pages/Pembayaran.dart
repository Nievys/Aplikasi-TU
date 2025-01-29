import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:aplikasikkp/ScreenView.dart';
import 'package:aplikasikkp/Utils/ColorNest.dart' as thiscolor;

class Pembayaran extends StatefulWidget {
  const Pembayaran({Key? key}) : super(key: key);

  @override
  State<Pembayaran> createState() => isiPembayaran();
}

class isiPembayaran extends State<Pembayaran> {
  int currentPage = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: thiscolor.AppColor.backgroundcolor,
      body: Container(
        child:
        Positioned(
          bottom: 30,
          left: 20,
          right: 20,
          child: Container(
            width: double.infinity,
            child: Center(
              child: Text("Pembayaran"),
            ),
          ),
        ),
      ),
    );
  }
}