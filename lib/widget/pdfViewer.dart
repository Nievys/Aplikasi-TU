import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdfx/pdfx.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart' as pdfcetak;

import '../Utils/ColorNest.dart' as thiscolor;

class PDFPreviewPage extends StatefulWidget {
  final String filePath;

  const PDFPreviewPage({super.key, required this.filePath});

  @override
  State<PDFPreviewPage> createState() => _PDFPreviewPageState();
}

class _PDFPreviewPageState extends State<PDFPreviewPage> {
  PdfControllerPinch? pdfController;

  @override
  void initState() {
    super.initState();
    _initPdfController();
  }

  void _initPdfController() async {
    try {
      final file = File(widget.filePath);
      final bytes = await file.readAsBytes();

      setState(() {
        pdfController = PdfControllerPinch(
          document: PdfDocument.openData(bytes),
        );
      });
    } catch (e) {
      log('Gagal membuka PDF: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal membuka file PDF')),
      );
    }
  }

  @override
  void dispose() {
    pdfController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: thiscolor.AppColor.backgroundcolor,
        ),
        title: Text("Preview Struk", style: GoogleFonts.poppins(
          color: thiscolor.AppColor.background,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: thiscolor.AppColor.ijoButton,
        actions: [
          IconButton(
            icon: Icon(Icons.print, color: thiscolor.AppColor.backgroundcolor),
            onPressed: _printPDF,
          ),
        ],
      ),
      body: pdfController == null
          ? Center(child: CircularProgressIndicator())
          : PdfViewPinch(controller: pdfController!),
      backgroundColor: thiscolor.AppColor.backgroundcolor,
    );
  }

  void _printPDF() async {
    try {
      final file = File(widget.filePath);
      final bytes = await file.readAsBytes();
      await Printing.layoutPdf(
        onLayout: (pdfcetak.PdfPageFormat format) async => bytes,
      );
    } catch (e) {
      log('Gagal mencetak PDF: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mencetak file PDF')),
      );
    }
  }
}