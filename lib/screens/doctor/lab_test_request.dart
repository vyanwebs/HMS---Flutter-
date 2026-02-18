import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/Doctor/lab_test_controllers.dart';
import '../../controllers/Doctor/patient_search_controllers.dart';
import '../../models/lab_test_request_model.dart';
import '../../utils/buttons.dart';
import '../../utils/keyboard_intents.dart';
import '../../utils/snackbar.dart';
import '../../utils/text.dart';
import '../../widgets/doctor_panel/stat_card_widget.dart';

class LabTestRequest extends StatelessWidget {
  LabTestRequest({super.key});

  final labTestControllers = Get.put(LabTestControllers());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// Breadcrumb
              const AppText(
                'DOCTOR PANEL >> Laboratory Results',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF718096),
              ),
              const SizedBox(height: 20),

              /// Stat Cards
              labTestStatCard(),
              const SizedBox(height: 30),

              /// Title
              const AppText(
                "Test requests",
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
              const SizedBox(height: 16),

              /// Top Controls
              _buildTopControls(context),
              const SizedBox(height: 20),

              /// TABLE SECTION (Only this scrolls)
              Expanded(
                child: _buildTableSection(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= TOP CONTROLS =================

  Widget _buildTopControls(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(width: 300, child: _searchBox()),
              // SizedBox(width: 140, child: _dropdown("All")),
              SizedBox(
                width: 180,
                child: _dropdown(
                  items: labTestControllers.priorityOptions,
                  selectedValue: labTestControllers.selectedPriority,
                ),
              ),

              SizedBox(
                width: 180,
                child: _dropdown(
                  items: labTestControllers.statusOptions,
                  selectedValue: labTestControllers.selectedStatus,
                ),
              ),
          
              AppButton(
                text: "Request new test",
                backgroundColor: const Color(0xFF2383E2),
                onPressed: () {
                  RequestNewTestDialog.show(context);
                },
              ),
          
              AppButton(
                text: "Delete",
                backgroundColor: Colors.red,
                onPressed: () => labTestControllers.deleteSelectedRequests(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _searchBox() {
    return SizedBox(
      height: 40,
      child: TextField(
        style: const TextStyle(fontSize: 14),
        onChanged: (value) {
          labTestControllers.searchQuery.value = value;
        },
        decoration: const InputDecoration(
          hintText: "Search by test, patient, category",
          prefixIcon: Icon(
            Icons.search,
            size: 18,
            color: Color(0xFF718096),
          ),
          isDense: true,
          filled: true,
          fillColor: Color(0xFFF7FAFC),
          contentPadding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 12,
          ),
        ),
      ),
    );
  }

  Widget _dropdown({
    required List<String> items,
    required RxString selectedValue,
  }) {
    return SizedBox(
      height: 40,
      child: Obx(() {
        return DropdownButtonFormField<String>(
          initialValue: selectedValue.value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, size: 18),
          decoration: const InputDecoration(
            isDense: true,
            filled: true,
            fillColor: Color(0xFFF7FAFC),
            contentPadding: EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 12,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFE2E8F0)),
            ),
          ),
          items: items.map((e) {
            return DropdownMenuItem(
              value: e,
              child: Text(
                e,
                style: const TextStyle(fontSize: 14),
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              selectedValue.value = value;
            }
          },
        );
      }),
    );
  }

  List<Widget> _labTestStatCards() {
    return [
      Obx(
        () => StatCardWidget(
          title: 'Total patients',
          value: labTestControllers.totalPatients.value.toString(),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2C7EDB), Color(0xFFE1F0FF)],
          ),
          imagePath: 'assets/images/box1.png',
        ),
      ),
      Obx(
        () => StatCardWidget(
          title: 'Completed',
          value: labTestControllers.completed.value.toString(),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF00B894), Color(0xFFE3FCFA)],
          ),
          imagePath: 'assets/images/box2.png',
        ),
      ),
      Obx(
        () => StatCardWidget(
          title: 'In-waiting',
          value: labTestControllers.waiting.value.toString(),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF00C9C9), Color(0xFFDFFFFF)],
          ),
          imagePath: 'assets/images/box3.png',
        ),
      ),
      Obx(
        () => StatCardWidget(
          title: 'Cancelled',
          value: labTestControllers.cancelled.value.toString(),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF00B83B), Color(0xFFECFEEE)],
          ),
          imagePath: 'assets/images/box4.png',
        ),
      )
    ];
  }

  Widget labTestStatCard() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // If enough width → show in row
        if (constraints.maxWidth > 1000) {
          return Row(
            children: _labTestStatCards()
                .map(
                  (card) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: card,
                    ),
                  ),
                )
                .toList(),
          );
        }

        // Otherwise wrap automatically
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: _labTestStatCards()
              .map(
                (card) => SizedBox(
                  width: 280,
                  child: card,
                ),
              )
              .toList(),
        );
      },
    );
  }

  Widget _buildTableSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [

          /// Table Header
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: const BoxDecoration(
              color: Color(0xFFF1F5F9),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: const Row(
              children: [
                SizedBox(width: 40),
                Expanded(child: AppText("Test name")),
                Expanded(child: AppText("Category")),
                Expanded(child: AppText("Patient")),
                Expanded(child: AppText("Date")),
                Expanded(child: AppText("Priority")),
                Expanded(child: AppText("Status")),
                SizedBox(width: 100, child: AppText("Action")),
              ],
            ),
          ),

          /// Table Body (Scrollable)
          Expanded(
            child: Obx(() {
              if (labTestControllers.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (labTestControllers.filteredLabTests.isEmpty) {
                return const Center(
                  child: AppText("No test requests found"),
                );
              }

              return SingleChildScrollView(
                child: Column(
                  children: List.generate(
                    labTestControllers.filteredLabTests.length,
                    (index) {
                      final item = labTestControllers.filteredLabTests[index];
                      return _tableRow(context, item, index);
                    },
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _tableRow(BuildContext context, LabTestRequestModel item, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFE2E8F0)),
        ),
      ),
      child: Row(
        children: [

          /// Checkbox
          SizedBox(
            width: 40,
            child: Obx(() => Checkbox(
              value: labTestControllers.isSelected(item.id),
              onChanged: (_) {
                labTestControllers.toggleSelection(item.id);
              },
            )),
          ),

          Expanded(child: AppText(item.testName)),
          Expanded(child: AppText(item.testCategory)),
          Expanded(child: AppText(item.patientName)),
          Expanded(
            child: AppText(
              DateFormat('dd/MM/yyyy').format(item.createdAt),
            ),
          ),

          /// Priority
          Expanded(
            child: Align(
              alignment: AlignmentGeometry.centerLeft,
              child: _statusBadge(
                text: item.priority,
                color: _priorityColor(item.priority),
              ),
            ),
          ),

          /// Status
          Expanded(
            child: Align(
              alignment: AlignmentGeometry.centerLeft,
              child: _statusBadge(
                text: item.status,
                color: _statusColor(item.status),
              ),
            ),
          ),

          /// Actions
          SizedBox(
            width: 100,
            child: Row(
              children: [
                IconButton(
                  onPressed: () => _showTestDetails(context, item),
                  icon: const Icon(Icons.visibility, size: 18,),
                ),
                const SizedBox(width: 6),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.download, size: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _priorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case "urgent":
        return const Color(0xFFE53E3E); // red
      case "routine":
        return const Color(0xFF38A169); // green
      default:
        return const Color(0xFF718096); // gray fallback
    }
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case "waiting":
        return const Color(0xFFED8936); // orange
      case "completed":
        return const Color(0xFF38A169); // green
      case "cancelled":
        return const Color(0xFFE53E3E); // red
      default:
        return const Color(0xFF718096); // gray fallback
    }
  }

  Widget _statusBadge({
    required String text,
    required Color color,
  }) {
    return IntrinsicWidth(
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        child: AppText(
          text,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  void _showTestDetails(BuildContext context, LabTestRequestModel item) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 900,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 30,
                  color: Colors.black26,
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// ================= HEADER =================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          "${item.patientName} - Test Sheet",
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        const SizedBox(height: 6),
                        AppText(
                          "Patient ID: ${item.patientId}",
                          fontSize: 13,
                          color: const Color(0xFF718096),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Get.back(),
                    )
                  ],
                ),

                const SizedBox(height: 30),

                /// ================= BODY =================
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// LEFT COLUMN
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          const AppText(
                            "Patient Information",
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                          const SizedBox(height: 18),

                          _infoRow("Age", "${item.age} years"),
                          _infoRow("Blood Group", item.bloodGroup),
                          _infoRow("Blood Pressure", item.bloodPressure),
                          _infoRow("Sugar", item.sugar),
                          _infoRow("Category", item.testCategory),
                        ],
                      ),
                    ),

                    const SizedBox(width: 60),

                    /// RIGHT COLUMN
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          const AppText(
                            "Test Details",
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                          const SizedBox(height: 18),

                          _infoRow("Test Name", item.testName),
                          _infoRow("Priority", item.priority),
                          _infoRow("Status", item.status),
                          _infoRow(
                            "Date",
                            "${item.createdAt.day}/${item.createdAt.month}/${item.createdAt.year}",
                          ),
                          _infoRow(
                            "Additional Notes",
                            item.additionalRequest.isEmpty
                                ? "-"
                                : item.additionalRequest,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                /// ================= ACTION BUTTONS =================
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    /// VIEW PDF BUTTON
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color(0xFFE53E3E),
                      ),
                      child: TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.picture_as_pdf,
                            color: Colors.white),
                        label: const Text(
                          "View PDF",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 30),

                    /// DOWNLOAD BUTTON
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color(0xFF38A169),
                      ),
                      child: TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.download,
                            color: Colors.white),
                        label: const Text(
                          "Download report",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            child: AppText(
              "$title :",
              fontWeight: FontWeight.w500,
              color: const Color(0xFF4A5568),
            ),
          ),
          Expanded(
            child: AppText(
              value,
              color: const Color(0xFF2D3748),
            ),
          ),
        ],
      ),
    );
  }

}

