import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/Doctor/patient_search_controllers.dart';
import '../utils/text.dart';

class CustomPatientSearchField extends StatelessWidget {
  final String label;
  final Function(PatientModel?)? onChanged;

  const CustomPatientSearchField({
    super.key,
    this.label = "Select patient",
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PatientSearchController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(label.isNotEmpty)...[
          AppText(label, fontSize: 12),
          const SizedBox(height: 6),
        ],

        /// Selector Field
        InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => _openBottomSheet(context, controller),
          child: Obx(() {
            final patient = controller.selectedPatient.value;

            return Container(
              height: 46,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Expanded(
                    child: AppText(
                      patient != null
                        ? patient.displayName
                        : "Search patient",
                      color: patient != null ? Colors.black : Colors.black45,
                    ),
                  ),
                  const Icon(
                    Icons.search,
                    size: 18,
                    color: Colors.black45
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }

  void _openBottomSheet(
      BuildContext context, PatientSearchController controller) {
    Get.bottomSheet(
      Container(
        height: MediaQuery.of(context).size.height * 0.75,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          children: [

            /// Drag Handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),

            const SizedBox(height: 16),

            /// Search Field
            TextField(
              controller: controller.searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: "Search patient...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: Obx(() => controller.isLoading.value
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(
                              strokeWidth: 2),
                        ),
                      )
                    : const SizedBox()),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// Patient List
            Expanded(
              child: Obx(() {
                final patients = controller.patients;

                if (controller.isLoading.value &&
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
                        controller.selectPatient(patient);
                        controller.clearSearch();
                        onChanged?.call(patient);
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
