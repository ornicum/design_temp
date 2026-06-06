import 'package:flutter/material.dart';
import 'package:osts_mobile_app/components/stat_card.dart';
import 'package:osts_mobile_app/init/i18n_manager.dart';
import '../../data/models/analytics_models.dart';

class AnalyticsStatsGrid extends StatelessWidget {
  final List<RustStatMetric> metrics;

  const AnalyticsStatsGrid({super.key, required this.metrics});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return LayoutBuilder(
      builder: (context, constraints) {
        int columns = width < 400 ? 2 : (width < 900 ? 3 : 6);
        double spacing = 12.0;
        double itemWidth = (constraints.maxWidth - (columns - 1) * spacing) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: List.generate(metrics.length, (index) {
            final m = metrics[index];
            return SizedBox(
              width: itemWidth,
              child: StatCard(
                title: I18n.t(context, m.key),
                value: m.value,
                change: m.changePct,
                changeLabel: m.changeLabel,
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
