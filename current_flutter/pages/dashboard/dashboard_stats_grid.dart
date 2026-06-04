import 'package:flutter/material.dart';
import 'package:osts_mobile_app/models/models.dart';
import 'package:osts_mobile_app/components/stat_card.dart';

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

        // Мобильный режим: 2 строки по 2 карточки
        if (availW < 800) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      title: 'Общий баланс',
                      value: '\$${totalBalance.toLocale()}',
                      change: pnlPercent,
                      icon: Icons.account_balance_wallet,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      title: 'Активные боты',
                      value: '$activeCount / $totalCount',
                      icon: Icons.smart_toy,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      title: 'Общий PnL',
                      value: '${totalPnL >= 0 ? "+" : ""}'
                          '\$${totalPnL.toStringAsFixed(2)}',
                      variant: totalPnL >= 0
                          ? StatCardVariant.success
                          : StatCardVariant.danger,
                      icon: Icons.trending_up,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      title: 'Всего сделок',
                      value: totalTrades.toLocale(),
                      changeLabel: 'Win Rate: '
                          '${avgWinRate.toStringAsFixed(1)}%',
                      icon: Icons.analytics,
                    ),
                  ),
                ],
              ),
            ],
          );
        }

        // Десктопный режим: Все 4 карточки строго в один ряд
        // ИСПРАВЛЕНО: Чистый Row + Expanded уничтожает shrinkWrap баг
        return Row(
          children: [
            Expanded(
              child: StatCard(
                title: 'Общий баланс',
                value: '\$${totalBalance.toLocale()}',
                change: pnlPercent,
                icon: Icons.account_balance_wallet,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                title: 'Активные боты',
                value: '$activeCount / $totalCount',
                icon: Icons.smart_toy,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                title: 'Общий PnL',
                value: '${totalPnL >= 0 ? "+" : ""}'
                    '\$${totalPnL.toStringAsFixed(2)}',
                variant: totalPnL >= 0
                    ? StatCardVariant.success
                    : StatCardVariant.danger,
                icon: Icons.trending_up,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                title: 'Всего сделок',
                value: totalTrades.toLocale(),
                changeLabel: 'Win Rate: '
                    '${avgWinRate.toStringAsFixed(1)}%',
                icon: Icons.analytics,
              ),
            ),
          ],
        );
      },
    );
  }
}
