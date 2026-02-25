import 'package:flutter/material.dart';
import 'package:flutter_mdi_icons/flutter_mdi_icons.dart';
import 'package:get/get.dart';

import '../../controllers/Doctor/patient_history_controllers.dart';
import '../../controllers/Doctor/patient_search_controllers.dart';
import '../../utils/text.dart';
import '../../widgets/patient_selector_widget.dart';

class PatientHistory extends StatefulWidget {
  const PatientHistory({super.key});

  @override
  State<PatientHistory> createState() => _PatientHistoryState();
}

class _PatientHistoryState extends State<PatientHistory> {

  final searchController = Get.find<PatientSearchController>();
  final historyController = Get.put(PatientHistoryControllers());

  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    searchController.clearSearch();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Column(
          children: [
            // Main Content Area
            Expanded(
              child: Container(
                color: const Color(0xFFF7F8FA),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      // Main Content
                      Container(
                        padding: EdgeInsets.all(
                          isMobile
                              ? 16
                              : isTablet
                                  ? 20
                                  : 24,
                        ),
                        child: _buildContent(isMobile, isTablet),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(bool isMobile, bool isTablet) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Breadcrumb
        const AppText(
          'DOCTOR PANEL >> Patient History',
          fontSize: 14,
          color: Color(0xFF94A3B8),
        ),

        const SizedBox(height: 12),

        // Page Title
        const AppText(
          'Patient history timeline',
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: Color(0xFF0F172A),
        ),

        const SizedBox(height: 4),

        const AppText(
          'Chronological view of patient medical records',
          fontSize: 14,
          color: Color(0xFF64748B),
        ),
        const SizedBox(height: 16),

        _patientInfoCard(isMobile, isTablet),
        const SizedBox(height: 24),

        Obx(() {
          final patient = searchController.selectedPatient.value;
          return AppText(
            'Medical history - ${patient?.name ?? ''}',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF0F172A),
          );
        }),
        const SizedBox(height: 16),

        Obx(() {
          if (searchController.selectedPatient.value == null) {
            return const Center(
              child: AppText("Please select a patient"),
            );
          }

          if (historyController.isHistoryLoading.value) {
            return const Padding(
              padding: EdgeInsets.all(40),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (historyController.historyList.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(40),
              child: Center(child: AppText("No history found")),
            );
          }

          return Column(
            children: historyController.historyList.map((item) {
              final style = _getEventStyle(item.eventType);

              return _timelineItem(
                color: style['color'],
                iconColor: style['iconColor'],
                title: item.title,
                subtitle: item.eventType.replaceAll('_', ' '),
                doctor: item.admissionType ?? '',
                details: item.note,
                date: formatDate(item.createdAt),
                time: formatTime(item.createdAt),
              );
            }).toList(),
          );
        }),

        // Add some bottom padding for better scrolling
        const SizedBox(height: 40),
      ],
    );
  }

  Map<String, dynamic> _getEventStyle(String type) {
    switch (type) {
      case "OPD_VISIT":
        return {
          "color": const Color(0xFFE8F1FF),
          "iconColor": const Color(0xFF3B82F6),
        };

      case "ADMISSION_WARD_ASSIGNMENT":
        return {
          "color": const Color(0xFFEAF7EF),
          "iconColor": const Color(0xFF22C55E),
        };

      case "IPD_BILL":
        return {
          "color": const Color(0xFFFFF1E8),
          "iconColor": const Color(0xFFF97316),
        };

      default:
        return {
          "color": const Color(0xFFF1EDFF),
          "iconColor": const Color(0xFF8B5CF6),
        };
    }
  }

  String formatDate(DateTime date) {
    return "${date.day}-${date.month}-${date.year}";
  }

  String formatTime(DateTime date) {
    return "${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }

  Widget _patientInfoCard(bool isMobile, bool isTablet) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppText(
            'Patient information',
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomPatientSearchField(
                      label: "Select patient",
                      onChanged: (patient) {
                        if (patient != null) {
                          historyController.fetchPatientHistory(patient.patientId);
                        }
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(width: isMobile ? 8 : 16),
              Expanded(
                child: _searchBox(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _searchBox() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText('Search history', fontSize: 12),
        const SizedBox(height: 6),
        TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search by diagnosis, medication',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.black54),
            suffixIcon: Icon(Icons.search, size: 18, color: Colors.black45),
          ),
          style: const TextStyle(color: Colors.black54),
          onChanged: (value) {
            setState(() {});
          },
        ),
      ],
    );
  }

  Widget _timelineItem({
    required Color color,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String doctor,
    required String details,
    required String date,
    required String time,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            height: 90,
            width: 90,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(Mdi.stethoscope, color: iconColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFBFDFF),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(title, fontWeight: FontWeight.w600),
                  const SizedBox(height: 4),
                  AppText(subtitle, color: Colors.black54),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.person_outline,
                        size: 14,
                        color: Colors.black45
                      ),
                      const SizedBox(width: 4),
                      AppText(
                        doctor,
                        fontSize: 12,
                        color: Colors.black54
                      ),
                      const Spacer(),
                      AppText(
                        '$date • $time',
                        fontSize: 12,
                        color: Colors.black45
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          _showDetailsDialog(title, details, doctor, date, time);
                        },
                        child: const AppText(
                          'View Details',
                          color: Color(0xFF2563EB),
                          fontWeight: FontWeight.w500
                        ),
                      ),
                      const SizedBox(width: 24),
                      TextButton(
                        onPressed: () {
                          _downloadReport(title, "");
                        },
                        child: const AppText(
                          'Download',
                          color: Color(0xFF16A34A),
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _showDetailsDialog(String title, String details, String doctor, String date, String time) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(
                      title,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2D3748),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F8FA),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.person_outline, size: 16, color: Colors.black45),
                          const SizedBox(width: 8),
                          AppText(
                            'Doctor: $doctor',
                            color: Colors.black87
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 16, color: Colors.black45),
                          const SizedBox(width: 8),
                          AppText(
                            'Date: $date',
                            color: Colors.black87
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 16, color: Colors.black45),
                          const SizedBox(width: 8),
                          AppText(
                            'Time: $time',
                            color: Colors.black87
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const AppText(
                  'Details',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3748),
                ),
                const SizedBox(height: 8),
                AppText(
                  details,
                  fontSize: 14,
                  color: Colors.black87,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const AppText(
                      'Close',
                      color: Colors.white
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _downloadReport(String title, String url) {
    // Show downloading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFF16A34A).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.download,
                    color: Color(0xFF16A34A),
                    size: 28,
                  ),
                ),
                const SizedBox(height: 16),
                const AppText(
                  'Downloading Report',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
                const SizedBox(height: 8),
                AppText(
                  title,
                  fontSize: 14,
                  color: const Color(0xFF4A5568),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF16A34A)),
                ),
                const SizedBox(height: 20),
                const AppText(
                  'Preparing file for download...',
                  fontSize: 12,
                  color: Colors.grey,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Show success message
                      _showDownloadSuccess(title);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF16A34A),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const AppText(
                      'Complete Download',
                      color: Colors.white
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // Simulate download process
    Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) {
        Navigator.pop(context);
        _showDownloadSuccess(title);
      }
    });
  }

  void _showDownloadSuccess(String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: AppText('Successfully downloaded: $title'),
        backgroundColor: const Color(0xFF16A34A),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}