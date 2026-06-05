import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:osts_mobile_app/app_theme.dart';
import 'package:osts_mobile_app/models/models.dart';
import 'package:osts_mobile_app/components/bot_card.dart';
import 'package:osts_mobile_app/init/i18n_manager.dart';

class DashboardBotsSection extends StatelessWidget {
  final List<Bot> activeBots;

  const DashboardBotsSection({
    super.key,
    required this.activeBots,
  });

  @override
  Widget build(BuildContext context) {
    if (activeBots.isEmpty) {
      return const SizedBox.shrink();
    }
    final displayBots = activeBots.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                I18n.t(context, 'dash_active_section'), // ПЕРЕВЕДЕНО
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.txt(context),
                ),
              ),
              TextButton(
                onPressed: () => context.go('/bots'), // Фикс навигации
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                ),
                child: Row(
                  children: [
                    Text(
                      I18n.t(context, 'dash_all_bots_link'), // ПЕРЕВЕДЕНО
                      style: TextStyle(
                        color: AppTheme.brand(context),
                        fontSize: 13,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward,
                      size: 14,
                      color: AppTheme.brand(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final double availW = constraints.maxWidth;

            if (availW < 650) {
              return Column(
                children: displayBots.map((bot) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: BotCard(bot: bot),
                  );
                }).toList(),
              );
            }

            if (availW < 1000) {
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: BotCard(bot: displayBots[0])),
                      if (displayBots.length > 1) ...[
                        const SizedBox(width: 12),
                        Expanded(child: BotCard(bot: displayBots[1])),
                      ],
                    ],
                  ),
                  if (displayBots.length > 2) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: BotCard(bot: displayBots[2])),
                        const SizedBox(width: 12),
                        const Expanded(child: SizedBox.shrink()),
                      ],
                    ),
                  ],
                ],
              );
            }

            return Row(
              children: [
                Expanded(child: BotCard(bot: displayBots[0])),
                const SizedBox(width: 12),
                Expanded(
                  child: displayBots.length > 1 ? BotCard(bot: displayBots[1]) : const SizedBox.shrink(),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: displayBots.length > 2 ? BotCard(bot: displayBots[2]) : const SizedBox.shrink(),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
