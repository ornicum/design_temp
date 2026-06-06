import 'package:flutter/material.dart';
import 'package:osts_mobile_app/app_theme.dart';
import 'package:osts_mobile_app/models/models.dart';
import 'bot_card_mini_stat.dart';

class BotCardFooter extends StatelessWidget {
  final Bot bot;

  const BotCardFooter({super.key, required this.bot});

  @override
  Widget build(BuildContext context) {
    final tradesStr = bot.totalTrades.toString();
    final wrStr = '${bot.winRate.toStringAsFixed(1)}%';
    final ddStr = '${bot.maxDrawdown.toStringAsFixed(1)}%';

    return Column(
      children: [
        const SizedBox(height: 12),
        Divider(color: AppTheme.bd(context)),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
          children: [
            BotCardMiniStat(
              label: 'Сделки',
              value: tradesStr,
            ),
            BotCardMiniStat(
              label: 'Win Rate',
              value: wrStr,
            ),
            BotCardMiniStat(
              label: 'Просадка',
              value: ddStr,
            ),
          ],
        ),
      ],
    );
  }
}
