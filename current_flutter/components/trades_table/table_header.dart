import 'package:flutter/material.dart';
import 'package:osts_mobile_app/app_theme.dart';
import 'package:osts_mobile_app/init/i18n_manager.dart';

class TableHeaderRow extends StatelessWidget {
  final bool isWide;
  const TableHeaderRow({super.key, required this.isWide});

  Widget _th(BuildContext context, String label, {bool left = false}) {
    return Text(
      label,
      textAlign: left ? TextAlign.left : TextAlign.right,
      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.txtMuted(context)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8).copyWith(bottom: 12),
      child: Row(
        children: [
          Expanded(flex: 3, child: _th(context, I18n.t(context, 'trades_table_th_pair'), left: true)),
          Expanded(flex: 2, child: _th(context, I18n.t(context, 'trades_table_th_price'))),
          if (isWide) ...[
            Expanded(flex: 2, child: _th(context, I18n.t(context, 'trades_table_th_volume'))),
            Expanded(flex: 2, child: _th(context, I18n.t(context, 'trades_table_th_time'))),
          ],
          Expanded(flex: 2, child: _th(context, I18n.t(context, 'trades_table_th_pnl'))),
        ],
      ),
    );
  }
}
