import 'dart:ffi';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:aplikasikkp/ScreenView.dart';
import 'package:aplikasikkp/pages/ProfilePage.dart';
import 'package:aplikasikkp/Utils/ColorNest.dart' as thiscolor;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 1;

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
                    Text(
                      "Home Page",
                      style: TextStyle(
                        fontSize: 24,
                        color: thiscolor.AppColor.ijoButton,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(17),
                        color: thiscolor.AppColor.ijoButton,
                      ),
                      child: IconButton(
                        onPressed: () {
                          Get.to(() => const Profilepage());
                        },
                        icon: Icon(Icons.person_sharp),
                        iconSize: 26,
                        color: thiscolor.AppColor.backgroundcolor,
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