import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/Doctor/patient_search_controllers.dart';
import '../../controllers/Reception/opd_registration_controller.dart';
import '../../utils/buttons.dart';
import '../../utils/text.dart';
import '../../widgets/patient_selector_widget.dart';

class OPDScreen extends StatelessWidget {
  OPDScreen({super.key});

  final controller = Get.find<OPDRegistrationController>();
  final searchController = Get.find<PatientSearchController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20,),
              /// Tabs
              Row(
                children: [
                  _buildTopTab(
                    "OPD",
                    !controller.isEmergency.value,
                    () => controller.isEmergency.value = false,
                  ),
                  const SizedBox(width: 30),
                  _buildTopTab(
                    "Emergency",
                    controller.isEmergency.value,
                    () => controller.isEmergency.value = true,
                  ),
                ],
              ),

              const SizedBox(height: 25),

              /// 🔥 IMPORTANT: Give Stepper remaining height
              Expanded(
                child: controller.isEmergency.value
                  ? SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: _emergencyForm(),
                    )
                  : _opdForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _opdForm() {
    return Column(
      children: [
        _buildOPDStepper(),

        const SizedBox(height: 25),

        Expanded(
          child: Obx(() {
            switch (controller.opdStep.value) {
              case 0:
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: _opdRegistrationStep(),
                );

              case 1:
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: _opdReviewStep(),
                );

              case 2:
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: _assignDoctorStep(),
                );

              case 3:
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: _finalReviewStep(),
                );

              default:
                return const SizedBox();
            }
          }),
        ),
      ],
    );
  }

  Widget _buildOPDStepper() {
    return Obx(() {
      final step = controller.opdStep.value;

      return Container(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 30),
        decoration: BoxDecoration(
          color: const Color(0xFFEFF3F8),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            _stepItem(0, "OPD registration", step),
            _stepLine(step >= 1),
            _stepItem(1, "Review", step),
            _stepLine(step >= 2),
            _stepItem(2, "Assign doctor", step),
            _stepLine(step >= 3),
            _stepItem(3, "Review", step),
          ],
        ),
      );
    });
  }

  Widget _stepItem(int index, String title, int currentStep) {
    final isActive = index == currentStep;
    final isCompleted = index < currentStep;

    return Expanded(
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive
                ? const Color(0xFF2383E2)
                : isCompleted
                    ? const Color(0xFF2383E2)
                    : Colors.grey.shade300,
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 20)
                  : Text(
                      "${index + 1}",
                      style: TextStyle(
                        color: isActive ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 8),
          AppText(
            title,
            fontSize: 13,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            color: Colors.black87,
          )
        ],
      ),
    );
  }

  Widget _stepLine(bool isActive) {
    return Container(
      height: 2,
      width: 60,
      color: isActive
        ? const Color(0xFF2383E2)
        : Colors.grey.shade300,
    );
  }

  Widget _opdRegistrationStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        _sectionHeader("OPD Registration"),

        const SizedBox(height: 25),

        _searchSection(),
        const SizedBox(height: 25),

        _personalInfoSection(),
        const SizedBox(height: 25),

        _visitInfoSection(),
        const SizedBox(height: 25),

        _photoUploadSection(),

        const SizedBox(height: 30),

        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: () {
              controller.opdStep.value = 1;
            },
            child: const Text("Continue"),
          ),
        ),
      ],
    );
  }

  Widget _opdReviewStep() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const AppText(
            "OPD Registration - Review",
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),

          const SizedBox(height: 25),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// Patient Card
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F9FC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 45,
                        backgroundImage: AssetImage("assets/avatar.png"),
                      ),
                      const SizedBox(height: 15),
                      const AppText(
                        "Jennifer Davis",
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const AppText(
                          "OPD",
                          fontSize: 12,
                        ),
                      )
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 25),

              /// Basic Info Card
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F9FC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        "Basic information",
                        fontWeight: FontWeight.w600,
                      ),
                      SizedBox(height: 15),
                      AppText("Age : 23 years"),
                      SizedBox(height: 8),
                      AppText("Gender : Male"),
                      SizedBox(height: 8),
                      AppText("Contact : +91 9876543210"),
                      SizedBox(height: 8),
                      AppText("Address : Pune"),
                      SizedBox(height: 8),
                      AppText("Weight : 55 kg"),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          /// Bottom Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 120,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                  ),
                  onPressed: () {
                    controller.opdStep.value = 0;
                  },
                  child: const Text("Edit"),
                ),
              ),
              const SizedBox(width: 20),
              SizedBox(
                width: 160,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () {
                    controller.opdStep.value = 2;
                  },
                  child: const Text("Assign Doctor"),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _assignDoctorStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const AppText(
          "Assign Doctor",
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),

        const SizedBox(height: 25),

        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            children: [

              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  hintText: "Select doctor",
                  filled: true,
                  fillColor: const Color(0xFFF7F9FC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: const [
                  DropdownMenuItem(
                    value: "Dr. Ankit Birla",
                    child: Text("Dr. Ankit Birla"),
                  ),
                  DropdownMenuItem(
                    value: "Dr. Rahul Mehta",
                    child: Text("Dr. Rahul Mehta"),
                  ),
                ],
                onChanged: (val) {
                  controller.selectedDoctor.value = val ?? "";
                },
              ),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      controller.opdStep.value = 1;
                    },
                    child: const Text("Back"),
                  ),
                  const SizedBox(width: 15),
                  ElevatedButton(
                    onPressed: () {
                      controller.opdStep.value = 3;
                    },
                    child: const Text("Continue"),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _finalReviewStep() {
    return Container();
  }

  Widget _sectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE6EDF5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.person_add_alt_1, color: Color(0xFF2383E2)),
          const SizedBox(width: 10),
          AppText(
            title,
            fontWeight: FontWeight.w600,
          )
        ],
      ),
    );
  }

  Widget _emergencyForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// 🔵 Title
        const AppText(
          "Emergency Registration",
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),

        const SizedBox(height: 20),

        _buildEmergencyStepIndicator(),

        const SizedBox(height: 25),

        _buildEmergencyPersonalInfoCard(),

        const SizedBox(height: 30),

        _buildEmergencyBottomBar(),
      ],
    );
  }

  Widget _buildEmergencyStepIndicator() {
    return Obx(() {
      final step = controller.currentStep.value;

      return Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F4F8),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _emergencyStepItem(1, "Patient Info", "Basic details", step),
            _emergencyStepItem(2, "Emergency Details", "Medical information", step),
            _emergencyStepItem(3, "Review", "Confirm & admit", step),
          ],
        ),
      );
    });
  }

  Widget _emergencyStepItem(
    int number,
    String title,
    String subtitle,
    int currentStep,
  ) {
    final active = number == currentStep;

    return Column(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor:
              active ? const Color(0xFF2383E2) : Colors.grey.shade300,
          child: AppText(
            "$number",
            color: active ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 6),
        AppText(title, fontWeight: FontWeight.w600),
        AppText(
          subtitle,
          fontSize: 12,
          color: Colors.grey,
        ),
      ],
    );
  }

  Widget _buildEmergencyPersonalInfoCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
    
        /// Section Title
        Row(
          children: const [
            Icon(Icons.person_outline, size: 20),
            SizedBox(width: 8),
            AppText(
              "Personal Information",
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
    
        const SizedBox(height: 20),
    
        /// Full Name
        _requiredLabel("Full Name"),
        const SizedBox(height: 6),
        _textField("Enter patient's full name"),
    
        const SizedBox(height: 20),
    
        /// Gender + DOB
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _requiredLabel("Gender"),
                  const SizedBox(height: 8),
                  Obx(
                    () => Row(
                      children: [
                        _genderButton("Male"),
                        const SizedBox(width: 10),
                        _genderButton("Female"),
                        const SizedBox(width: 10),
                        _genderButton("Other"),
                      ],
                    )
                  ),
                ],
              ),
            ),
    
            const SizedBox(width: 20),
    
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _requiredLabel("Date of Birth"),
                  const SizedBox(height: 6),
                  _dateField(),
                ],
              ),
            ),
          ],
        ),
    
        const SizedBox(height: 20),
    
        /// Contact
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _requiredLabel("Contact Number"),
                  const SizedBox(height: 6),
                  _textField("Enter mobile number", icon: Icons.phone),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppText("Emergency Contact"),
                  const SizedBox(height: 6),
                  _textField("Emergency contact number", icon: Icons.person),
                ],
              ),
            ),
          ],
        ),
    
        const SizedBox(height: 20),
    
        /// Address
        const AppText("Address"),
        const SizedBox(height: 6),
        _textField("Current address", icon: Icons.location_on_outlined),
    
        const SizedBox(height: 20),
    
        /// ID Section
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppText("ID Type"),
                  const SizedBox(height: 6),
                  _dropdownField(),
                  const SizedBox(height: 4),
                  const AppText(
                    "For patient identification",
                    fontSize: 12,
                    color: Colors.grey,
                  )
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppText("ID Number"),
                  const SizedBox(height: 6),
                  _textField("Enter ID number"),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmergencyBottomBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () {},
          child: const Text("Previous"),
        ),
        Row(
          children: [
            TextButton(
              onPressed: () {},
              child: const Text("Cancel"),
            ),
            const SizedBox(width: 15),
            SizedBox(
              width: 120,
              height: 42,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2383E2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Continue"),
              ),
            )
          ],
        )
      ],
    );
  }

  Widget _requiredLabel(String text) {
    return RichText(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
        children: const [
          TextSpan(
            text: " *",
            style: TextStyle(color: Colors.red),
          )
        ],
      ),
    );
  }

  Widget _dropdownField() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF7F9FC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
      items: const [
        DropdownMenuItem(value: "aadhaar", child: Text("Aadhaar")),
        DropdownMenuItem(value: "pan", child: Text("PAN Card")),
        DropdownMenuItem(value: "passport", child: Text("Passport")),
      ],
      onChanged: (v) {},
    );
  }

  Widget _buildTopTab(String title, bool active, VoidCallback onTap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            AppText(
              title,
              fontWeight: FontWeight.w600,
              color: active ? Colors.black : Colors.grey,
            ),
            const SizedBox(height: 6),
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 40,
              height: 3,
              color: active ? Colors.black : Colors.transparent,
            )
          ],
        ),
      ),
    );
  }

  Widget _searchSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText(
          "Search existing patients",
          fontWeight: FontWeight.w600
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: CustomPatientSearchField(
                label: "",
                onChanged: (patient) {
                  if (kDebugMode) {
                    print(patient?.displayName);
                  }
                },
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _textField(
                "Patient id result"
              )
            ),
          ],
        )
      ],
    );
  }

  Widget _personalInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText(
          "Personal information",
          fontWeight: FontWeight.w600
        ),
        const SizedBox(height: 15),

        _textField("Enter full name"),

        const SizedBox(height: 15),

        Row(
          children: [
            Expanded(child: _textField("Age")),
            const SizedBox(width: 15),
            Expanded(child: _textField("Weight")),
            const SizedBox(width: 15),
            Expanded(child: _textField("Phone number")),
          ],
        ),

        const SizedBox(height: 15),

        _textField("Address"),

        const SizedBox(height: 15),

        const AppText("Gender"),
        const SizedBox(height: 10),

        Obx(
          () => Row(
            children: [
              _genderButton("Male"),
              const SizedBox(width: 15),
              _genderButton("Female"),
              const SizedBox(width: 15),
              _genderButton("Others"),
            ],
          )
        )
      ],
    );
  }

  Widget _visitInfoSection() {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFFE6EDF5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.refresh, color: Color(0xFF2383E2)),
            const SizedBox(width: 12),
            const Expanded(child: AppText("Is this revisit?")),
            Switch(
              value: controller.isRevisit.value,
              onChanged: (v) => controller.isRevisit.value = v,
            )
          ],
        ),
      )
    );
  }

  Widget _photoUploadSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE6EDF5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.image, color: Colors.blue),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppText(
                  "Upload image",
                  fontWeight: FontWeight.w600
                ),
                const SizedBox(height: 6),
                const AppText(
                  "Please upload clear image of the patient face.",
                  color: Colors.grey,
                ),
                const SizedBox(height: 10),
                AppButton(
                  onPressed: controller.pickImage,
                  text: "Upload image",
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _textField(
    String hint, {
    IconData? icon,
  }) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: icon != null ? Icon(icon, size: 18) : null,
        filled: true,
        fillColor: const Color(0xFFF7F9FC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
    );
  }

  Widget _dateField() {
    return TextField(
      readOnly: true,
      onTap: () async {
        final date = await showDatePicker(
          context: Get.context!,
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
          initialDate: DateTime.now(),
        );

        if (date != null) {
          controller.selectedDate.value = date;
        }
      },
      decoration: InputDecoration(
        hintText: "Select date",
        suffixIcon: const Icon(Icons.calendar_today),
        filled: true,
        fillColor: const Color(0xFFF7F9FC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _genderButton(String label) {
    final isActive = controller.gender.value == label;

    return Expanded(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => controller.gender.value = label,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 45,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isActive
                  ? const Color(0xFF2383E2)
                  : Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: AppText(
              label,
              color: isActive ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
