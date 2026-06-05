import 'package:flutter/material.dart';
import 'package:osts_mobile_app/app_theme.dart';
import 'package:osts_mobile_app/models/models.dart';
import 'package:osts_mobile_app/init/i18n_manager.dart';

class InteractiveRow extends StatefulWidget {
  final Trade trade;
  final bool showExtended;
  const InteractiveRow({super.key, required this.trade, required this.showExtended});

  @override
  State<InteractiveRow> createState() => _InteractiveRowState();
}

class _InteractiveRowState extends State<InteractiveRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isBuy = widget.trade.type == 'buy';
    final pnl = widget.trade.profitLoss;
    final isDark = AppTheme.isDark(context);
    final Color liveColor = _isHovered ? AppTheme.brand(context) : AppTheme.txt(context);
    final Color hoverBg = isDark ? const Color(0xFF1A2131).withOpacity(0.2) : const Color(0xFFE2E8F0).withOpacity(0.4);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(color: _isHovered ? hoverBg : Colors.transparent, border: Border(bottom: BorderSide(color: AppTheme.bd(context).withOpacity(0.3)))),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              final text = I18n.t(context, 'trades_toast_details').replaceAll('{id}', widget.trade.id);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: AppTheme.surface(context), content: Text(text, style: TextStyle(color: AppTheme.txt(context)))));
            },
            splashColor: AppTheme.brand(context).withOpacity(0.15),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedDefaultTextStyle(duration: const Duration(milliseconds: 150), style: AppTheme.monoStyle(fontSize: 13, fontWeight: FontWeight.w600, color: liveColor), child: Text(widget.trade.tradingPair)),
                        const SizedBox(height: 3),

                        // ДОБАВЛЕНО: Вывод имени робота мелким приглушенным текстом по сетке терминала
                        Text(
                          widget.trade.botName,
                          style: TextStyle(fontSize: 11, color: AppTheme.txtMuted(context)),
                        ),
                        const SizedBox(height: 3),

                        Row(mainAxisSize: MainAxisSize.min, children: [
                          Icon(isBuy ? Icons.arrow_upward : Icons.arrow_downward, size: 10, color: isBuy ? AppTheme.success : AppTheme.destructive),
                          const SizedBox(width: 2),
                          Text(isBuy ? I18n.t(context, 'trades_type_buy') : I18n.t(context, 'trades_type_sell'), style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isBuy ? AppTheme.success : AppTheme.destructive)),
                        ]),
                      ],
                    ),
                  ),
                  Expanded(flex: 2, child: AnimatedDefaultTextStyle(duration: const Duration(milliseconds: 150), style: AppTheme.monoStyle(fontSize: 12, color: liveColor), textAlign: TextAlign.right, child: Text('\$${widget.trade.price.toLocale()}'))),
                  if (widget.showExtended) ...[
                    Expanded(flex: 2, child: Text('\$${widget.trade.total.toLocale()}', textAlign: TextAlign.right, style: AppTheme.monoStyle(fontSize: 12, color: AppTheme.txtMuted(context)))),
                    Expanded(flex: 2, child: Text('${widget.trade.executedAt.hour.toString().padLeft(2, '0')}:${widget.trade.executedAt.minute.toString().padLeft(2, '0')}', textAlign: TextAlign.right, style: TextStyle(fontSize: 12, color: AppTheme.txtMuted(context)))),
                  ],
                  Expanded(flex: 2, child: Text('${pnl >= 0 ? "+" : ""}${pnl.toStringAsFixed(2)}\$', textAlign: TextAlign.right, style: AppTheme.monoStyle(fontSize: 12, fontWeight: FontWeight.bold, color: pnl >= 0 ? AppTheme.success : AppTheme.destructive))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
