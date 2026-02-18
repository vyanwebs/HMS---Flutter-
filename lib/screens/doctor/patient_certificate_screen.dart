import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:get/get.dart';

import '../../controllers/Doctor/certificate_controllers.dart';
import '../../models/patient_model.dart';
import '../../utils/buttons.dart';
import '../../utils/constants.dart';
import '../../utils/pdf_download.dart';
import '../../utils/snackbar.dart';
import '../../utils/text.dart';

class CertificateScreen extends StatelessWidget {
  final PatientModel patient;

  CertificateScreen({super.key, required this.patient});

  final certCtrl = Get.put(CertificateControllers());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          children: [
            const SizedBox(height: 20),

            /// Patient Header
            _patientHeader(),

            const SizedBox(height: 24),

            /// MAIN CONTENT (NO Expanded)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// LEFT FORM
                Expanded(flex: 1, child: _leftForm(context)),

                const SizedBox(width: 24),

                /// RIGHT SUMMARY
                Expanded(
                  flex: 1,
                  child: Obx(() {
                    if (certCtrl.certificateResponse.value == null) {
                      return const AppText(
                        "No Certificate Generated",
                        textAlign: TextAlign.center,
                        fontSize: 24,
                        color: Colors.black,
                      );
                    }
                    return _rightSummary(context);
                  }),
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
      // floatingActionButton: SpeedDial(
      //   icon: Icons.menu,
      //   activeIcon: Icons.close,
      //   backgroundColor: AppColors.info,
      //   foregroundColor: Colors.white,
      //   overlayColor: Colors.black,
      //   overlayOpacity: 0.3,
      //   spacing: 10,
      //   closeManually: false,
      //   spaceBetweenChildren: 10,
      //   direction: SpeedDialDirection.up,
      //   childrenButtonSize: const Size(56, 56),
      //   childPadding: const EdgeInsets.all(4),
      //   shape: const CircleBorder(),
      //   children: [
      //     _speedItem(
      //       icon: Icons.chat,
      //       label: "Chats",
      //       color: Colors.green,
      //       onTap: () {

      //       },
      //     ),
      //     _speedItem(
      //       icon: Icons.local_hospital,
      //       label: "Emergency medicine",
      //       color: Colors.red,
      //       onTap: () {
              
      //       },
      //     ),
      //     _speedItem(
      //       icon: Icons.description,
      //       label: "Discharge summary",
      //       color: Colors.purple,
      //       onTap: () {},
      //     ),
      //     _speedItem(
      //       icon: Icons.science,
      //       label: "Lab test request",
      //       color: Colors.orange,
      //       onTap: () {},
      //     ),
      //     _speedItem(
      //       icon: Icons.person_add,
      //       label: "Add Doctor consulting",
      //       color: Colors.green,
      //       onTap: () {},
      //     ),
      //     _speedItem(
      //       icon: Icons.add_circle,
      //       label: "Add Diagnosis",
      //       color: Colors.blue,
      //       onTap: () {},
      //     ),
      //   ],
      // ),
    );
  }

