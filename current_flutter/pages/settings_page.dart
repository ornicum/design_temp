import 'package:flutter/material.dart';
import '../app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Локальное состояние тумблеров для симуляции UI
  bool _telegramAlerts = true;
  bool _emailAlerts = false;
  bool _is2FAEnabled = true;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool isMobile = width < 900;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Настройки системы', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        backgroundColor: AppTheme.background,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isMobile) ...[
              _buildSecurityCard(),
              const SizedBox(height: 24),
              _buildNotificationCard(),
            ] else ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 5, child: _buildSecurityCard()),
                  const SizedBox(width: 24),
                  Expanded(flex: 5, child: _buildNotificationCard()),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

    Widget _buildSecurityCard() {
    return _HoverSettingsCard(
      title: 'Безопасность аккаунта',
      icon: Icons.security_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ИСПРАВЛЕНИЕ: Заменили голый Row со Switch на наш интерактивный класс с ховером!
          _InteractiveSwitchRow(
            title: 'Двухфакторная аутентификация (2FA)',
            subtitle: 'Защита вывода средств и изменения API',
            value: _is2FAEnabled,
            onChanged: (val) => setState(() => _is2FAEnabled = val),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Divider(color: AppTheme.border)),
          const Text('Сессия терминала', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E293B),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            child: const Text('Завершить другие сессии', style: TextStyle(color: Colors.white, fontSize: 13)),
          ),
        ],
      ),
    );
  }


  Widget _buildNotificationCard() {
    return _HoverSettingsCard(
      title: 'Уведомления и логи',
      icon: Icons.notifications_none_outlined,
      child: Column(
        children: [
          _buildSwitchRow(
            title: 'Алерты в Telegram',
            subtitle: 'Отправка сообщений об исполнении ордеров ботов',
            value: _telegramAlerts,
            onChanged: (val) => setState(() => _telegramAlerts = val),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(color: AppTheme.border)),
          _buildSwitchRow(
            title: 'Отчеты на Email',
            subtitle: 'Еженедельная аналитика PnL и винрейта на почту',
            value: _emailAlerts,
            onChanged: (val) => setState(() => _emailAlerts = val),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchRow({required String title, required String subtitle, required bool value, required Function(bool) onChanged}) {
    // Вызываем наш новый интерактивный блок строки с точечной подсветкой тумблера
    return _InteractiveSwitchRow(
      title: title,
      subtitle: subtitle,
      value: value,
      onChanged: onChanged,
    );
  }
}

// Новый микро-виджет строки с точечной подсветкой переключателя
class _InteractiveSwitchRow extends StatefulWidget {
  final String title; final String subtitle; final bool value; final Function(bool) onChanged;
  const _InteractiveSwitchRow({required this.title, required this.subtitle, required this.value, required this.onChanged});
  @override State<_InteractiveSwitchRow> createState() => _InteractiveSwitchRowState();
}

class _InteractiveSwitchRowState extends State<_InteractiveSwitchRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Текст названия опции загорается ярче при наведении на строку
                Text(widget.title, style: TextStyle(color: _isHovered ? Colors.white : const Color(0xFFCBD5E1), fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(widget.subtitle, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          // ЭЛЕМЕНТ ВЗАИМОДЕЙСТВИЯ: Тумблер получает неоновое свечение вокруг бегунка при наведении мыши
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: _isHovered && widget.value
                  ? [BoxShadow(color: AppTheme.primary.withOpacity(0.3), blurRadius: 14, spreadRadius: 4)]
                  : null,
            ),
            child: Switch(
              value: widget.value,
              activeColor: AppTheme.primary,
              activeTrackColor: AppTheme.primary.withOpacity(0.15),
              inactiveTrackColor: const Color(0xFF1E293B),
              onChanged: widget.onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

// Строгая базовая карточка без кричащих внешних ховеров рамок
class _HoverSettingsCard extends StatelessWidget {
  final String title; final IconData icon; final Widget child;
  const _HoverSettingsCard({required this.title, required this.icon, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0E1424),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Icon(icon, color: AppTheme.primary, size: 20), const SizedBox(width: 12), Text(title, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold))]),
          const SizedBox(height: 24),
          child,
        ],
      ),
    );
  }
}
