import 'package:aplikasikkp/pages/HomePage.dart';
import 'package:aplikasikkp/pages/ProfilePage.dart';
import 'package:aplikasikkp/pages/Tagihan.dart';
import 'package:aplikasikkp/pages/Riwayat.dart';
import 'package:aplikasikkp/providers/bloc/bottom_nav_cubit.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:aplikasikkp/Utils/ColorNest.dart' as thiscolor;

class Screenview extends StatefulWidget {
  const Screenview({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => isiScreenview();
}

class isiScreenview extends State<Screenview> with SingleTickerProviderStateMixin {
  late PageController pageController;
  int selectedPage = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController(initialPage: selectedPage);
  }

  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  // Masih gatau ini mo dipake apa kg
  Future<bool> kemanalu() async {
    if (pageController.page?.round() != 0) {
      setState(() {
        selectedPage = 0;
        pageController.jumpToPage(0);
        context.read<bottomnavcubit>().changeSelectedPage(0);
      });
      return false;
    } else {
      bool? exitConfirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Konfirmasi Keluar'),
          content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Tidak'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Ya'),
            ),
          ],
        ),
      );
      if (exitConfirmed == true) {
        SystemNavigator.pop();
        return true;
      }
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Ini PageView yg full screen
          PageView(
            controller: pageController,
            onPageChanged: (index) {
              setState(() {
                selectedPage = index;
              });
              BlocProvider.of<bottomnavcubit>(context).changeSelectedPage(index);
            },
            children: [
              HomePage(pageController: pageController),
              Tagihan(pageController: pageController),
              Riwayat(pageController: pageController),
            ],
          ),

          // BOTTOM NAV SEBAGAI OVERLAY
          Positioned(
            left: 0,
            right: 0,
            bottom: 20, // Jarak dari bawah
            child: Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 70),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: thiscolor.AppColor.ijoButton,
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 17,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: GNav(
                  selectedIndex: selectedPage,
                  onTabChange: (index) {
                    pageController.jumpToPage(index);
                    setState(() {
                      selectedPage = index;
                    });
                    BlocProvider.of<bottomnavcubit>(context).changeSelectedPage(index);
                  },
                  color: thiscolor.AppColor.backgroundcolor,
                  activeColor: thiscolor.AppColor.ijoButton,
                  tabBackgroundColor: thiscolor.AppColor.buttonColor,
                  gap: 10,
                  iconSize: 24,
                  curve: Curves.easeInToLinear,
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  tabMargin: const EdgeInsets.symmetric(vertical: 10),
                  tabs: const [
                    GButton(icon: Icons.home, text: 'Home'),
                    GButton(icon: Icons.view_stream_rounded, text: 'Tagihan'),
                    GButton(icon: Icons.timer_rounded, text: 'Riwayat'),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget isiPageview ({required PageController pageController, required Function(int) onPageChange}) {
    return PageView(
      controller: pageController,
      onPageChanged: onPageChange,
        children: <Widget>[
          HomePage(pageController: pageController),
          Tagihan(pageController: pageController),
          Riwayat(pageController: pageController),
        ],
    );
  }

  void onPageChange(int page) {
    BlocProvider.of<bottomnavcubit>(context).changeSelectedPage(page);
  }
}
