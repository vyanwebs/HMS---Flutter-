import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/Doctor/followup_controllers.dart';
import '../../../models/health_status_model.dart';
import '../../../models/patient_model.dart';
import '../../../utils/buttons.dart';
import '../../../utils/constants.dart';
import '../../../utils/string_utils.dart';
import '../../../utils/text.dart';
import '../../../widgets/patient_avatar_widget.dart';

class PatientDetailsFollowUps extends StatefulWidget {
  final PatientModel patient;

  const PatientDetailsFollowUps({super.key, required this.patient});

  @override
  State<PatientDetailsFollowUps> createState() => _PatientDetailsFollowUpsState();
}

class _PatientDetailsFollowUpsState extends State<PatientDetailsFollowUps> {
  final followupControllers = Get.put(FollowupControllers());

  @override
  void initState() {
    super.initState();
    followupControllers.fetchVitals(widget.patient.id, 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20), 
            
            _buildHeader(),

            const SizedBox(height: 30),

            _buildTabs(),

            const SizedBox(height: 20),

            Expanded(
              child: Obx(() {
                if (followupControllers.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildPatientCard(),
                      const SizedBox(height: 30),
                      _buildTrendSection(),
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
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
                child: const Icon(Icons.bar_chart, color: Colors.white, size: 28)
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    "Patient followups",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  AppText(
                    "Analysis of patient follow ups",
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ],
              )
            ],
          ),
          Row(
            children: [
              AppButton(
                onPressed: () {
                  final currentTab = followupControllers.selectedTab.value;

                  followupControllers.fetchVitals(
                    widget.patient.id,
                    currentTab,
                  );
                },
                text: "Refresh",
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                borderRadius: 8,
                fontSize: 12,
              ),
              const SizedBox(width: 12),
              AppButton(
                onPressed: () {},
                text: "Print pdf",
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                borderRadius: 8,
                fontSize: 12,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Obx(() {
      final selected = followupControllers.selectedTab.value;

      return Row(
        children: [
          _buildTab("2 hr follow ups", 2, selected),
          const SizedBox(width: 40),
          _buildTab("4 hr follow ups", 4, selected),
        ],
      );
    });
  }

  Widget _buildTab(String title, int value, int selected) {
    final isSelected = value == selected;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => followupControllers.changeTab(value, widget.patient.id),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              title,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.blue : Colors.black54,
            ),
            const SizedBox(height: 6),
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: 3,
              width: isSelected ? 160 : 0,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientCard() {
    return Obx(() {
      final isTwoHr = followupControllers.selectedTab.value == 2;

      final vital = isTwoHr
        ? followupControllers.twoHourVital.value
        : followupControllers.fourHourVital.value;

      if (vital == null) {
        return Container(
          padding: const EdgeInsets.all(40),
          alignment: Alignment.center,
          child: const AppText(
            "No vitals recorded",
            fontSize: 14,
            color: Colors.black54,
          ),
        );
      }

      final latest = vital;

      final bpStatus = _getBpStatus(latest.bp);
      final pulseStatus = _getPulseStatus(latest.pulse);
      final tempStatus = _getTempStatus(latest.temperature);
      final spo2Status = _getSpo2Status(latest.spo2);

      return Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// ================= TOP SECTION =================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    PatientAvatar(
                      name: widget.patient.name,
                      imageUrl: widget.patient.avatar?.url,
                      googleDriveLink: widget.patient.avatar?.googleDriveLink,
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          widget.patient.name,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                        const SizedBox(height: 4),
                        AppText(
                          "Bed ${extractBedNumber(widget.patient.currentBedAssign)} • Ward-${extractWardFromBedAssign(widget.patient.currentBedAssign)}",
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ],
                ),

                /// Updated time
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _statusBadgeHealth(widget.patient.currentHealthCondition),
                    const SizedBox(height: 6),
                    AppText(
                      _formatTime(latest.recordedAt),
                      fontSize: 12,
                      color: Colors.black45,
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 35),

            /// ================= VITALS =================
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;

                // Decide number of columns based on screen width
                int columns = 4;
                if (width < 900) columns = 3;
                if (width < 600) columns = 1;

                final itemWidth = (width - ((columns - 1) * 24)) / columns;

                return Wrap(
                  spacing: 24,
                  runSpacing: 30,
                  children: [
                    _vitalItem(
                      width: itemWidth,
                      icon: Icons.favorite,
                      title: "Blood Pressure",
                      value: latest.bp,
                      status: bpStatus,
                    ),
                    _vitalItem(
                      width: itemWidth,
                      icon: Icons.monitor_heart,
                      title: "Pulse Rate",
                      value: "${latest.pulse}",
                      status: pulseStatus,
                    ),
                    _vitalItem(
                      width: itemWidth,
                      icon: Icons.thermostat,
                      title: "Temperature",
                      value: "${latest.temperature}°F",
                      status: tempStatus,
                    ),
                    _vitalItem(
                      width: itemWidth,
                      icon: Icons.bloodtype,
                      title: "Oxygen Sat.",
                      value: "${latest.spo2}%",
                      status: spo2Status,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      );
    });
  }

  Widget _statusBadgeHealth(String status) {
    final statusConfig = _healthStatusConfig(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusConfig.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        statusConfig.label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: statusConfig.color,
        ),
      ),
    );
  }

  HealthStatusConfig _healthStatusConfig(String status) {
    switch (status.toLowerCase()) {
      case 'critical':
        return const HealthStatusConfig(
          label: 'Critical',
          color: Color(0xFFE53E3E), // Red
        );

      case 'serious':
        return const HealthStatusConfig(
          label: 'Serious',
          color: Color(0xFFDD6B20), // Orange
        );

      case 'moderate':
        return const HealthStatusConfig(
          label: 'Moderate',
          color: Color(0xFFD69E2E), // Yellow
        );

      case 'mild':
        return const HealthStatusConfig(
          label: 'Mild',
          color: Color(0xFF3182CE), // Blue
        );

      case 'stable':
      default:
        return const HealthStatusConfig(
          label: 'Stable',
          color: Color(0xFF38A169), // Green
        );
    }
  }

  Widget _buildTrendSection() {
    return Obx(() {
      final isTwoHr = followupControllers.selectedTab.value == 2;

      final vitals = isTwoHr
          ? followupControllers.twoHourVitals
          : followupControllers.fourHourVitals;

      if (vitals.isEmpty) return const SizedBox();

      return Wrap(
        spacing: 24,
        runSpacing: 24,
        children: [
          _bpTrendCard(vitals),

          _singleVitalTrendCard(
            title: "Pulse Rate",
            vitals: vitals,
            valueGetter: (v) => v.pulse.toDouble(),
            color: Colors.green,
            maxY: 150,
          ),

          _singleVitalTrendCard(
            title: "Temperature",
            vitals: vitals,
            valueGetter: (v) => v.temperature,
            color: Colors.orange,
            maxY: 110,
          ),

          _singleVitalTrendCard(
            title: "Oxygen Saturation (%)",
            vitals: vitals,
            valueGetter: (v) => v.spo2.toDouble(),
            color: Colors.orange,
            maxY: 100,
          ),
        ],
      );
    });
  }

  Widget _vitalItem({
    required double width,
    required IconData icon,
    required String title,
    required String value,
    required String status,
  }) {
    final isHigh = status == "High";
    final isLow = status == "Low";

    Color color = Colors.green;
    if (isHigh) color = Colors.red;
    if (isLow) color = Colors.orange;

    return SizedBox(
      width: width,
      child: Column(
        children: [
          Container(
            width: 85,
            height: 85,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.12),
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(height: 14),
          AppText(title, fontSize: 12),
          const SizedBox(height: 6),
          AppText(
            value,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 8),
          _statusBadge(status),
        ],
      ),
    );
  }

  Widget _bpTrendCard(List<VitalFollowUp> vitals, {double width = 350}) {
    if (vitals.isEmpty) return const SizedBox();

    final dataToShow = vitals;

    return _trendContainer(
      "Blood Pressure",
      width,
      BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 200,
          titlesData: _chartTitles(dataToShow),
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: false),
          barGroups: List.generate(dataToShow.length, (index) {
            final parts = dataToShow[index].bp.split('/');

            final systolic = parts.isNotEmpty ? double.tryParse(parts[0]) ?? 0 : 0;

            final diastolic = parts.length > 1 ? double.tryParse(parts[1]) ?? 0 : 0;

            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: systolic.toDouble(),
                  width: 8,
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(4),
                ),
                BarChartRodData(
                  toY: diastolic.toDouble(),
                  width: 8,
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }),
        ),
      ),
      legend: _bpLegend(),
    );
  }

