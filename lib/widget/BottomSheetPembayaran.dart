import 'dart:developer';

import 'package:aplikasikkp/model/transaksi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Utils/ColorNest.dart' as thiscolor;
import '../Utils/RpFormatter.dart';

class Bottomsheetpembayaran extends StatefulWidget {
  final transaksi transaction;
  final BuildContext parentContext;
  const Bottomsheetpembayaran({
    Key? key,
    required this.transaction,
    required this.parentContext,
  }) : super(key: key);

  @override
  State<Bottomsheetpembayaran> createState() => IsiBottomSheetPembayaran();
}

class IsiBottomSheetPembayaran extends State<Bottomsheetpembayaran> {
  final DraggableScrollableController controllerSheet = DraggableScrollableController();
  bool deskripsiAktif = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 100), () {
      if (mounted) {
        controllerSheet.addListener(() {
          if (controllerSheet.size <= 0.05) {
            if (mounted) {
              Navigator.pop(context);
            }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final parentContext = context;

    // TODO: implement build
    return DraggableScrollableSheet(
        controller: controllerSheet,
        initialChildSize: 0.4,
        minChildSize: 0.2,
        maxChildSize: 0.4,
        builder: (contextBottomSheet, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: thiscolor.AppColor.background,
              borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
            ),
            child: SingleChildScrollView(
                controller: scrollController,
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(height: MediaQuery.of(contextBottomSheet).size.height * 0.005),

                      Container(
                        width: MediaQuery.of(contextBottomSheet).size.width * 0.8,
                        height: MediaQuery.of(contextBottomSheet).size.height * 0.08,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Kartu Pembayaran",
                                style: GoogleFonts.poppins(
                                  color: thiscolor.AppColor.ijoButton,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                "Sentuh kartu untuk melihat status pembayaran",
                                style: GoogleFonts.poppins(
                                  color: thiscolor.AppColor.ijoButton,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ]
                        ),
                      ),

                      InkWell(
                        onTap: () {
                          setState(() {
                            deskripsiAktif = !deskripsiAktif;
                          });
                        },
                        child: Container(
                            margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(contextBottomSheet).size.width * 0.07),
                            width: MediaQuery.of(contextBottomSheet).size.width * 0.8,
                            height: MediaQuery.of(contextBottomSheet).size.height * 0.2,
                            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                            decoration: BoxDecoration(
                                color: thiscolor.AppColor.ijoButton,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 10,
                                    offset: Offset(0, 12),
                                  )
                                ]
                            ),
                            child: Center(
                              child: AnimatedSwitcher(
                                duration: Duration(milliseconds: 200),
                                transitionBuilder: (Widget child, Animation<double> animation) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                                child: deskripsiAktif
                                    ? Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Expanded(
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      "Ketua Komite",
                                                      style: GoogleFonts.poppins(
                                                          color: thiscolor.AppColor.background,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.normal
                                                      ),
                                                    ),
                                                    Text(
                                                      widget.transaction.namaKetuaKomite ?? "null",
                                                      style: GoogleFonts.poppins(
                                                          color: thiscolor.AppColor.background,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.normal
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                            ),
                                            Expanded(
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      "Kepala Sekolah",
                                                      style: GoogleFonts.poppins(
                                                          color: thiscolor.AppColor.background,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.normal
                                                      ),
                                                    ),
                                                    Text(
                                                      widget.transaction.kepalaSekolah ?? "null",
                                                      style: GoogleFonts.poppins(
                                                          color: thiscolor.AppColor.background,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.normal
                                                      ),
                                                    ),
                                                  ],
                                                )
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: statuslunas(widget.transaction.statusLunas)
                                      ),
                                      Text(
                                        "Semester ${widget.transaction.semester}",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          color: thiscolor.AppColor.background,
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      Text(
                                        "Tahun Ajaran ${widget.transaction.tahunAjaran}",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          color: thiscolor.AppColor.background,
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      )
                                    ],
                                  ),
                                ) : Column(
                                  children: [
                                    Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01)),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          widget.transaction.namaLengkap,
                                          style: GoogleFonts.poppins(
                                            color: thiscolor.AppColor.background,
                                            fontSize: 11,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        Text(
                                          "Bulan ke - ${widget.transaction.bulan}",
                                          style: GoogleFonts.poppins(
                                            color: thiscolor.AppColor.background,
                                            fontSize: 11,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: MediaQuery.of(context).size.height * 0.035),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Tagihan SPP",
                                          style: GoogleFonts.poppins(
                                            color: thiscolor.AppColor.background,
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        Text(
                                          CurrencyFormat.convertToIdr(double.tryParse(widget.transaction.spp ?? "0")! - double.tryParse(widget.transaction.potongan)!, 2).toString(),
                                          style: GoogleFonts.poppins(
                                            color: thiscolor.AppColor.background,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 15),
                                        SizedBox(
                                          height: MediaQuery.of(context).size.height * 0.04,
                                          width: MediaQuery.of(context).size.width * 1,
                                          child: Column(
                                            children: [
                                              saldoawalmasuk(
                                                "SPP awal",
                                                CurrencyFormat.convertToIdr(double.parse(widget.transaction.spp ?? "0") ?? 0, 2).toString(),
                                              ),
                                              saldoawalmasuk(
                                                "Potongan",
                                                CurrencyFormat.convertToIdr(double.parse(widget.transaction.potongan ?? "0") ?? 0, 2).toString(),
                                              ),
                                            ],
                                          )
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                        ),
                      ),


                      SizedBox(height: MediaQuery.of(contextBottomSheet).size.height * 0.01),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: thiscolor.AppColor.ijoButton,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text(
                                "Tutup",
                                style: GoogleFonts.poppins(
                                  color: thiscolor.AppColor.background,
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal,
                                )),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
            ),
          );
        }
    );
  }

  Widget saldoawalmasuk (String title, String amount) {
    return Align(
        alignment: Alignment.centerLeft,
        child:
        Row(
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  color: thiscolor.AppColor.background,
                  fontSize: 11,
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(width: 5),
              Text(
                  amount,
                  style: GoogleFonts.poppins(
                    color: thiscolor.AppColor.background,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  )
              )
            ]
        )
    );
  }

  Widget statuslunas(String statusLunas) {
    final parts = statusLunas.split("|");
    log("status lunas: $statusLunas");

    final isLunas = parts.isNotEmpty && parts.first.trim() == "1";

    String tanggal = "";
    if (parts.length >= 2) {
      tanggal = parts[1].trim();
      log("tanggal: $tanggal");
    }

    return Column(
      children: [
        Text(
          isLunas ? "Lunas" : "Belum Lunas",
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            color: thiscolor.AppColor.background,
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
        ),
        if (isLunas)
          Text(
            tanggal,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: thiscolor.AppColor.background,
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ),
        if (!isLunas)
          Text(
            "Silahkan lakukan pembayaran",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: thiscolor.AppColor.background,
              fontSize: 14,
              fontWeight: FontWeight.normal
            ),
          )
      ],
    );
  }
}