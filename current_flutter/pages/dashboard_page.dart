import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:osts_mobile_app/app_theme.dart';
import 'package:osts_mobile_app/models/models.dart';
import 'package:osts_mobile_app/components/portfolio_chart.dart';
import 'package:osts_mobile_app/components/recent_trades_table.dart';
import 'package:osts_mobile_app/pages/dashboard/dashboard_header.dart';
import 'package:osts_mobile_app/pages/dashboard/dashboard_stats_grid.dart';
import 'package:osts_mobile_app/pages/dashboard/dashboard_bots_section.dart';
import 'package:osts_mobile_app/init/i18n_manager.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Bot> bots = [
      Bot(
        id: '1',
        name: 'BTC Grid Premium',
        description: 'Сетка ордеров в диапазоне',
        strategy: 'grid',
        status: 'active',
        exchange: 'binance',
        tradingPair: 'BTC/USDT',
        initialCapital: 10000.0,
        currentBalance: 12840.0,
        profitLoss: 2840.0,
        profitLossPercent: 28.4,
        riskLevel: 'medium',
        totalTrades: 582,
        winRate: 68.5,
        maxDrawdown: 4.2,
      ),
      Bot(
        id: '2',
        name: 'ETH DCA Safe',
        description: 'Регулярные покупки',
        strategy: 'dca',
        status: 'active',
        exchange: 'bybit',
        tradingPair: 'ETH/USDT',
        initialCapital: 3000.0,
        currentBalance: 3150.0,
        profitLoss: 150.0,
        profitLossPercent: 5.0,
        riskLevel: 'low',
        totalTrades: 124,
        winRate: 71.0,
        maxDrawdown: 2.1,
      ),
    ];

    final activeBots = bots.where((b) => b.status == 'active').toList();
    final totalBalance = bots.fold(0.0, (sum, b) => sum + b.currentBalance);
    final totalPnL = bots.fold(0.0, (sum, b) => sum + b.profitLoss);
    final totalTrades = bots.fold(0, (sum, b) => sum + b.totalTrades);
    final avgWinRate = bots.isNotEmpty ? bots.fold(0.0, (sum, b) => sum + b.winRate) / bots.length : 0.0;
    final double pnlPercent = totalPnL != 0 ? (totalPnL / (totalBalance - totalPnL) * 100) : 0.0;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: constraints.maxWidth),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const DashboardHeader(),
                    const SizedBox(height: 12),
                    DashboardStatsGrid(
                      totalBalance: totalBalance,
                      pnlPercent: pnlPercent,
                      totalPnL: totalPnL,
                      totalTrades: totalTrades,
                      avgWinRate: avgWinRate,
                      activeCount: activeBots.length,
                      totalCount: bots.length,
                    ),
                    const SizedBox(height: 20),

                    // Заголовок графика динамики портфеля
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            I18n.t(context, 'dash_chart_title'),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.txt(context),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            I18n.t(context, 'dash_chart_sub'),
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.txtMuted(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    const PortfolioChart(),

                    const SizedBox(height: 20),
                    DashboardBotsSection(activeBots: activeBots),
                    const SizedBox(height: 20),

                    // ИСПРАВЛЕНО: Заголовок таблицы последних сделок вынесен наружу и полностью переведен
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        I18n.t(context, 'trades_table_title'),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.txt(context),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const RecentTradesTable(limit: 6), // Очищенная таблица
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
