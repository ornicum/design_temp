import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../app_theme.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool isMobile = width < 768;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('АНАЛИТИКА ДОХОДНОСТИ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        backgroundColor: AppTheme.background,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('ДИНАМИКА БАЛАНСА (EQUITY)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.0)),
            const SizedBox(height: 20),

            // Контейнер под наш высокотехнологичный график
            Container(
              height: isMobile ? 260 : 400,
              padding: const EdgeInsets.only(right: 24, left: 12, top: 24, bottom: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF0E1424), // --card
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.border),
              ),
              child: _buildEquityChart(),
            ),
            const SizedBox(height: 32),
            _buildQuickStats(isMobile),
          ],
        ),
      ),
    );
  }

  Widget _buildEquityChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true, drawVerticalLine: true, horizontalInterval: 1, verticalInterval: 1, getDrawingHorizontalLine: (value) => const FlLine(color: Color(0xFF1B2336), strokeWidth: 1), getDrawingVerticalLine: (value) => const FlLine(color: Color(0xFF1B2336), strokeWidth: 1)),
        titlesData: FlTitlesData(
          show: true, rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)), topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30, interval: 1, getTitlesWidget: (value, meta) {
            const days = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
            if (value.toInt() >= 0 && value.toInt() < days.length) { return Text(days[value.toInt()], style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)); }
            return const Text('');
          })),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, interval: 2, reservedSize: 42, getTitlesWidget: (value, meta) {
            return Text('\$${value.toInt()}k', style: const TextStyle(color: Color(0xFF64748B), fontSize: 12));
          })),
        ),
        borderData: FlBorderData(show: true, border: Border.all(color: AppTheme.border, width: 1)),
        minX: 0, maxX: 6, minY: 10, maxY: 16,
        lineBarsData: [
          LineChartBarData(
            // Фейковые точки доходности для симуляции торговли ботов
            spots: const [FlSpot(0, 11), FlSpot(1, 10.5), FlSpot(2, 13), FlSpot(3, 12.2), FlSpot(4, 15), FlSpot(5, 14.3), FlSpot(6, 15.8)],
            isCurved: true, color: AppTheme.primary, barWidth: 3, isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            // Мягкий бирюзовый градиент, уходящий в темноту под линией графика
            belowBarData: BarAreaData(show: true, gradient: LinearGradient(colors: [AppTheme.primary.withOpacity(0.2), AppTheme.primary.withOpacity(0.0)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          ),
        ],
      ),
    );
  }

    Widget _buildQuickStats(bool isMobile) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: isMobile ? 2 : 4,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 2.5,
      children: [
        // Вызываем обновленные компоненты
        _HoverMiniStat(label: 'ПРИБЫЛЬ ЗА НЕДЕЛЮ', value: '+\$1,180.20', valueColor: AppTheme.success),
        _HoverMiniStat(label: 'МАКС. ПРОСАДКА', value: '1.42%', valueColor: AppTheme.destructive),
        _HoverMiniStat(label: 'ПРОФИТ ФАКТОР', value: '2.84', valueColor: Colors.white),
        _HoverMiniStat(label: 'ВИНРЕЙТ', value: '68.4%', valueColor: AppTheme.primary),
      ],
    );
  }
}

  // Новый интерактивный виджет мини-карточки с неоновым ховером
class _HoverMiniStat extends StatefulWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _HoverMiniStat({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  State<_HoverMiniStat> createState() => _HoverMiniStatState();
}

class _HoverMiniStatState extends State<_HoverMiniStat> {
  bool _isHovered = false; // Локальное состояние наведения мыши ПК

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          // При наведении фон становится чуть глубже
          color: _isHovered ? const Color(0xFF131C31) : const Color(0xFF0E1424),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            // Зажигаем бирюзовый неон на рамке при наведении курсора
            color: _isHovered ? AppTheme.primary : AppTheme.border,
            width: 1,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: AppTheme.primary.withOpacity(0.12),
                    blurRadius: 8,
                    spreadRadius: 1,
                  )
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.label,
              style: TextStyle(
                // Текст заголовка становится контрастнее при наведении
                color: _isHovered ? Colors.white70 : const Color(0xFF64748B),
                fontSize: 9,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.value,
              style: TextStyle(
                color: widget.valueColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
