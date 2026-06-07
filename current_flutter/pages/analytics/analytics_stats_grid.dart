import 'package:flutter/material.dart';
import 'package:osts_mobile_app/components/stat_card.dart';
import 'package:osts_mobile_app/init/i18n_manager.dart';
import '../../data/models/analytics_models.dart';

class AnalyticsStatsGrid extends StatelessWidget {
  final List<RustStatMetric> metrics;

  const AnalyticsStatsGrid({super.key, required this.metrics});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double availW = constraints.maxWidth;

        int columns = 1;
        if (availW >= 1024) {
          columns = 4;
        } else if (availW >= 600) {
          columns = 2;
        }

        final double itemWidth = (availW - (columns - 1) * 12) / columns;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: List.generate(metrics.length, (index) {
            final m = metrics[index];

            // Динамическая локализация зашитых changeLabel из Rust-слоя
            String localizedLabel = m.changeLabel;
            if (m.key == 'analytics_total_balance') {
              localizedLabel = I18n.t(context, 'analytics_invested_label').replaceAll('{value}', '\$24 500');
            } else if (m.key == 'analytics_total_pnl') {
              localizedLabel = m.changeLabel; // Здесь процентная строка "+9.0%", она интернациональна
            } else if (m.key == 'analytics_total_trades') {
              localizedLabel = I18n.t(context, 'analytics_profitable_label').replaceAll('{value}', '812');
            } else if (m.key == 'analytics_avg_winrate') {
              localizedLabel = I18n.t(context, 'analytics_stable_label');
            } else if (m.key == 'analytics_trading_volume') {
              localizedLabel = I18n.t(context, 'analytics_trades_count_label').replaceAll('{value}', '1353');
            } else if (m.key == 'analytics_active_bots') {
              localizedLabel = I18n.t(context, 'analytics_total_label').replaceAll('{value}', '5');
            }

            return SizedBox(
              width: itemWidth,
              child: StatCard(
                title: I18n.t(context, m.key),
                value: m.value,
                change: m.changePct,
                changeLabel: localizedLabel,
                icon: m.isWalletIcon ? Icons.account_balance_wallet : Icons.bolt,
                variant: m.isSuccessVariant ? StatCardVariant.success : StatCardVariant.defaultVariant,
              ),
            );
          }),
        );
      },
    );
  }
}
