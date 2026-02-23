import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hms/utils/buttons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../controllers/Reception/external_doctor_controller.dart';
import '../../models/reception_panel/external_doctor_model.dart';
import '../../utils/text.dart';

class ExternalDoctorScreen extends StatelessWidget {
  const ExternalDoctorScreen({super.key});

  Future<void> _launchEmail(String email) async {
    final Uri emailUri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  void _openAddDoctorDialog() {
    final formKey = GlobalKey<FormState>();
    final controller = Get.find<ExternalDoctorController>();

    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final passwordCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();
    final expCtrl = TextEditingController();

    String? selectedSpec;
    String? selectedDept;

    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          width: 850,
          padding: const EdgeInsets.all(35),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppText("Admin / view",
                      color: Colors.grey, fontSize: 13),
                  const SizedBox(height: 6),
                  const AppText("Add new doctor",
                      fontSize: 22, fontWeight: FontWeight.bold),
                  const SizedBox(height: 30),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- LEFT COLUMN: Personal Info ---
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const AppText("Personal information",
                                color: Colors.grey),
                            const SizedBox(height: 18),
                            _label("Full name"),
                            _field(nameCtrl, "Enter full name",
                                validator: (v) =>
                                    v!.isEmpty ? "Enter name" : null),
                            _label("Email"),
                            _field(emailCtrl, "Enter email", validator: (v) {
                              if (v == null || v.isEmpty)
                                return "Email is required";
                              if (!GetUtils.isEmail(v))
                                return "Enter a valid email address";
                              return null;
                            }),
                            _label("Phone number"),
                            _field(phoneCtrl, "Enter phone number",
                                isNumeric: true, validator: (v) {
                              if (v == null || v.isEmpty)
                                return "Phone number is required";

                              // Matches your backend regex: starts with 6-9 and followed by 9 digits
                              final phoneRegex = RegExp(r'^[6-9]\d{9}$');

                              if (!phoneRegex.hasMatch(v)) {
                                return "Enter a valid Indian phone number";
                              }
                              return null;
                            }),
                            _label("Password"),
                            _field(passwordCtrl, "Enter password",
                                obscure: true,
                                validator: (v) =>
                                    v!.length < 6 ? "Min 6 characters" : null),
                            _label("Confirm password"),
                            _field(confirmCtrl, "**********", obscure: true,
                                validator: (v) {
                              if (v!.isEmpty) return "Please confirm password";
                              if (v != passwordCtrl.text)
                                return "Passwords do not match";
                              return null;
                            }),
                          ],
                        ),
                      ),
                      const SizedBox(width: 40),
                      // --- RIGHT COLUMN: Professional Info ---
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const AppText("Professional information",
                                color: Colors.grey),
                            const SizedBox(height: 18),
                            _label("Speciality"),
                            _dropdown(
                              hint: "Select speciality",
                              items: [
                                "Anesthesiology",
                                "Neurology",
                                "Cardiology",
                                "General"
                              ],
                              onChanged: (v) => selectedSpec = v,
                            ),
                            _label("Department"),
                            _dropdown(
                              hint: "Select department",
                              items: controller.departments
                                  .where((d) => d != "All")
                                  .toList(),
                              onChanged: (v) => selectedDept = v,
                            ),
                            _label("Year of experience"),
                            _field(
                              expCtrl,
                              "e.g. 5",
                              isNumeric: true,
                              validator: (v) =>
                                  v!.isEmpty ? "Enter experience" : null,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                          width: 110,
                          child: AppButton(
                              text: "Cancel",
                              onPressed: () => Get.back(),
                              backgroundColor: Colors.grey.shade500)),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 160,
                        child: AppButton(
                          text: "Register doctor",
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              controller.registerDoctor(
                                name: nameCtrl.text,
                                email: emailCtrl.text,
                                phone: phoneCtrl.text,
                                password: passwordCtrl.text,
                                confirmPassword: confirmCtrl.text,
                                specialty: selectedSpec ?? "",
                                experience: expCtrl.text,
                                department: selectedDept ?? "",
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: AppText(text, fontWeight: FontWeight.w600, fontSize: 13),
      );

  Widget _field(TextEditingController ctrl, String hint,
      {bool obscure = false,
      bool isNumeric = false,
      String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: ctrl,
        obscureText: obscure,
        validator: validator,
        // Restricts input at the keyboard level
        inputFormatters: isNumeric
            ? [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))]
            : null,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          errorStyle:
              const TextStyle(fontSize: 11, height: 0.8), // Slim error text
        ),
      ),
    );
  }

  Widget _dropdown(
      {required String hint,
      required List<String> items,
      required Function(String?) onChanged}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: DropdownButtonFormField<String>(
        items: items
            .map((e) =>
                DropdownMenuItem(value: e, child: AppText(e, fontSize: 14)))
            .toList(),
        onChanged: onChanged,
        validator: (v) => v == null ? "Required" : null,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ExternalDoctorController());
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppText("Admin / Dashboard",
                color: Colors.grey, fontSize: 13),
            const SizedBox(height: 15),
            Obx(() => _DoctorStatCard(
                value: controller.totalDoctorsCount.toString())),
            const SizedBox(height: 30),
            _buildTableContainer(controller),
          ],
        ),
      ),
    );
  }

  Widget _buildTableContainer(ExternalDoctorController controller) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            _buildToolbar(controller),
            _buildTableHeader(),
            Expanded(
              child: Obx(() => controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.separated(
                      itemCount: controller.doctors.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final doc = controller.doctors[index];
                        return _buildDataRow(doc, controller);
                      },
                    )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolbar(ExternalDoctorController controller) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          SizedBox(
            width: 320,
            height: 40,
            child: TextField(
              onChanged: controller.updateSearch,
              decoration: InputDecoration(
                hintText: "Search",
                prefixIcon: const Icon(Icons.search, size: 20),
                filled: true,
                fillColor: const Color(0xFFF7FAFC),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
                color: const Color(0xFFF7FAFC),
                borderRadius: BorderRadius.circular(8)),
            child: Obx(() => DropdownButton<String>(
                  value: controller.selectedDepartment.value,
                  underline: const SizedBox(),
                  items: controller.departments
                      .map((e) => DropdownMenuItem(value: e, child: AppText(e)))
                      .toList(),
                  onChanged: controller.updateDepartment,
                )),
          ),
          const Spacer(),
          AppButton(
              text: "Add new doctor",
              onPressed: _openAddDoctorDialog,
              icon: Icons.add,
              iconSize: 18,
              iconIsLast: false,),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      color: const Color(0xFFF7FAFC),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      child: const Row(
        children: [
          Expanded(
              flex: 3,
              child: AppText("User",
                  fontWeight: FontWeight.bold, color: Colors.grey)),
          Expanded(
              flex: 2,
              child: AppText("Department",
                  fontWeight: FontWeight.bold, color: Colors.grey)),
          Expanded(
              flex: 2,
              child: AppText("Experience",
                  fontWeight: FontWeight.bold, color: Colors.grey)),
          Expanded(
              flex: 2,
              child: AppText("Contact",
                  fontWeight: FontWeight.bold, color: Colors.grey)),
          Expanded(
              flex: 1,
              child: Align(
                  alignment: Alignment.centerRight,
                  child: AppText("Action",
                      fontWeight: FontWeight.bold, color: Colors.grey))),
        ],
      ),
    );
  }

  Widget _buildDataRow(
      ExternalDoctor doc, ExternalDoctorController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      child: Row(
        children: [
          Expanded(
              flex: 3,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(doc.name, fontWeight: FontWeight.bold),
                    AppText(doc.email, color: Colors.grey, fontSize: 12),
                  ])),
          Expanded(flex: 2, child: AppText(doc.department)),
          Expanded(
              flex: 2,
              child: AppText(controller.formatExperience(doc.experience))),
          Expanded(flex: 2, child: AppText(doc.phone)),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () => _launchEmail(doc.email),
                    icon: const Icon(Icons.email_outlined,
                        size: 20, color: Colors.grey)),
                IconButton(
                    onPressed: () => controller.deleteDoctor(doc.id),
                    icon: const Icon(Icons.delete_outline,
                        size: 20, color: Colors.redAccent)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DoctorStatCard extends StatelessWidget {
  final String value;
  const _DoctorStatCard({required this.value});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: 320,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
              colors: [Color(0xFF4A90E2), Color(0xFFBFE0FF)])),
      child: Row(
        children: [
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText(value,
                            fontSize: 30, fontWeight: FontWeight.bold),
                        const AppText("Total Doctors",
                            fontSize: 14, color: Colors.black87),
                      ]))),
          Image.asset('assets/images/box1.png', width: 100, height: 100),
        ],
      ),
    );
  }
}
