import 'dart:developer';
import 'dart:io';

import 'package:aplikasikkp/Utils/transaksiServices.dart';
import 'package:aplikasikkp/model/transaksi.dart';
import 'package:aplikasikkp/widget/pdfViewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Utils/ColorNest.dart' as thiscolor;
import '../Utils/RpFormatter.dart';
import '../Utils/localDB.dart';
import '../auth/authServices.dart';
import '../providers/bloc/transaksiCubit.dart';

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
  bool isLoading = false;

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
    bool isConfirmed = widget.transaction.status_verifikasi == 1;
    bool isLunas = widget.transaction.statusLunas.split("|").isNotEmpty && widget.transaction.statusLunas.split("|").first.trim() == "1";
    transaksiServices apiTransaksi = transaksiServices();

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

                      Container(
                        margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(contextBottomSheet).size.width * 0.085),
                        width: MediaQuery.of(contextBottomSheet).size.width * 0.8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: ElevatedButton(
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
                                  ),
                                ),
                              ),
                            ),

                            // Button saat sudah lunas untuk cetak kwitansi
                            if (isConfirmed && isLunas)
                              SizedBox(width: 10),
                            if (isConfirmed && isLunas)
                              isLoading
                                ? Container(
                                width: 40,
                                height: 40,
                                padding: EdgeInsets.all(8),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(thiscolor.AppColor.ijoButton),
                                ),
                              )
                                : ElevatedButton(
                                  onPressed: () async {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    final storageService = StorageService();
                                    final String? token = await storageService.getToken();
                                    if (token != null) {
                                      final pdfFile = await apiTransaksi.downloadAndSavePDF(token, widget.transaction.idTransaksi.toString());

                                      if (pdfFile != null && context.mounted) {
                                        setState(() {
                                          isLoading = false;
                                        });
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => PDFPreviewPage(filePath: pdfFile.path),
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text("Gagal download PDF")),
                                        );
                                        log("Gagal download PDF");
                                      }
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: thiscolor.AppColor.ijoButton,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: Text(
                                      "Lihat Kwitansi",
                                      style: GoogleFonts.poppins(
                                        color: thiscolor.AppColor.background,
                                        fontSize: 13,
                                        fontWeight: FontWeight.normal,
                                      )),
                                ),

                            // Button untuk mengganti bukti pembayaran dengan kondisi belum lunas dan belum terkonfirmasi
                            if (!isConfirmed && !isLunas)
                              SizedBox(width: 10),
                            if (!isConfirmed && !isLunas)
                              ElevatedButton(
                                onPressed: () async {
                                  if (widget.transaction.bukti_pembayaran != null) {
                                    showDialog(context: context, builder: (context) {
                                      return AlertDialog(
                                        title: Text(
                                          "Bukti Pembayaran sudah ada!",
                                          style: GoogleFonts.poppins(
                                            color: thiscolor.AppColor.ijoButton,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        content: Text(
                                          "Apakah anda ingin mengganti bukti pembayaran?",
                                          style: GoogleFonts.poppins(
                                            color: thiscolor.AppColor.ijoButton,
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              return;
                                            },
                                            child: Text(
                                              "batal",
                                              style: GoogleFonts.poppins(
                                                color: thiscolor.AppColor.ijoButton,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              )
                                            )
                                          ),
                                          TextButton(
                                              onPressed: () async {
                                                bool success = await uploadImage();
                                                if (success) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text("Berhasil mengubah bukti pembayaran")),
                                                  );
                                                }
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                  "ganti",
                                                  style: GoogleFonts.poppins(
                                                    color: thiscolor.AppColor.ijoButton,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  )
                                              )
                                          )
                                        ],
                                      );
                                    });
                                  } else {
                                    bool success = await uploadImage();
                                    if (success) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("Berhasil kirim bukti pembayaran")),
                                      );
                                      Navigator.pop(context, true);
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: thiscolor.AppColor.ijoButton,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: Text(
                                    "Upload bukti transfer",
                                    style: GoogleFonts.poppins(
                                      color: thiscolor.AppColor.background,
                                      fontSize: 13,
                                      fontWeight: FontWeight.normal,
                                    )),
                              ),

                            // Button untuk mengkonfirmasi pembayaran jika sudah lunas
                            if (!isConfirmed && isLunas)
                              SizedBox(width: 10),
                            if (!isConfirmed && isLunas)
                              ElevatedButton(
                                onPressed: () async {
                                  bool success = await konfirmasiPembayaran(context, widget.transaction);
                                  if (success) {
                                    Navigator.pop(context, true);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: thiscolor.AppColor.ijoButton,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: Text(
                                    "Verifikasi Pembayaran",
                                    style: GoogleFonts.poppins(
                                      color: thiscolor.AppColor.background,
                                      fontSize: 13,
                                      fontWeight: FontWeight.normal,
                                    )),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
            ),
          );
        }
    );
  }

  Future<bool> konfirmasiPembayaran(BuildContext context, transaksi trx) async {
    try {
      final storageService = StorageService();
      final String? token = await storageService.getToken();

      if (token == null || token.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Token tidak ditemukan")),
        );
        return false;
      }

      final data = {
        'token': token,
        'id_verifikasi': trx.id_verifikasi,
        'status': 1,
      };
      final response = await transaksiServices().updateConfirmation(data);

      if (response.toString().toLowerCase() != "success") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal konfirmasi ke server")),
        );
        return false;
      }

      final updatedTrx = trx.copyWith(status_verifikasi: 1);
      await localDB().updateTransaction(updatedTrx);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Konfirmasi berhasil")),
      );
      return true;

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan saat konfirmasi")),
      );
      print("Error konfirmasi: $e");
      return false;
    }
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

  Future<bool> uploadImage() async {
    final token = await StorageService().getToken();
    if (token != null) {
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(source: ImageSource.gallery);
      if (pickedImage == null) {
        return false;
      }
      var response = await transaksiServices().uploadBuktiPembayaran(
        token: token,
        idTransaksi: widget.transaction.idTransaksi.toString(),
        buktiPembayaran: File(pickedImage.path),
      );
      if (response.toString().toLowerCase() != "success") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal upload bukti pembayaran")),
        );
      }
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Token tidak ditemukan")),
      );
      return false;
    }
    return true;
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