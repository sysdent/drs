import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';

class ManualScreen extends StatelessWidget {
  String pathPDF = "";
  ManualScreen(this.pathPDF);

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
        appBar: AppBar(
          title: Text("Manual de usuario"),
        ),
        path: pathPDF);
  }
}
