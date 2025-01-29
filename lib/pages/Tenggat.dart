import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:aplikasikkp/ScreenView.dart';
import 'package:aplikasikkp/Utils/ColorNest.dart' as thiscolor;

class Tenggat extends StatefulWidget {
  const Tenggat({Key? key}) : super(key: key);

  @override
  State<Tenggat> createState() => isiTenggat();
}

class isiTenggat extends State<Tenggat> {
  int currentPage = 3;

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
              child: Text("Tenggat"),
            ),
          ),
        ),
      ),
    );
  }
}