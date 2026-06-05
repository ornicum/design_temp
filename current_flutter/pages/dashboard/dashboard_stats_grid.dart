import 'package:flutter/material.dart';
import 'package:osts_mobile_app/models/models.dart';
import 'package:osts_mobile_app/components/stat_card.dart';
import 'package:osts_mobile_app/init/i18n_manager.dart';

class DashboardStatsGrid extends StatelessWidget {
  final double totalBalance;
  final double pnlPercent;
  final double totalPnL;
  final int totalTrades;
  final double avgWinRate;
  final int activeCount;
  final int totalCount;

  const DashboardStatsGrid({
    super.key,
    required this.totalBalance,
    required this.pnlPercent,
    required this.totalPnL,
    required this.totalTrades,
    required this.avgWinRate,
    required this.activeCount,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double availW = constraints.maxWidth;

        // Рассчитываем адаптивную ширину карточек по нашей безопасной формуле
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
          children: [
            SizedBox(
              width: itemWidth,
              child: StatCard(
                title: I18n.t(context, 'dash_total_balance'),
                value: '\$${totalBalance.toLocale()}',
                change: pnlPercent,
                icon: Icons.account_balance_wallet,
              ),
            ),
            SizedBox(
              width: itemWidth,
              child: StatCard(
                title: I18n.t(context, 'dash_active_bots'),
                value: '$activeCount / $totalCount',
                icon: Icons.smart_toy,
              ),
            ),
            SizedBox(
              width: itemWidth,
              child: StatCard(
                title: I18n.t(context, 'dash_total_pnl'),
                value: '${totalPnL >= 0 ? "+" : ""}\$${totalPnL.toStringAsFixed(2)}',
                variant: totalPnL >= 0 ? StatCardVariant.success : StatCardVariant.danger,
                icon: Icons.trending_up,
              ),
            ),
            SizedBox(
              width: itemWidth,
              child: StatCard(
                title: I18n.t(context, 'dash_total_trades'),
                value: totalTrades.toLocale(),
                changeLabel: 'Win Rate: ${avgWinRate.toStringAsFixed(1)}%',
                icon: Icons.analytics,
              ),
            ),
          ],
        );
      },
    );
  }
}
