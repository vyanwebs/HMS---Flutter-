import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../controllers/discharge_controllers.dart';
import '../../models/patient_model.dart';
import '../../utils/buttons.dart';
import '../../utils/string_utils.dart';
import '../../utils/text.dart';
import '../../widgets/html_preview_dialog.dart';
import '../../widgets/pdf_viewer_widget.dart';

class DischargeSummary extends StatefulWidget {
  final PatientModel patient;

  const DischargeSummary({super.key, required this.patient});

  @override
  State<DischargeSummary> createState() => _DischargeSummaryState();
}

class _DischargeSummaryState extends State<DischargeSummary> {
  final dischargeController = Get.put(DischargeControllers());
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  bool _isSpeechAvailable = false;
  bool _isInitializing = true;
  String? _activeVoiceFieldLabel;

  late final Map<String, FocusNode> _focusNodes;

  // Controllers for discharge summary fields
  final Map<String, TextEditingController> _summaryControllers = {
    'Chief Complaints': TextEditingController(),
    'History of Present Illness': TextEditingController(),
    'Past Medical History': TextEditingController(),
    'Examination Findings': TextEditingController(),
    'Investigations': TextEditingController(),
    'Final Diagnosis': TextEditingController(),
    'Treatment Given': TextEditingController(),
    'Course in Hospital': TextEditingController(),
    'Condition at Discharge': TextEditingController(),
    'Medications on Discharge': TextEditingController(),
    'Follow-up Instructions': TextEditingController(),
    'Diet Advice': TextEditingController(),
    'Activity Restrictions': TextEditingController(),
  };

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _focusNodes = {
      for (var key in _summaryControllers.keys) key: FocusNode(),
    };
  }

  @override
  void dispose() {
    for (var controller in _summaryControllers.values) {
      controller.dispose();
    }

    for (var node in _focusNodes.values) {
      node.dispose();
    }

    super.dispose();
  }

  void _signAndFinalize() {
    // Digital signature logic
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const AppText('Sign and Finalize'),
        content: const AppText(
            'Are you sure you want to sign and finalize this discharge summary? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const AppText('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar('Discharge summary signed and finalized!');
            },
            child: const AppText('Confirm'),
          ),
        ],
      ),
    );
  }

  void _initSpeech() async {
    try {
      _isSpeechAvailable = await _speech.initialize(
        onStatus: (val) {
          debugPrint('Speech Status: $val');
          if (val == 'done' || val == 'notListening') {
            if (mounted) {
              setState(() {
                _isListening = false;
                _activeVoiceFieldLabel = null;
              });
            }
          }
        },
        onError: (val) {
          debugPrint('Speech Error: ${val.errorMsg}');
          _showSnackBar('Error: ${val.errorMsg}');
          if (mounted) {
            setState(() {
              _isListening = false;
              _activeVoiceFieldLabel = null;
            });
          }
        },
      );
    } catch (e) {
      debugPrint('Speech Initialization Error: $e');
      _isSpeechAvailable = false;
    } finally {
      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
      }
    }
  }

  void _listen(String label, TextEditingController controller) async {
    if (_isInitializing) {
      _showSnackBar('Initializing speech recognition...');
      return;
    }

    if (!_isSpeechAvailable) {
      _showSnackBar('Speech recognition is not available on this device');
      return;
    }

    if (_isListening && _activeVoiceFieldLabel == label) {
      _speech.stop();
      setState(() {
        _isListening = false;
        _activeVoiceFieldLabel = null;
      });
    } else {
      if (_isListening) {
        await _speech.stop();
      }
      _startListening(label, controller);
    }
  }

  void _startListening(String label, TextEditingController controller) async {
    String originalText = controller.text;
    if (originalText.isNotEmpty && !originalText.endsWith(' ')) {
      originalText += ' ';
    }

    setState(() {
      _isListening = true;
      _activeVoiceFieldLabel = label;
    });

    _speech.listen(
      onResult: (val) {
        setState(() {
          controller.text = originalText + val.recognizedWords;
          controller.selection = TextSelection.fromPosition(
              TextPosition(offset: controller.text.length));
        });
      },
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: AppText(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // Main Content Area
            Expanded(
              child: _buildMainContent(isMobile, isTablet),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(bool isMobile, bool isTablet) {
    return Container(
      color: const Color(0xFFF7FAFC),
      child: Column(
        children: [
          // Divider
          Container(height: 1, color: const Color(0xFFE2E8F0)),

          // Main Content
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(
                  isMobile
                      ? 16
                      : isTablet
                          ? 20
                          : 24,
                ),
                child: _buildContent(isMobile, isTablet),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(bool isMobile, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title Section
        const AppText(
          'Discharge Summary',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2D3748),
        ),
        const SizedBox(height: 4),
        const AppText(
          'Create and manage patient discharge summaries',
          fontSize: 14,
          color: Color(0xFF718096),
        ),
        const SizedBox(height: 20),

        // STATS CARDS SECTION - Only 2 boxes with blank space on the right
        // _buildStatsCards(isMobile, isTablet),

        const SizedBox(height: 20),

        // Main Content Area - Full screen summary form
        _summaryForm(isMobile),
      ],
    );
  }

  // List<Widget> _dischargeCards() {
  //   return [
  //     const StatCardWidget(
  //       title: "Total Patients",
  //       value: "12",
  //       gradient: LinearGradient(
  //         begin: Alignment.topCenter,
  //         end: Alignment.bottomCenter,
  //         colors: [Color(0xFF2C7EDB), Color(0xFFE1F0FF)],
  //       ),
  //       imagePath: 'assets/images/box1.png',
  //     ),
  //     const StatCardWidget(
  //       title: "Ready for Discharge",
  //       value: "8",
  //       gradient: LinearGradient(
  //         begin: Alignment.topCenter,
  //         end: Alignment.bottomCenter,
  //         colors: [Color(0xFF00B894), Color(0xFFE3FCFA)],
  //       ),
  //       imagePath: 'assets/images/box2.png',
  //     ),
  //   ];
  // }

  // Widget _buildStatsCards(bool isMobile, bool isTablet) {
  //   final cards = _dischargeCards();

  //   if (isMobile) {
  //     return Column(
  //       children: cards.map((card) {
  //         return Padding(
  //           padding: const EdgeInsets.only(bottom: 12),
  //           child: card,
  //         );
  //       }).toList(),
  //     );
  //   }

  //   return Row(
  //     children: cards.map((card) {
  //       return Expanded(
  //         child: Padding(
  //           padding: const EdgeInsets.only(right: 10),
  //           child: card,
  //         ),
  //       );
  //     }).toList(),
  //   );
  // }

  Widget _summaryForm(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Patient Information Section - Now with input fields
          const AppText(
            'Patient Information',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3748),
          ),
          const SizedBox(height: 16),

          /// ================= PATIENT HEADER =================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF7FAFC),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Name
                AppText(
                  widget.patient.name,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),

                const SizedBox(height: 4),

                /// Age • Gender • Bed
                AppText(
                  "${widget.patient.age} Years • ${widget.patient.gender} • Bed ${extractBedNumber(widget.patient.currentBedAssign)}",
                  fontSize: 13,
                  color: const Color(0xFF718096),
                ),

                const SizedBox(height: 4),

                /// Ward
                AppText(
                  "Ward: ${extractWardFromBedAssign(widget.patient.currentBedAssign)}",
                  fontSize: 13,
                  color: const Color(0xFF718096),
                ),

                const SizedBox(height: 4),

                /// Admission Code
                AppText(
                  "Admission Code: ${widget.patient.currentAdmissionCode}",
                  fontSize: 13,
                  color: const Color(0xFF718096),
                ),

                const SizedBox(height: 4),

                AppText(
                  "Admitted: ${widget.patient.registeredAt.toLocal().toString().split(' ')[0]}",
                  fontSize: 13,
                  color: const Color(0xFF718096),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Discharge Summary Form Fields
          const AppText(
            'Discharge Summary Details',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3748),
          ),
          const SizedBox(height: 16),

          // Form Fields - Now editable
          FocusTraversalGroup(
            child: Column(
              children: _summaryControllers.entries
                  .map((entry) => _inputField(entry.key, entry.value))
                  .toList(),
            ),
          ),

          const SizedBox(height: 20),

          // Action Buttons - Now functional
          if (isMobile)
            Column(
              children: [
                _actionButton('Save', Icons.save, const Color(0xFF2383E2),
                    _saveDischargeSummary),
                const SizedBox(height: 8),
                _actionButton('Generate PDF', Icons.picture_as_pdf,
                    const Color(0xFF2563EB), _generatePDF),
                const SizedBox(height: 8),
                _actionButton('Sign and Finalize', Icons.verified,
                    const Color(0xFF16A34A), _signAndFinalize),
                const SizedBox(height: 8),
                // _actionButton('Voice Entry', Icons.mic, const Color(0xFF7C3AED), _voiceEntry),
              ],
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _actionButton('Preview', Icons.remove_red_eye, Colors.cyan,
                    _previewDischarge),
                const SizedBox(width: 8),
                _actionButton('Save', Icons.save, const Color(0xFF2383E2),
                    _saveDischargeSummary),
                const SizedBox(width: 8),
                _actionButton('Generate PDF', Icons.picture_as_pdf,
                    const Color(0xFF2563EB), _generatePDF),
                const SizedBox(width: 8),
                _actionButton('Sign and Finalize', Icons.verified,
                    const Color(0xFF16A34A), _signAndFinalize),
                const SizedBox(width: 8),
                // _actionButton('Voice Entry', Icons.mic, const Color(0xFF7C3AED), _voiceEntry),
              ],
            ),
        ],
      ),
    );
  }

  void _saveDischargeSummary() {
    final data = {
      for (var entry in _summaryControllers.entries)
        entry.key: entry.value.text,
    };

    dischargeController.createDischargeSummary(
      patientMongoId: widget.patient.id,
      formData: data,
    );
  }

  void _generatePDF() async {
    final data = {
      for (var entry in _summaryControllers.entries)
        entry.key: entry.value.text,
    };

    final pdfUrl = await dischargeController.generateDischargePdf(
      patientMongoId: widget.patient.id,
      formData: data,
    );

    if (pdfUrl != null) {
      Get.to(() => PdfViewerScreen(url: pdfUrl));
    }
  }

  void _previewDischarge() async {
    final data = {
      for (var entry in _summaryControllers.entries)
        entry.key: entry.value.text,
    };

    final html = await dischargeController.viewDischargePdf(
      patientMongoId: widget.patient.id,
      formData: data,
    );

    // ✅ SAFETY CHECK
    if (!mounted || html == null) return;

    Get.dialog(HtmlPreviewDialog(htmlContent: html));

  }

  Widget _inputField(String label, TextEditingController controller) {
    final keys = _summaryControllers.keys.toList();
    final index = keys.indexOf(label);
    final isLast = index == keys.length - 1;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            label,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF4A5568),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            focusNode: _focusNodes[label],

            /// ⭐ first field auto focus
            autofocus: index == 0,

            textInputAction: isLast ? TextInputAction.done : TextInputAction.next,

            onSubmitted: (_) {
              if (!isLast) {
                FocusScope.of(context).nextFocus();
              } else {
                FocusScope.of(context).unfocus();
              }
            },

            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Enter details here...',
              suffixIcon: IconButton(
                icon: Icon(
                  _isListening && _activeVoiceFieldLabel == label
                      ? Icons.mic
                      : Icons.mic_none,
                  color: _isListening && _activeVoiceFieldLabel == label
                      ? Colors.red
                      : const Color(0xFF718096),
                ),
                onPressed: () => _listen(label, controller),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(
    String text,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      icon: icon,
      fontSize: 12,
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      borderRadius: 8,
      iconSize: 16,
    );
  }

}
