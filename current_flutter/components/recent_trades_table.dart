import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../models/models.dart';

class RecentTradesTable extends StatelessWidget {
  final int limit;
  final String? botId;

  const RecentTradesTable({
    super.key,
    this.limit = 8,
    this.botId,
  });

  @override
  Widget build(BuildContext context) {
    final List<Trade> trades = [
      Trade(
        id: 't1',
        botId: '1',
        botName: 'BTC Grid Premium',
        type: 'buy',
        tradingPair: 'BTC/USDT',
        amount: 0.015,
        price: 67200.0,
        total: 1008.0,
        profitLoss: 0.0,
        fee: 1.0,
        status: 'executed',
        executedAt: DateTime.now().subtract(
          const Duration(minutes: 12),
        ),
      ),
      Trade(
        id: 't2',
        botId: '1',
        botName: 'BTC Grid Premium',
        type: 'sell',
        tradingPair: 'BTC/USDT',
        amount: 0.015,
        price: 67550.0,
        total: 1013.25,
        profitLoss: 5.25,
        fee: 1.01,
        status: 'executed',
        executedAt: DateTime.now().subtract(
          const Duration(hours: 1),
        ),
      ),
    ];

    final filtered = botId != null
        ? trades.where((t) => t.botId == botId).toList()
        : trades;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.bd(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Последние сделки',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.txt(context),
            ),
          ),
          const SizedBox(height: 16),
          if (filtered.isEmpty)
            _buildEmptyState(context)
          else
            _buildTable(context, filtered),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 32,
        ),
        child: Text(
          'Пока нет сделок',
          style: TextStyle(
            color: AppTheme.txtMuted(context),
          ),
        ),
      ),
    );
  }

  Widget _buildTable(
      BuildContext context,
      List<Trade> items,
      ) {
    final width = MediaQuery.of(context).size.width;
    final bool isWide = width > 600;

    return Column(
      children: [
        Padding(
          // ИСПРАВЛЕНО: Корректный конструктор отступов
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
          ).copyWith(bottom: 12),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: _th(context, 'Робот / Пара',
                    left: true),
              ),
              Expanded(
                flex: 2,
                child: _th(context, 'Цена'),
              ),
              if (isWide) ...[
                Expanded(
                  flex: 2,
                  child: _th(context, 'Объём'),
                ),
                Expanded(
                  flex: 2,
                  child: _th(context, 'Время'),
                ),
              ],
              Expanded(
                flex: 2,
                child: _th(context, 'PnL'),
              ),
            ],
          ),
        ),
        Divider(color: AppTheme.bd(context), height: 1),
        ...items.take(limit).map(
              (trade) => _InteractiveRow(
            trade: trade,
            showExtended: isWide,
          ),
        ),
      ],
    );
  }

  Widget _th(
      BuildContext context,
      String label, {
        bool left = false,
      }) {
    return Text(
      label,
      textAlign: left ? TextAlign.left : TextAlign.right,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: AppTheme.txtMuted(context),
      ),
    );
  }
}

class _InteractiveRow extends StatefulWidget {
  final Trade trade;
  final bool showExtended;

  const _InteractiveRow({
    required this.trade,
    required this.showExtended,
  });

  @override
  State<_InteractiveRow> createState() =>
      _InteractiveRowState();
}

class _InteractiveRowState extends State<_InteractiveRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isBuy = widget.trade.type == 'buy';
    final pnl = widget.trade.profitLoss;
    final isDark = AppTheme.isDark(context);

    final Color liveColor = _isHovered
        ? AppTheme.brand(context)
        : AppTheme.txt(context);

    final Color rowHoverColor = isDark
        ? const Color(0xFF1A2131).withOpacity(0.2)
        : const Color(0xFFE2E8F0).withOpacity(0.4);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: _isHovered ? rowHoverColor : Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: AppTheme.bd(context).withOpacity(0.3),
            ),
          ),
        ),
        // ИСПРАВЛЕНО: Внедрен InkWell для тактильного неонового клика
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              // Заглушка под будущий роутинг /trades/tradeId илиBottomSheet
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppTheme.surface(context),
                  content: Text(
                    'Детали сделки ${widget.trade.id} скоро будут доступны',
                    style: TextStyle(color: AppTheme.txt(context)),
                  ),
                ),
              );
            },
            splashColor: AppTheme.brand(context).withOpacity(0.15),
            highlightColor: AppTheme.brand(context).withOpacity(0.05),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 8,
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 150),
                          style: AppTheme.monoStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: liveColor,
                          ),
                          child: Text(widget.trade.tradingPair),
                        ),
                        const SizedBox(height: 3),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isBuy
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward,
                              size: 10,
                              color: isBuy
                                  ? AppTheme.success
                                  : AppTheme.destructive,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              isBuy ? 'Покупка' : 'Продажа',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: isBuy
                                    ? AppTheme.success
                                    : AppTheme.destructive,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 150),
                      style: AppTheme.monoStyle(
                        fontSize: 12,
                        color: liveColor,
                      ),
                      textAlign: TextAlign.right,
                      child: Text(
                        '\$${widget.trade.price.toLocale()}',
                      ),
                    ),
                  ),
                  if (widget.showExtended) ...[
                    Expanded(
                      flex: 2,
                      child: Text(
                        '\$${widget.trade.total.toLocale()}',
                        textAlign: TextAlign.right,
                        style: AppTheme.monoStyle(
                          fontSize: 12,
                          color: AppTheme.txtMuted(context),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        '${widget.trade.executedAt.hour.toString().padLeft(2, '0')}:'
                            '${widget.trade.executedAt.minute.toString().padLeft(2, '0')}',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.txtMuted(context),
                        ),
                      ),
                    ),
                  ],
                  Expanded(
                    flex: 2,
                    child: Text(
                      '${pnl >= 0 ? "+" : ""}${pnl.toStringAsFixed(2)}\$',
                      textAlign: TextAlign.right,
                      style: AppTheme.monoStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: pnl >= 0
                            ? AppTheme.success
                            : AppTheme.destructive,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}