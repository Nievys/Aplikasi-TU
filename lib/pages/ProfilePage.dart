import 'dart:ffi';

import 'package:aplikasikkp/pages/HomePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:aplikasikkp/ScreenView.dart';
import 'package:aplikasikkp/Utils/ColorNest.dart' as thiscolor;

class Profilepage extends StatefulWidget {
  const Profilepage({Key? key}) : super(key: key);

  @override
  State<Profilepage> createState() => isiProfilepage();
}

class isiProfilepage extends State<Profilepage> {
  int currentPage = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: thiscolor.AppColor.backgroundcolor,
      body: Container(
        child:
        SafeArea(
          left: true,
          right: true,
          top: true,
          bottom: true,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(17),
                        color: thiscolor.AppColor.ijoButton,
                      ),
                      child: BackButton(
                        onPressed: () => Navigator.of(context).pop(),
                        color: thiscolor.AppColor.backgroundcolor,
                      ),
                    ),
                    Text(
                      "Profile Page",
                      style: TextStyle(
                        fontSize: 24,
                        color: thiscolor.AppColor.ijoButton,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}