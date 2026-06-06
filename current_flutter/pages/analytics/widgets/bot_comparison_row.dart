import 'package:flutter/material.dart';
import '../../../app_theme.dart';

class BotComparisonRow {
  static DataRow build({
    required BuildContext context,
    required String name,
    required String ex,
    required String pair,
    required String balance,
    required String pnl,
    required String pct,
    required String wr,
    required String dd,
    required String trades,
    required bool isPos,
  }) {
    final pnlColor = pnl == '\$0.00' ? AppTheme.txtMuted(context) : (isPos ? AppTheme.success : AppTheme.destructive);

    return DataRow(
      cells: [
        DataCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.txt(context))),
              Text('$ex · $pair', style: TextStyle(fontSize: 11, color: AppTheme.txtMuted(context))),
            ],
          ),
        ),
        DataCell(Text(balance, style: AppTheme.monoStyle(fontSize: 13, color: AppTheme.txt(context)))),
        DataCell(Text(pnl, style: AppTheme.monoStyle(fontSize: 13, fontWeight: FontWeight.bold, color: pnlColor))),
        DataCell(Text(pct, style: AppTheme.monoStyle(fontSize: 13, color: pnlColor))),
        DataCell(Text(wr, style: AppTheme.monoStyle(fontSize: 13, color: AppTheme.txt(context)))),
        DataCell(Text(dd, style: AppTheme.monoStyle(fontSize: 13, color: AppTheme.destructive))),
        DataCell(Text(trades, style: AppTheme.monoStyle(fontSize: 13, color: AppTheme.txtMuted(context)))),
      ],
    );
  }
}
