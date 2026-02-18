import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mdi_icons/flutter_mdi_icons.dart';
import 'package:get/get.dart';

import '../../../utils/buttons.dart';
import '../../../utils/constants.dart';
import '../../../utils/text.dart';
import '../../controllers/Doctor/patient_details_treatment_controllers.dart';
import '../../models/patient_model.dart';
import '../../models/traetment_model.dart';

class PatientDetailsTreatment extends StatefulWidget {
  final PatientModel patient;
  const PatientDetailsTreatment({super.key, required this.patient});

  @override
  State<PatientDetailsTreatment> createState() => _PatientDetailsTreatmentState();
}

class _PatientDetailsTreatmentState extends State<PatientDetailsTreatment> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final treatmentController = Get.put(PatientDetailsTreatmentControllers());

  final Map<int, TableColumnWidth> _columnWidths = const {
    0: FixedColumnWidth(100),
    1: FlexColumnWidth(),
    2: FixedColumnWidth(120),
    3: FixedColumnWidth(180),
    4: FixedColumnWidth(120),
    5: FixedColumnWidth(150),
  };

  String formatDate(DateTime dt) {
    return "${dt.day.toString().padLeft(2, '0')}-"
        "${dt.month.toString().padLeft(2, '0')}-"
        "${dt.year}";
  }

  String formatTime(DateTime dt) {
    final hour = dt.hour > 12 ? dt.hour - 12 : dt.hour;
    final suffix = dt.hour >= 12 ? "P.M." : "A.M.";
    return "${hour.toString().padLeft(2, '0')}:"
        "${dt.minute.toString().padLeft(2, '0')} $suffix";
  }

  Color statusBg(String status) {
    switch (status.toLowerCase()) {
      case "completed":
        return Colors.green.shade100;
      case "pending":
      default:
        return Colors.orange.shade100;
    }
  }

  Color statusText(String status) {
    switch (status.toLowerCase()) {
      case "completed":
        return Colors.green.shade700;
      case "pending":
      default:
        return Colors.orange.shade700;
    }
  }

  @override
  void initState() {
    super.initState();

    treatmentController.fetchMedicationTreatments(widget.patient.id);

    _tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: treatmentController.activeTab.value,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      treatmentController.changeTab(
        _tabController.index,
        widget.patient.id,
      );
    });

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;

      treatmentController.changeTab(
        _tabController.index,
        widget.patient.id,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),

          // ================= HEADER =================
          _header(),

          const SizedBox(height: 20),

          // ================= RECORD HEADER =================
          _recordsHeader(),

          const SizedBox(height: 16),

          // ================= TABS =================
          _tabs(),

          const SizedBox(height: 12),

          // ================= TABLE HEADER =================
          Obx(() {
            switch (treatmentController.activeTab.value) {
              case 0:
                return _medicationTableHeader();
              case 1:
                return _ivFluidTableHeader();
              case 2:
                return _procedureTableHeader();
              case 3:
                return _instructionTableHeader();
              default:
                return const SizedBox.shrink();
            }
          }),

          // ================= TABLE BODY =================
          Expanded(
            child: Obx(() {
              final tab = treatmentController.activeTab.value;

              if (tab == 0) {
                if (treatmentController.isMedicationLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                return _medicationList();
              }

              if (tab == 1) {
                if (treatmentController.isIVFluidLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                return _ivFluidList();
              }

              if (tab == 2) {
                if (treatmentController.isProcedureLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                return _procedureList();
              }

              if (tab == 3) {
                if (treatmentController.isInstructionLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                return _instructionList();
              }

              return const Center(child: AppText("Coming soon"));
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
                  Mdi.pill,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    "Patient treatment",
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
              builder: (_) => AddTreatmentDialog(patientMongoId: widget.patient.id),
            ),
            icon: Icons.add,
            iconIsLast: false,
            text: "Add treatment",
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
        color: AppColors.info.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const AppText(
            "Treatment records",
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => treatmentController.refreshCurrentTab(widget.patient.id),
          ),
          const SizedBox(width: 6),
          Obx(
            () => Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFB2F5EA),
                borderRadius: BorderRadius.circular(20),
              ),
              child: AppText(
                "${treatmentController.medicationList.length} Ongoing",
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= TABS =================
  Widget _tabs() {
    return TabBar(
      controller: _tabController,
      labelColor: AppColors.primary,
      unselectedLabelColor: Colors.grey,
      indicatorColor: AppColors.primary,
      tabs: const [
        Tab(text: "Medication"),
        Tab(text: "IV - Fluid"),
        Tab(text: "Procedures"),
        Tab(text: "Instructions"),
      ],
    );
  }

  // ================= Medication TABLE HEADER =================
  Widget _medicationTableHeader() {
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
              _HeaderCell("Medication"),
              _HeaderCell("Type"),
              _HeaderCell("Date and time"),
              _HeaderCell("Status"),
              _HeaderCell("Action"),
            ],
          ),
        ],
      ),
    );
  }
  
  // =============== IV FLUID TEBLE HEADER ====================
  Widget _ivFluidTableHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Table(
        columnWidths: const {
          0: FixedColumnWidth(100),
          1: FlexColumnWidth(),
          2: FixedColumnWidth(120),
          3: FixedColumnWidth(150),
          4: FixedColumnWidth(120),
          5: FixedColumnWidth(150),
        },
        children: const [
          TableRow(children: [
            _HeaderCell("Number"),
            _HeaderCell("IV Fluid"),
            _HeaderCell("Quantity"),
            _HeaderCell("Duration"),
            _HeaderCell("Status"),
            _HeaderCell("Action"),
          ]),
        ],
      ),
    );
  }

  // ================= PROCEDURE TABLE HEADER =================
  Widget _procedureTableHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Table(
        columnWidths: const {
          0: FixedColumnWidth(100),
          1: FlexColumnWidth(),
          2: FixedColumnWidth(150),
          3: FixedColumnWidth(180),
          4: FixedColumnWidth(120),
          5: FixedColumnWidth(150),
        },
        children: const [
          TableRow(
            children: [
              _HeaderCell("Number"),
              _HeaderCell("Procedure"),
              _HeaderCell("Frequency"),
              _HeaderCell("Date & Time"),
              _HeaderCell("Status"),
              _HeaderCell("Action"),
            ],
          ),
        ],
      ),
    );
  }

  // ================= INSTRUCTION TABLE HEADER =================
  Widget _instructionTableHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Table(
        columnWidths: const {
          0: FixedColumnWidth(100),
          1: FlexColumnWidth(),
          2: FixedColumnWidth(180),
          3: FixedColumnWidth(120),
          4: FixedColumnWidth(150),
        },
        children: const [
          TableRow(
            children: [
              _HeaderCell("Number"),
              _HeaderCell("Instruction"),
              _HeaderCell("Date & Time"),
              _HeaderCell("Status"),
              _HeaderCell("Action"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _medicationList() {
    if (treatmentController.medicationList.isEmpty) {
      return const Center(child: AppText("No medications found"));
    }

    return ListView.builder(
      itemCount: treatmentController.medicationList.length,
      itemBuilder: (_, i) {
        final med = treatmentController.medicationList[i];
        return _treatmentRow(
          index: i + 1,
          id: med.id,
          name: med.medicationName,
          frequency: med.dosage.timeOfDay,
          type: med.medicationType,
          date: formatDate(med.createdAt),
          time: formatTime(med.createdAt),
          status: med.status,
          med: med,
        );
      },
    );
  }

  Widget _ivFluidList() {
    if (treatmentController.ivFluidList.isEmpty) {
      return const Center(child: AppText("No IV fluids found"));
    }

    return ListView.builder(
      itemCount: treatmentController.ivFluidList.length,
      itemBuilder: (_, i) {
        final iv = treatmentController.ivFluidList[i];

        return Table(
          columnWidths: const {
            0: FixedColumnWidth(100),
            1: FlexColumnWidth(),
            2: FixedColumnWidth(120),
            3: FixedColumnWidth(150),
            4: FixedColumnWidth(120),
            5: FixedColumnWidth(150),
          },
          children: [
            TableRow(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade200),
                ),
              ),
              children: [
                _cell(AppText("${i + 1}.")),
                _cell(AppText(iv.ivFluidName)),
                _cell(AppText(iv.quantity)),
                _cell(AppText(iv.duration)),
                _cell(_statusChip(iv.status)),
                _cell(_actionButtons(iv)),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _procedureList() {
    final list = treatmentController.procedureList;

    if (list.isEmpty) {
      return const Center(child: AppText("No procedures found"));
    }

    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (_, i) {
        final proc = list[i];

        return Table(
          columnWidths: const {
            0: FixedColumnWidth(100),
            1: FlexColumnWidth(),
            2: FixedColumnWidth(150),
            3: FixedColumnWidth(180),
            4: FixedColumnWidth(120),
            5: FixedColumnWidth(150),
          },
          children: [
            TableRow(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade200),
                ),
              ),
              children: [
                _cell(AppText("${i + 1}.")),

                _cell(
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.medical_services_outlined,
                          size: 16,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 10),
                      AppText(
                        proc.procedure,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),

                _cell(AppText(proc.frequency)),

                _cell(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        formatDate(proc.createdAt),
                        fontWeight: FontWeight.w500,
                      ),
                      AppText(
                        formatTime(proc.createdAt),
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),

                _cell(_statusChip(proc.status)),

                _cell(
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.edit_outlined,
                          size: 18,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => EditProcedureDialog(
                              procedure: proc,
                              patientMongoId: widget.patient.id,
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 4),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          size: 18,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          showDeleteTreatmentDialog(
                            treatmentName: proc.procedure,
                            onConfirm: () {
                              treatmentController.deleteProcedureTreatment(procedureId: proc.id, patientMongoId: widget.patient.id);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _instructionList() {
    final list = treatmentController.instructionList;

    if (list.isEmpty) {
      return const Center(child: AppText("No instructions found"));
    }

    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (_, i) {
        final ins = list[i];

        return Table(
          columnWidths: const {
            0: FixedColumnWidth(100),
            1: FlexColumnWidth(),
            2: FixedColumnWidth(180),
            3: FixedColumnWidth(120),
            4: FixedColumnWidth(150),
          },
          children: [
            TableRow(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade200),
                ),
              ),
              children: [
                _cell(AppText("${i + 1}.")),

                _cell(
                  AppText(
                    ins.specialInstruction,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                _cell(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(formatDate(ins.createdAt), fontWeight: FontWeight.w500),
                      AppText(
                        formatTime(ins.createdAt),
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),

                _cell(_statusChip(ins.status)),

                _cell(
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.edit_outlined,
                          size: 18,
                          color: Colors.blue,
                        ),
                        onPressed: () => showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => EditInstructionDialog(
                            instruction: ins,
                            patientMongoId: widget.patient.id,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          size: 18,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          showDeleteTreatmentDialog(
                            treatmentName: ins.specialInstruction,
                            onConfirm: () {
                              treatmentController.deleteInstructionTreatment(
                                instructionId: ins.id,
                                patientMongoId: widget.patient.id,
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // ================= TABLE ROW =================
  Widget _treatmentRow({
    required int index,
    required String id,
    required String name,
    required String frequency,
    required String type,
    required String date,
    required String time,
    required String status,
    required TreatmentMedicationModel med,
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

            _cell(
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.info.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(Mdi.pill, size: 16, color: AppColors.info),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(name, fontWeight: FontWeight.w600),
                      AppText(
                        frequency,
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            _cell(AppText(type)),

            _cell(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(date, fontWeight: FontWeight.w500),
                  AppText(time, fontSize: 11, color: Colors.grey),
                ],
              ),
            ),

            _cell(
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBg(status),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: AppText(
                  status,
                  fontSize: 11,
                  color: statusText(status),
                ),
              ),
            ),

            _cell(
              Row(
                children: [
                  IconButton(
                    onPressed: () => showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => EditTreatmentDialog(
                        medication: med,
                        patientMongoId: widget.patient.id,
                      ),
                    ),
                    icon: const Icon(Icons.edit_outlined, size: 18, color: Colors.blue,),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    onPressed: () => showDeleteTreatmentDialog(
                      treatmentName: name,
                      onConfirm: () {
                        treatmentController.deleteMedicationTreatment(
                          medicationId: id,
                          patientMongoId: widget.patient.id,
                        );
                      },
                    ),
                    icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red,),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _statusChip(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: statusBg(status),
        borderRadius: BorderRadius.circular(6),
      ),
      child: AppText(
        status,
        fontSize: 11,
        color: statusText(status),
      ),
    );
  }

  Widget _actionButtons(IvFluidTreatmentModel iv) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.edit_outlined, size: 18, color: Colors.blue),
          onPressed: () => showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => EditIvFluidDialog(
              ivFluid: iv,
              patientMongoId: widget.patient.id,
            ),
          ),
        ),
        const SizedBox(width: 4,),
        IconButton(
          icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
          onPressed: () {
            showDeleteTreatmentDialog(
              treatmentName: iv.ivFluidName,
              onConfirm: () {
                treatmentController.deleteIvFluidTreatment(ivFluidId: iv.id, patientMongoId: widget.patient.id);
              },
            );
          },
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

  void showDeleteTreatmentDialog({
    required String treatmentName,
    required VoidCallback onConfirm,
  }) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 420,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ================= TITLE =================
                const AppText(
                  "Delete treatment",
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),

                const SizedBox(height: 10),

                // ================= MESSAGE =================
                AppText(
                  "Are you sure you want to delete \"$treatmentName\"?\n"
                  "This action cannot be undone.",
                  fontSize: 13,
                  color: Colors.grey,
                ),

                const SizedBox(height: 24),

                // ================= ACTIONS =================
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
                        Get.back(); // close dialog
                        onConfirm(); // perform delete
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

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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

class AddTreatmentDialog extends StatefulWidget {
  final String patientMongoId;
  const AddTreatmentDialog({super.key, required this.patientMongoId});

  @override
  State<AddTreatmentDialog> createState() => _AddTreatmentDialogState();
}

class _SubmitTreatmentIntent extends Intent {
  const _SubmitTreatmentIntent();
}

class _AddTreatmentDialogState extends State<AddTreatmentDialog> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final treatmentController = Get.find<PatientDetailsTreatmentControllers>();

  final TextEditingController medicationCtrl = TextEditingController();

  final TextEditingController ivFluidNameCtrl = TextEditingController();
  final TextEditingController quantityCtrl = TextEditingController();
  final TextEditingController durationCtrl = TextEditingController();

  final TextEditingController procedureCtrl = TextEditingController();
  final TextEditingController frequencyCtrl = TextEditingController();

  final TextEditingController instructionCtrl = TextEditingController();

  String? selectedDosage = "Morning";

  final List<String> dosageOptions = const [
    "Morning",
    "Afternoon",
    "Night",
  ];

  final _formKey = GlobalKey<FormState>();

  String selectedType = "Oral";

  final List<String> treatmentTypes = const [
    "Oral",
    "Injectable",
    "Topical",
    "Inhalation",
  ];


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    instructionCtrl.dispose();
    ivFluidNameCtrl.dispose();
    quantityCtrl.dispose();
    durationCtrl.dispose();
    _tabController.dispose();
    medicationCtrl.dispose();
    super.dispose();
  }

  Future<void> _submitTreatment() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    // ================= MEDICATION TAB =================
    if (_tabController.index == 0) {
      final created = await treatmentController.createMedicationTreatment(
        patientMongoId: widget.patientMongoId,
        medicationName: treatmentController.selectedMedicine.value!.name,
        medicationType: selectedType,
        dosages: selectedDosage!,
      );

      if (created && context.mounted) {
        Navigator.pop(context);
      }
    }

    // ================= IV FLUID TAB =================
    else if (_tabController.index == 1) {
      final created = await treatmentController.createIvFluidTreatment(
        patientMongoId: widget.patientMongoId,
        ivFluidName: ivFluidNameCtrl.text,
        quantity: quantityCtrl.text,
        duration: durationCtrl.text,
      );

      if (created && context.mounted) {
        Navigator.pop(context);
      }
    }

    // ================= PROCEDURE TAB =================
    else if (_tabController.index == 2) {
      final created = await treatmentController.createProcedureTreatment(
        patientMongoId: widget.patientMongoId,
        procedure: procedureCtrl.text,
        frequency: frequencyCtrl.text,
      );

      if (created && context.mounted) {
        Navigator.pop(context);
      }
    }

    // ================= INSTRUCTIONS TAB =================
    else if (_tabController.index == 3) {
      final created = await treatmentController.createInstructionTreatment(
        patientMongoId: widget.patientMongoId,
        specialInstruction: instructionCtrl.text,
      );

      if (created && context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: const <ShortcutActivator, Intent>{
        SingleActivator(LogicalKeyboardKey.enter): _SubmitTreatmentIntent(),
        SingleActivator(LogicalKeyboardKey.numpadEnter): _SubmitTreatmentIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          _SubmitTreatmentIntent: CallbackAction<_SubmitTreatmentIntent>(
            onInvoke: (_) {
              _submitTreatment();
              return null;
            },
          ),
        },
        child: Focus(
          autofocus: true,
          child: Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900, maxHeight: 600),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
            
                // ================= TITLE =================
                const AppText(
                  "New Treatment Plan",
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
            
                const SizedBox(height: 16),
            
                // ================= TABS =================
                TabBar(
                  controller: _tabController,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: AppColors.primary,
                  tabs: const [
                    Tab(text: "Medication"),
                    Tab(text: "IV-Fluid"),
                    Tab(text: "Procedures"),
                    Tab(text: "Instructions"),
                  ],
                ),
            
                const SizedBox(height: 24),

                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _medicationTab(),
                      _ivFluidTab(),
                      _proceduresTab(),
                      _instructionsTab(),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
            
                // ================= ACTIONS =================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AppButton(
                          text: "Cancel",
                          backgroundColor: Colors.grey.shade600,
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 14),
                        AppButton(
                          text: "Add treatment",
                          icon: Icons.add,
                          iconIsLast: false,
                          onPressed: _submitTreatment,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ));
  }

  Widget _medicationTab() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _medicineSearchInput()),
            const SizedBox(width: 24),
            Expanded(child: _dosageDropdown()),
          ],
        ),
        const SizedBox(height: 18),
        _typeDropdown(),
      ],
    );
  }

  Widget _ivFluidTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _inputField(
                label: "IV-Fluid Name",
                hint: "Enter medication name",
                validatorMsg: "IV-Fluid name is required",
                controller: ivFluidNameCtrl,
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _inputField(
                label: "Quantity",
                hint: "Enter quantity",
                validatorMsg: "Quantity is required",
                controller: quantityCtrl,
              ),
            ),
          ],
        ),

        const SizedBox(height: 18),

        _inputField(
          label: "Duration",
          hint: "Enter duration",
          validatorMsg: "Duration is required",
          controller: durationCtrl,
        ),
      ],
    );
  }

  Widget _proceduresTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ================= ROW 1 =================
        _inputField(
          label: "Procedure",
          hint: "Enter procedure name",
          validatorMsg: "Procedure is required",
          controller: procedureCtrl,
        ),
        const SizedBox(height: 20),
        _inputField(
          label: "Frequency",
          hint: "e.g. Once daily / Twice weekly",
          validatorMsg: "Frequency is required",
          controller: frequencyCtrl,
        ),
      ],
    );
  }

  Widget _instructionsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText(
          "Special instruction",
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),

        const SizedBox(height: 8),

        TextFormField(
          controller: instructionCtrl,
          minLines: 6,
          maxLines: null,
          textAlignVertical: TextAlignVertical.top,
          validator: (v) {
            if (v == null || v.trim().isEmpty) {
              return "Instruction is required";
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: "Enter special instruction",
            alignLabelWithHint: true,
            contentPadding: const EdgeInsets.all(16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _dosageDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText(
          "Dosages",
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(height: 6),

        DropdownButtonFormField<String>(
          initialValue: selectedDosage,
          items: dosageOptions.map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(e),
            ),
          ).toList(),
          onChanged: (value) {
            setState(() {
              selectedDosage = value;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Dosage is required";
            }
            return null;
          },
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
      ],
    );
  }

  Widget _typeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText(
          "Type",
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(height: 6),

        DropdownButtonFormField<String>(
          initialValue: selectedType,
          items: treatmentTypes.map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(e),
            ),
          ).toList(),
          onChanged: (value) {
            setState(() {
              selectedType = value!;
            });
          },
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
      ],
    );
  }

  Widget _medicineSearchInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText(
          "Medication Name",
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: medicationCtrl,
          validator: (_) {
            if (medicationCtrl.text.trim().isEmpty) {
              return "Medication name is required";
            }
            if (treatmentController.selectedMedicine.value == null) {
              return "Please select a medicine from the list";
            }
            return null;
          },
          onChanged: (value) {
            treatmentController.selectedMedicine.value = null;
            treatmentController.searchMedicine(value);
          },
          decoration: InputDecoration(
            hintText: "Search medicine (min 3 characters)",
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
        Obx(() {
          if (treatmentController.isMedicineLoading.value) {
            return const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Center(
                child: SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            );
          }
    
          if (treatmentController.medicines.isEmpty) {
            return const SizedBox.shrink();
          }
    
          return Container(
            margin: const EdgeInsets.only(top: 6),
            constraints: const BoxConstraints(maxHeight: 170),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: treatmentController.medicines.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, index) {
                final med = treatmentController.medicines[index];
                return ListTile(
                  dense: true,
                  title: Text(med.name),
                  onTap: () {
                    medicationCtrl.text = med.name;
                    treatmentController.selectMedicine(med);
                  },
                );
              },
            ),
          );
        }),
      ],
    );
  }

  Widget _inputField({
    required String label,
    required String hint,
    required String validatorMsg,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          label,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          validator: (v) => v == null || v.trim().isEmpty ? validatorMsg : null,
          decoration: InputDecoration(
            hintText: hint,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
      ],
    );
  }

}

class EditTreatmentDialog extends StatefulWidget {
  final TreatmentMedicationModel medication;
  final String patientMongoId;

  const EditTreatmentDialog({
    super.key,
    required this.medication,
    required this.patientMongoId,
  });

  @override
  State<EditTreatmentDialog> createState() => _EditTreatmentDialogState();
}

class _EditTreatmentDialogState extends State<EditTreatmentDialog> {
  final _formKey = GlobalKey<FormState>();
  final controller = Get.find<PatientDetailsTreatmentControllers>();

  late TextEditingController medicationCtrl;
  late String selectedDosage = dosages.first;

  final dosages = ["Morning", "Afternoon", "Night"];

  late String selectedType;
  late String selectedStatus;

  final types = ["Oral", "Injectable", "Topical", "Inhalation"];
  final statuses = ["Pending", "Completed"];

  @override
  void initState() {
    super.initState();

    medicationCtrl = TextEditingController(text: widget.medication.medicationName);
    selectedDosage = widget.medication.dosage.timeOfDay;

    selectedType = widget.medication.medicationType;
    selectedStatus = widget.medication.status;
  }

  @override
  void dispose() {
    medicationCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      backgroundColor: Colors.white,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppText(
                  "Edit Treatment",
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(height: 24),

                _medicineSearchInput(),

                const SizedBox(height: 16),

                _dosageDropdown(),

                const SizedBox(height: 16),

                _dropdown(
                  label: "Type",
                  value: selectedType,
                  items: types,
                  onChanged: (v) => setState(() => selectedType = v),
                ),

                const SizedBox(height: 16),

                _dropdown(
                  label: "Status",
                  value: selectedStatus,
                  items: statuses,
                  onChanged: (v) => setState(() => selectedStatus = v),
                ),

                const SizedBox(height: 32),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppButton(
                      text: "Cancel",
                      backgroundColor: Colors.grey.shade500,
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 12),
                    AppButton(
                      text: "Update",
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) return;

                        final updated =
                            await controller.updateMedicationTreatment(
                          medicationId: widget.medication.id,
                          patientMongoId: widget.patientMongoId,
                          medicationName: medicationCtrl.text,
                          dosages: selectedDosage,
                          medicationType: selectedType,
                          status: selectedStatus,
                        );

                        if (updated && context.mounted) {
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _dosageDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText(
          "Dosages",
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(height: 6),

        DropdownButtonFormField<String>(
          initialValue: selectedDosage,
          items: dosages.map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(e),
            ),
          ).toList(),
          onChanged: (v) => setState(() => selectedDosage = v!),
          validator: (v) => v == null || v.isEmpty ? "Dosage is required" : null,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _medicineSearchInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText(
          "Medication Name",
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: medicationCtrl,
          validator: (_) {
            if (medicationCtrl.text.trim().isEmpty) {
              return "Medication name is required";
            }
            if (controller.selectedMedicine.value == null) {
              return "Please select a medicine from the list";
            }
            return null;
          },
          onChanged: (value) {
            controller.selectedMedicine.value = null;
            controller.searchMedicine(value);
          },
          decoration: InputDecoration(
            hintText: "Search medicine (min 3 characters)",
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
        Obx(() {
          if (controller.isMedicineLoading.value) {
            return const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Center(
                child: SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            );
          }
    
          if (controller.medicines.isEmpty) {
            return const SizedBox.shrink();
          }
    
          return Container(
            margin: const EdgeInsets.only(top: 6),
            constraints: const BoxConstraints(maxHeight: 170),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: controller.medicines.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, index) {
                final med = controller.medicines[index];
                return ListTile(
                  dense: true,
                  title: Text(med.name),
                  onTap: () {
                    medicationCtrl.text = med.name;
                    controller.selectMedicine(med);
                  },
                );
              },
            ),
          );
        }),
      ],
    );
  }

  Widget _dropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(label, fontSize: 13, fontWeight: FontWeight.w500),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (v) => onChanged(v!),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }
}

class EditIvFluidDialog extends StatefulWidget {
  final IvFluidTreatmentModel ivFluid;
  final String patientMongoId;

  const EditIvFluidDialog({
    super.key,
    required this.ivFluid,
    required this.patientMongoId,
  });

  @override
  State<EditIvFluidDialog> createState() => _EditIvFluidDialogState();
}

class _EditIvFluidDialogState extends State<EditIvFluidDialog> {
  final _formKey = GlobalKey<FormState>();
  final controller = Get.find<PatientDetailsTreatmentControllers>();

  late TextEditingController ivFluidNameCtrl;
  late TextEditingController quantityCtrl;
  late TextEditingController durationCtrl;

  late String selectedStatus;
  final statuses = ["Pending", "Completed"];

  @override
  void initState() {
    super.initState();

    ivFluidNameCtrl = TextEditingController(text: widget.ivFluid.ivFluidName);
    quantityCtrl = TextEditingController(text: widget.ivFluid.quantity);
    durationCtrl = TextEditingController(text: widget.ivFluid.duration);
    selectedStatus = widget.ivFluid.status;
  }

  @override
  void dispose() {
    ivFluidNameCtrl.dispose();
    quantityCtrl.dispose();
    durationCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      backgroundColor: Colors.white,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppText(
                  "Edit IV Fluid",
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),

                const SizedBox(height: 24),

                _inputField(
                  label: "IV Fluid Name",
                  controller: ivFluidNameCtrl,
                  validatorMsg: "IV fluid name is required",
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: _inputField(
                        label: "Quantity",
                        controller: quantityCtrl,
                        validatorMsg: "Quantity is required",
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _inputField(
                        label: "Duration",
                        controller: durationCtrl,
                        validatorMsg: "Duration is required",
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                _dropdown(
                  label: "Status",
                  value: selectedStatus,
                  items: statuses,
                  onChanged: (v) => setState(() => selectedStatus = v),
                ),

                const SizedBox(height: 32),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppButton(
                      text: "Cancel",
                      backgroundColor: Colors.grey.shade500,
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 12),
                    AppButton(
                      text: "Update",
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) return;

                        final updated =
                            await controller.updateIvFluidTreatment(
                          ivFluidId: widget.ivFluid.id,
                          patientMongoId: widget.patientMongoId,
                          ivFluidName: ivFluidNameCtrl.text,
                          quantity: quantityCtrl.text,
                          duration: durationCtrl.text,
                          status: selectedStatus,
                        );

                        if (updated && context.mounted) {
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputField({
    required String label,
    required TextEditingController controller,
    required String validatorMsg,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(label, fontSize: 13, fontWeight: FontWeight.w500),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          validator: (v) => v == null || v.trim().isEmpty ? validatorMsg : null,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
      ],
    );
  }

  Widget _dropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(label, fontSize: 13, fontWeight: FontWeight.w500),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          initialValue: value,
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (v) => onChanged(v!),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }
}

class EditProcedureDialog extends StatefulWidget {
  final ProcedureTreatmentModel procedure;
  final String patientMongoId;

  const EditProcedureDialog({
    super.key,
    required this.procedure,
    required this.patientMongoId,
  });

  @override
  State<EditProcedureDialog> createState() => _EditProcedureDialogState();
}

class _EditProcedureDialogState extends State<EditProcedureDialog> {
  final _formKey = GlobalKey<FormState>();
  final controller = Get.find<PatientDetailsTreatmentControllers>();

  late TextEditingController procedureCtrl;
  late TextEditingController frequencyCtrl;

  late String selectedStatus;

  final statuses = const ["Pending", "Completed"];

  @override
  void initState() {
    super.initState();

    procedureCtrl = TextEditingController(text: widget.procedure.procedure);
    frequencyCtrl = TextEditingController(text: widget.procedure.frequency);
    selectedStatus = widget.procedure.status;
  }

  @override
  void dispose() {
    procedureCtrl.dispose();
    frequencyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ================= TITLE =================
                const AppText(
                  "Edit Procedure",
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),

                const SizedBox(height: 24),

                // ================= PROCEDURE =================
                _inputField(
                  label: "Procedure",
                  hint: "Enter procedure name",
                  controller: procedureCtrl,
                  validatorMsg: "Procedure is required",
                ),

                const SizedBox(height: 16),

                // ================= FREQUENCY =================
                _inputField(
                  label: "Frequency",
                  hint: "Enter frequency",
                  controller: frequencyCtrl,
                  validatorMsg: "Frequency is required",
                ),

                const SizedBox(height: 16),

                // ================= STATUS =================
                _statusDropdown(),

                const SizedBox(height: 32),

                // ================= ACTIONS =================
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppButton(
                      text: "Cancel",
                      backgroundColor: Colors.grey.shade500,
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 12),
                    AppButton(
                      text: "Update",
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) return;

                        final updated =
                            await controller.updateProcedureTreatment(
                          procedureId: widget.procedure.id,
                          patientMongoId: widget.patientMongoId,
                          procedure: procedureCtrl.text,
                          frequency: frequencyCtrl.text,
                          status: selectedStatus,
                        );

                        if (updated && context.mounted) {
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= INPUT FIELD =================
  Widget _inputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required String validatorMsg,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(label, fontSize: 13, fontWeight: FontWeight.w500),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          validator: (v) =>
              v == null || v.trim().isEmpty ? validatorMsg : null,
          decoration: InputDecoration(
            hintText: hint,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
      ],
    );
  }

  // ================= STATUS DROPDOWN =================
  Widget _statusDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText(
          "Status",
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: selectedStatus,
          items: statuses
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e),
                ),
              )
              .toList(),
          onChanged: (v) => setState(() => selectedStatus = v!),
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
      ],
    );
  }
}

class EditInstructionDialog extends StatefulWidget {
  final InstructionTreatmentModel instruction;
  final String patientMongoId;

  const EditInstructionDialog({
    super.key,
    required this.instruction,
    required this.patientMongoId,
  });

  @override
  State<EditInstructionDialog> createState() => _EditInstructionDialogState();
}

class _EditInstructionDialogState extends State<EditInstructionDialog> {
  final _formKey = GlobalKey<FormState>();
  final controller = Get.find<PatientDetailsTreatmentControllers>();

  late TextEditingController instructionCtrl;
  late String selectedStatus;

  final statuses = ["Pending", "Completed"];

  @override
  void initState() {
    super.initState();
    instructionCtrl = TextEditingController(text: widget.instruction.specialInstruction);
    selectedStatus = widget.instruction.status;
  }

  @override
  void dispose() {
    instructionCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      backgroundColor: Colors.white,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppText(
                  "Edit Instruction",
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),

                const SizedBox(height: 20),

                const AppText(
                  "Special Instruction",
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(height: 6),

                TextFormField(
                  controller: instructionCtrl,
                  maxLines: 5,
                  validator: (v) =>
                      v == null || v.trim().isEmpty
                          ? "Instruction is required"
                          : null,
                  decoration: InputDecoration(
                    hintText: "Enter instruction",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  value: selectedStatus,
                  items: statuses
                      .map((e) =>
                          DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => selectedStatus = v!),
                  decoration: InputDecoration(
                    labelText: "Status",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppButton(
                      text: "Cancel",
                      backgroundColor: Colors.grey.shade500,
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 12),
                    AppButton(
                      text: "Update",
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) return;

                        final updated =
                            await controller.updateInstructionTreatment(
                          instructionId: widget.instruction.id,
                          patientMongoId: widget.patientMongoId,
                          specialInstruction: instructionCtrl.text,
                          status: selectedStatus,
                        );

                        if (updated && context.mounted) {
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
