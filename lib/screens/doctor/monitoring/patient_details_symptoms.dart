import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/Doctor/symptom_controllers.dart';
import '../../../models/patient_model.dart';
import '../../../utils/buttons.dart';
import '../../../utils/constants.dart';
import '../../../utils/text.dart';
import '../../../widgets/add_symptoms_dialog.dart';

class PatientDetailsSymptoms extends StatefulWidget {
  final PatientModel patient;

  const PatientDetailsSymptoms({super.key, required this.patient});

  @override
  State<PatientDetailsSymptoms> createState() => _PatientDetailsSymptomsState();
}

class _PatientDetailsSymptomsState extends State<PatientDetailsSymptoms> {
  final symptopmControllers = Get.put(SymptomControllers());

  @override
  void initState() {
    super.initState();
    symptopmControllers.fetchSymptoms(widget.patient.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// ================= HEADER =================
            symptomsHeader(context),

            const SizedBox(height: 30),

            /// ================= TITLE + ACTIONS =================
            Obx(() {
              final selectedCount = symptopmControllers.selectedRows.length;
              final hasSelection = selectedCount > 0;

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  /// 🔥 LEFT SIDE TITLE
                  AppText(
                    hasSelection
                      ? "$selectedCount Selected"
                      : "Patient symptoms",
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: hasSelection ? Colors.red : Colors.black,
                  ),

                  /// 🔥 RIGHT SIDE ACTIONS
                  if (hasSelection)
                    AppButton(
                      onPressed: () async {
                        final grouped = <String, List<String>>{};

                        for (final row in symptopmControllers.selectedRows) {
                          grouped.putIfAbsent(row.recordId, () => []);
                          grouped[row.recordId]!.add(row.id);
                        }

                        for (final entry in grouped.entries) {
                          await symptopmControllers.deleteSymptoms(
                            patientMongoId: widget.patient.id,
                            recordId: entry.key,
                            symptomIds: entry.value,
                          );
                        }
                      },
                      text: "Delete",
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      borderRadius: 8,
                      fontSize: 12,
                    )
                  else
                    Row(
                      children: [

                        // AppButton(
                        //   onPressed: () {},
                        //   text: "Symptom analysis",
                        //   backgroundColor: const Color(0xFF2C7EDB),
                        //   padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                        //   borderRadius: 8,
                        //   fontSize: 12,
                        // ),

                        // const SizedBox(width: 12),

                        AppButton(
                          onPressed: () {},
                          text: "Export data",
                          backgroundColor: Colors.grey.shade600,
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                          borderRadius: 8,
                          fontSize: 12,
                        ),
                      ],
                    ),
                ],
              );
            }),

            const SizedBox(height: 24),

            /// ================= FILTER CARD =================
            _filterSection(),

            const SizedBox(height: 24),

            /// ================= TABLE =================
            Expanded(
              child: _symptomsTable(),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  Widget symptomsHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [

          /// ICON BOX
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.info,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.bar_chart,
              size: 32,
              color: Colors.white,
            ),
          ),

          const SizedBox(width: 12),

