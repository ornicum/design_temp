import 'package:flutter/material.dart';
import 'package:osts_mobile_app/app_theme.dart';
import 'package:osts_mobile_app/init/i18n_manager.dart';

class AppBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AppBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap, // Передаем управление напрямую в оригинальный коллбэк layout.dart
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppTheme.surface(context),
      selectedItemColor: AppTheme.brand(context),
      unselectedItemColor: AppTheme.txtMuted(context),
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
      unselectedLabelStyle: const TextStyle(fontSize: 11),
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.dashboard_outlined, size: 20),
          activeIcon: const Icon(Icons.dashboard, size: 20),
          label: I18n.t(context, 'nav_overview'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.smart_toy_outlined, size: 20),
          activeIcon: const Icon(Icons.smart_toy, size: 20),
          label: I18n.t(context, 'nav_bots'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.analytics_outlined, size: 20),
          activeIcon: const Icon(Icons.analytics, size: 20),
          label: I18n.t(context, 'nav_analytics'),
        ),
      ],
    );
  }
}
