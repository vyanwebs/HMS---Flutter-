import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controllers/doctor_search_controller.dart';
import '../models/doctor_model.dart';
import '../utils/text.dart';

class DoctorSearchField extends StatelessWidget {

  final Function(DoctorModel)? onDoctorSelected;
  final FocusNode? focusNode;

  DoctorSearchField({super.key, this.onDoctorSelected, this.focusNode,});

  final DoctorSearchController controller = Get.put(DoctorSearchController(), tag: UniqueKey().toString());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// SEARCH FIELD
        Shortcuts(
          shortcuts: {
            LogicalKeySet(LogicalKeyboardKey.arrowDown): const NextFocusIntent(),
            LogicalKeySet(LogicalKeyboardKey.arrowUp): const PreviousFocusIntent(),
            LogicalKeySet(LogicalKeyboardKey.enter): const ActivateIntent(),
            LogicalKeySet(LogicalKeyboardKey.escape): const DismissIntent(),
          },
          child: Actions(
            actions: {
              /// 🔥 DOWN ARROW
              NextFocusIntent: CallbackAction<NextFocusIntent>(
                onInvoke: (_) {
                  controller.moveDown();
                  return null;
                },
              ),

              /// 🔥 UP ARROW
              PreviousFocusIntent: CallbackAction<PreviousFocusIntent>(
                onInvoke: (_) {
                  controller.moveUp();
                  return null;
                },
              ),
              
              ActivateIntent: CallbackAction<ActivateIntent>(
                onInvoke: (_) {
                  controller.selectHighlightedDoctor();
                  final doctor = controller.selectedDoctor.value;
                  if (doctor != null) {
                    onDoctorSelected?.call(doctor);
                  }
                  return null;
                },
              ),

              DismissIntent: CallbackAction<DismissIntent>(
                onInvoke: (_) {
                  controller.clearResults();
                  return null;
                },
              ),
            },
            child: TextFormField(
              focusNode: focusNode,
              controller: controller.searchController,
              onChanged: controller.onSearchChanged,
              decoration: InputDecoration(
                hintText: "Search doctor...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: const Color(0xffF5F6F7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),

        /// RESULT LIST
        Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (controller.doctors.isEmpty) {
            return const SizedBox();
          }

          return Obx(
            () => Container(
              margin: const EdgeInsets.only(top: 8),
              constraints: const BoxConstraints(maxHeight: 220),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: ListView.builder(
                itemCount: controller.doctors.length,
                itemBuilder: (_, i) {
                  final isHighlighted = controller.highlightedIndex.value == i;
                  final doctor = controller.doctors[i];

                  final isUnavailable =
                      !doctor.isAvailableToday ||
                      doctor.staffStatus != "ACTIVE" ||
                      doctor.hasLeftHospital;

                  return InkWell(
                    onTap: isUnavailable
                      ? null
                      : () {
                          controller.selectDoctor(doctor);

                          onDoctorSelected?.call(doctor);
                        },
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      color: isHighlighted
                        ? Colors.blue.withValues(alpha: .08)
                        : isUnavailable
                            ? Colors.grey.withValues(alpha: .05)
                            : null,
                      child: Row(
                        children: [

                          /// DOCTOR INFO
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  doctor.name,
                                  fontWeight: FontWeight.w500,
                                  color: isUnavailable
                                    ? Colors.grey
                                    : Colors.black,
                                ),

                                const SizedBox(height: 2),

                                AppText(
                                  "${doctor.specialty} • ${doctor.department}",
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),

                          /// STATUS BADGE
                          if (isUnavailable)
                            _statusTag(
                              "Unavailable",
                              Colors.red,
                            )
                          else
                            _statusTag(
                              "Available",
                              Colors.green,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              )
            )
          );
        }),
      ],
    );
  }

  Widget _statusTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: AppText(
        text,
        fontSize: 11,
        color: color,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}