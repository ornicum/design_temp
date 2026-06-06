import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../app_theme.dart';

class BotsProfitabilityChart extends StatelessWidget {
  const BotsProfitabilityChart({super.key});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 3000,
        minY: -500,
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 1000,
          getDrawingHorizontalLine: (v) => FlLine(color: AppTheme.bd(context), strokeWidth: 1),
        ),
        titlesData: const FlTitlesData(show: false),
        barGroups: const [], // Будет наполнено слоем данных на следующем шаге
      ),
    );
  }
}