  Widget _singleVitalTrendCard({
    required String title,
    required List<VitalFollowUp> vitals,
    required double Function(VitalFollowUp) valueGetter,
    required Color color,
    double maxY = 150,
    double width = 350,
  }) {
    if (vitals.isEmpty) return const SizedBox();

    final latestTwo = vitals.length >= 2
        ? vitals.sublist(vitals.length - 2)
        : vitals;

    return _trendContainer(
      title,
      width,
      BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxY,
          titlesData: _chartTitles(latestTwo),
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: false),
          barGroups: List.generate(latestTwo.length, (index) {
            final value = valueGetter(latestTwo[index]);

            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: value,
                  width: 12,
                  color: color,
                  borderRadius: BorderRadius.circular(6),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _trendContainer(
    String title,
    double width,
    Widget chart, {
    Widget? legend,
  }) {
    return Container(
      width: width,
      height: 280,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(title, fontWeight: FontWeight.w600),
          const SizedBox(height: 16),

          SizedBox(
            height: 170,
            child: chart,
          ),

          const Spacer(),

          if (legend != null) legend,
        ],
      ),
    );
  }

  FlTitlesData _chartTitles(List<VitalFollowUp> vitals) {
    return FlTitlesData(
      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            if (value.toInt() >= vitals.length) {
              return const SizedBox();
            }

            final date = vitals[value.toInt()].recordedAt;
            final hour = date?.hour ?? 0;
            final displayHour = hour > 12 ? hour - 12 : hour;
            final period = hour >= 12 ? "PM" : "AM";

            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: AppText(
                "$displayHour $period",
                fontSize: 10,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _statusBadge(String status) {
    final isHigh = status == "High";
    final isLow = status == "Low";

    Color bg = Colors.green.shade100;
    Color text = Colors.green;

    if (isHigh) {
      bg = Colors.red.shade100;
      text = Colors.red;
    } else if (isLow) {
      bg = Colors.orange.shade100;
      text = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: AppText(
        status,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: text,
      ),
    );
  }

  String _getBpStatus(String bp) {
    final parts = bp.split('/');
    if (parts.length != 2) return "Normal";

    final systolic = int.tryParse(parts[0]) ?? 0;

    if (systolic >= 140) return "High";
    if (systolic < 90) return "Low";
    return "Normal";
  }

  String _getPulseStatus(int pulse) {
    if (pulse > 100) return "High";
    if (pulse < 60) return "Low";
    return "Normal";
  }

  String _getTempStatus(double temp) {
    if (temp > 99.5) return "High";
    if (temp < 97) return "Low";
    return "Normal";
  }

  String _getSpo2Status(int spo2) {
    if (spo2 < 94) return "Low";
    return "Normal";
  }

  String _formatTime(DateTime? date) {
    if (date == null) return "Updated just now";
    final difference = DateTime.now().difference(date).inMinutes;
    return "Updated $difference min ago";
  }
  
  Widget _bpLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _legendItem(Colors.red, "Systolic"),
        const SizedBox(width: 20),
        _legendItem(Colors.blue, "Diastolic"),
      ],
    );
  }

  Widget _legendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        AppText(
          text,
          fontSize: 12,
          color: Colors.black54,
        ),
      ],
    );
  }

}
