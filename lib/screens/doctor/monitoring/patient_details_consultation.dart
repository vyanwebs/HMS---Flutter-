import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../controllers/Doctor/patient_consultation_controllers.dart';
import '../../../models/patient_model.dart';
import '../../../utils/buttons.dart';
import '../../../utils/constants.dart';
import '../../../utils/text.dart';

class PatientDetailsConsultationPage extends StatefulWidget {
  final PatientModel patient;

  const PatientDetailsConsultationPage({
    super.key,
    required this.patient,
  });

  @override
  State<PatientDetailsConsultationPage> createState() => _PatientDetailsConsultationPageState();
}

class _PatientDetailsConsultationPageState extends State<PatientDetailsConsultationPage> {


  final controller = Get.put(PatientConsultationController());
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    controller.setPatient(widget.patient.id);
  }

  @override
  void dispose() {
    Get.delete<PatientConsultationController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String registrationDate = widget.patient.registeredAt != null
        ? DateFormat('yyyy-MM-dd').format(widget.patient.registeredAt!)
        : DateFormat('yyyy-MM-dd').format(DateTime.now());

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppText(
                  'Patient Consultation',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),

                const SizedBox(height: 16),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        /// ================= TOP BANNER =================
                        _buildBlueBanner(
                          imageName: 'consultation_icon.png',
                          title: 'Patient consultation form',
                          subtitle: 'Please fill the form',
                        ),

                        const SizedBox(height: 14),

                        /// ================= SINGLE CONTAINER (MERGED CARDS) =================
                        _buildCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// ----- Patient Info (formerly separate card) -----
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppText(
                                    widget.patient.name,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),

                                  const SizedBox(height: 4),

                                  AppText(
                                    '${widget.patient.age} Years • Male • ID: ${widget.patient.patientId}',
                                    fontSize: 12,
                                    color: AppColors.greyText,
                                  ),

                                  AppText(
                                    'Admission: ${widget.patient.currentAdmissionCode} • $registrationDate',
                                    fontSize: 12,
                                    color: AppColors.greyText,
                                  ),

                                  const SizedBox(height: 20),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildInputField(
                                          'Known allergies',
                                          controller.allergiesCtrl,
                                          'Food / Drug',
                                          removeBottomPadding: true,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: _buildInputField(
                                          'Personal habits',
                                          controller.personalHabitsCtrl,
                                          'Smoking / Alcohol',
                                          removeBottomPadding: true,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              const SizedBox(height: 14),

                              /// ----- History Banner -----
                              _buildBlueBanner(
                                imageName: 'history_icon.png',
                                title: 'Patient history',
                                subtitle: 'Create patient history',
                                isInner: true,
                              ),

                              /// ----- History Fields -----
                              _buildInputField(
                                'Chief complaints',
                                controller.chiefComplaintCtrl,
                                'Main reason for visit',
                              ),

                              _buildInputField(
                                'Describe allergies',
                                controller.describeAllergiesCtrl,
                                'Allergic reactions',
                              ),

                              _buildInputField(
                                'History of illness',
                                controller.illnessCtrl,
                                'Illness timeline',
                              ),

                              _buildInputField(
                                'Past medical history',
                                controller.pastHistoryCtrl,
                                'Previous conditions',
                              ),

                              _buildInputField(
                                'Family history',
                                controller.familyHistoryCtrl,
                                'Family medical history',
                              ),

                              _buildInputField(
                                'Previous investigations',
                                controller.investigationCtrl,
                                'Test reports',
                              ),

                              _buildInputField(
                                'Menstrual history',
                                controller.menstrualCtrl,
                                'Cycle details',
                              ),

                              _buildInputField(
                                'Visual analogue',
                                controller.visualCtrl,
                                'Pain score / scale',
                              ),

                              _buildInputField(
                                'Immunization history',
                                controller.immunizationCtrl,
                                'Vaccination details',
                              ),

                              const SizedBox(height: 14),

                              /// ----- Examination Banner -----
                              _buildBlueBanner(
                                imageName: 'exam_icon.png',
                                title: 'General examination',
                                subtitle: 'Vital information',
                                isInner: true,
                              ),

                              /// ----- Examination Fields -----
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  final width = (constraints.maxWidth / 2) - 8;

                                  return Wrap(
                                    spacing: 12,
                                    runSpacing: 12,
                                    children: [
                                      SizedBox(
                                        width: width,
                                        child: _buildVitalField(
                                          'Pulse',
                                          controller.pulseCtrl,
                                          '75 bpm',
                                        ),
                                      ),
                                      SizedBox(
                                        width: width,
                                        child: _buildVitalField(
                                          'Blood Pressure',
                                          controller.bpCtrl,
                                          '120/80',
                                        ),
                                      ),
                                      SizedBox(
                                        width: width,
                                        child: _buildVitalField(
                                          'Temperature',
                                          controller.tempCtrl,
                                          '98.6°F',
                                        ),
                                      ),
                                      SizedBox(
                                        width: width,
                                        child: _buildVitalField(
                                          'Oxygen',
                                          controller.oxygenCtrl,
                                          '98%',
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        /// ================= SAVE BUTTON =================
                        Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            width: 180,
                            height: 44,
                            child: AppButton(
                              text: 'Save Consultation',
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  controller.submitConsultation();
                                }
                              },
                              backgroundColor:
                                  AppColors.success ?? Colors.green,
                              textColor: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),
                      ],
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

  /// ================= CARD =================
  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }

  /// ================= BANNER =================
  Widget _buildBlueBanner({
    required String imageName,
    required String title,
    required String subtitle,
    bool isInner = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F7FF),
        borderRadius: isInner ? BorderRadius.zero : BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.info,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Image.asset(
              'assets/images/$imageName',
              height: 22,
              width: 22,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                title,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              AppText(
                subtitle,
                fontSize: 12,
                color: AppColors.greyText,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ================= INPUT =================
  Widget _buildInputField(
    String label,
    TextEditingController? ctr,
    String hint, {
    bool removeBottomPadding = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: removeBottomPadding ? 0 : 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            label,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.greyText,
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: ctr,
            style: const TextStyle(fontSize: 14),
            decoration: _inputDecoration(hint),
          ),
        ],
      ),
    );
  }

  /// ================= VITAL =================
  Widget _buildVitalField(
    String label,
    TextEditingController ctr,
    String hint,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          label,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.greyText,
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: ctr,
          style: const TextStyle(fontSize: 14),
          decoration: _inputDecoration(hint),
        ),
      ],
    );
  }

  /// ================= DECORATION =================
  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        fontSize: 12,
        color: Colors.grey[400],
      ),
      filled: true,
      fillColor: AppColors.cardBackground,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.border),
      ),
    );
  }
}