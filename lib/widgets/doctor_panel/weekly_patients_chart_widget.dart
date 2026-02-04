import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../models/weekly_patients_chart_model.dart';
import '../../utils/text.dart';

class PatientStatisticsChart extends StatelessWidget {
  final List<String> labels;
  final List<PatientChartData> data;

  const PatientStatisticsChart({
    super.key,
    required this.labels,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppText(
            'OPD/IPD/Emergency patients this week',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: LineChart(_chartData()),
          ),
          const SizedBox(height: 12),
          _legend(),
        ],
      ),
    );
  }

  // ================= CHART CONFIG =================

  LineChartData _chartData() {
    return LineChartData(
      extraLinesData: const ExtraLinesData(),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: _yInterval(),
        getDrawingHorizontalLine: (_) => const FlLine(color: Color(0xFFE2E8F0), strokeWidth: 1),
      ),
      titlesData: FlTitlesData(
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 50,
            getTitlesWidget: (value, _) => Text('${value.toInt()}', style: _axisText),
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            interval: 1,
            showTitles: true,
            getTitlesWidget: (value, _) {
              int index = value.toInt();
              if (index < 0 || index >= labels.length) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(labels[index], style: _axisText),
              );
            },
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: (labels.length - 1).toDouble(),
      minY: 0,
      maxY: _maxY() + _yInterval(),
      lineBarsData: [
        _line(data.map((e) => e.ipd).toList(),
            const Color(0xFF3B82F6)),
        _line(data.map((e) => e.opd).toList(),
            const Color(0xFF22C55E)),
        _line(data.map((e) => e.emergency).toList(),
            const Color(0xFFF87171)),
      ],
    );
  }

  LineChartBarData _line(List<double> values, Color color) {
    return LineChartBarData(
      isCurved: true,
      color: color,
      barWidth: 2.5,
      dotData: const FlDotData(show: true),
      belowBarData: BarAreaData(
        show: true,
        color: color.withValues(alpha: 0.25),
      ),
      spots: List.generate(
        values.length,
        (index) => FlSpot(index.toDouble(), values[index]),
      ),
    );
  }

  double _yInterval() {
    final maxY = _maxY();

    if (maxY <= 5) return 1;
    if (maxY <= 10) return 2;
    if (maxY <= 20) return 5;
    if (maxY <= 50) return 10;

    return 20;
  }

  double _maxY() {
    final values = data.expand((e) => [e.ipd, e.opd, e.emergency]).toList();

    final max = values.reduce((a, b) => a > b ? a : b);

    if (max <= 5) return 5;
    if (max <= 10) return 10;
    if (max <= 20) return 20;
    if (max <= 50) return 50;

    return (max + 10).ceilToDouble();
  }

  // ================= LEGEND =================

  Widget _legend() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _LegendItem(color: Color(0xFF3B82F6), label: 'IPD'),
        SizedBox(width: 16),
        _LegendItem(color: Color(0xFF22C55E), label: 'OPD'),
        SizedBox(width: 16),
        _LegendItem(color: Color(0xFFF87171), label: 'Emergency'),
      ],
    );
  }

  static const TextStyle _axisText = TextStyle(
    fontSize: 11,
    color: Color(0xFF718096),
  );
}

// ================= LEGEND ITEM =================

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        AppText(
          label,
          fontSize: 12,
          color: const Color(0xFF2D3748),
        ),
      ],
    );
  }
}
