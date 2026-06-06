import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PortfolioPieChart extends StatelessWidget {
  final List<PieChartSectionData> sections;

  const PortfolioPieChart({super.key, required this.sections});

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 40,
        sections: sections,
      ),
    );
  }
}
