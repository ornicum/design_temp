import 'package:flutter/material.dart';
import '../../app_theme.dart';

class BotCardMiniStat extends StatelessWidget {
  final String label;
  final String value;

  const BotCardMiniStat({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: AppTheme.txtMuted(context),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTheme.monoStyle(
            fontSize: 12,
            color: AppTheme.txt(context),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
