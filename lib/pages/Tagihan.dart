import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:aplikasikkp/ScreenView.dart';
import 'package:aplikasikkp/Utils/ColorNest.dart' as thiscolor;

class Tagihan extends StatefulWidget {
  const Tagihan({Key? key}) : super(key: key);

  @override
  State<Tagihan> createState() => isiPembayaran();
}

class isiPembayaran extends State<Tagihan> {
  int currentPage = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: thiscolor.AppColor.backgroundcolor,
      body: Center(
        child: Container(
            width: double.infinity,
            child: Center(
              child: Text("Tagihan"),
            ),
          ),
      ),
    );
  }
}