import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:osts_mobile_app/app_theme.dart';
import 'package:osts_mobile_app/init/i18n_manager.dart';

class AnalyticsPieCharts extends StatelessWidget {
  const AnalyticsPieCharts({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool isMobile = width < 900;

    final chartBlocks = [
      _buildPieCard(
        context,
        title: I18n.t(context, 'analytics_distribution_bots'),
        sub: I18n.t(context, 'analytics_sub_by_bots'),
        indicators: [
          _buildIndicator(context, color: const Color(0xFF09DAEC), label: 'BTC Grid Premium', pct: '80.3%'),
          _buildIndicator(context, color: const Color(0xFF10B981), label: 'ETH DCA Safe', pct: '19.7%'),
        ],
        sections: [
          PieChartSectionData(color: const Color(0xFF09DAEC), value: 80.3, radius: 22, showTitle: false),
          PieChartSectionData(color: const Color(0xFF10B981), value: 19.7, radius: 22, showTitle: false),
        ],
      ),
      _buildPieCard(
        context,
        title: I18n.t(context, 'analytics_distribution_exchanges'),
        sub: I18n.t(context, 'analytics_sub_by_exchanges'),
        indicators: [
          _buildIndicator(context, color: const Color(0xFFF3BA2F), label: 'BINANCE', pct: '80.3%'),
          _buildIndicator(context, color: const Color(0xFFFFA500), label: 'BYBIT', pct: '19.7%'),
        ],
        sections: [
          PieChartSectionData(color: const Color(0xFFF3BA2F), value: 80.3, radius: 22, showTitle: false),
          PieChartSectionData(color: const Color(0xFFFFA500), value: 19.7, radius: 22, showTitle: false),
        ],
      ),
    ];

    if (isMobile) {
      return Column(
        children: [
          chartBlocks[0],
          const SizedBox(height: 16),
          chartBlocks[1],
        ],
      );
    }

    return Row(
      children: [
        Expanded(child: chartBlocks[0]),
        const SizedBox(width: 16),
        Expanded(child: chartBlocks[1]),
      ],
    );
  }

  Widget _buildPieCard(
      BuildContext context, {
        required String title,
        required String sub,
        required List<Widget> indicators,
        required List<PieChartSectionData> sections,
      }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.bd(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.txt(context))),
          Text(sub, style: TextStyle(fontSize: 11, color: AppTheme.txtMuted(context))),
          const SizedBox(height: 20),
          Row(
            children: [
              SizedBox(
                width: 110,
                height: 110,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 3,
                    centerSpaceRadius: 33,
                    sections: sections,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: indicators,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(BuildContext context, {required Color color, required String label, required String pct}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 12, color: AppTheme.txtMuted(context)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            pct,
            style: AppTheme.monoStyle(fontSize: 12, color: AppTheme.txt(context), fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
