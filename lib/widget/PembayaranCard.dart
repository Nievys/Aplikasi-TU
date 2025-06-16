import 'package:aplikasikkp/model/transaksi.dart';
import 'package:aplikasikkp/widget/BottomSheetPembayaran.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Utils/ColorNest.dart' as thiscolor;
import '../Utils/RpFormatter.dart';
import '../Utils/localDB.dart';

class Pembayarancard extends StatelessWidget {
  final transaksi transaction;

  const Pembayarancard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final parentContext = context;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
              context: parentContext,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => Bottomsheetpembayaran(transaction: transaction, parentContext: parentContext)
          );
          //deleteAccount(account);
          //context.read<lastAkunCubit>().selectAccount(account.account_id ?? 0);
        },
        splashColor: thiscolor.AppColor.brokenwhite.withOpacity(0.8),
        highlightColor: thiscolor.AppColor.brokenwhite.withOpacity(0.5),
        borderRadius: BorderRadius.circular(15),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.1,
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          margin: const EdgeInsets.only(bottom: 3),
          decoration: BoxDecoration(
              color: thiscolor.AppColor.brokenwhite,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: thiscolor.AppColor.brokenwhite,
                width: 1,
              )
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "SPP Bulan ke - ${transaction.bulan}",
                    style: GoogleFonts.poppins(
                      color: thiscolor.AppColor.ijoButton,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Semester ${transaction.semester}",
                    style: GoogleFonts.poppins(
                      color: thiscolor.AppColor.ijoButton,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    "Tahun Ajaran ${transaction.tahunAjaran}",
                    style: GoogleFonts.poppins(
                      color: thiscolor.AppColor.ijoButton,
                      fontSize: 12,
                    ),
                  )
                ],
              ),
              Spacer(),
              totalspp(CurrencyFormat.convertToIdr(double.parse(transaction.spp) - double.parse(transaction.potongan), 2), transaction.statusLunas),
            ],
          ),
        ),
      ),
    );
  }

  Widget totalspp(String sppril, String statusLunas) {
    final isLunas = statusLunas.split("|").isNotEmpty && statusLunas.split("|").first.trim() == "1";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          isLunas ? "Lunas" : "Belum Lunas",
          style: GoogleFonts.poppins(
            color: thiscolor.AppColor.ijoButton,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          sppril,
          style: GoogleFonts.poppins(
            color: thiscolor.AppColor.ijoButton,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
