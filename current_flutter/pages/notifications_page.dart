import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../init/i18n_manager.dart';

enum LogType { info, trade, warning, error }

class LogEvent {
  final String id; final DateTime timestamp; final LogType type; final String message; final String botName;
  LogEvent({required this.id, required this.timestamp, required this.type, required this.message, required this.botName});
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});
  @override State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<LogEvent> _logs = [
    LogEvent(id: '1', timestamp: DateTime.now().subtract(const Duration(minutes: 2)), type: LogType.trade, message: 'Исполнен лимитный ордер BUY #48102 на объем 0.05 BTC @ \$67,420.00', botName: 'Binance Grid Scalper'),
    LogEvent(id: '2', timestamp: DateTime.now().subtract(const Duration(minutes: 15)), type: LogType.error, message: 'API Error: Invalid API Key or signature. Запрос отклонен биржей.', botName: 'Bybit Trend Follower'),
    LogEvent(id: '3', timestamp: DateTime.now().subtract(const Duration(hours: 1)), type: LogType.warning, message: 'Внимание: Высокая волатильность на рынке. Сетка ордеров расширена на 15%.', botName: 'Binance Grid Scalper'),
    LogEvent(id: '4', timestamp: DateTime.now().subtract(const Duration(hours: 3)), type: LogType.info, message: 'Микросервис статистики успешно перезапущен. Синхронизация БД завершена.', botName: 'State Service'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg(context),
      appBar: AppBar(
        title: Text(
          I18n.t(context, 'notifications_screen_title'),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
        backgroundColor: AppTheme.bg(context),
        foregroundColor: AppTheme.txt(context),
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24.0),
        itemCount: _logs.length,
        itemBuilder: (context, index) {
          return _LogItemRow(log: _logs[index]);
        },
      ),
    );
  }
}

class _LogItemRow extends StatefulWidget {
  final LogEvent log; const _LogItemRow({required this.log});
  @override State<_LogItemRow> createState() => _LogItemRowState();
}

class _LogItemRowState extends State<_LogItemRow> {
  bool _isHovered = false;

  Map<String, dynamic> _getLogTheme() {
    switch (widget.log.type) {
      case LogType.trade: return {'color': AppTheme.success, 'icon': Icons.swap_horizontal_circle_outlined};
      case LogType.error: return {'color': AppTheme.destructive, 'icon': Icons.error_outline};
      case LogType.warning: return {'color': const Color(0xFFF59E0B), 'icon': Icons.warning_amber_outlined};
      case LogType.info: return {'color': Colors.cyan, 'icon': Icons.info_outline};
    }
  }

  @override Widget build(BuildContext context) {
    final theme = _getLogTheme(); final Color logColor = theme['color']; final IconData logIcon = theme['icon'];
    final String timeStr = "${widget.log.timestamp.hour.toString().padLeft(2, '0')}:${widget.log.timestamp.minute.toString().padLeft(2, '0')}:${widget.log.timestamp.second.toString().padLeft(2, '0')}";

    final isDark = AppTheme.isDark(context);
    final Color cardBg = isDark
        ? (_isHovered ? const Color(0xFF131C31) : AppTheme.surface(context))
        : (_isHovered ? Colors.black.withOpacity(0.03) : AppTheme.surface(context));

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: _isHovered ? logColor.withOpacity(0.5) : AppTheme.bd(context)),
        ),
        child: InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: AppTheme.surface(context),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: AppTheme.bd(context))),
                title: Row(children: [
                  Icon(Icons.terminal, color: AppTheme.brand(context), size: 20),
                  const SizedBox(width: 12),
                  Text(I18n.t(context, 'notifications_screen_dialog_title'), style: TextStyle(color: AppTheme.txt(context), fontSize: 15, fontWeight: FontWeight.bold)),
                ]),
                content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('${I18n.t(context, 'notifications_screen_source')}: ${widget.log.botName}', style: TextStyle(color: AppTheme.brand(context))),
                  const SizedBox(height: 12),
                  Text(widget.log.message, style: TextStyle(color: AppTheme.txt(context), fontSize: 13)),
                ]),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(I18n.t(context, 'notifications_screen_dialog_close'), style: TextStyle(color: AppTheme.txtMuted(context))),
                  ),
                ],
              ),
            );
          },
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(children: [
              Icon(logIcon, color: logColor, size: 20),
              const SizedBox(width: 16),
              Text(timeStr, style: AppTheme.monoStyle(fontSize: 13, color: AppTheme.txtMuted(context))),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(widget.log.botName, style: TextStyle(color: AppTheme.txt(context).withOpacity(0.8), fontSize: 11)),
              ),
              const SizedBox(width: 16),
              Expanded(child: Text(widget.log.message, style: TextStyle(color: AppTheme.txt(context), fontSize: 13), overflow: TextOverflow.ellipsis, maxLines: 1))
            ]),
          ),
        ),
      ),
    );
  }
}
