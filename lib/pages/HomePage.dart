import 'dart:ffi';
import 'package:aplikasikkp/Utils/localDB.dart';
import 'package:aplikasikkp/auth/authServices.dart';
import 'package:aplikasikkp/model/userLogin.dart';
import 'package:aplikasikkp/widget/FutureMoney.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:aplikasikkp/ScreenView.dart';
import 'package:aplikasikkp/pages/ProfilePage.dart';
import 'package:aplikasikkp/Utils/ColorNest.dart' as thiscolor;

import '../Utils/RpFormatter.dart';
import '../model/transaksi.dart';
import '../providers/bloc/transaksiCubit.dart';

class HomePage extends StatefulWidget {
  final PageController pageController;
  const HomePage({super.key, required this.pageController});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 1;
  late Future<userLogin> userWhoLogged;
  final StorageService ambiltoken = StorageService();

  void initState() {
    userWhoLogged = loadUserData();
    loadAllTransaction();
  }

  Future<userLogin> loadUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var name = localStorage.getString('name');
    var email = localStorage.getString('email');
    var role = localStorage.getString('role');
    var account_id = localStorage.getInt('account_id');

    if (name != null && email != null && role != null && account_id != null) {
      return userLogin(
        name: name,
        email: email,
        role: role,
        account_id: account_id,
      );
    } else {
      return userLogin(account_id: 0, name: "account error, lakukan login ulang!", email: "noemail@gmail.com", role: "error");
    }
  }

  Future<void> loadAllTransaction() async {
    final callthiscubit = context.read<transaksiCubit>();

    var token = await ambiltoken.getToken();
    var data = {
      'token' : token
    };
    callthiscubit.AllTransaction(data);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child:
        Scaffold(
          backgroundColor: thiscolor.AppColor.backgroundcolor,
          body: Center(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.08,
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.08,
                            right: MediaQuery.of(context).size.width * 0.08,
                            top: MediaQuery.of(context).size.width * 0.03
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FutureBuilder(future: userWhoLogged, builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text(
                                  snapshot.error.toString(),
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: thiscolor.AppColor.ijoButton
                                  )
                                );
                              }
                              return Text(
                                  snapshot.data!.name,
                                  style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: thiscolor.AppColor.ijoButton
                                  )
                              );
                            }
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: thiscolor.AppColor.backgroundcolor,
                              ),
                              child: IconButton(
                                onPressed: () {
                                  Get.to(() => const Profilepage());
                                },
                                icon: Icon(Icons.notifications_none_rounded),
                                iconSize: 26,
                                color: thiscolor.AppColor.ijoButton,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.height * 0.15,
                        margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: thiscolor.AppColor.backgroundcolor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                widget.pageController.jumpToPage(2);
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.48,
                                height: MediaQuery.of(context).size.height * 0.18,
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: thiscolor.AppColor.ijoButton,
                                  boxShadow:[BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 10,
                                    offset: Offset(0, 12),
                                  )],
                                ),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "SPP lunas",
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: thiscolor.AppColor.backgroundcolor,
                                          )
                                      ),
                                      BlocBuilder<transaksiCubit, transaksiState>(
                                          builder: (context, state) {
                                            if (state is transaksiLoading) {
                                              return CircularProgressIndicator();
                                            } else if (state is transaksiFailure) {
                                              return Text(
                                                "error state",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  color: thiscolor.AppColor.backgroundcolor,
                                                ),
                                              );
                                            } else if (state is transaksiSuccess) {
                                              return FutureBuilder<List<transaksi>>(future: localDB.panggilini.getSpecificTransaction("1"), builder: (context, snapshot) {
                                                if (snapshot.connectionState == ConnectionState.waiting) {
                                                  return CircularProgressIndicator();
                                                } if (snapshot.hasError) {
                                                  return Text(
                                                    snapshot.error.toString(),
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w400,
                                                      color: thiscolor.AppColor.backgroundcolor,
                                                    ),
                                                  );
                                                } else {
                                                  List<transaksi> data = snapshot.data!;
                                                  double totalLunas = 0.0;
                                                  for (var jumlahLunas in snapshot.data!) {
                                                    totalLunas += (double.parse(jumlahLunas.spp) - double.parse(jumlahLunas.potongan));
                                                  }
                                                  return futuremoney(amount: CurrencyFormat.convertToIdr(totalLunas, 2).toString());
                                                }
                                              }
                                              );
                                            }
                                            return Text(
                                              "error future builder",
                                              style: GoogleFonts.poppins(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: thiscolor.AppColor.backgroundcolor,
                                              ),
                                            );
                                          }
                                      ),
                                      SizedBox(height: MediaQuery.of(context).size.height * 0.025),

                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Lihat riwayat pembayaran",
                                              style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  color: thiscolor.AppColor.backgroundcolor
                                              ),
                                            ),
                                            Text(
                                              ">",
                                              style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  color: thiscolor.AppColor.backgroundcolor
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ]
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.4,
                                  height: MediaQuery.of(context).size.height * 0.07,
                                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.045, vertical: MediaQuery.of(context).size.height * 0.015),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: thiscolor.AppColor.ijoButton,
                                    boxShadow:[BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 10,
                                      offset: Offset(0, 12),
                                    )],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Tagihan bulan ini",
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: thiscolor.AppColor.backgroundcolor,
                                            ),
                                          ),
                                          Text(
                                            "Rp. 123.123.123,00",
                                            style: GoogleFonts.poppins(
                                              fontSize: MediaQuery.of(context).size.width * 0.0335,
                                              fontWeight: FontWeight.bold,
                                              color: thiscolor.AppColor.backgroundcolor,
                                            ),
                                          )
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            ">",
                                            style: GoogleFonts.poppins(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w400,
                                              color: thiscolor.AppColor.backgroundcolor,
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.4,
                                  height: MediaQuery.of(context).size.height * 0.07,
                                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.045, vertical: MediaQuery.of(context).size.height * 0.015),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: thiscolor.AppColor.ijoButton,
                                    boxShadow:[BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 10,
                                      offset: Offset(0, 12),
                                    )],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Total tagihan",
                                            style: GoogleFonts.poppins(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w400,
                                              color: thiscolor.AppColor.backgroundcolor,
                                            ),
                                          ),
                                          Text(
                                            "12",
                                            style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: thiscolor.AppColor.backgroundcolor,
                                            ),
                                          )
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            ">",
                                            style: GoogleFonts.poppins(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w400,
                                              color: thiscolor.AppColor.backgroundcolor,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}