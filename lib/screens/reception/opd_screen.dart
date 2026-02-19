import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/Reception/opd_registration_controller.dart';
import '../../utils/buttons.dart';
import '../../utils/images.dart';
import '../../utils/snackbar.dart';
import '../../utils/text.dart';
import '../../widgets/patient_selector_widget.dart';

class OPDScreen extends StatelessWidget {
  OPDScreen({super.key});

  final controller = Get.find<OPDRegistrationController>();

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
                  ? _emergencyForm()
                  : _opdForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ========================= OPD FORM =============================

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

  // ================== OPD FIRST STEP =======================
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
          child: AppButton(
            onPressed: () => controller.opdStep.value = 1,
            text: "Continue",
          ),
        ),
      ],
    );
  }

  // ================== OPD SECOND STEP =======================
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
                        backgroundImage: AssetImage(userImage),
                      ),
                      // PatientAvatar(patient: ,)
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
                child: AppButton(
                  onPressed: () => controller.opdStep.value = 0,
                  backgroundColor: Colors.grey,
                  text: "Back",
                ),
              ),
              const SizedBox(width: 20),
              SizedBox(
                width: 160,
                child: AppButton(
                  onPressed: () => controller.opdStep.value = 2,
                  backgroundColor: Colors.green,
                  text: "Assign Doctor",
                )
              ),
            ],
          )
        ],
      ),
    );
  }

  // ================== OPD THIRD STEP =======================
  Widget _assignDoctorStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// Step Title
        const AppText(
          "Assign Doctor",
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),

        const SizedBox(height: 20),

        /// Patient Info Card (Top strip)
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFE8EEF5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFF2383E2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.person, color: Colors.white),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    "Patient ID - #Pat1234567",
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: 4),
                  AppText(
                    "Admission ID - 1234567899",
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ],
              )
            ],
          ),
        ),

        const SizedBox(height: 25),

        const AppText(
          "Available doctors",
          fontWeight: FontWeight.w600,
        ),

        const SizedBox(height: 16),

        /// Doctors Grid
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;

            int crossAxisCount;

            if (width < 600) {
              crossAxisCount = 1; // Mobile
            } else if (width < 840) {
              crossAxisCount = 2; // Tablet portrait
            } else if (width < 1200) {
              crossAxisCount = 3; // Tablet landscape / small desktop
            } else {
              crossAxisCount = 4; // Desktop
            }

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 10,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                mainAxisExtent: 260, // MUCH better than aspectRatio
              ),
              itemBuilder: (context, index) {
                return _doctorCard(index);
              },
            );
          },
        ),

        const SizedBox(height: 30),

        /// Bottom Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                controller.opdStep.value = 1;
              },
              child: const AppText("Back"),
            ),
            const SizedBox(width: 15),
            AppButton(
              onPressed: controller.selectedDoctor.value.isEmpty
                ? null
                : () {
                    controller.opdStep.value = 3;
                  },
              text: "Continue",
            ),
          ],
        ),
      ],
    );
  }

  Widget _doctorCard(int index) {
    const doctorName = "Dr. Jennifer Davis";
    final doctorKey = doctorName + index.toString();

    return Obx(() {
      final isSelected =
          controller.selectedDoctor.value == doctorKey;

      return InkWell(
        onTap: () {
          controller.selectedDoctor.value = doctorKey;
        },
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF2383E2)
                  : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
              )
            ],
          ),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 35,
                backgroundImage: AssetImage(userImage),
              ),
              const SizedBox(height: 12),
              const AppText(
                "Dr. Jennifer Davis",
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(height: 6),
              const AppText(
                "drjennifer@gmail.com",
                fontSize: 11,
                color: Colors.black54,
              ),
              const SizedBox(height: 4),
              const AppText(
                "Experience - 2 years",
                fontSize: 11,
                color: Colors.black54,
              ),
              const SizedBox(height: 4),
              const AppText(
                "Assigned patients - 15",
                fontSize: 11,
                color: Colors.black54,
              ),
              const Spacer(),
              Container(
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFF2383E2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const AppText(
                  "Assign patient",
                  color: Colors.white,
                  fontSize: 12,
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  // ================== OPD LAST STEP =======================
  Widget _finalReviewStep() {
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
            "OPD Registration - Final Review",
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),

          const SizedBox(height: 30),

          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
            
                /// LEFT SIDE – Patient Card
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
                          backgroundImage: AssetImage(userImage),
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
                        ),
            
                        const SizedBox(height: 20),
            
                        Divider(color: Colors.grey.shade300),
            
                        const SizedBox(height: 15),
            
                        /// 🔵 Assigned Doctor
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.medical_services_outlined,
                              size: 16,
                              color: Color(0xFF2383E2)
                            ),
                            SizedBox(width: 6),
                            AppText(
                              "Assigned doctor - Dr. Ankit Sharma",
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
            
                const SizedBox(width: 25),
            
                /// RIGHT SIDE – Basic Info
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
          ),

          const SizedBox(height: 35),

          /// Bottom Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              SizedBox(
                width: 120,
                child: AppButton(
                  onPressed: () => controller.opdStep.value = 2,
                  backgroundColor: Colors.grey,
                  text: "Back",
                ),
              ),

              const SizedBox(width: 20),

              SizedBox(
                width: 180,
                child: AppButton(
                  onPressed: () {},
                  text: "Register patient",
                )
              ),
            ],
          )
        ],
      ),
    );
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
  
  // ================== EMERGENCY FORM =======================
  Widget _emergencyForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildEmergencyStepper(),
        const SizedBox(height: 25),

        Expanded(
          child: Obx(() {
            switch (controller.currentStep.value) {
              case 1:
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: _buildEmergencyPersonalInfoCard()
                );
              case 2:
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: _buildEmergencyDetailsStep()
                );
              case 3:
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: _buildBedAssignmentStep()
                );
              default:
                return const SizedBox();
            }
          }),
        ),
      ],
    );
  }

  Widget _buildEmergencyStepper() {
    return Obx(() {
      final step = controller.currentStep.value - 1;

      return Container(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 30),
        decoration: BoxDecoration(
          color: const Color(0xFFEFF3F8),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            _emergencyStepItem(0, "Patient Info", step),
            _stepLine(step >= 1),
            _emergencyStepItem(1, "Emergency Details", step),
            _stepLine(step >= 2),
            _emergencyStepItem(2, "Review", step),
          ],
        ),
      );
    });
  }

  Widget _emergencyStepItem(int index, String title, int currentStep) {
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

  // ================== EMERGENCY FIRST STEP ======================
  Widget _buildEmergencyPersonalInfoCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
    
        /// Section Title
        const Row(
          children: [
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
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: 120,
              child: AppButton(
                onPressed: () {
                  // If this is first step, maybe do nothing or exit
                  controller.currentStep.value = 1; 
                },
                backgroundColor: Colors.grey,
                text: "Back",
              ),
            ),
            const SizedBox(width: 15),
            SizedBox(
              width: 140,
              child: AppButton(
                onPressed: () {
                  controller.currentStep.value = 2;
                },
                text: "Continue",
              ),
            ),
          ],
        ),

      ],
    );
  }

  // ================== EMERGENCY SECOND STEP ======================
  Widget _buildEmergencyDetailsStep() {
    return Form(
      key: controller.emergencyDetailsFormKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const AppText(
              "Emergency Details",
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),

            const SizedBox(height: 25),

            /// ===================== MAIN CARD =====================
            _sectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// Department + Staff
                  Row(
                    children: [
                      Expanded(
                        child: _dropdownFormField(
                          label: "Department *",
                          items: ["Cardiology", "Orthopedic", "General"],
                          onChanged: (v) => controller.department.value = v ?? "",
                          validator: (v) =>
                              v == null || v.isEmpty ? "Required" : null,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _dropdownFormField(
                          label: "Attending Staff",
                          items: ["Dr. Smith", "Dr. John"],
                          onChanged: (v) => controller.attendingStaff.value = v ?? "",
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  /// Triage Level
                  const AppText("Triage Level *"),
                  const SizedBox(height: 10),
                  Obx(() => Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: ["Immediate", "Urgent", "Semi-Urgent", "Non-Urgent"]
                            .map((e) => _selectionChip(
                                  label: e,
                                  selected: controller.triageLevel.value == e,
                                  onTap: () => controller.triageLevel.value = e,
                                ))
                            .toList(),
                      )),

                  const SizedBox(height: 25),

                  /// Arrival Mode
                  const AppText("Arrival Mode *"),
                  const SizedBox(height: 10),
                  Obx(() => Wrap(
                        spacing: 12,
                        children: ["Ambulance", "Walk-in", "Referral"]
                            .map((e) => _selectionChip(
                                  label: e,
                                  selected: controller.arrivalMode.value == e,
                                  onTap: () => controller.arrivalMode.value = e,
                                ))
                            .toList(),
                      )),

                  const SizedBox(height: 25),

                  /// Chief Complaint
                  _textFormField(
                    label: "Chief Complaint *",
                    hint: "Describe the main complaint...",
                    maxLines: 3,
                    validator: (v) =>
                        v == null || v.isEmpty ? "Required" : null,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            /// ===================== VITAL SIGNS =====================
            _sectionCard(
              title: "Vital Signs (Optional)",
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _textFormField(
                          label: "Blood Pressure",
                          hint: "120/80",
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _textFormField(
                          label: "Heart Rate",
                          hint: "72",
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            if (v != null && v.isNotEmpty) {
                              if (int.tryParse(v) == null) {
                                return "Invalid number";
                              }
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: _textFormField(
                          label: "Temperature",
                          hint: "98.6",
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _textFormField(
                          label: "Oxygen Saturation",
                          hint: "98",
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            if (v != null && v.isNotEmpty) {
                              final value = int.tryParse(v);
                              if (value == null || value < 0 || value > 100) {
                                return "0 - 100 only";
                              }
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            /// ===================== NOTES =====================
            _sectionCard(
              title: "Additional Notes",
              child: _textFormField(
                hint: "Any additional information...",
                maxLines: 3,
              ),
            ),

            const SizedBox(height: 35),

            /// Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 120,
                  child: AppButton(
                    onPressed: () => controller.currentStep.value = 1,
                    backgroundColor: Colors.grey,
                    text: "Back",
                  ),
                ),
                const SizedBox(width: 15),
                SizedBox(
                  width: 140,
                  child: AppButton(
                    onPressed: () {
                      if (controller.emergencyDetailsFormKey.currentState!
                          .validate()) {

                        if (controller.triageLevel.value.isEmpty) {
                          AppSnackbar.show(
                            title: "Error",
                            message: "Select triage level",
                            type: AppSnackType.error
                          );
                          return;
                        }

                        if (controller.arrivalMode.value.isEmpty) {
                          AppSnackbar.show(
                            title: "Error",
                            message: "Select arrival mode",
                            type: AppSnackType.error
                          );
                          return;
                        }

                        controller.currentStep.value = 3;
                      }
                    },
                    text: "Continue",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionCard({String? title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            AppText(title, fontWeight: FontWeight.w600),
            const SizedBox(height: 20),
          ],
          child,
        ],
      ),
    );
  }

  Widget _dropdownFormField({
    required String label,
    required List<String> items,
    String? Function(String?)? validator,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      validator: validator,
      onChanged: onChanged,
    );
  }

  Widget _textFormField({
    String? label,
    String? hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _selectionChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF2383E2) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: AppText(
          label,
          color: selected ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  // ================== EMERGENCY THIRD STEP ======================
  Widget _buildBedAssignmentStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const AppText(
          "Bed Assignment",
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),

        const SizedBox(height: 25),

        /// ================= Ward Dropdown =================
        _sectionCard(
          child: Obx(() => DropdownButtonFormField<String>(
                value: controller.selectedWard.value,
                decoration: InputDecoration(
                  labelText: "Select Ward",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: [
                  "General Ward (40 Beds)",
                  "ICU (10 Beds)",
                  "Private Ward (15 Beds)"
                ]
                    .map((e) =>
                        DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) =>
                    controller.selectedWard.value = v ?? "",
              )),
        ),

        const SizedBox(height: 25),

        /// ================= Stats Row =================
        Obx(() => Row(
              children: [
                _statCard(
                    "Total Beds",
                    controller.totalBeds.value.toString(),
                    Icons.bed_outlined,
                    Colors.blue),
                const SizedBox(width: 20),
                _statCard(
                    "Available",
                    controller.availableBeds.value.toString(),
                    Icons.check_circle_outline,
                    Colors.green),
                const SizedBox(width: 20),
                _statCard(
                    "Occupied",
                    controller.occupiedBeds.value.toString(),
                    Icons.person_outline,
                    Colors.red),
                const SizedBox(width: 20),
                _statCard(
                    "Occupancy Rate",
                    "${((controller.occupiedBeds.value / controller.totalBeds.value) * 100).toStringAsFixed(1)}%",
                    Icons.calendar_today_outlined,
                    Colors.orange),
              ],
            )),

        const SizedBox(height: 30),

        const Center(
          child: AppText(
            "Bed Layout - General Ward",
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 20),

        /// ================= Bed Grid =================
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;

            int crossAxisCount;
            if (width < 600) {
              crossAxisCount = 4;
            } else if (width < 900) {
              crossAxisCount = 6;
            } else {
              crossAxisCount = 8;
            }

            return Obx(() => GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.totalBeds.value,
                  gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    mainAxisExtent: 70,
                  ),
                  itemBuilder: (context, index) {
                    final bedNumber = "A-${index + 1}";
                    final isOccupied =
                        index >= controller.availableBeds.value;
                    final isSelected =
                        controller.selectedBed.value == bedNumber;

                    return InkWell(
                      onTap: isOccupied
                          ? null
                          : () => controller.selectedBed.value =
                              bedNumber,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isOccupied
                              ? Colors.red.shade50
                              : Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF2383E2)
                                : isOccupied
                                    ? Colors.red.shade300
                                    : Colors.green.shade300,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            Icon(
                              isOccupied
                                  ? Icons.person
                                  : Icons.check_circle,
                              size: 18,
                              color: isOccupied
                                  ? Colors.red
                                  : Colors.green,
                            ),
                            const SizedBox(height: 4),
                            AppText(
                              bedNumber,
                              fontSize: 12,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ));
          },
        ),

        const SizedBox(height: 35),

        /// ================= Bottom Buttons =================
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: 120,
              child: AppButton(
                onPressed: () => controller.currentStep.value = 2,
                backgroundColor: Colors.grey,
                text: "Back",
              ),
            ),
            const SizedBox(width: 20),
            SizedBox(
              width: 180,
              child: AppButton(
                onPressed: controller.selectedBed.value.isEmpty
                    ? null
                    : () {
                        // Submit logic
                      },
                text: "Register patient",
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _statCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F9FC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 18),
                ),
                const Spacer(),
                AppText(
                  value,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                )
              ],
            ),
            const SizedBox(height: 10),
            AppText(
              title,
              fontSize: 12,
              color: Colors.black54,
            ),
          ],
        ),
      ),
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