          /// TEXT SECTION
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  "Symptoms analysis",
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                AppText(
                  "Analyze patient symptoms",
                  fontSize: 12,
                  color: AppColors.greyText,
                ),
              ],
            ),
          ),

          /// ACTION BUTTON
          AppButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AddSymptomsDialog(patient: widget.patient),
              );
            },
            text: "Add new symptom",
          ),
        ],
      ),
    );
  }

  // =========================================================
  Widget _filterSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const AppText(
            "Filter & Sort",
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),

          const SizedBox(height: 16),

          Row(
            children: [

              /// Search
              Expanded(
                child: TextField(
                  onChanged: (value) {
                    symptopmControllers.applyLocalSearch(value);
                  },
                  decoration: InputDecoration(
                    hintText: "Search symptom",
                    filled: true,
                    fillColor: const Color(0xFFF7F8FA),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 20),

              /// Sort dropdown
              Expanded(
                child: Obx(() {
                  return DropdownButtonFormField<String>(
                    initialValue: symptopmControllers.currentSort.value,
                    items: const [
                      DropdownMenuItem(value: "newest", child: Text("Newest first")),
                      DropdownMenuItem(value: "oldest", child: Text("Oldest first")),
                    ],
                    onChanged: (value) {
                      if (value == null) return;

                      symptopmControllers.currentSort.value = value;

                      symptopmControllers.fetchSymptoms(
                        widget.patient.id,
                        sort: value,
                      );
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF7F8FA),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =========================================================
  Widget _symptomsTable() {
    return Obx(() {
      if (symptopmControllers.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (symptopmControllers.symptomRecords.isEmpty) {
        return const Center(
          child: AppText(
            "No symptoms recorded",
            color: Colors.black54,
          ),
        );
      }

      /// Flatten records → because each record contains multiple symptoms
      final rows = symptopmControllers.symptomRecords.expand<SymptomTableRow>(
        (record) =>
          record.symptoms.map<SymptomTableRow>((symptom) {
            return SymptomTableRow(
              id: symptom.id,
              name: symptom.name,
              severity: symptom.severity,
              date: record.recordedAt,
              message: symptom.message,
              recordId: record.id,
            );
          }
        )
      ).toList();

      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          children: [

            /// ================= TABLE HEADER =================
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: const BoxDecoration(
                color: Color(0xFFF1F5F9),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              child:const Row(
                children: [
                  SizedBox(width: 30),
                  Expanded(flex: 3, child: AppText("Symptom")),
                  Expanded(child: AppText("Date")),
                  Expanded(child: AppText("Severity")),
                  Expanded(child: AppText("Action")),
                ],
              ),
            ),

            /// ================= TABLE BODY =================
            Expanded(
              child: ListView.builder(
                itemCount: rows.length,
                itemBuilder: (_, index) {
                  final row = rows[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                    child: Row(
                      children: [

                        Obx(() {
                          final isSelected = symptopmControllers.isRowSelected(row);
                        
                          return Checkbox(
                            value: isSelected,
                            onChanged: (_) {
                              symptopmControllers.toggleRowSelection(row);
                            },
                          );
                        }),

                        /// Symptom name
                        Expanded(
                          flex: 3,
                          child: AppText(
                            row.name,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        /// Date
                        Expanded(
                          child: AppText(
                            _formatDate(row.date),
                          ),
                        ),

                        /// Severity
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: _severityBadge(row.severity),
                          ),
                        ),

                        /// Actions
                        Expanded(
                          child: Row(
                            children: [
                              // IconButton(
                              //   onPressed: () {
                              //     // TODO: View dialog
                              //   },
                              //   icon: const Icon(
                              //     Icons.visibility_outlined,
                              //     size: 20,
                              //     color: Color(0xFF2C7EDB),
                              //   ),
                              //   splashRadius: 20,
                              // ),
                              // const SizedBox(width: 8),
                              IconButton(
                                onPressed: () {
                                  symptopmControllers.deleteSymptoms(
                                    patientMongoId: widget.patient.id,
                                    recordId: row.recordId,
                                    symptomIds: [row.id],
                                  );
                                },
                                icon: const Icon(
                                  Icons.delete_outline,
                                  size: 20,
                                  color: Colors.red,
                                ),
                                splashRadius: 20,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _severityBadge(String severity) {
    Color bg;
    Color text;

    switch (severity.toLowerCase()) {
      case "mild":
        bg = const Color(0xFFE6F4EA);
        text = Colors.green;
        break;
      case "moderate":
        bg = const Color(0xFFFFE8B2);
        text = Colors.orange;
        break;
      case "severe":
        bg = const Color(0xFFFFE4E4);
        text = Colors.red;
        break;
      default:
        bg = Colors.grey.shade200;
        text = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: AppText(
        severity.capitalizeFirst ?? severity,
        fontWeight: FontWeight.w500,
        color: text,
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "-";
    return "${date.day.toString().padLeft(2, '0')}-"
          "${date.month.toString().padLeft(2, '0')}-"
          "${date.year}";
  }

}

class SymptomTableRow {
  final String id;
  final String name;
  final String severity;
  final DateTime? date;
  final String? message;
  final String recordId;

  SymptomTableRow({
    required this.id,
    required this.recordId,
    required this.name,
    required this.severity,
    required this.date,
    this.message,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SymptomTableRow &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