  // ================= PATIENT HEADER =================
  Widget _patientHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: AppColors.info.withValues(alpha: 0.3),
            child: AppText(patient.initials),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                patient.name,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              AppText(
                "ID:${patient.patientId} · Age:${patient.age} · ${patient.gender}",
                fontSize: 12,
                color: AppColors.greyText,
              ),
            ],
          )
        ],
      ),
    );
  }
  
  // ================= LEFT FORM =================
  final _certificateTypeFormKey = GlobalKey<FormState>();

  Widget _leftForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Certificate Type
        SectionCard(
          title: "Certificate type",

          /// WRAP LIST
          listChild: Obx(() {
            final fixed = certCtrl.certificates.where((e) => e.isFixed).toList();
            final custom = certCtrl.certificates.where((e) => !e.isFixed).toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// FIXED TYPES
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: fixed.map((cert) {
                    return InkWell(
                      onTap: () => certCtrl.selectCertificate(cert.certificateName),
                      child: _CertTypeChip(
                        label: cert.certificateName,
                        icon: cert.icon,
                        selected:
                            certCtrl.selectedCertificate.value == cert.certificateName,
                      ),
                    );
                  }).toList(),
                ),

                /// CUSTOM TYPES
                if (custom.isNotEmpty) ...[
                  const SizedBox(height: 16),

                  const AppText(
                    "Custom certificate types",
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.greyText,
                  ),

                  const SizedBox(height: 10),

                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: custom.map((cert) {
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          InkWell(
                            onTap: () =>
                                certCtrl.selectCertificate(cert.certificateName),
                            child: _CertTypeChip(
                              label: cert.certificateName,
                              icon: cert.icon,
                              selected: certCtrl.selectedCertificate.value ==
                                  cert.certificateName,
                            ),
                          ),

                          /// ❌ DELETE ICON (CUSTOM ONLY)
                          Positioned(
                            top: -6,
                            right: -6,
                            child: InkWell(
                              onTap: () {
                                certCtrl.deleteCertificateType(cert.id);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ],
            );
          }),

          /// ADD CUSTOM FORM (UNCHANGED)
          formChild: Form(
            key: _certificateTypeFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: certCtrl.certificateNameCtrl,
                  decoration: InputDecoration(
                    labelText: "Certificate name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Certificate name is required";
                    }
                    if (value.trim().length < 3) {
                      return "Minimum 3 characters required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  maxLines: 3,
                  controller: certCtrl.certificateDescriptionCtrl,
                  decoration: InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Description is required";
                    } else if (value.trim().length > 200) {
                      return "Description cannot exceed 200 characters";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      isLoading: certCtrl.isAddingType.value,
                      text: "Add custom type",
                      onPressed: () {
                        if (_certificateTypeFormKey.currentState!.validate()) {
                          certCtrl.addCustomCertificateType();
                        }
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
    
        const SizedBox(height: 20),
    
        /// Medical Details
        _sectionCard(
          title: "Medical details",
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: _input("Diagnosis", certCtrl.diagnosisCtrl)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _dateInput(
                      context: context,
                      hint: "Medical leave start date",
                      controller: certCtrl.medicalLeaveStartDateCtrl,
                      onTap: () => certCtrl.pickDate(
                        context: context,
                        isStartDate: true,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _input("Expected rest duration", certCtrl.expecteRestDurationCtrl)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _dateInput(
                      context: context,
                      hint: "Expected return date",
                      controller: certCtrl.expectedReturnDateCtrl,
                      onTap: () => certCtrl.pickDate(
                        context: context,
                        isStartDate: false,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
    
        const SizedBox(height: 20),
    
        /// Additional Notes
        _sectionCard(
          title: "Additional notes",
          child: Column(
            children: [
              TextFormField(
                maxLines: 3,
                controller: certCtrl.additionalNotesCtrl,
                decoration: InputDecoration(
                  hintText: "Enter additional notes",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Align(
                alignment: Alignment.centerRight,
                child: AppButton(
                  text: "Add",
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
                  onPressed: () {
                    certCtrl.generateCertificate(
                      patientMongoId: patient.id,
                      diagnosis: certCtrl.diagnosisCtrl.text,
                      medicalLeaveStartDate: certCtrl.medicalLeaveStartDateCtrl.text,
                      expectedRestDuration: certCtrl.expecteRestDurationCtrl.text,
                      expectedReturnDate: certCtrl.expectedReturnDateCtrl.text,
                      additionalNotes: certCtrl.additionalNotesCtrl.text
                    );
                  }
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ================= RIGHT SUMMARY =================
  Widget _rightSummary(BuildContext context) {
    final response = certCtrl.certificateResponse.value!;
    final cert = response.certificateDetails;
    final admissionInfo = response.admissionInfo;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        /// ✅ SUCCESS CARD
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 36),
              const SizedBox(height: 8),
              const AppText(
                "Certificate generated successfully",
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: "View",
                      onPressed: () {
                        Get.to(() => Scaffold(
                          appBar: AppBar(
                            title: const Text("Certificate"),
                          ),
                          body: Center(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width*0.6,
                              child: SfPdfViewer.network(
                                cert.localDriveUrl,
                                controller: certCtrl.pdfViewerController,
                                canShowScrollHead: true,
                                canShowScrollStatus: true,
                                enableDoubleTapZooming: true,
                              ),
                            ),
                          ),
                        ));
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: AppButton(
                      text: "Download",
                      backgroundColor: Colors.grey.shade600,
                      onPressed: () async {
                        final success = await PdfDownloader.download(
                          url: cert.localDriveUrl.isNotEmpty
                            ? cert.localDriveUrl
                            : cert.googleDriveUrl,
                          fileName: cert.certificateName,
                        );
                        if (success) {
                          AppSnackbar.show(
                            title: "Downloaded",
                            message: "PDF downloaded successfully",
                            type: AppSnackType.success,
                          );
                        } else {
                          AppSnackbar.show(
                            title: "Failed",
                            message: "Unable to download PDF",
                            type: AppSnackType.error,
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        /// 👤 PATIENT DETAILS
        _infoCard(
          title: "Patient details",
          items: {
            "Patient name": patient.name,
            "Patient ID": patient.patientId,
            "Patient age": "${patient.age} years",
            "Gender": patient.gender,
          },
        ),

        const SizedBox(height: 20),

        /// 📄 CERTIFICATE DETAILS
        _infoCard(
        title: "Certificate details",
        items: {
          "Diagnosis": cert.diagnosis,
          "Leave start date": cert.medicalLeaveStartDate,
          "Rest duration": cert.expectedRestDuration,
          "Expected return": cert.expectedReturnDate,
          "Issue date": cert.issueDate,
          "Doctor": cert.doctorName,
          "Speciality": cert.doctorDepartment,
          "Type": cert.certificateType,
        },
      ),

        const SizedBox(height: 20),

        /// ➕ ADDITIONAL DETAILS
        _infoCard(
          title: "Additional details",
          items: {
            "OPD number": admissionInfo.admissionCode,
            "Admission date": admissionInfo.admissionDate,
          },
        ),
      ],
    );
  }

  // ================= REUSABLES =================
  Widget _sectionCard({
    required String title,
    required Widget child,
    VoidCallback? onAddCustom,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                title,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),

              if (onAddCustom != null)
                TextButton.icon(
                  onPressed: onAddCustom,
                  icon: const Icon(
                    Icons.add,
                    size: 18,
                    color: AppColors.info,
                  ),
                  label: const AppText(
                    "Add custom",
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.info,
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    foregroundColor: AppColors.info,
                  ),
                ),
            ],
          ),

          const SizedBox(height: 14),

          /// BODY
          child,
        ],
      ),
    );
  }

  Widget _input(String hint, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _dateInput({
    required BuildContext context,
    required String hint,
    required TextEditingController controller,
    required VoidCallback onTap,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: hint,
        suffixIcon: const Icon(Icons.calendar_today),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _infoCard({
    required String title,
    required Map<String, String> items,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(title, fontSize: 15, fontWeight: FontWeight.w600),
          const SizedBox(height: 12),
          ...items.entries.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  const Icon(Icons.circle, size: 8, color: Colors.green),
                  const SizedBox(width: 8),
                  AppText("${e.key}: ${e.value}", fontSize: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // SpeedDialChild _speedItem({
  //   required IconData icon,
  //   required String label,
  //   required Color color,
  //   required VoidCallback onTap,
  // }) {
  //   return SpeedDialChild(
  //     elevation: 4,
  //     labelWidget: Material(
  //       color: color,
  //       borderRadius: BorderRadius.circular(10),
  //       child: Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  //         child: Row(
  //           children: [
  //             Icon(icon, color: Colors.white, size: 20),
  //             const SizedBox(width: 8),
  //             AppText(
  //               label,
  //               fontSize: 13,
  //               fontWeight: FontWeight.w500,
  //               color: Colors.white,
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //     onTap: onTap,
  //   );
  // }

}

/// ================= CERT TYPE CHIP =================
class _CertTypeChip extends StatelessWidget {
  final String label;
  final Widget icon;
  final bool selected;

  const _CertTypeChip({
    required this.label,
    required this.icon,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: selected
          ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.12)
          : Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: selected
            ? Theme.of(context).colorScheme.primary
            : Colors.grey.shade400,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconTheme(
            data: IconThemeData(
              color: selected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
            ),
            child: icon,
          ),
          const SizedBox(width: 8),
          AppText(
            label,
            fontWeight: FontWeight.w500,
            color: selected
              ? Theme.of(context).colorScheme.primary
              : Colors.black87,
          ),
        ],
      ),
    );
  }
}

class SectionCard extends StatefulWidget {
  final String title;
  final Widget listChild;   // wrap list
  final Widget formChild;   // add custom form

  const SectionCard({
    super.key,
    required this.title,
    required this.listChild,
    required this.formChild,
  });

  @override
  State<SectionCard> createState() => _SectionCardState();
}

class _SectionCardState extends State<SectionCard> {
  bool showForm = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                widget.title,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),

              TextButton.icon(
                onPressed: () {
                  setState(() => showForm = !showForm);
                },
                icon: Icon(
                  showForm ? Icons.list : Icons.add,
                  size: 18,
                  color: AppColors.info,
                ),
                label: AppText(
                  showForm ? "Show list" : "Add custom",
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.info,
                ),
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  foregroundColor: AppColors.info,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          /// BODY
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: showForm
                ? widget.formChild
                : widget.listChild,
          ),
        ],
      ),
    );
  }
}
