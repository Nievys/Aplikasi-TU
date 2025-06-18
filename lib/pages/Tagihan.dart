import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:aplikasikkp/ScreenView.dart';
import 'package:aplikasikkp/Utils/ColorNest.dart' as thiscolor;

import '../Utils/RpFormatter.dart';
import '../Utils/localDB.dart';
import '../auth/authServices.dart';
import '../model/transaksi.dart';
import '../providers/bloc/transaksiCubit.dart';
import '../widget/FutureMoney.dart';
import '../widget/PembayaranCard.dart';
import 'ProfilePage.dart';

class Tagihan extends StatefulWidget {
  final PageController pageController;
  const Tagihan({super.key, required this.pageController});

  @override
  State<Tagihan> createState() => isiPembayaran();
}

class isiPembayaran extends State<Tagihan> {
  final StorageService ambiltoken = StorageService();

  void initState() {
    loadAllTransaction();
  }

  Future<void> loadAllTransaction() async {
    final callthiscubit = context.read<transaksiCubit>();

    var token = await ambiltoken.getToken();
    var data = {
      'token' : token
    };
    callthiscubit.AllTransaction(data);
  }

  int currentPage = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        Text(
                          "Tagihan",
                          style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: thiscolor.AppColor.ijoButton
                          ),
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
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.11,
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
                              width: MediaQuery.of(context).size.width * 0.6,
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
                                        "Jumlah Keseluruhan Tagihan",
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
                                            return FutureBuilder<List<transaksi>>(future: localDB.panggilini.getSpecificTransaction("0"), builder: (context, snapshot) {
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
                                                double totalTagihan = 0.0;
                                                for (var totalTagihanLoop in snapshot.data!) {
                                                  totalTagihan += (double.parse(totalTagihanLoop.spp) - double.parse(totalTagihanLoop.potongan));
                                                }
                                                return futuremoney(amount: CurrencyFormat.convertToIdr(totalTagihan, 2).toString());
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
                                    // Expanded(
                                    //   child: Row(
                                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    //     children: [
                                    //       Text(
                                    //         "Lihat riwayat pembayaran",
                                    //         style: GoogleFonts.poppins(
                                    //             fontSize: 12,
                                    //             fontWeight: FontWeight.w400,
                                    //             color: thiscolor.AppColor.backgroundcolor
                                    //         ),
                                    //       ),
                                    //       Text(
                                    //         ">",
                                    //         style: GoogleFonts.poppins(
                                    //             fontSize: 12,
                                    //             fontWeight: FontWeight.w400,
                                    //             color: thiscolor.AppColor.backgroundcolor
                                    //         ),
                                    //       )
                                    //     ],
                                    //   ),
                                    // ),
                                  ]
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.28,
                            height: MediaQuery.of(context).size.height * 0.18,
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                                      "Total",
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
                                          return FutureBuilder<int>(future: localDB.panggilini.countTotalTagihan("0"), builder: (context, snapshot) {
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
                                              final data = snapshot.data!;
                                              return Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    data.toString(),
                                                    style: GoogleFonts.poppins(
                                                      color: thiscolor.AppColor.backgroundcolor,
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold
                                                    )
                                                  ),
                                                  Text(
                                                    "Tagihan",
                                                    style: GoogleFonts.poppins(
                                                      color: thiscolor.AppColor.backgroundcolor,
                                                      fontWeight: FontWeight.normal,
                                                      fontSize: 14
                                                    ),
                                                  )
                                                ],
                                              );
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
                                ]
                            ),
                          ),
                        ],
                      ),
                    ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    //height: MediaQuery.of(context).size.height * 0.59,
                    margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.05,
                        right: MediaQuery.of(context).size.width * 0.05,
                      top: MediaQuery.of(context).size.height * 0.01
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                      color: thiscolor.AppColor.buttonColor,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow:[BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 12),
                      )],
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.8,
                                  height: MediaQuery.of(context).size.height * 0.02,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Seluruh Tagihan",
                                        style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: thiscolor.AppColor.ijoButton
                                        ),
                                      ),
                                      // ElevatedButton(
                                      //   onPressed: () {
                                      //     widget.pageController.jumpToPage(1);
                                      //   },
                                      //   style: ElevatedButton.styleFrom(
                                      //     backgroundColor: thiscolor.AppColor.backgroundcolor,
                                      //     side: BorderSide(color: thiscolor.AppColor.ijoButton),
                                      //     shape: RoundedRectangleBorder(
                                      //       borderRadius: BorderRadius.circular(30),
                                      //     ),
                                      //   ),
                                      //   child:
                                      //   Text(
                                      //     "Lihat semua",
                                      //     style: GoogleFonts.poppins(
                                      //       color: thiscolor.AppColor.ijoButton,
                                      //       fontSize: 10,
                                      //       fontWeight: FontWeight.normal,
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                )
                            )
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.015),
                          //padding: EdgeInsets.symmetric(horizontal: 20),
                          //height:  MediaQuery.of(context).size.height * 0.47,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)
                          ),
                          child: BlocBuilder<transaksiCubit, transaksiState>(
                              builder: (context, state) {
                                if (state is transaksiLoading) {
                                  return CircularProgressIndicator();
                                } else if (state is transaksiFailure) {
                                  return Text(
                                    "error state",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: thiscolor.AppColor.ijoButton,
                                    ),
                                  );
                                } else if (state is transaksiSuccess) {
                                  return FutureBuilder<List<transaksi>>(future: localDB.panggilini.getLatestDateTransactionsFilteredByStatus("0"), builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    } if (snapshot.hasError) {
                                      return Text(
                                        snapshot.error.toString(),
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: thiscolor.AppColor.ijoButton,
                                        ),
                                      );
                                    } else {
                                      return ListView.builder(
                                          itemCount: snapshot.data?.length,
                                          shrinkWrap: true,
                                          physics: const BouncingScrollPhysics(),
                                          //padding: const EdgeInsets.symmetric(horizontal: 20),
                                          itemBuilder:(context, index) {
                                            final transaksi = snapshot.data?[index];
                                            return Pembayarancard(transaction: transaksi!, isHome: false);
                                          }
                                      );
                                    }
                                  }
                                  );
                                }
                                return Text(
                                  "error future builder",
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: thiscolor.AppColor.ijoButton,
                                  ),
                                );
                              }
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.11)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}