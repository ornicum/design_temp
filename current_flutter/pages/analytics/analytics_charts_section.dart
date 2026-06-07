import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../init/i18n_manager.dart';
import '../../app_theme.dart';
import '../../data/models/analytics_models.dart';
import 'widgets/portfolio_pie_chart.dart';

class AnalyticsChartsSection extends StatelessWidget {
  final double width;
  final RustAnalyticsState state;

  const AnalyticsChartsSection({super.key, required this.width, required this.state});

  static const List<Color> colors = [Color(0xFF09DAEC), Color(0xFF10B981), Color(0xFF8B5CF6), Color(0xFFF59E0B)];

  @override
  Widget build(BuildContext context) {
    final bool isMobile = width < 900;
    return Column(
      children: [
        _buildCard(
          context,
          title: I18n.t(context, 'analytics_bots_profitability'),
          sub: I18n.t(context, 'analytics_bots_pnl_desc'),
          child: BarChart(BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: 3000,
            minY: -500,
            // 1. Сетка: Включаем только горизонтальные линии (как в CartesianGrid vertical={false})
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 1000,
              getDrawingHorizontalLine: (value) => FlLine(
                color: AppTheme.bd(context).withOpacity(0.4),
                strokeWidth: 1,
              ),
            ),
            borderData: FlBorderData(show: false),
            // 2. Оси: Включаем детальные финтех-подписи осей X и Y из оригинала
            titlesData: FlTitlesData(
              show: true,
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              // Ось Y: Форматирование вывода валюты ($1.5k, $0)
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 45, // Немного увеличим отступ для красивого выравнивания
                  getTitlesWidget: (value, meta) {
                    if (value == 0) {
                      return Text('\$0', style: TextStyle(color: AppTheme.txtMuted(context), fontSize: 10));
                    }

                    final String sign = value < 0 ? '-' : '';
                    final double absoluteValue = value.abs();
                    String formatted;

                    if (absoluteValue >= 1000) {
                      final double thousands = absoluteValue / 1000;
                      formatted = '${thousands.toStringAsFixed(1)}k';
                    } else {
                      formatted = '${absoluteValue.toInt()}';
                    }

                    return Text(
                      '$sign\$$formatted',
                      style: TextStyle(color: AppTheme.txtMuted(context), fontSize: 10),
                    );
                  },
                ),
              ),
              // Ось X: Поворот длинных названий роботов под углом -35 градусов для защиты от наложения
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 45,
                  getTitlesWidget: (value, meta) {
                    int idx = value.toInt();
                    if (idx >= 0 && idx < state.botPnL.length) {
                      String name = state.botPnL[idx].label;
                      if (name.length > 14) name = '${name.substring(0, 13)}…';
                      return SideTitleWidget(
                        meta: meta, // Обязательный именованный параметр в данной версии fl_chart
                        angle: -0.61, // ~ -35 градусов в радианах
                        space: 12,
                        child: Text(
                          name,
                          style: TextStyle(color: AppTheme.txtMuted(context), fontSize: 9, fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
            // 3. Столбцы: Радиусы скругления углов и динамический цвет PnL
            barGroups: List.generate(state.botPnL.length, (i) {
              final double yVal = state.botPnL[i].y;
              return BarChartGroupData(
                x: state.botPnL[i].x,
                barRods: [
                  BarChartRodData(
                    toY: yVal,
                    color: yVal >= 0 ? AppTheme.success : AppTheme.destructive,
                    width: isMobile ? 14 : 20,
                    borderRadius: yVal >= 0
                        ? const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4))
                        : const BorderRadius.only(bottomLeft: Radius.circular(4), bottomRight: Radius.circular(4)),
                  ),
                ],
              );
            }),
          )),
        ),
        const SizedBox(height: 20),
        isMobile
            ? Column(children: [_buildDaily(context), const SizedBox(height: 20), _buildBots(context)])
            : Row(children: [Expanded(child: _buildDaily(context)), const SizedBox(width: 20), Expanded(child: _buildBots(context))]),
        const SizedBox(height: 20),
        isMobile
            ? Column(children: [_buildEx(context), const SizedBox(height: 20), _buildStrat(context)])
            : Row(children: [Expanded(child: _buildEx(context)), const SizedBox(width: 20), Expanded(child: _buildStrat(context))]),
      ],
    );
  }

  Widget _buildCard(BuildContext context, {required String title, required String sub, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppTheme.surface(context), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.bd(context))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.txt(context))), Text(sub, style: TextStyle(fontSize: 11, color: AppTheme.txtMuted(context))), const SizedBox(height: 20), SizedBox(height: 180, child: child)]),
    );
  }

  Widget _buildDaily(BuildContext context) => _buildCard(context, title: I18n.t(context, 'analytics_daily_pnl'), sub: '14 дней', child: BarChart(BarChartData(maxY: 150, minY: -100, borderData: FlBorderData(show: false), titlesData: const FlTitlesData(show: false), barGroups: List.generate(state.dailyPnL.length, (i) => BarChartGroupData(x: state.dailyPnL[i].x, barRods: [BarChartRodData(toY: state.dailyPnL[i].y, color: state.dailyPnL[i].y >= 0 ? AppTheme.success : AppTheme.destructive, width: 8)])))));
  Widget _buildBots(BuildContext context) => _buildCard(context, title: I18n.t(context, 'analytics_balance_dist'), sub: 'Боты', child: PortfolioPieChart(sections: List.generate(state.balanceDistribution.length, (i) => PieChartSectionData(color: colors[i % colors.length], value: state.balanceDistribution[i].value, radius: 20, showTitle: false))));
  Widget _buildEx(BuildContext context) => _buildCard(context, title: I18n.t(context, 'analytics_by_exchanges'), sub: 'Биржи', child: PortfolioPieChart(sections: List.generate(state.exchangeDistribution.length, (i) => PieChartSectionData(color: i == 0 ? const Color(0xFFF3BA2F) : const Color(0xFFFFA500), value: state.exchangeDistribution[i].value, radius: 20, showTitle: false))));
  Widget _buildStrat(BuildContext context) => _buildCard(context, title: I18n.t(context, 'analytics_by_strategies'), sub: 'Стратегии', child: BarChart(BarChartData(maxY: 3000, borderData: FlBorderData(show: false), titlesData: const FlTitlesData(show: false), barGroups: List.generate(state.strategyPerformance.length, (i) => BarChartGroupData(x: state.strategyPerformance[i].x, barRods: [BarChartRodData(toY: state.strategyPerformance[i].y, color: const Color(0xFF09DAEC), width: 16)])))));
}
