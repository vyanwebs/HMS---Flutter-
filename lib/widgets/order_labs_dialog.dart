import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/lab_order_controller.dart';
import '../utils/text.dart';

class OrderLabsDialog extends StatelessWidget {
  OrderLabsDialog({
    super.key,
    required this.patientName,
    required this.patientId,
  });

  final String patientName;
  final String patientId;

  final controller = Get.put(LabOrderController());

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(30),
      child: Container(
        width: 1100,
        height: 720,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            /// HEADER
            _header(),

            const SizedBox(height: 20),

            Expanded(
              child: Row(
                children: [

                  /// LEFT SIDE
                  Expanded(flex: 3, child: _leftPanel()),

                  const VerticalDivider(),

                  /// RIGHT SIDE
                  Expanded(flex: 2, child: _orderSummary()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppText(
              "Order Laboratory Tests",
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
            AppText(
              "Patient: $patientName ($patientId)",
              color: Colors.grey,
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Get.back(),
        )
      ],
    );
  }

  Widget _leftPanel() {
    return Column(
      children: [

        /// SEARCH
        TextField(
          onChanged: (v) => controller.search.value = v,
          decoration: InputDecoration(
            hintText: "Search tests...",
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),

        const SizedBox(height: 14),

        _categories(),

        const SizedBox(height: 14),

        Expanded(
          child: Obx(
            () => ListView(
            children: controller.filteredTests.map(_testTile).toList(),
          )),
        )
      ],
    );
  }

  Widget _categories() {
    final categories = [
      "All",
      "Hematology",
      "Biochemistry",
      "Cardiac Markers",
      "Radiology"
    ];

    return Obx(
      () => Wrap(
        spacing: 8,
        children: categories.map((c) {
          final active = controller.selectedCategory.value == c;

          return ChoiceChip(
            label: Text(c),
            selected: active,
            onSelected: (_) => controller.selectedCategory.value = c,
          );
        }).toList(),
      )
    );
  }

  Widget _testTile(LabTestModel test) {
    return Obx(() {
      final selected = test.selected.value;

      return InkWell(
        onTap: () => controller.toggleTest(test),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: selected
              ? Colors.blue.withValues(alpha: 0.08)
              : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? Colors.blue : Colors.grey.shade300,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      test.name,
                      fontWeight: FontWeight.w500
                    ),
                    AppText(
                      "₹${test.price}",
                      color: Colors.grey
                    ),
                  ],
                ),
              ),

              if (selected)
                const Icon(
                  Icons.check_circle,
                  color: Colors.blue
                ),
            ],
          ),
        ),
      );
    });
  }

  Widget _orderSummary() {
    return Obx(() {
      final selected = controller.selectedTests;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const AppText(
            "Order Summary",
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),

          const SizedBox(height: 12),

          /// SELECTED TESTS
          Expanded(
            child: selected.isEmpty
                ? const Center(
                    child: AppText("No tests selected")
                  )
                : ListView(
                    children: selected.map((t) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppText(t.name),
                                  AppText(
                                    "₹${t.price}",
                                    color: Colors.grey
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => controller.toggleTest(t),
                            )
                          ],
                        ),
                      );
                    }).toList(),
                  ),
          ),

          const SizedBox(height: 10),

          _priority(),

          const SizedBox(height: 10),

          _notes(),

          const SizedBox(height: 10),

          _totalCost(),

          const SizedBox(height: 14),

          _submitButtons(),
        ],
      );
    });
  }

  Widget _priority() {
    final options = ["ROUTINE", "URGENT", "STAT"];

    return Obx(
      () => Row(
        children: options.map((p) {
          final active = controller.priority.value == p;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(p),
              selected: active,
              onSelected: (_) => controller.priority.value = p,
            ),
          );
        }).toList(),
      )
    );
  }

  Widget _notes() {
    return TextField(
      maxLines: 3,
      onChanged: (v) => controller.notes.value = v,
      decoration: InputDecoration(
        hintText: "Reason for ordering these tests...",
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _totalCost() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const AppText("Total Cost"),
          AppText(
            "₹${controller.totalCost.toStringAsFixed(0)}",
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }

  Widget _submitButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: controller.selectedTests.isEmpty
              ? null
              : () {
                  /// API CALL HERE
                },
            child: const Text("Submit Lab Order"),
          ),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => Get.back(),
          child: const Text("Cancel"),
        )
      ],
    );
  }
}