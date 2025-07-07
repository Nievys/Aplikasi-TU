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
import '../widget/PopupMenuWidget.dart';
import 'ProfilePage.dart';

class Riwayat extends StatefulWidget {
  final PageController pageController;
  const Riwayat({super.key, required this.pageController});

  @override
  State<Riwayat> createState() => isiTenggat();
}

class isiTenggat extends State<Riwayat> {
  String? selectedSemester;
  String? selectedTahunAjaran;
  List<String> semesterList = [];
  List<String> tahunAjaranList = [];
  int currentPage = 3;

  @override
  void initState() {
    super.initState();
    refreshData();
    loadFilterOptions();
  }

  Future<void> loadFilterOptions() async {
    final data = await localDB.panggilini.getTransaksi();
    final semesters = data.map((e) => e.semester.toString()).toSet().toList();
    final tahunAjaran = data.map((e) => e.tahunAjaran).toSet().toList();

    setState(() {
      semesterList = semesters;
      tahunAjaranList = tahunAjaran;
    });
  }

  Future<void> refreshData() async {
    final token = await StorageService().getToken();
    var data = {
      'token' : token
    };
    if (token != null) {
      context.read<transaksiCubit>().AllTransaction(data);
    }
  }

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
                          "Riwayat",
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
                          child: PopupMenuWidget(
                            iconColor: thiscolor.AppColor.ijoButton,
                            backgroundColor: thiscolor.AppColor.brokenwhite,
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
                                      "Jumlah Seluruh Terbayarkan",
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
                                          return FutureBuilder<List<transaksi>>(future: localDB.panggilini.getSixMonthTransaction("1"), builder: (context, snapshot) {
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
                                              for (var totalLunasLoop in snapshot.data!) {
                                                totalLunas += (double.parse(totalLunasLoop.spp) - double.parse(totalLunasLoop.potongan));
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
                                        return FutureBuilder<List<transaksi>>(future: localDB.panggilini.getSixMonthTransaction("1"), builder: (context, snapshot) {
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
                                                    data.length.toString(),
                                                    style: GoogleFonts.poppins(
                                                        color: thiscolor.AppColor.backgroundcolor,
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.bold
                                                    )
                                                ),
                                                Text(
                                                  "Kwitansi",
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
                                  height: MediaQuery.of(context).size.height * 0.04,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Riwayat",
                                        style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: thiscolor.AppColor.ijoButton
                                        ),
                                      ),
                                      const Spacer(),

                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: thiscolor.AppColor.brokenwhite,
                                            width: 1.5,
                                          ),
                                          borderRadius: BorderRadius.circular(8),
                                          color: thiscolor.AppColor.ijoButton,
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            hint: Text(
                                                "Semester",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 11,
                                                  color: thiscolor.AppColor.backgroundcolor,
                                                )
                                            ),
                                            value: selectedSemester,
                                            icon: Icon(
                                              Icons.arrow_drop_down,
                                              color: thiscolor.AppColor.backgroundcolor,
                                            ),
                                            dropdownColor: thiscolor.AppColor.ijoButton,
                                            style: GoogleFonts.poppins(
                                              fontSize: 11,
                                              color: thiscolor.AppColor.backgroundcolor,
                                            ),
                                            items: semesterList.map((value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                                  child: Text(
                                                      value,
                                                      style: GoogleFonts.poppins(
                                                        fontSize: 11,
                                                        color: thiscolor.AppColor.backgroundcolor,
                                                      )
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                selectedSemester = value;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: thiscolor.AppColor.brokenwhite,
                                            width: 1.5,
                                          ),
                                          borderRadius: BorderRadius.circular(8),
                                          color: thiscolor.AppColor.ijoButton,
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            hint: Text(
                                                "Tahun Ajaran",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 11,
                                                  color: thiscolor.AppColor.backgroundcolor,
                                                )
                                            ),
                                            value: selectedTahunAjaran,
                                            icon: Icon(
                                              Icons.arrow_drop_down,
                                              color: thiscolor.AppColor.backgroundcolor,
                                            ),
                                            dropdownColor: thiscolor.AppColor.ijoButton,
                                            style: GoogleFonts.poppins(
                                              fontSize: 11,
                                              color: thiscolor.AppColor.backgroundcolor,
                                            ),
                                            items: tahunAjaranList.map((value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                                  child: Text(
                                                      value,
                                                      style: GoogleFonts.poppins(
                                                        fontSize: 11,
                                                        color: thiscolor.AppColor.backgroundcolor,
                                                      )
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                selectedTahunAjaran = value;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
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
                                  return FutureBuilder<List<transaksi>>(
                                      future: localDB.panggilini.getFilteredTransactions(
                                        status: "1",
                                        semester: selectedSemester,
                                        tahunAjaran: selectedTahunAjaran,
                                      ), builder: (context, snapshot) {
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
                                            return Pembayarancard(transaction: transaksi!, isHome: false, onRefresh: refreshData);
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
                        SizedBox(height: 5),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.height * 0.08,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: thiscolor.AppColor.backgroundcolor,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {

                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.5,
                                  //height: MediaQuery.of(context).size.height * 0.11,
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                                            "Total Pembayaran",
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
                                                return FutureBuilder<List<transaksi>>(future: localDB.panggilini.getFilteredTransactions(
                                                  status: "1",
                                                  semester: selectedSemester,
                                                  tahunAjaran: selectedTahunAjaran,
                                                ), builder: (context, snapshot) {
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
                                                    for (var totalLunasLoop in snapshot.data!) {
                                                      totalLunas += (double.parse(totalLunasLoop.spp) - double.parse(totalLunasLoop.potongan));
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
                                      ]
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.28,
                                //height: MediaQuery.of(context).size.height * 0.18,
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                                          "Jumlah",
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
                                              return FutureBuilder<List<transaksi>>(future: localDB.panggilini.getFilteredTransactions(
                                                status: "1",
                                                semester: selectedSemester,
                                                tahunAjaran: selectedTahunAjaran,
                                              ), builder: (context, snapshot) {
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
                                                          data.length.toString(),
                                                          style: GoogleFonts.poppins(
                                                              color: thiscolor.AppColor.backgroundcolor,
                                                              fontSize: 18,
                                                              fontWeight: FontWeight.bold
                                                          )
                                                      ),
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