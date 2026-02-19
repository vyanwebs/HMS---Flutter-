import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/Reception/reception_ipd_controllers.dart';
import '../../utils/buttons.dart';
import '../../utils/text.dart';
import '../../widgets/doctor_panel/stat_card_widget.dart';

class IPDScreen extends StatelessWidget {
  IPDScreen({super.key});

  final ipdControllers = Get.put(ReceptionIPDControllers());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [

          /// ================= STAT CARDS =================
          _statCards(),

          const SizedBox(height: 25),

          /// ================= MAIN BODY =================
          Expanded(
            child: Row(
              children: [

                /// LEFT - PATIENT LIST
                Expanded(
                  flex: 3,
                  child: _patientsList(),
                ),

                const SizedBox(width: 25),

                /// RIGHT - IPD DETAILS
                Expanded(
                  flex: 5,
                  child: _ipdDetailsPanel(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // ==============================================================
  // STAT CARDS (Like your dashboard)
  // ==============================================================

  Widget _statCards() {
    return Row(
      children: [

        Expanded(
          child: StatCardWidget(
            title: "Total patients",
            value: "30",
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF2C7EDB), Color(0xFFE1F0FF)],
            ),
            imagePath: 'assets/images/box1.png',
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: StatCardWidget(
            title: "Bed assigned",
            value: "20",
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF00B894), Color(0xFFE3FCFA)],
            ),
            imagePath: 'assets/images/box2.png',
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: StatCardWidget(
            title: "Need update",
            value: "12",
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF00C9C9), Color(0xFFDFFFFF)],
            ),
            imagePath: 'assets/images/box3.png',
          ),
        ),
      ],
    );
  }

  // ==============================================================
  // LEFT PANEL – PATIENT LIST
  // ==============================================================

  Widget _patientsList() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const AppText(
            "Patients list",
            fontWeight: FontWeight.w600,
          ),

          const SizedBox(height: 15),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 6,
              itemBuilder: (_, index) => _patientTile(index),
            ),
          ),
        ],
      ),
    );
  }

  Widget _patientTile(int index) {
    return Obx(() {
      final isSelected = ipdControllers.selectedIndex.value == index;

      return InkWell(
        onTap: () => ipdControllers.selectedIndex.value = index,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isSelected
              ? const Color(0xFFEAF2FF)
              : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                ? const Color(0xFF2C7EDB)
                : const Color(0xFFE2E8F0),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// ===== Top Row =====
              Row(
                children: [

                  const CircleAvatar(radius: 18),
                  // PatientAvatar(patient: ,),
                  const SizedBox(width: 10),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          "John Smith",
                          fontWeight: FontWeight.w600,
                        ),
                        SizedBox(height: 4),
                        AppText(
                          "Age : 45 yr / male",
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),

                  _greyChip("No bed assigned"),
                ],
              ),

              const SizedBox(height: 12),

              /// ===== Bottom Row =====
              Row(
                children: [

                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          "Bed : B-205",
                          fontSize: 12,
                        ),
                        SizedBox(height: 4),
                        AppText(
                          "Ward : General",
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),

                  _redOutlineChip("Need update"),
                ],
              )
            ],
          ),
        ),
      );
    });
  }

  Widget _greyChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: AppText(
        text,
        fontSize: 11,
        color: Colors.black87,
      ),
    );
  }

  Widget _redOutlineChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.red),
      ),
      child: const AppText(
        "Need update",
        fontSize: 11,
        color: Colors.red,
      ),
    );
  }

  // ==============================================================
  // RIGHT PANEL – IPD DETAILS
  // ==============================================================

  Widget _ipdDetailsPanel() {
    return Container(
      decoration: _cardDecoration(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// ================= PATIENT HEADER =================
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF3F8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [

                  const CircleAvatar(radius: 24),

                  const SizedBox(width: 12),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          "Maria George",
                          fontWeight: FontWeight.w600,
                        ),
                        SizedBox(height: 4),
                        AppText(
                          "ID: PAT123 • Age: 23 • Male",
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _statusChip(
                        "IPD details pending",
                        Colors.orange,
                      ),
                      const SizedBox(height: 6),
                      _statusChip(
                        "Admit note - ICU",
                        Colors.green,
                      ),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// ================= IPD DETAILS =================
            const AppText(
              "IPD details",
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),

            const SizedBox(height: 20),

            _label("Reason for admission"),
            const SizedBox(height: 6),
            _textField("Enter reason for admission"),

            const SizedBox(height: 18),

            _label("Symptoms"),
            const SizedBox(height: 6),
            _textField("Enter patient symptoms"),

            const SizedBox(height: 18),

            _label("Initial diagnosis"),
            const SizedBox(height: 6),
            _textField("Enter diagnosis"),

            const SizedBox(height: 30),

            /// ================= BED ASSIGNMENT =================
            const AppText(
              "Bed assignment",
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),

            const SizedBox(height: 15),

            _dropdownField(),

            const SizedBox(height: 20),

            const AppText(
              "Available beds",
              fontWeight: FontWeight.w500,
            ),

            const SizedBox(height: 12),

            Wrap(
              spacing: 14,
              runSpacing: 14,
              children: List.generate(
                10,
                (index) => _styledBedBox(
                  "A-${index + 1}",
                  index == 0,     // selected
                  index == 2 || index == 4, // occupied sample
                ),
              ),
            ),

            const SizedBox(height: 35),
            _depositManagementSection(),
          ],
        ),
      ),
    );
  }

  Widget _depositManagementSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// ===== Title =====
        const AppText(
          "Deposit management",
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),

        const SizedBox(height: 15),

        /// ===== Receipt Summary Strip =====
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF2FB),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [

              /// Header Row
              Row(
                children: [
                  const Icon(Icons.account_balance_wallet_outlined, size: 18),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: AppText(
                      "Deposit receipt (1 Generated)",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const AppText(
                      "Total Rs 1870",
                      fontSize: 11,
                      color: Colors.blue,
                    ),
                  )
                ],
              ),

              const SizedBox(height: 15),

              /// Receipt Card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [

                    /// Receipt Number Circle
                    Container(
                      width: 30,
                      height: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.blue),
                      ),
                      child: const AppText(
                        "1",
                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(width: 12),

                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            "Rs 880",
                            fontWeight: FontWeight.w600,
                          ),
                          SizedBox(height: 4),
                          AppText(
                            "Receipt id - Rec123456789",
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 2),
                          AppText(
                            "04-02-2025 • 8:24 a.m.",
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),

                    Icon(Icons.visibility_outlined,
                        size: 18, color: Colors.grey.shade600),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 30),

        /// ===== Add New Deposit Receipt =====
        const AppText(
          "Add new deposit receipt",
          fontWeight: FontWeight.w600,
        ),

        const SizedBox(height: 15),

        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            children: [

              Row(
                children: [

                  /// Amount Field
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AppText("Create deposit receipt"),
                        const SizedBox(height: 6),
                        _textField("Enter deposit amount"),
                      ],
                    ),
                  ),

                  const SizedBox(width: 20),

                  /// Payment Mode
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AppText("Payment mode"),
                        const SizedBox(height: 6),
                        _dropdownField(),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppText("Remark (optional)"),
                  const SizedBox(height: 6),
                  _textField("Enter remark"),
                ],
              ),

              const SizedBox(height: 20),

              AppButton(
                onPressed: () {},
                text: "Create deposit receipt",
              ),
            ],
          ),
        ),

        const SizedBox(height: 35),

        /// ===== Bottom Buttons =====
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AppButton(
              onPressed: () {},
              icon: Icons.receipt,
              iconIsLast: false,
              text: "Generate IPD Bill",
            ),
            const SizedBox(width: 15),
            AppButton(
              onPressed: () {},
              icon: Icons.receipt,
              iconIsLast: false,
              backgroundColor: Colors.grey,
              text: "Update & assign bed",
            ),
          ],
        ),
      ],
    );
  }

  Widget _statusChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: AppText(
        text,
        fontSize: 11,
        color: color,
      ),
    );
  }

  Widget _label(String text) {
    return AppText(
      text,
      fontSize: 13,
      fontWeight: FontWeight.w500,
    );
  }

  Widget _styledBedBox(
    String label,
    bool selected,
    bool occupied,
  ) {
    Color bgColor;
    Color borderColor;

    if (selected) {
      bgColor = const Color(0xFFDFF7E6);
      borderColor = Colors.green;
    } else if (occupied) {
      bgColor = Colors.grey.shade300;
      borderColor = Colors.grey;
    } else {
      bgColor = Colors.grey.shade200;
      borderColor = Colors.grey.shade400;
    }

    return Container(
      width: 70,
      height: 70,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            selected
                ? Icons.check_circle
                : occupied
                    ? Icons.lock
                    : Icons.bed_outlined,
            size: 18,
            color: borderColor,
          ),
          const SizedBox(height: 4),
          AppText(
            label,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }

  // ==============================================================
  // COMMON UI
  // ==============================================================

  Widget _textField(String hint) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF7F9FC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
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
      ),
      items: const [
        DropdownMenuItem(value: "general", child: Text("General ward")),
        DropdownMenuItem(value: "icu", child: Text("ICU")),
      ],
      onChanged: (v) {},
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFFE2E8F0)),
    );
  }
}
