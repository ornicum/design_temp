import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DailyPnLChart extends StatelessWidget {
  const DailyPnLChart({super.key});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 150,
        minY: -100,
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: const FlTitlesData(show: false),
        barGroups: const [], // Будет наполнено слоем данных на следующем шаге
      ),
    );
  }
}
