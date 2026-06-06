import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:osts_mobile_app/app_theme.dart';
import 'package:osts_mobile_app/init/i18n_manager.dart';
import 'package:osts_mobile_app/components/layout/interactive_nav_item.dart';
import 'package:osts_mobile_app/components/layout/footer_action_button.dart';

class AppSidebar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onItemTapped;

  const AppSidebar({
    super.key,
    required this.currentIndex,
    required this.onItemTapped,
  });

  @override
  State<AppSidebar> createState() => _AppSidebarState();
}

class _AppSidebarState extends State<AppSidebar> {
  bool _isSidebarCollapsed = false;

  @override
  Widget build(BuildContext context) {
    final double sidebarWidth = _isSidebarCollapsed ? 72.0 : 240.0;

    // Получаем текущий путь для визуальной подсветки элементов (isCurrent под капотом)
    final String currentPath = GoRouterState.of(context).uri.path;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      width: sidebarWidth,
      height: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.surface(context),
        border: Border(
          right: BorderSide(color: AppTheme.bd(context), width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Icon(Icons.bolt, color: AppTheme.brand(context), size: 28),
                if (!_isSidebarCollapsed) ...[
                  const SizedBox(width: 10),
                  Text(
                    'OSTS TERMINAL',
                    style: TextStyle(
                      color: AppTheme.txt(context),
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  InteractiveNavItem(
                    icon: Icons.dashboard_outlined,
                    label: I18n.t(context, 'nav_overview'),
                    path: '/dashboard',
                    currentPath: currentPath,
                    isCollapsed: _isSidebarCollapsed,
                    onTap: () => widget.onItemTapped(0), // ИСПРАВЛЕНО: Передаем напрямую по правилам архитектуры
                  ),
                  const SizedBox(height: 4),
                  InteractiveNavItem(
                    icon: Icons.smart_toy_outlined,
                    label: I18n.t(context, 'nav_bots'),
                    path: '/bots',
                    currentPath: currentPath,
                    isCollapsed: _isSidebarCollapsed,
                    onTap: () => widget.onItemTapped(1),
                  ),
                  const SizedBox(height: 4),
                  InteractiveNavItem(
                    icon: Icons.analytics_outlined,
                    label: I18n.t(context, 'nav_analytics'),
                    path: '/analytics',
                    currentPath: currentPath,
                    isCollapsed: _isSidebarCollapsed,
                    onTap: () => widget.onItemTapped(2),
                  ),
                  const SizedBox(height: 4),
                  InteractiveNavItem(
                    icon: Icons.vpn_key_outlined,
                    label: I18n.t(context, 'nav_api_keys'),
                    path: '/api-keys',
                    currentPath: currentPath,
                    isCollapsed: _isSidebarCollapsed,
                    onTap: () => widget.onItemTapped(3),
                  ),
                  const SizedBox(height: 4),
                  InteractiveNavItem(
                    icon: Icons.settings_outlined,
                    label: I18n.t(context, 'nav_settings'),
                    path: '/settings',
                    currentPath: currentPath,
                    isCollapsed: _isSidebarCollapsed,
                    onTap: () => widget.onItemTapped(4),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                // Скрываем кнопку сворачивания для мобильных экранов
                if (MediaQuery.of(context).size.width >= 900) ...[
                  FooterActionButton(
                    icon: _isSidebarCollapsed ? Icons.chevron_right : Icons.chevron_left,
                    label: I18n.t(context, 'nav_collapse'),
                    isCollapsed: _isSidebarCollapsed,
                    onTap: () => setState(() => _isSidebarCollapsed = !_isSidebarCollapsed),
                  ),
                  const SizedBox(height: 6),
                ],
                FooterActionButton(
                  icon: Icons.logout,
                  label: I18n.t(context, 'nav_logout'),
                  isCollapsed: MediaQuery.of(context).size.width < 900 ? false : _isSidebarCollapsed, // На мобилке всегда развернут текст
                  onTap: () => context.go('/login'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
