import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aplikasikkp/Utils/ColorNest.dart' as thiscolor;

class futuremoney extends StatelessWidget {
  const futuremoney({
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
                fontSize: 18,
                fontWeight: FontWeight.bold
            )
        )
    );
  }
}