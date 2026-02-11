import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/teleconsultation_controllers.dart';
import '../../models/teleconsultation_model.dart';
import '../../utils/buttons.dart';
import '../../utils/text.dart';
import '../../widgets/doctor_panel/stat_card_widget.dart';

class Telecommunication extends StatelessWidget {
  Telecommunication({super.key});

  final teleController = Get.put(TeleconsultationControllers());

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
        // Header with breadcrumb
        if (!isMobile)
          const AppText(
            'DOCTOR PANEL >> Teleconsultation',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF718096),
          ),

        if (isMobile)
          const AppText(
            'Teleconsultation',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF718096),
          ),

        const SizedBox(height: 20),
        // Stats Cards
        Obx(() => teleconsultationStatCard(isMobile: isMobile)),
        const SizedBox(height: 20),

        // Title Section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  'Teleconsultation',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
                SizedBox(height: 4),
                AppText(
                  'Video and audio consultations with patients',
                  fontSize: 14,
                  color: Color(0xFF718096),
                ),
              ],
            ),
            Row(
              children: [
                outlinedButton(
                  text: "Add consult",
                  icon: Icons.add,
                  onPressed: () {},
                ),
                const SizedBox(width: 12),
                AppButton(
                  text: "Schedule new",
                  backgroundColor: const Color(0xFF2383E2),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Main Content
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: isMobile ? 1 : 4,
              child: Container(
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
                    const AppText(
                      "Today's Consultation",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3748),
                    ),
                    const SizedBox(height: 16),
                    Obx(() {
                      if (teleController.isLoading.value) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      if (teleController.todaysTeleconsultations.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: AppText(
                            'No consultations today',
                            color: Color(0xFF718096),
                          ),
                        );
                      }

                      return Column(
                        children: teleController.todaysTeleconsultations.map(
                          (consultation) =>_consultTile(model: consultation)
                        ).toList(),
                      );
                    }),
                  ],
                ),
              ),
            ),

            if (!isMobile) const SizedBox(width: 20),

            // Right Column - Active Consultation & Chat
            if (!isMobile)
              Expanded(
                flex: 6,
                child: Column(
                  children: [
                    // No Active Consultation Card
                    Container(
                      padding: const EdgeInsets.all(20),
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
                      alignment: Alignment.center,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.videocam_off,
                            size: 60,
                            color: Color(0xFFCBD5E0),
                          ),
                          SizedBox(height: 12),
                          AppText(
                            'No active consultation',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xFF2D3748),
                          ),
                          SizedBox(height: 8),
                          AppText(
                            'Select a patient to start consultation',
                            fontSize: 14,
                            color: Color(0xFF718096),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Chat Section
                    Container(
                      padding: const EdgeInsets.all(20),
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
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2383E2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const AppText(
                              'Chat & Notes',
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _chatBubble(
                            'Hello Doctor, I have been experiencing chest pain.',
                            false,
                          ),
                          _chatBubble(
                            'Hello, can you describe the pain? When did it start?',
                            true,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Type a message',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(color: Color(0xFF2383E2)),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2383E2),
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {},
                                icon: const Icon(Icons.send, size: 16),
                                label: const AppText(
                                  'Send',
                                  fontSize: 14,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),

        // Mobile View - Chat Section (shown below on mobile)
        if (isMobile) ...[
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
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
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2383E2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const AppText(
                    'Chat & Notes',
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
                _chatBubble(
                  'Hello Doctor, I have been experiencing chest pain.',
                  false,
                ),
                _chatBubble(
                  'Hello, can you describe the pain? When did it start?',
                  true,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Type a message',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xFF2383E2)),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2383E2),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {},
                      icon: const Icon(Icons.send, size: 16),
                      label: const AppText(
                        'Send',
                        fontSize: 14,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');

    final isAM = hour < 12;
    final formattedHour = hour == 0
        ? 12
        : hour > 12
            ? hour - 12
            : hour;

    return '$formattedHour:$minute ${isAM ? 'AM' : 'PM'}';
  }

  // ===================== TODAY CONSULTATIONS =====================

  Widget _consultTile({
    required TeleconsultationModel model,
  }) {
    final bool ongoing = model.status == 'ONGOING';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ongoing ? const Color(0xFFF0F7FF) : const Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ================= HEADER =================
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF2383E2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppText(
                  model.patientName,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2D3748),
                ),
              ),

              // STATUS
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: ongoing
                      ? const Color(0xFFDCFCE7)
                      : const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: AppText(
                  ongoing ? 'Ongoing' : 'Scheduled',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: ongoing
                      ? const Color(0xFF16A34A)
                      : const Color(0xFF2563EB),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // ================= META =================
          AppText(
            'Age : ${model.patientAge}',
            fontSize: 14,
            color: const Color(0xFF718096),
          ),
          AppText(
            'Time : ${_formatTime(model.startTime)}',
            fontSize: 14,
            color: const Color(0xFF718096),
          ),

          const SizedBox(height: 12),

          // ================= ACTIONS =================
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (!ongoing)
                outlinedButton(
                  text: "Reschedule",
                  icon: Icons.schedule,
                  fontSize: 11,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  onPressed: () {},
                ),

              // ❌ CANCEL REMOVED FOR ONGOING
              if (!ongoing) const SizedBox(width: 10),
              if (!ongoing)
                AppButton(
                  text: "Cancel",
                  icon: Icons.close,
                  fontSize: 11,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  backgroundColor: const Color(0xFFEF4444),
                  onPressed: () {},
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ===================== CHAT BUBBLE =====================

  Widget _chatBubble(String text, bool isDoctor) {
    return Align(
      alignment: isDoctor ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDoctor ? const Color(0xFF2383E2) : const Color(0xFFF7FAFC),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDoctor ? Colors.transparent : const Color(0xFFE2E8F0),
          ),
        ),
        child: AppText(
          text,
          color: isDoctor ? Colors.white : const Color(0xFF2D3748),
          fontSize: 14,
        ),
      ),
    );
  }

  Widget outlinedButton({
    required String text,
    IconData? icon,
    required VoidCallback onPressed,
    Color color = const Color(0xFF2383E2),
    double fontSize = 12,
    EdgeInsets padding =
        const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
    double borderRadius = 12,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        onTap: onPressed,
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: color, width: 1.4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: color),
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: GoogleFonts.poppins(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _teleconsultationCards() {
    return [
      StatCardWidget(
        title: 'Total Schedule',
        value: teleController.totalSchedule.value.toString(),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2C7EDB), Color(0xFFE1F0FF)],
        ),
        imagePath: 'assets/images/box1.png',
      ),
      StatCardWidget(
        title: 'Today Schedule',
        value: teleController.todaySchedule.value.toString(),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF00B894), Color(0xFFE3FCFA)],
        ),
        imagePath: 'assets/images/box2.png',
      ),
      StatCardWidget(
        title: 'Completed',
        value: teleController.completed.value.toString(),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF00C9C9), Color(0xFFDFFFFF)],
        ),
        imagePath: 'assets/images/box3.png',
      ),
      StatCardWidget(
        title: 'Cancelled',
        value: teleController.cancelled.value.toString(),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF00B83B), Color(0xFFECFEEE)],
        ),
        imagePath: 'assets/images/box4.png',
      ),
    ];
  }

  Widget teleconsultationStatCard({required bool isMobile}) {
    if (isMobile) {
      return Column(
        children: _teleconsultationCards()
            .map(
              (card) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: card,
              ),
            )
            .toList(),
      );
    }

    return Row(
      children: _teleconsultationCards()
          .map(
            (card) => Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: card,
              ),
            ),
          )
          .toList(),
    );
  }
}
