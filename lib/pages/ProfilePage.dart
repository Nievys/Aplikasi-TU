import 'dart:convert';
import 'dart:ffi';

import 'package:aplikasikkp/pages/HomePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:aplikasikkp/ScreenView.dart';
import 'package:aplikasikkp/Utils/ColorNest.dart' as thiscolor;
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/transaksiServices.dart';
import '../main.dart';

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
              Container(
                padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 40.0),
                child:
                  SafeArea(child:
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(thiscolor.AppColor.ijoButton),
                        foregroundColor: MaterialStateProperty.all(thiscolor.AppColor.buttonColor),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        elevation: MaterialStateProperty.all(10),
                      ),
                      onPressed: () {
                        logout();
                      },
                      child: Text("Logout".toUpperCase()),
                    ),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }

  void logout() async {
    bool confirmLogout = await showLogoutDialog();
    if (!confirmLogout) return;
  }

  Future<bool> showLogoutDialog() async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Logout"),
          content: Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text("Logout", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    ) ?? false;
  }

  void showMsg(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }
}