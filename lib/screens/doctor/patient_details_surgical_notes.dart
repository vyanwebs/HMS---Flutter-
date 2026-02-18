import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/Doctor/surgical_notes_controllers.dart';
import '../../models/patient_model.dart';
import '../../utils/buttons.dart';
import '../../utils/constants.dart';
import '../../utils/text.dart';
import '../../widgets/patient_avatar_widget.dart';

class PatientDetailsSurgicalNotes extends StatelessWidget {
  final PatientModel patient;

  PatientDetailsSurgicalNotes({
    super.key,
    required this.patient,
  });

  final SurgicalNotesControllers controller = Get.put(SurgicalNotesControllers());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// 🔵 PATIENT HEADER (Fixed)
          _patientHeader(),

          const SizedBox(height: 25),

          /// 🔵 SURGICAL HEADER (Fixed)
          _surgicalHeader(),

          const SizedBox(height: 20),

          /// 🔥 TABLE TAKES REMAINING HEIGHT
          Expanded(
            child: _notesTable(),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // PATIENT HEADER
  // =========================================================

  Widget _patientHeader() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          PatientAvatar(patient: patient,),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                patient.name,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(height: 4),
              AppText(
                "ID: ${patient.patientId} · Age: ${patient.age} · ${patient.gender}",
                color: Colors.grey,
              ),
            ],
          )
        ],
      ),
    );
  }

  // =========================================================
  // SURGICAL HEADER
  // =========================================================

  Widget _surgicalHeader() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.info,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.note_alt_outlined,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppText(
                  "Surgical notes",
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(height: 4),
                AppText(
                  "Admission ID: ${patient.currentAdmissionCode}",
                  color: Colors.grey,
                ),
              ],
            ),
          ),
          AppButton(
            onPressed: () => _showAddSurgicalNoteDialog(),
            icon: Icons.add,
            iconIsLast: false,
            text: "Add new notes",
          )
        ],
      ),
    );
  }

  // =========================================================
  // TABLE
  // =========================================================

  Widget _notesTable() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [

          /// 🔹 TABLE HEADER (Fixed)
          _tableHeader(),

          /// 🔹 SCROLLABLE BODY
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: 2,
              itemBuilder: (context, index) {
                return _tableRow(
                  number: "${index + 1}.",
                  doctor: "Dr. Ankit Birla",
                  date: "04-01-2026",
                  time: "10:45 A.M.",
                  status: "Successful",
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _tableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(12),
        ),
      ),
      child: const Row(
        children: [
          Expanded(flex: 1, child: AppText("Number", fontWeight: FontWeight.w500,)),
          Expanded(flex: 2, child: AppText("Doctor name", fontWeight: FontWeight.w500,)),
          Expanded(flex: 2, child: AppText("Date and time", fontWeight: FontWeight.w500,)),
          Expanded(flex: 1, child: AppText("Status", fontWeight: FontWeight.w500,)),
          Expanded(flex: 1, child: AppText("Action", fontWeight: FontWeight.w500,)),
        ],
      ),
    );
  }

  Widget _tableRow({
    required String number,
    required String doctor,
    required String date,
    required String time,
    required String status,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      child: Row(
        children: [
          Expanded(flex: 1, child: AppText(number)),
          Expanded(flex: 2, child: AppText(doctor)),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(date),
                const SizedBox(height: 4),
                AppText(
                  time,
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                _statusBadge(status),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                _actionIcon(
                  icon: Icons.visibility_outlined,
                  color: Colors.blue,
                  onPressed: () => _showSurgicalNoteDialog(),
                ),
                const SizedBox(width: 4),
                _actionIcon(
                  icon: Icons.delete_outline,
                  color: Colors.red,
                  onPressed: () {}
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: AppText(
          status,
          color: Colors.green,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _actionIcon({required IconData icon, required Color color, VoidCallback? onPressed}) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, size: 20, color: color),
    );
  }

  void _showSurgicalNoteDialog() {
    Get.dialog(
      Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 80, vertical: 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: Colors.white,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 1200,
            maxHeight: 700,
          ),
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const AppText(
                      "Surgical notes",
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.close),
                    )
                  ],
                ),

                const SizedBox(height: 5),

                const AppText(
                  "(Date 17-02-2025 8:15 p.m.)",
                  color: Colors.grey,
                  fontSize: 13,
                ),

                const SizedBox(height: 25),

                /// BODY (SCROLLABLE)
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = 4;

                      if (constraints.maxWidth < 1100) {
                        crossAxisCount = 3;
                      }
                      if (constraints.maxWidth < 800) {
                        crossAxisCount = 2;
                      }
                      if (constraints.maxWidth < 500) {
                        crossAxisCount = 1;
                      }

                      return GridView(
                        padding: EdgeInsets.zero,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          childAspectRatio: 1.3,
                        ),
                        children: [

                          _infoCard("Basic information", [
                            "Surgeon name - Ankit Birla",
                            "Operating room - N/A",
                            "Surgery duration - N/A",
                            "Urgency - High",
                            "Surgical approach - Open Surgical",
                          ]),

                          _infoCard("Diagnostics and procedure", [
                            "Pre operative diagnosis - fgfghjgh",
                            "Post operative diagnosis - fgfghjgh",
                            "Indication for surgery - fgfghjgh",
                            "Planned procedure - dfghjkj",
                          ]),

                          _infoCard("Surgical details", [
                            "Inclusion type - esdfghj",
                            "Inclusion location - esdfghj",
                            "Estimated blood loss - fuhjhijh",
                            "Suture material - fghjfxg",
                            "Drains - fghjfxg",
                          ]),

                          _infoCard("Surgical findings", [
                            "DFGHjkwefghbjhn",
                          ]),

                          _infoCard("Recovery information", [
                            "Expected recovery time - fghgh",
                            "Follow up instruction - vhjbjb",
                            "Discharge planning - ghj",
                          ]),

                          _infoCard("Documentation", [
                            "Photographic documentation - no",
                            "Videography documentation - no",
                            "Pathology specimen - fgfghjgh",
                            "PDF generated - no",
                          ]),

                          _infoCard("Surgeon notes", [
                            "DFGHjkwefghbjhn",
                          ]),

                          _infoCard("Nursing notes", [
                            "DFGHjkwefghbjhn",
                          ]),

                          _infoCard("Procedure description", [
                            "DFGHjkwefghbjhn",
                          ]),

                          _infoCard("Intra operative compliance", [
                            "DFGHjkwefghbjhn",
                          ]),

                          _infoCard("Post operative instruction", [
                            "DFGHjkwefghbjhn",
                          ]),

                          _infoCard("Recovery notes", [
                            "DFGHjkwefghbjhn",
                          ]),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoCard(String title, List<String> items) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            title,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 12),
          ...items.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: AppText(
                e,
                fontSize: 13,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddSurgicalNoteDialog() {
    Get.dialog(
      Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 60, vertical: 30),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: Colors.white,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 1200,
            maxHeight: 850,
          ),
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// HEADER
                Row(
                  children: [
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: AppColors.info,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.note_alt, color: Colors.white),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const AppText(
                            "Surgical notes",
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          const SizedBox(height: 4),
                          AppText(
                            "Admission ID: ${patient.currentAdmissionCode}",
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.close),
                    )
                  ],
                ),

                const SizedBox(height: 25),

                /// BODY (SCROLLABLE)
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        _sectionTitle("Basic information"),
                        _basicInfoSection(),

                        const SizedBox(height: 25),

                        _sectionTitle("Diagnostics & Procedure"),
                        _diagnosticsSection(),

                        const SizedBox(height: 25),

                        _sectionTitle("Anesthesia"),
                        _anesthesiaSection(),

                        const SizedBox(height: 25),

                        _sectionTitle("Surgical details"),
                        _surgicalDetailsSection(),

                        const SizedBox(height: 25),

                        _sectionTitle("Findings & Description"),
                        _findingsSection(),

                        const SizedBox(height: 25),

                        _sectionTitle("Fluid balance"),
                        _fluidSection(),

                        const SizedBox(height: 25),

                        _sectionTitle("Vital signs"),
                        _vitalSection(),

                        const SizedBox(height: 25),

                        _sectionTitle("Post operative care"),
                        _postOperativeSection(),

                        const SizedBox(height: 25),

                        _documentationAndAssistantSection(),

                        const SizedBox(height: 25),

                        _sectionTitle("Additional notes"),
                        _additionalNotesSection(),

                        const SizedBox(height: 40),

                        /// FOOTER BUTTONS
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: 120,
                              child: OutlinedButton(
                                onPressed: () => Get.back(),
                                child: const AppText("Cancel"),
                              ),
                            ),
                            const SizedBox(width: 15),
                            SizedBox(
                              width: 120,
                              child: AppButton(
                                onPressed: () {},
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 22),
                                borderRadius: 50,
                                text: "Save", 
                              ),
                            ),
                          ],
                        )
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

  Widget _sectionTitle(String title) {
    return Column(
      children: [
        AppText(
          title,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        const SizedBox(height: 14,)
      ],
    );
  }

  Widget _basicInfoSection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _datePickerField(
                title: "Surgery date",
                hint: "Enter date",
                selectedDate: controller.surgeryDate,
              )
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _timePickerField(
                title: "Enter time",
                hint: "Enter time",
                selectedTime: controller.surgeryTime,
              )
            ),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: _input(
                title: "Operating room",
                hint: "Enter room"
              )
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _input(
                title: "Duration",
                hint: "Enter Duration"
              )
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Obx(() => _dropdown<String>(
                title: "Urgency",
                hint: "Select urgency",
                value: controller.urgency.value.isEmpty
                  ? null
                  : controller.urgency.value,
                items: const [
                  DropdownMenuItem(value: "Elective", child: Text("Elective")),
                  DropdownMenuItem(value: "Urgent", child: Text("Urgent")),
                  DropdownMenuItem(value: "Emergency", child: Text("Emergency")),
                ],
                onChanged: (val) {
                  controller.urgency.value = val ?? "";
                },
              )),
            ),
          ],
        ),
      ],
    );
  }

  Widget _diagnosticsSection() {
    return Column(
      children: [
        _multiLineInput(
          title: "Surgical procedure",
          hint: "Enter surgical procedure"
        ),
        const SizedBox(height: 15),
        _multiLineInput(
          title: "Pre-operative diagnosis",
          hint: "Enter pre-operative diagnosis"
        ),
        const SizedBox(height: 15),
        _multiLineInput(
          title: "Post-operative diagnosis",
          hint: "Enter post-operative diagnosis"
        ),
        const SizedBox(height: 15),
        _multiLineInput(
          title: "Indication for surgery",
          hint: "Enter indication for surgery"
        ),
        const SizedBox(height: 15),
        _multiLineInput(
          title: "Planned procedure",
          hint: "Enter planned procedure"
        ),
      ],
    );
  }

  Widget _anesthesiaSection() {
    return Row(
      children: [
        Expanded(
          child: _input(
            title: "Anesthesia type",
            hint: "Enter type"
          )
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _timePickerField(
            title: "Anesthesia start",
            hint: "Start time",
            selectedTime: controller.anesthesiaStart
          )
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _timePickerField(
            title: "Anesthesia end",
            hint: "End time",
            selectedTime: controller.anesthesiaEnd
          )
        ),
      ],
    );
  }

  Widget _surgicalDetailsSection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _input(
                title: "Surgical approach",
                hint: "Enter surgical approach",
              )
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _input(
                title: "Inclusion type",
                hint: "Enter inclusion type",
              )
            ),
          ],
        ),
        const SizedBox(height: 15),
        _multiLineInput(
          title: "Incision location",
          hint: "Enter incision location"
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: _input(
                title: "Estimated blood loss",
                hint: "Enter estimated blood loss"
              )
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _input(
                title: "Suture material",
                hint: "Enter suture material"
              )
            ),
          ],
        ),
        const SizedBox(height: 15),
        _input(
          title: "Drains",
          hint: "drains"
        ),
      ],
    );
  }

  Widget _findingsSection() {
    return Column(
      children: [
        _multiLineInput(
          title: "Surgical finding",
          hint: "Enter surgical finding"
        ),
        const SizedBox(height: 15),
        _multiLineInput(
          title: "Procedure description",
          hint: "Enter procedure description"
        ),
        const SizedBox(height: 15),
        _multiLineInput(
          title: "Intra operative compliances",
          hint: "Enter intra operative compliances"
        ),
      ],
    );
  }

  Widget _fluidSection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _input(
                title: "Input fluid",
                hint: "Enter input fluid"
              )
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _input(
                title: "Output fluid",
                hint: "Enter output fluid"
              )
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _input(
                title: "Blood transfusion",
                hint: "Enter blood transfusion"
              )
            ),
          ],
        ),
      ],
    );
  }

  Widget _vitalSection() {
    return Column(
      children: [

        /// Row 1
        Row(
          children: [
            Expanded(
              child: _input(
                title: "Blood pressure",
                hint: "Enter blood pressure"
              )
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _input(
                title: "Heart rate",
                hint: "Enter heart rate"
              )
            ),
          ],
        ),

        const SizedBox(height: 15),

        /// Row 2
        Row(
          children: [
            Expanded(
              child: _input(
                title: "Oxygen saturation",
                hint: "Enter oxygen saturation"
              )
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _input(
                title: "Temperature",
                hint: "Enter temperature"
              )
            ),
          ],
        ),
      ],
    );
  }

  Widget _postOperativeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        _multiLineInput(
          title: "Post operative instruction",
          hint: "Enter post operative instruction",
        ),

        const SizedBox(height: 15),

        _multiLineInput(
          title: "Recovery notes",
          hint: "Enter recovery notes",
        ),

        const SizedBox(height: 15),

        Row(
          children: [
            Expanded(
              child: _timePickerField(
                title: "Expected recovery time",
                hint: "Select expected recovery time",
                selectedTime: controller.expectedRecoveryTime,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Obx(() => _dropdown<String>(
                title: "Procedure outcome",
                hint: "Select outcome",
                value: controller.outcome.value.isEmpty
                  ? null
                  : controller.outcome.value,
                items: const [
                  DropdownMenuItem(value: "Successful", child: Text("Successful")),
                  DropdownMenuItem(value: "Complication", child: Text("Complication")),
                  DropdownMenuItem(value: "Failed", child: Text("Failed")),
                ],
                onChanged: (val) {
                  controller.outcome.value = val ?? "";
                },
              )),
            ),
          ],
        ),

        const SizedBox(height: 15),

        _multiLineInput(
          title: "Follow up instruction",
          hint: "Enter follow up instruction",
        ),

        const SizedBox(height: 15),

        _multiLineInput(
          title: "Discharge planning",
          hint: "Enter discharge planning",
        ),
      ],
    );
  }

  Widget _documentationAndAssistantSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// ================= DOCUMENTATION =================
        const AppText(
          "Documentation",
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),

        const SizedBox(height: 15),

        Obx(
          () => _dropdown<String>(
            title: "Document type",
            hint: "Select document type",
            items: const [
              DropdownMenuItem(value: "Photographic", child: Text("Photographic")),
              DropdownMenuItem(value: "Videographic", child: Text("Videographic")),
              DropdownMenuItem(value: "Both", child: Text("Both")),
            ],
            value: controller.documentationType.value.isEmpty
              ? null
              : controller.documentationType.value,
            onChanged: (val) {
              controller.documentationType.value = val ?? "";
            },
          ),
        ),

        const SizedBox(height: 35),

        /// ================= ASSISTANT SURGEON =================
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const AppText(
              "Assistant surgeon",
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: ElevatedButton.icon(
                onPressed: _addAssistantSurgeon,
                icon: const Icon(Icons.add, size: 16),
                label: const Text("Add assistant surgeon"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2383E2),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            )
          ],
        ),

        const SizedBox(height: 15),

        /// Assistant List
        Obx(() {
          if (controller.assistantSurgeons.isEmpty) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F9FC),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const AppText(
                "No assistant surgeon added",
                color: Colors.grey,
              ),
            );
          }

          return Column(
            children: controller.assistantSurgeons.map(
              (name) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F9FC),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(
                      name,
                      color: const Color(0xFF2383E2),
                      fontWeight: FontWeight.w500,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: () => controller.assistantSurgeons.remove(name),
                    )
                  ],
                ),
              ),
            ).toList(),
          );
        }),
      ],
    );
  }

  void _addAssistantSurgeon() {
    final textController = TextEditingController();

    void submit() {
      final value = textController.text.trim();
      if (value.isNotEmpty) {
        controller.assistantSurgeons.add(value);
        Get.back();
      }
    }

    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        title: const Text("Add Assistant Surgeon"),
        content: TextField(
          controller: textController,
          autofocus: true,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => submit(),   // 👈 ENTER key works now
          decoration: const InputDecoration(
            hintText: "Enter doctor name",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: submit,
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  Widget _additionalNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        _multiLineInput(
          title: "Surgeon notes",
          hint: "Enter surgeon notes",
        ),

        const SizedBox(height: 15),

        _multiLineInput(
          title: "Nursing notes",
          hint: "Enter nursing notes",
        ),

        const SizedBox(height: 15),

        _multiLineInput(
          title: "Additional observation",
          hint: "Enter additional observation",
        ),
      ],
    );
  }

  Widget _input({
    required String title,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          title,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(height: 10,),
        TextFormField(
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: const Color(0xFFF7F9FC),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _multiLineInput({
    required String title,
    required String hint
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          title,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(height: 10,),
        TextFormField(
          maxLines: 2,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: const Color(0xFFF7F9FC),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _dropdown<T>({
    required String title,
    required String hint,
    required List<DropdownMenuItem<T>> items,
    required T? value,
    required Function(T?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          title,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<T>(
          value: value,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: const Color(0xFFF7F9FC),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
          items: items,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _datePickerField({
    required String title,
    required String hint,
    required Rx<DateTime?> selectedDate,
  }) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            title,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          const SizedBox(height: 10,),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: TextField(
              readOnly: true,
              controller: TextEditingController(
                text: selectedDate.value == null
                    ? ""
                    : "${selectedDate.value!.day.toString().padLeft(2, '0')}-"
                      "${selectedDate.value!.month.toString().padLeft(2, '0')}-"
                      "${selectedDate.value!.year}",
              ),
              onTap: () async {
                final picked = await showDatePicker(
                  context: Get.context!,
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                  initialDate: selectedDate.value ?? DateTime.now(),
                );
          
                if (picked != null) {
                  selectedDate.value = picked;
                }
              },
              decoration: _inputDecoration(
                hint: hint,
                icon: Icons.calendar_today,
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _timePickerField({
    required String title,
    required String hint,
    required Rx<TimeOfDay?> selectedTime,
  }) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            title,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          const SizedBox(height: 10,),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: TextField(
              readOnly: true,
              controller: TextEditingController(
                text: selectedTime.value == null
                    ? ""
                    : selectedTime.value!.format(Get.context!),
              ),
              onTap: () async {
                final picked = await showTimePicker(
                  context: Get.context!,
                  initialTime: selectedTime.value ?? TimeOfDay.now(),
                );
          
                if (picked != null) {
                  selectedTime.value = picked;
                }
              },
              decoration: _inputDecoration(
                hint: hint,
                icon: Icons.access_time,
              ),
            ),
          ),
        ],
      );
    });
  }

  InputDecoration _inputDecoration({
    required String hint,
    IconData? icon,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: icon != null ? Icon(icon, size: 18) : null,
      filled: true,
      fillColor: const Color(0xFFF7F9FC),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );
  }
}
