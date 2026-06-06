import 'package:flutter/material.dart';
import '../../init/i18n_manager.dart';
import '../../app_theme.dart';
import '../../data/models/analytics_models.dart';
import 'widgets/bot_comparison_row.dart';

class AnalyticsBotsTable extends StatelessWidget {
  final List<RustBotRowMetric> bots;

  const AnalyticsBotsTable({super.key, required this.bots});

  @override
  Widget build(BuildContext context) {
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
          Text(I18n.t(context, 'analytics_table_title'), style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.txt(context))),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: DataTable(
              headingRowHeight: 36, horizontalMargin: 4, columnSpacing: 28,
              columns: [
                DataColumn(label: Text(I18n.t(context, 'analytics_th_bot'), style: TextStyle(color: AppTheme.txtMuted(context), fontSize: 12))),
                DataColumn(label: Text(I18n.t(context, 'analytics_th_balance'), style: TextStyle(color: AppTheme.txtMuted(context), fontSize: 12)), numeric: true),
                DataColumn(label: Text(I18n.t(context, 'analytics_th_pnl'), style: TextStyle(color: AppTheme.txtMuted(context), fontSize: 12)), numeric: true),
                DataColumn(label: Text(I18n.t(context, 'analytics_th_pnl_pct'), style: TextStyle(color: AppTheme.txtMuted(context), fontSize: 12)), numeric: true),
                DataColumn(label: Text(I18n.t(context, 'analytics_th_winrate'), style: TextStyle(color: AppTheme.txtMuted(context), fontSize: 12)), numeric: true),
                DataColumn(label: Text(I18n.t(context, 'analytics_th_drawdown'), style: TextStyle(color: AppTheme.txtMuted(context), fontSize: 12)), numeric: true),
                DataColumn(label: Text(I18n.t(context, 'analytics_th_trades'), style: TextStyle(color: AppTheme.txtMuted(context), fontSize: 12)), numeric: true),
              ],
              rows: List.generate(bots.length, (idx) {
                final b = bots[idx];
                return BotComparisonRow.build(
                  context: context,
                  name: b.name, ex: b.exchange, pair: b.pair,
                  balance: b.balance, pnl: b.pnl, pct: b.pnlPct,
                  wr: b.winRate, dd: b.drawdown, trades: b.trades,
                  isPos: b.isPositive,
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
