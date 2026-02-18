import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mdi_icons/flutter_mdi_icons.dart';
import 'package:get/get.dart';

import '../../../controllers/Doctor/vitals_controllers.dart';
import '../../../models/patient_model.dart';
import '../../../models/patient_vitals_model.dart';
import '../../../utils/buttons.dart';
import '../../../utils/constants.dart';
import '../../../utils/enums.dart';
import '../../../utils/labels.dart';
import '../../../utils/text.dart';
import '../../../widgets/add_vitals_dialog.dart';
import '../../../widgets/helper_widgets.dart';

class PatientDetailsVitalsMonitoring extends StatefulWidget {
  final PatientModel patient;
  
  const PatientDetailsVitalsMonitoring({super.key, required this.patient});

  @override
  State<PatientDetailsVitalsMonitoring> createState() => _PatientDetailsVitalsMonitoringState();
}

class _PatientDetailsVitalsMonitoringState extends State<PatientDetailsVitalsMonitoring> {

  final vitalsCtrl = Get.put(VitalsControllers());

  @override
  void initState() {
    super.initState();
    vitalsCtrl.fetchVitals(patientMongoId: widget.patient.id);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          patientVitals(),
          const SizedBox(height: 30),
          _header(),
          const SizedBox(height: 20),
          Expanded(
            child: Obx(() {
              return vitalsCtrl.viewMode.value == VitalsViewMode.table
                ? _vitalTable()
                : _analysisView();
            }),
          ),
        ],
      ),
    );
  }

  Widget patientVitals() {
    return Obx(
      () => Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.info.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.info,
                borderRadius: BorderRadius.circular(10)
              ),
              child: Icon(
                vitalsCtrl.viewMode.value == VitalsViewMode.table
                  ? Mdi.heartPulse
                  : Icons.bar_chart,
                size: 32,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    vitalsCtrl.viewMode.value == VitalsViewMode.table
                      ? "Patient Vital"
                      : "View analysis",
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  AppText(
                    "ID: ${widget.patient.patientId} : Admission ID : ${widget.patient.currentAdmissionCode}",
                    fontSize: 12,
                    color: AppColors.greyText,
                  )
                ],
              )
            ),
          ],
        ),
      )
    );
  }

  Widget _header() {
    return Obx(() {
      final hasSelection = vitalsCtrl.hasSelection;

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText(
            hasSelection
              ? "${vitalsCtrl.selectedVitalIds.length} selected"
              : "Patient Vital",
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),

          Row(
            children: [
              if (hasSelection)
                AppButton(
                  text: "Delete",
                  icon: Icons.delete_outline,
                  backgroundColor: Colors.red,
                  onPressed: _confirmBulkDelete,
                )
              else if (vitalsCtrl.viewMode.value == VitalsViewMode.table) ...[
                AppButton(
                  text: "Chart",
                  icon: Icons.bar_chart,
                  backgroundColor: Colors.green,
                  onPressed: () => vitalsCtrl.showAnalysis(widget.patient.id),
                ),
                const SizedBox(width: 12),
                AppButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => AddVitalDialog(patient: widget.patient),
                    );
                  },
                  text: "Add",
                  icon: Icons.add,
                ),
              ] else
                AppButton(
                  onPressed: vitalsCtrl.showTable,
                  text: "Back to vitals",
                ),
            ],
          ),
        ],
      );
    });
  }

  Widget _vitalTable() {
    return Obx(() {
      if (vitalsCtrl.isLoading.value) {
        return const Padding(
          padding: EdgeInsets.all(40),
          child: Center(child: CircularProgressIndicator()),
        );
      }

      if (vitalsCtrl.vitals.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: const Center(
            child: AppText(
              "No vitals recorded yet",
              color: Colors.grey,
            ),
          ),
        );
      }

      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          children: [
            _tableHeader(),
            const Divider(height: 1),
            Expanded(
              child: ListView.separated(
                itemCount: vitalsCtrl.vitals.length,
                separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey.shade200),
                itemBuilder: (context, index) {
                  return _tableRow(vitalsCtrl.vitals[index]);
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  /// HEADER ROW
  Widget _tableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
      ),
      child: const Row(
        children: [
          SizedBox(width: 40), // checkbox spacing
          _Cell(text: "Date & time", flex: 1, isHeader: true),
          _Cell(text: "Temp.", isHeader: true),
          _Cell(text: "Pulse", isHeader: true),
          _Cell(text: "BP", isHeader: true),
          _Cell(text: "Sugar", isHeader: true),
          _Cell(text: "Notes", flex: 2, isHeader: true),
          _Cell(text: "Action", isHeader: true),
        ],
      ),
    );
  }

  /// DATA ROW
  Widget _tableRow(PatientVitalsModel vital) {
    final id = vital.id;
    final date =
        "${vital.recordedAt.day.toString().padLeft(2, '0')}-"
        "${vital.recordedAt.month.toString().padLeft(2, '0')}-"
        "${vital.recordedAt.year}";

    final time =
        "${vital.recordedAt.hour.toString().padLeft(2, '0')}:"
        "${vital.recordedAt.minute.toString().padLeft(2, '0')}";

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Obx(() => Checkbox(
              value: vitalsCtrl.isSelected(id),
              onChanged: (_) => vitalsCtrl.toggleSelection(id),
              activeColor: AppColors.info,
            )),
          ),

          _Cell(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(date, fontWeight: FontWeight.w500),
                const SizedBox(height: 4),
                AppText(
                  time,
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ],
            ),
          ),

          _Cell(text: "${vital.temperature}°F"),
          _Cell(text: "${vital.pulse} bpm"),
          _Cell(text: vital.bp.isNotEmpty ? vital.bp : "--"),
          _Cell(
            text: vital.bloodSugarLevel.isNotEmpty
                ? "${vital.bloodSugarLevel} mg/dl"
                : "--",
          ),
          _Cell(
            text: vital.notes.isNotEmpty ? vital.notes : "No notes",
            color: Colors.grey,
            flex: 2,
          ),

          _Cell(
            child: Row(
              children: [
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.visibility_outlined, size: 18),
                  onPressed: () {
                    showDialog(
                      context: Get.context!,
                      barrierDismissible: true,
                      builder: (_) => VitalDetailsDialog(vital: vital),
                    );
                  },
                ),
                const SizedBox(width: 4,),
                IconButton(
                  onPressed: () => _confirmSingleDelete(vital),
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(
                    Icons.delete_outline,
                    size: 18,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _analysisView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// FILTERS
        Row(
          children: [
            Expanded(
              child: _vitalDropdown(),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _rangeDropdown(),
            ),
            const SizedBox(width: 16),
            AppButton(
              onPressed: () => vitalsCtrl.printAnalysis(widget.patient),
              text: "Print",
              icon: Icons.print,
            ),
          ],
        ),
        const SizedBox(height: 20),

        /// CHART CARD
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          vitalLabel(vitalsCtrl.selectedVital.value),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        const SizedBox(height: 4),
                        AppText(
                          vitalsCtrl.selectedRange.value == TimeRange.all
                            ? "Showing all records"
                            : "Showing records for last ${timeRangeLabel(vitalsCtrl.selectedRange.value)}",
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                
                    /// STATS
                    Row(
                      children: [
                        vitalsCtrl.selectedVital.value == VitalType.bp
                          ? Row(
                              children: [
                                _statCard(
                                  "Avg Systolic",
                                  "${vitalsCtrl.avgSystolic.toStringAsFixed(0)} mmHg",
                                ),
                                const SizedBox(width: 12),
                                _statCard(
                                  "Avg Diastolic",
                                  "${vitalsCtrl.avgDiastolic.toStringAsFixed(0)} mmHg",
                                ),
                              ],
                            )
                          : _statCard(
                              "Average",
                              "${vitalsCtrl.average.toStringAsFixed(1)} ${vitalUnit(vitalsCtrl.selectedVital.value)}",
                            ),
                        const SizedBox(width: 14,),
                        _statCard(
                          "Min Max",
                          "${vitalsCtrl.minValue.toStringAsFixed(0)} - "
                          "${vitalsCtrl.maxValue.toStringAsFixed(0)} ${vitalUnit(vitalsCtrl.selectedVital.value)}",
                        ),

                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                /// CHART PLACEHOLDER
                Expanded(
                  child: _vitalChart(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String vitalUnit(VitalType type) {
    switch (type) {
      case VitalType.pulse:
        return "bpm";
      case VitalType.temperature:
        return "°F";
      case VitalType.spo2:
        return "%";
      case VitalType.bp:
        return "mmHg";
      case VitalType.respiration:
        return "breaths/min";
      case VitalType.weight:
        return "kg";
      case VitalType.sugar:
        return "mg/dl";
    }
  }

  Widget _vitalDropdown() {
    return Obx(() {
      return dropdownCard<VitalType>(
        title: "Vital sign",
        value: vitalsCtrl.selectedVital.value,
        items: VitalType.values,
        labelBuilder: vitalLabel,
        onChanged: (v) => vitalsCtrl.changeVital(v, widget.patient.id),
      );
    });
  }

  Widget _rangeDropdown() {
    return Obx(() {
      return dropdownCard<TimeRange>(
        title: "Time range",
        value: vitalsCtrl.selectedRange.value,
        items: TimeRange.values,
        labelBuilder: timeRangeLabel,
        onChanged: (r) => vitalsCtrl.changeRange(r, widget.patient.id),
      );
    });
  }

  Widget _statCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(title, fontSize: 12, color: Colors.grey),
          const SizedBox(height: 4),
          AppText(value, fontWeight: FontWeight.w600),
        ],
      ),
    );
  }

  Widget _vitalChart() {
    return Obx(() {
      if (vitalsCtrl.isGraphLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (vitalsCtrl.graphPoints.isEmpty) {
        return const Center(
          child: AppText("No data available", color: Colors.grey),
        );
      }

      final min = vitalsCtrl.selectedVital.value == VitalType.bp
        ? vitalsCtrl.bpMin
        : vitalsCtrl.minValue;

      final max = vitalsCtrl.selectedVital.value == VitalType.bp
        ? vitalsCtrl.bpMax
        : vitalsCtrl.maxValue;
      
      final bpPoints = vitalsCtrl.graphPoints.where((p) => p.systolic != null || p.diastolic != null).toList();

      return LineChart(
        LineChartData(
          minY: min == max ? min - 5 : min - 2,
          maxY: min == max ? max + 5 : max + 2,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 5,
            getDrawingHorizontalLine: (_) => FlLine(color: Colors.grey.shade300, strokeWidth: 1),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 42,
                interval: 5,
                getTitlesWidget: (v, _) => AppText(v.toInt().toString(), fontSize: 11),
              ),
            ),
            bottomTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(
            show: true,
            border: const Border(
              bottom: BorderSide(),
              left: BorderSide()
            )
          ),
          lineBarsData: vitalsCtrl.selectedVital.value == VitalType.bp
            ? [
                /// SYSTOLIC LINE
                LineChartBarData(
                  spots: bpPoints.asMap().entries
                      .where((e) => e.value.systolic != null)
                      .map(
                        (e) => FlSpot(
                          e.key.toDouble(),
                          e.value.systolic!,
                        ),
                      )
                      .toList(),
                  isCurved: true,
                  color: Colors.red,
                  barWidth: 3,
                  dotData: const FlDotData(show: true),
                ),

                /// DIASTOLIC LINE
                LineChartBarData(
                  spots: bpPoints.asMap().entries
                      .where((e) => e.value.diastolic != null)
                      .map(
                        (e) => FlSpot(
                          e.key.toDouble(), // SAME X
                          e.value.diastolic!,
                        ),
                      )
                      .toList(),
                  isCurved: true,
                  color: Colors.blue,
                  barWidth: 3,
                  dotData: const FlDotData(show: true),
                ),
              ]
            : [
                /// NORMAL VITALS LINE
                LineChartBarData(
                  spots: vitalsCtrl.graphPoints.where((p) => p.value != null).toList().asMap().entries.map(
                    (e) => FlSpot(
                      e.key.toDouble(),
                      e.value.value!,
                    ),
                  ).toList(),
                  isCurved: true,
                  color: AppColors.info,
                  barWidth: 3,
                  dotData: const FlDotData(show: true),
                  belowBarData: BarAreaData(
                    show: true,
                    color: AppColors.info.withValues(alpha: 0.15),
                  ),
                ),
              ],
        ),
      );
    });
  }

  void _confirmBulkDelete() {
    Get.dialog(
      AlertDialog(
        title: const AppText("Delete vitals"),
        content: AppText(
          "Are you sure you want to delete "
          "${vitalsCtrl.selectedVitalIds.length} records?",
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const AppText("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              _deleteSelected();
            },
            child: const AppText(
              "Delete",
              color: Colors.red
            ),
          ),
        ],
      ),
    );
  }

  void _deleteSelected() {
    final ids = vitalsCtrl.selectedVitalIds.toList();

    vitalsCtrl.deleteMultipleVitals(
      vitalIds: ids,
      patientMongoId: widget.patient.id,
    );
  }

  void _confirmSingleDelete(PatientVitalsModel vital) {
    Get.dialog(
      AlertDialog(
        title: const AppText("Delete vital"),
        content: AppText(
          "Delete vital recorded on "
          "${vital.recordedAt.day}/${vital.recordedAt.month}/${vital.recordedAt.year}?",
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const AppText("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              vitalsCtrl.deleteVital(
                vitalId: vital.id,
                patientMongoId: widget.patient.id,
              );
            },
            child: const AppText(
              "Delete",
              color: Colors.red
            ),
          ),
        ],
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  final String? text;
  final Widget? child;
  final int flex;
  final bool isHeader;
  final Color? color;

  const _Cell({
    this.text,
    this.child,
    this.flex = 1,
    this.isHeader = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: child ??
          AppText(
            text ?? "",
            fontSize: isHeader ? 13 : 12,
            fontWeight: isHeader ? FontWeight.w600 : FontWeight.w500,
            color: color ?? (isHeader ? Colors.grey.shade700 : Colors.black),
          ),
      ),
    );
  }
}

class VitalDetailsDialog extends StatelessWidget {
  final PatientVitalsModel vital;

  const VitalDetailsDialog({super.key, required this.vital});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.info.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.monitor_heart,
                      color: AppColors.info,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const AppText(
                    "Vital Signs Details",
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              _row("Recorded At", _formattedDateTime()),
              _row("Temperature", _val(vital.temperature, "°C")),
              _row("Pulse", _val(vital.pulse, "bpm")),
              _row("Blood Pressure", vital.bp.isNotEmpty ? vital.bp : "Not recorded"),
              _row("Blood Sugar", _val(vital.bloodSugarLevel, "mg/dL")),
              _row("SpO₂", _val(vital.spo2, "%")),
              _row("Respiration", _val(vital.respirationRate, "breaths/min")),
              _row("Weight", _val(vital.weight, "kg")),
              _row("Notes", vital.notes.isNotEmpty ? vital.notes : "No notes"),

              const SizedBox(height: 20),

              /// ACTION
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const AppText("Close"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ---------------- HELPERS ----------------

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: AppText(
              label,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
          Expanded(
            child: AppText(value, maxLines: 4),
          ),
        ],
      ),
    );
  }

  String _val(dynamic v, String unit) {
    if (v == null || v.toString().isEmpty) return "Not recorded";
    return "$v $unit";
  }

  String _formattedDateTime() {
    final d = vital.recordedAt;
    return "${d.day.toString().padLeft(2, '0')} "
        "${_month(d.month)} ${d.year} - "
        "${d.hour.toString().padLeft(2, '0')}:"
        "${d.minute.toString().padLeft(2, '0')}";
  }

  String _month(int m) {
    const months = [
      "Jan","Feb","Mar","Apr","May","Jun",
      "Jul","Aug","Sep","Oct","Nov","Dec"
    ];
    return months[m - 1];
  }
}