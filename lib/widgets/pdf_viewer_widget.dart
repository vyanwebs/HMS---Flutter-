import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerScreen extends StatelessWidget {
  final String url;

  const PdfViewerScreen({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("View PDF")),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width*0.6,
          child: SfPdfViewer.network(url)
        ),
      ),
    );
  }
}
