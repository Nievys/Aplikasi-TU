import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aplikasikkp/Utils/ColorNest.dart' as thiscolor;

class futuremoneykecil extends StatelessWidget {
  const futuremoneykecil({
    super.key,
    required this.amount,
  });

  final String amount;

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.centerLeft,
        child:
        Text(
            amount,
            style: GoogleFonts.poppins(
                color: thiscolor.AppColor.backgroundcolor,
                fontSize: MediaQuery.of(context).size.width * 0.0335,
                fontWeight: FontWeight.bold
            )
        )
    );
  }
}