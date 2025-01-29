import 'package:aplikasikkp/pages/HomePage.dart';
import 'package:aplikasikkp/pages/Pembayaran.dart';
import 'package:aplikasikkp/pages/Tenggat.dart';
import 'package:aplikasikkp/pages/Laporan.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:aplikasikkp/Utils/ColorNest.dart' as thiscolor;

class Screenview extends StatefulWidget {
  const Screenview({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => isiScreenview();
}

class isiScreenview extends State<Screenview> {
  int selectedPage = 0;
  final List<Widget> pages = [
    HomePage(),
    Pembayaran(),
    Tenggat(),
    Laporan()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: thiscolor.AppColor.backgroundcolor,
      body: pages[selectedPage],
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: thiscolor.AppColor.ijoButton,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: GNav(
          selectedIndex: selectedPage,
          onTabChange: (index) {
            setState(() {
              selectedPage = index;
            });
          },
          color: thiscolor.AppColor.backgroundcolor,
          activeColor: thiscolor.AppColor.ijoButton,
          tabBackgroundColor: thiscolor.AppColor.buttonColor,
          gap: 10,
          iconSize: 24,
          curve: Curves.easeInToLinear,
          duration: const Duration(milliseconds: 400),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          tabMargin: const EdgeInsets.symmetric(vertical: 10),
          tabs: const [
            GButton(icon: Icons.home, text: 'Home'),
            GButton(icon: Icons.view_stream_rounded, text: 'Pembayaran'),
            GButton(icon: Icons.timer_rounded, text: 'Tenggat'),
            GButton(icon: Icons.timeline, text: 'Laporan'),
          ],
        ),
      ),
    );
  }
}
