import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:file_saver/file_saver.dart';
import 'package:url_launcher/url_launcher.dart';

class PdfDownloader {
  static Future<bool> download({
    required String url,
    required String fileName,
  }) async {
    try {
      // 🌐 WEB → let browser handle it
      if (kIsWeb) {
        final uri = Uri.parse(url);
        if (!await launchUrl(uri, webOnlyWindowName: '_blank')) {
          return false;
        }
        return true;
      }

      // 📱 Desktop & Mobile → download bytes
      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        return false;
      }

      final Uint8List bytes = response.bodyBytes;

      await FileSaver.instance.saveFile(
        name: fileName.replaceAll('.pdf', ''),
        bytes: bytes,
        fileExtension: 'pdf',
        mimeType: MimeType.pdf,
      );

      return true; // ✅ success
    } catch (e) {
      if (kDebugMode) {
        print("❌ PDF download failed");
        print(e);
      }
      return false; // ❌ failure
    }
  }
}