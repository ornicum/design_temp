import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../app_theme.dart';
import '../../../data/models/analytics_models.dart';

class StrategiesChart extends StatelessWidget {
  final List<RustChartPoint> strategyPerf;

  const StrategiesChart({super.key, required this.strategyPerf});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        maxY: 3000,
        gridData: FlGridData(show: true, drawVerticalLine: false, horizontalInterval: 1000, getDrawingHorizontalLine: (v) => FlLine(color: AppTheme.bd(context).withOpacity(0.3))),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          show: true,
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 35, getTitlesWidget: (v, m) => Text('\$${v.toInt()}', style: TextStyle(color: AppTheme.txtMuted(context), fontSize: 9)))),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (v, m) {
                int idx = v.toInt();
                if (idx < strategyPerf.length) {
                  return Text(strategyPerf[idx].label, style: TextStyle(color: AppTheme.txtMuted(context), fontSize: 10));
                }
                return const Text('');
              },
            ),
          ),
        ),
        barGroups: List.generate(strategyPerf.length, (i) {
          return BarChartGroupData(
            x: strategyPerf[i].x,
            barRods: [
              BarChartRodData(
                toY: strategyPerf[i].y,
                color: const Color(0xFF09DAEC),
                width: 18,
                borderRadius: BorderRadius.circular(2),
              )
            ],
          );
        }),
      ),
    );
  }
}