class RequestNewTestDialog extends StatefulWidget {
  const RequestNewTestDialog({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const RequestNewTestDialog(),
    );
  }

  @override
  State<RequestNewTestDialog> createState() => _RequestNewTestDialogState();
}

class _RequestNewTestDialogState extends State<RequestNewTestDialog> {

  final _formKey = GlobalKey<FormState>();

  String? selectedPatientMongoId;
  String? selectedPatientId;

  final labTestControllers = Get.find<LabTestControllers>();
  final searchController = Get.find<PatientSearchController>();

  // ================= TEXT CONTROLLERS =================

  final TextEditingController patientController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController bloodGroupController = TextEditingController();
  final TextEditingController bloodPressureController = TextEditingController();
  final TextEditingController sugarController = TextEditingController();
  final TextEditingController testNameController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController additionalController = TextEditingController();

  // Dropdown values
  // String selectedPriority = "Routine";
  // String selectedStatus = "Waiting";
  String selectedCategory = "Hematology";

  @override
  void dispose() {
    patientController.dispose();
    ageController.dispose();
    bloodGroupController.dispose();
    bloodPressureController.dispose();
    sugarController.dispose();
    testNameController.dispose();
    categoryController.dispose();
    additionalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.enter): const SubmitIntent(),
        LogicalKeySet(LogicalKeyboardKey.escape): const CloseIntent(),
        LogicalKeySet(
          LogicalKeyboardKey.control,
          LogicalKeyboardKey.keyS,
        ): const SubmitIntent(),
        LogicalKeySet(
          LogicalKeyboardKey.control,
          LogicalKeyboardKey.keyW,
        ): const CloseIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          SubmitIntent: CallbackAction<SubmitIntent>(
            onInvoke: (intent) {
              _submit();
              return null;
            },
          ),
          CloseIntent: CallbackAction<CloseIntent>(
            onInvoke: (intent) {
              Get.back();
              return null;
            },
          ),
        },
        child: Focus(
          autofocus: true,
          child: Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: _dialogBody(), // move your container to method
          ),
        ),
      ),
    );
  }

  // ================= SUBMIT =================

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (selectedPatientMongoId == null) {
      AppSnackbar.show(
        title: "Validation Error",
        message: "Please select a patient",
        type: AppSnackType.warning,
      );
      return;
    }

    labTestControllers.createLabTestRequest(
      patientMongoId: selectedPatientMongoId!,
      patientId: selectedPatientId!,
      patientName: searchController.selectedPatient.value?.name ?? "",
      age: int.parse(ageController.text),
      bloodGroup: bloodGroupController.text,
      bloodPressure: bloodPressureController.text,
      sugar: sugarController.text,
      testName: testNameController.text,
      testCategory: selectedCategory,
      additionalRequest: additionalController.text,
    );
  }

  // ================= FORM =================

  Widget _dialogBody() {
    return Container(
      width: 600,
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppText(
                "Request new test",
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(height: 20),

              _buildFormFields(),

              const SizedBox(height: 30),

              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          width: 140,
          child: AppButton(
            text: "Cancel",
            backgroundColor: Colors.grey.shade600,
            onPressed: () => Get.back(),
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 180,
          child: AppButton(
            text: "Request test",
            backgroundColor: const Color(0xFF2383E2),
            onPressed: _submit,
          ),
        ),
      ],
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        _buildPatientSelector(),
        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(child: _textField("Patient age", ageController, isNumber: true)),
            const SizedBox(width: 16),
            Expanded(child: _textField("Blood group", bloodGroupController)),
          ],
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(child: _textField("Blood pressure", bloodPressureController)),
            const SizedBox(width: 16),
            Expanded(child: _textField("Sugar", sugarController, isNumber: true)),
          ],
        ),
        const SizedBox(height: 16),

        _textField("Test name", testNameController),
        const SizedBox(height: 16),

        _buildCategoryDropdown(),
        const SizedBox(height: 16),

        TextFormField(
          controller: additionalController,
          maxLines: 3,
          decoration: _inputDecoration("Additional request (Optional)"),
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: selectedCategory,
      decoration: _inputDecoration("Test category"),
      items: const [
        "Hematology",
        "Biochemistry",
        "Microbiology",
        "Immunology",
        "Serology",
        "Pathology",
        "Radiology",
        "Cardiology",
        "Endocrinology",
        "Toxicology",
        "Molecular Diagnostics",
      ].map((e) {
        return DropdownMenuItem(
          value: e,
          child: Text(e),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedCategory = value!;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please select test category";
        }
        return null;
      },
    );
  }

  Widget _textField(
    String hint,
    TextEditingController controller, {
    bool isNumber = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: const TextStyle(fontSize: 14),
      decoration: _inputDecoration(hint),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "$hint is required";
        }

        if (isNumber && int.tryParse(value) == null) {
          return "Enter valid number";
        }

        if (hint == "Blood group") {
          final validGroups = [
            "A+", "A-", "B+", "B-",
            "AB+", "AB-", "O+", "O-"
          ];
          if (!validGroups.contains(value.toUpperCase())) {
            return "Invalid blood group";
          }
        }

        return null;
      },
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      isDense: true,
      filled: true,
      fillColor: const Color(0xFFF7FAFC),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
    );
  }

  Widget _buildPatientSelector() {
    return GestureDetector(
      onTap: _openPatientSearchSheet,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF7FAFC),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        alignment: Alignment.centerLeft,
        child: Obx(() {
          final patient = searchController.selectedPatient.value;

          return AppText(
            patient != null
                ? patient.displayName
                : "Search patient",
            color: patient != null
                ? Colors.black
                : Colors.black45,
          );
        }),
      ),
    );
  }

  void _openPatientSearchSheet() {
    searchController.initializeSearch();

    Get.bottomSheet(
      Container(
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          children: [

            /// Search Field
            TextField(
              controller: searchController.searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: "Search patient...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: Obx(() => searchController.isLoading.value
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : const SizedBox()),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: Obx(() {
                final patients = searchController.patients;

                if (searchController.isLoading.value &&
                    patients.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (patients.isEmpty) {
                  return const Center(
                    child: AppText("Start typing to search"),
                  );
                }

                return ListView.builder(
                  itemCount: patients.length,
                  itemBuilder: (context, index) {
                    final patient = patients[index];

                    return ListTile(
                      title: AppText(patient.displayName),
                      onTap: () {

                        searchController.selectPatient(patient);

                        // Save selected values
                        selectedPatientMongoId = patient.id;
                        selectedPatientId = patient.patientId;

                        patientController.text = patient.displayName;

                        searchController.clearSearch();
                        Get.back();
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

}