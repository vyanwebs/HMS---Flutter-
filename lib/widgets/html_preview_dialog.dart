import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Windows
import 'package:webview_windows/webview_windows.dart';

// Mobile / macOS
import 'package:webview_flutter/webview_flutter.dart';

import '../utils/text.dart';

class HtmlPreviewDialog extends StatefulWidget {
  final String htmlContent;

  const HtmlPreviewDialog({
    super.key,
    required this.htmlContent,
  });

  @override
  State<HtmlPreviewDialog> createState() => _HtmlPreviewDialogState();
}

class _HtmlPreviewDialogState extends State<HtmlPreviewDialog> {

  WebviewController? _windowsController;
  late final WebViewController _mobileController;

  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {

    if (!kIsWeb && Platform.isWindows) {
      _windowsController = WebviewController();
      await _windowsController!.initialize();
      await _windowsController!.loadStringContent(widget.htmlContent);
    }

    else if (!kIsWeb) {
      _mobileController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadHtmlString(widget.htmlContent);
    }

    if (mounted) {
      setState(() {
        _isReady = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SizedBox(
        width: 1100,
        height: 750,
        child: Column(
          children: [

            /// ===== HEADER WITH CLOSE BUTTON =====
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 50,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xFFE2E8F0)),
                ),
              ),
              child: Row(
                children: [

                  const AppText(
                    "Discharge Preview",
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),

                  const Spacer(),

                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
            ),

            /// ===== CONTENT =====
            Expanded(
              child: !_isReady
                  ? const Center(child: CircularProgressIndicator())
                  : _buildPlatformView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlatformView() {

    if (kIsWeb) {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SelectableText(widget.htmlContent),
        ),
      );
    }

    if (Platform.isWindows) {
      return Webview(_windowsController!);
    }

    return WebViewWidget(controller: _mobileController);
  }
}
