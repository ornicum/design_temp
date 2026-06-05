import 'package:flutter/material.dart';
import '../../../../app_theme.dart';
import '../../../../init/i18n_manager.dart';

class DialogHeaderBlock extends StatelessWidget {
  const DialogHeaderBlock({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          I18n.t(context, 'create_bot_modal_title'),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.txt(context),
          ),
        ),
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: const Icon(Icons.close, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
