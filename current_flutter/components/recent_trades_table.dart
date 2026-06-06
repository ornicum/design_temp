import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../models/models.dart';
import '../init/i18n_manager.dart';
import 'trades_table/table_header.dart';
import 'trades_table/interactive_row.dart';

class RecentTradesTable extends StatelessWidget {
  final int limit;
  final String? botId;

  const RecentTradesTable({super.key, this.limit = 8, this.botId});

  @override
  Widget build(BuildContext context) {
    // Твои оригинальные моковые данные со всеми полями models.dart
    final List<Trade> trades = [
      Trade(id: 't1', botId: '1', botName: 'BTC Grid Premium', type: 'buy', tradingPair: 'BTC/USDT', amount: 0.015, price: 67200.0, total: 1008.0, profitLoss: 0.0, fee: 1.0, status: 'executed', executedAt: DateTime.now().subtract(const Duration(minutes: 12))),
      Trade(id: 't2', botId: '1', botName: 'BTC Grid Premium', type: 'sell', tradingPair: 'BTC/USDT', amount: 0.015, price: 67550.0, total: 1013.25, profitLoss: 5.25, fee: 1.01, status: 'executed', executedAt: DateTime.now().subtract(const Duration(hours: 1))),
    ];

    final filtered = botId != null ? trades.where((t) => t.botId == botId).toList() : trades;
    final width = MediaQuery.of(context).size.width;
    final bool isWide = width > 600;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppTheme.surface(context), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.bd(context))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (filtered.isEmpty)
            Center(child: Padding(padding: const EdgeInsets.symmetric(vertical: 32), child: Text(I18n.t(context, 'trades_table_empty'), style: TextStyle(color: AppTheme.txtMuted(context)))))
          else ...[
            TableHeaderRow(isWide: isWide),
            Divider(color: AppTheme.bd(context), height: 1),
            ...filtered.take(limit).map((trade) => InteractiveRow(trade: trade, showExtended: isWide)),
          ],
        ],
      ),
    );
  }
}
