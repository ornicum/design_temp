import 'package:flutter/material.dart';
import 'package:osts_mobile_app/app_theme.dart';
import 'package:osts_mobile_app/models/models.dart';
import 'package:osts_mobile_app/components/'
    'dashboard/bot_card_footer.dart';

class BotCard extends StatefulWidget {
  final Bot bot;

  const BotCard({super.key, required this.bot});

  @override
  State<BotCard> createState() => _BotCardState();
}

class _BotCardState extends State<BotCard> {
  bool _isHovered = false;

  Color _getExchangeColor(String ex) {
    switch (ex.toLowerCase()) {
      case 'binance': return const Color(0xFFF3BA2F);
      case 'bybit': return const Color(0xFFFFA500);
      case 'okx': return const Color(0xFF0000FF);
      case 'kucoin': return const Color(0xFF00E676);
      case 'kraken': return const Color(0xFF6A1B9A);
      default: return AppTheme.darkMuted;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active': return AppTheme.success;
      case 'paused': return AppTheme.warning;
      case 'error': return AppTheme.destructive;
      default: return AppTheme.darkMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPos = widget.bot.profitLoss >= 0;
    final isDark = AppTheme.isDark(context);

    final Color titleColor = _isHovered
        ? AppTheme.brand(context)
        : AppTheme.txt(context);

    final Color borderHoverColor = isDark
        ? AppTheme.brand(context).withOpacity(0.3)
        : const Color(0xFF64748B);

    final List<BoxShadow>? currentShadow = _isHovered
        ? [
      isDark
          ? BoxShadow(
        color: AppTheme.brand(context)
            .withOpacity(0.05),
        blurRadius: 16,
        spreadRadius: 1,
      )
          : BoxShadow(
        color: Colors.black.withOpacity(0.04),
        blurRadius: 12,
        offset: const Offset(0, 4),
      )
    ]
        : null;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: AppTheme.surface(context),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isHovered
                ? borderHoverColor
                : AppTheme.bd(context),
          ),
          boxShadow: currentShadow,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            splashColor:
            AppTheme.brand(context).withOpacity(0.12),
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          AnimatedDefaultTextStyle(
                            duration: const Duration(
                              milliseconds: 200,
                            ),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: titleColor,
                            ),
                            child: Text(widget.bot.name),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                widget.bot.exchange
                                    .toUpperCase(),
                                style: AppTheme.monoStyle(
                                  fontSize: 11,
                                  fontWeight:
                                  FontWeight.bold,
                                  color:
                                  _getExchangeColor(
                                    widget.bot.exchange,
                                  ),
                                ),
                              ),
                              Text(
                                '  ·  '
                                    '${widget.bot.tradingPair}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppTheme
                                      .txtMuted(context),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(
                            widget.bot.status,
                          ).withOpacity(0.1),
                          borderRadius:
                          BorderRadius.circular(12),
                          border: Border.all(
                            color: _getStatusColor(
                              widget.bot.status,
                            ).withOpacity(0.2),
                          ),
                        ),
                        child: Text(
                          widget.bot.status
                              .toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: _getStatusColor(
                              widget.bot.status,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PnL',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppTheme
                                  .txtMuted(context),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Icon(
                                isPos
                                    ? Icons.arrow_upward
                                    : Icons.arrow_downward,
                                size: 14,
                                color: isPos
                                    ? AppTheme.success
                                    : AppTheme
                                    .destructive,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '${isPos ? "+" : ""}'
                                    '${widget.bot.profitLoss.toStringAsFixed(2)}\$',
                                style: AppTheme
                                    .monoStyle(
                                  fontSize: 13,
                                  fontWeight:
                                  FontWeight.bold,
                                  color: isPos
                                      ? AppTheme.success
                                      : AppTheme
                                      .destructive,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Стратегия',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppTheme
                                  .txtMuted(context),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.bot.strategy
                                .toUpperCase(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight:
                              FontWeight.w500,
                              color: AppTheme.txt(
                                context,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // ИСПРАВЛЕНО: Теперь вызывается один чистый виджет футера
                  BotCardFooter(bot: widget.bot),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
