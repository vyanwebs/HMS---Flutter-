import 'package:flutter/material.dart';
import 'package:flutter_mdi_icons/flutter_mdi_icons.dart';
import 'package:get/get.dart';

import '../../../controllers/patient_details_diagnosis_controllers.dart';
import '../../../models/patient_model.dart';
import '../../../utils/buttons.dart';
import '../../../utils/constants.dart';
import '../../../utils/text.dart';

class PatientDetailsDiagnosis extends StatefulWidget {
  final PatientModel patient;

  const PatientDetailsDiagnosis({super.key, required this.patient});

  @override
  State<PatientDetailsDiagnosis> createState() => _PatientDetailsDiagnosisState();
}

class _PatientDetailsDiagnosisState extends State<PatientDetailsDiagnosis> {
  final diagnosisController = Get.put(PatientDetailsDiagnosisControllers());

  @override
  void initState() {
    super.initState();
    diagnosisController.fetchDiagnoses(widget.patient.id);
  }

  String _formatDate(DateTime dt) {
    return "${dt.day.toString().padLeft(2, '0')}-"
          "${dt.month.toString().padLeft(2, '0')}-"
          "${dt.year}";
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour > 12 ? dt.hour - 12 : dt.hour;
    final suffix = dt.hour >= 12 ? "P.M." : "A.M.";
    return "${hour.toString().padLeft(2, '0')}:"
          "${dt.minute.toString().padLeft(2, '0')} $suffix";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20), 
          _header(),
          const SizedBox(height: 20),
          _recordsHeader(),
          const SizedBox(height: 12),
          _tableHeader(),
          Expanded(
            child: Obx(() {
              if (diagnosisController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (diagnosisController.diagnosisList.isEmpty) {
                return const Center(
                  child: AppText("No diagnosis records found"),
                );
              }

              final rows = diagnosisController.diagnosisList.expand<_DiagnosisRowData>((record) {
                return record.diagnoses.map(
                  (d) => _DiagnosisRowData(
                    recordId: record.id,
                    diagnosisItemId: d.id, // ✅ IMPORTANT
                    diagnosisName: d.name,
                    diagnosedAt: record.diagnosedAt,
                  ),
                );
              }).toList();

              return ListView.builder(
                itemCount: rows.length,
                itemBuilder: (_, index) {
                  final row = rows[index];

                  return _diagnosisRow(
                    index: index + 1,
                    row: row,
                  );
                },
              );
            }),
          ),

        ],
      ),
    );
  }

  // ================= HEADER =================
  Widget _header() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.info,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Mdi.heartPulse,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    "Dignosis by doctor",
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: 2),
                  AppText(
                    "Manage medicines and dosage instructions",
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ],
              ),
            ],
          ),
          AppButton(
            onPressed: () => showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => AddDiagnosisDialog(patient: widget.patient),
            ),
            icon: Icons.add,
            iconIsLast: false,
            text: "Add diagnosis",
          ),
        ],
      ),
    );
  }

  // ================= RECORD HEADER =================
  Widget _recordsHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F8FF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const AppText(
            "Diagnosis records",
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          const Spacer(),
          IconButton(
            onPressed: () => diagnosisController.fetchDiagnoses(widget.patient.id),
            icon: const Icon(Icons.refresh, size: 20),
          ),
          const SizedBox(width: 6),
          Obx(
            () {
              final totalDiagnoses = diagnosisController.diagnosisList.fold<int>(
                0,
                (sum, record) => sum + record.diagnoses.length,
              );

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFB2F5EA),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: AppText(
                  "$totalDiagnoses Diagnosis",
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ================= TABLE HEADER =================
  Widget _tableHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Table(
        columnWidths: _columnWidths,
        children: const [
          TableRow(
            children: [
              _HeaderCell("Number"),
              _HeaderCell("Diagnosis"),
              _HeaderCell("Date and time"),
              _HeaderCell("Action"),
            ],
          ),
        ],
      ),
    );
  }

  final Map<int, TableColumnWidth> _columnWidths = const {
    0: FixedColumnWidth(120),   // Number
    1: FlexColumnWidth(),     // Diagnosis
    2: FixedColumnWidth(220), // Date & Time
    3: FixedColumnWidth(100), // Action
  };

  // ================= TABLE ROW =================
  Widget _diagnosisRow({
    required int index,
    required _DiagnosisRowData row,
  }) {
    return Table(
      columnWidths: _columnWidths,
      children: [
        TableRow(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade200),
            ),
          ),
          children: [
            _cell(AppText("$index.")),

            // ===== SINGLE DIAGNOSIS =====
            _cell(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    row.diagnosisName,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(height: 4),
                  AppText(
                    _formatTime(row.diagnosedAt),
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),

            // ===== DATE & TIME =====
            _cell(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    _formatDate(row.diagnosedAt),
                    fontWeight: FontWeight.w500,
                  ),
                  const SizedBox(height: 4),
                  AppText(
                    _formatTime(row.diagnosedAt),
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),

            // ===== ACTION =====
            _cell(
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () {
                  _showDeleteDialog(
                    diagnosisName: row.diagnosisName,
                    onConfirm: () {
                      diagnosisController.deleteDiagnosisItem(
                        diagnosisRecordId: row.recordId,
                        diagnosisItemId: row.diagnosisItemId,
                        patientMongoId: widget.patient.id
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _cell(Widget child) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: child,
    );
  }

  void _showDeleteDialog({
    required String diagnosisName,
    required VoidCallback onConfirm,
  }) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 420, // ✅ perfect desktop dialog width
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppText(
                  "Delete diagnosis",
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(height: 10),
                AppText(
                  "Are you sure you want to delete \"$diagnosisName\"?\n"
                  "This action cannot be undone.",
                  fontSize: 13,
                  color: Colors.grey,
                ),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppButton(
                      text: "Cancel",
                      backgroundColor: Colors.grey.shade400,
                      onPressed: () => Get.back(),
                    ),
                    const SizedBox(width: 12),
                    AppButton(
                      text: "Delete",
                      backgroundColor: Colors.red,
                      onPressed: () {
                        Get.back();
                        onConfirm();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String text;
  const _HeaderCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: AppText(
        text,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class AddDiagnosisDialog extends StatefulWidget {
  final PatientModel patient;

  const AddDiagnosisDialog({super.key, required this.patient});

  @override
  State<AddDiagnosisDialog> createState() => _AddDiagnosisDialogState();
}

class _AddDiagnosisDialogState extends State<AddDiagnosisDialog> {

  final TextEditingController diagnosisCtrl = TextEditingController();
  final diagnosisController = Get.find<PatientDetailsDiagnosisControllers>();

  final _formKey = GlobalKey<FormState>();
  final FocusNode _diagnosisFocus = FocusNode();

  final List<String> diagnoses = [];

  final List<String> quickChips = const [
    "Fever",
    "Chills / Rigors",
    "Fatigue",
    "Headache",
    "Body pain",
  ];

  void _addDiagnosis() {
    final text = diagnosisCtrl.text.trim();
    if (text.isEmpty) return;

    if (!diagnoses.contains(text)) {
      setState(() {
        diagnoses.add(text);
      });
    }

    diagnosisCtrl.clear();

    FocusScope.of(context).requestFocus(_diagnosisFocus);
  }

  void _removeDiagnosis(String value) {
    setState(() {
      diagnoses.remove(value);
    });
  }

  @override
  void dispose() {
    diagnosisCtrl.dispose();
    _diagnosisFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      backgroundColor: Colors.white,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ================= PATIENT HEADER =================
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.info.withValues(alpha: 0.2),
                      child: Text(
                        widget.patient.initials,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          widget.patient.name,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                        AppText(
                          "ID:${widget.patient.patientId} · Age-${widget.patient.age} · ${widget.patient.gender}",
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ================= TITLE =================
              const AppText(
                "Manual diagnosis entry",
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(height: 6),
              const AppText(
                "Enter diagnosis manually",
                fontSize: 12,
                color: Colors.grey,
              ),

              const SizedBox(height: 14),

              // ================= INPUT =================
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: diagnosisCtrl,
                  focusNode: _diagnosisFocus,
                  autofocus: true,
                  textInputAction: TextInputAction.done,

                  onFieldSubmitted: (_) {
                    final text = diagnosisCtrl.text.trim();
                    if (text.isEmpty) {
                      _submitForm();
                    } else {
                      _addDiagnosis();
                    }
                  },

                  validator: (_) {
                    if (diagnoses.isEmpty) {
                      return "Please add at least one diagnosis";
                    }
                    return null;
                  },

                  decoration: InputDecoration(
                    hintText: "Type diagnosis and press Enter",
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: _addDiagnosis,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              if (diagnoses.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: diagnoses.map((d) {
                    return Chip(
                      label: Text(d),
                      deleteIcon: const Icon(Icons.close, size: 18),
                      onDeleted: () => _removeDiagnosis(d),
                    );
                  }).toList(),
                ),
              ],

              const SizedBox(height: 12),

              // ================= QUICK CHIPS =================
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: quickChips.map((chip) {
                  return InkWell(
                    onTap: () {
                      diagnosisCtrl.text = chip;
                      _addDiagnosis();
                    },
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.info.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: AppText(
                        chip,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              // ================= ACTIONS =================
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppButton(
                    text: "Close",
                    backgroundColor: Colors.grey.shade500,
                    onPressed: () => Get.back(),
                  ),
                  const SizedBox(width: 12),
                  AppButton(
                    text: "Add diagnoses",
                    icon: Icons.add,
                    iconIsLast: false,
                    onPressed: () => _submitForm(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      FocusScope.of(context).requestFocus(_diagnosisFocus);
      return;
    }

    diagnosisController.createDiagnoses(
      patientMongoId: widget.patient.id,
      diagnoses: diagnoses,
    );
  }
}

class _DiagnosisRowData {
  final String recordId;
  final String diagnosisItemId;
  final String diagnosisName;
  final DateTime diagnosedAt;

  _DiagnosisRowData({
    required this.recordId,
    required this.diagnosisItemId,
    required this.diagnosisName,
    required this.diagnosedAt,
  });
}

