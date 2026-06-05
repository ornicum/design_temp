import 'package:flutter/material.dart';
import '../../../../app_theme.dart';
import '../../../../init/i18n_manager.dart';

InputDecoration inputDecoration(BuildContext context, String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(color: AppTheme.txtMuted(context), fontSize: 13),
    filled: true,
    fillColor: AppTheme.isDark(context) ? const Color(0xFF1E293B).withOpacity(0.3) : Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AppTheme.bd(context))),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AppTheme.brand(context))),
  );
}

class DialogLabel extends StatelessWidget {
  final String text;
  const DialogLabel({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, left: 2),
      child: Text(text, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppTheme.txtMuted(context))),
    );
  }
}
