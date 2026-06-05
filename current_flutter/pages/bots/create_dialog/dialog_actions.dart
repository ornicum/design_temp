import 'package:flutter/material.dart';
import '../../../../app_theme.dart';
import '../../../../init/i18n_manager.dart';
import '../../../../components/ui/osts_button.dart'; // Подключаем кастомную кнопку терминала

class DialogActionsBlock extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final String Function() getName;

  const DialogActionsBlock({
    super.key,
    required this.formKey,
    required this.getName,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            I18n.t(context, 'create_bot_modal_cancel'),
            style: TextStyle(color: AppTheme.txtMuted(context)),
          ),
        ),
        const SizedBox(width: 12),
        OstsButton(
          label: I18n.t(context, 'create_bot_modal_launch'),
          onTap: () {
            if (formKey.currentState!.validate()) {
              Navigator.pop(context);
              final successMsg = I18n.t(context, 'create_bot_modal_success_toast').replaceAll('{name}', getName());
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(successMsg)),
              );
            }
          },
        ),
      ],
    );
  }
}
