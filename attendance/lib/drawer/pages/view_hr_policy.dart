import 'dart:io';
import 'package:faecauth/extension/appbar_ext.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

class ViewPdfPage extends StatefulWidget {
  @override
  _ViewPdfPageState createState() => _ViewPdfPageState();
}

class _ViewPdfPageState extends State<ViewPdfPage> {
  late Future<File> pdfFile;

  Future<File> generatePdf() async {
    final pdf = pw.Document();
    for (int i = 1; i <= 4; i++) {
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) => pw.Stack(
            children: [
              pw.Positioned.fill(
                child: pw.Center(
                  child: pw.Transform.rotate(
                    angle: -0.5,
                    child: pw.Opacity(
                      opacity: 0.1,
                      child: pw.Text(
                        'WATERMARK',
                        style: pw.TextStyle(
                          fontSize: 100,
                          color: PdfColors.grey,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Content of the page (with border)
              pw.Container(
                width: PdfPageFormat.a3.width,
                height: PdfPageFormat.a3.height,
                padding: pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(
                    color: PdfColors.black,
                    width: 2.0,
                  ),
                ),
                child: pw.Text(
                  'PDFs may not be the most simple format to add to, but creativity will strike when you least expect it. Occasionally, this will happen after your easily editable document has been saved as a PDF. Maybe you came up with an even better closing line for your latest eBook. You can easily end your book on the best note using the Adobe Acrobat PDF editor to include the additional text you need. Sometimes, it takes more than a few edits to get your PDF exactly right. Even if your document is not in an easily editable format, Acrobat can help transform your PDF to be editable again.',
                  style: pw.TextStyle(fontSize: 17),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final outputFile = await getTemporaryDirectory();
    final file = File("${outputFile.path}/dummy_a4_with_watermark.pdf");
    await file.writeAsBytes(await pdf.save());

    return file;
  }

  @override
  void initState() {
    super.initState();
    pdfFile = generatePdf();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          'View Pdf',
          // style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ).gradientBackground(withActions: true),
      body: FutureBuilder<File>(
        future: pdfFile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return PDFView(
              filePath: snapshot.data!.path,
            );
          } else {
            return Center(child: Text('No PDF available'));
          }
        },
      ),
    );
  }
}
