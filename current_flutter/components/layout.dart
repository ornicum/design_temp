import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:osts_mobile_app/app_theme.dart';
import 'package:osts_mobile_app/main.dart';
import 'package:osts_mobile_app/components/layout/'
    'interactive_nav_item.dart';
import 'package:osts_mobile_app/components/layout/'
    'footer_action_button.dart';

class AppLayout extends StatefulWidget {
  final Widget child;

  const AppLayout({super.key, required this.child});

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  bool _isCollapsed = false;

  @override
  Widget build(BuildContext context) {
    final bool isMobile =
        MediaQuery.of(context).size.width < 1024;

    return Scaffold(
      backgroundColor: AppTheme.bg(context),
      drawer: isMobile ? _buildMobileDrawer() : null,
      bottomNavigationBar: isMobile ? _buildMobileNav() : null,
      body: SafeArea(
        child: isMobile
            ? Column(
          children: [
            _buildTopBar(isMobile),
            // ИСПРАВЛЕНО: Тонкая серая линия режет
            // пустоту и отделяет TopBar в светлой теме
            Divider(
              color: AppTheme.bd(context),
              height: 1,
            ),
            Expanded(child: widget.child),
          ],
        )
            : Stack(
          children: [
            AnimatedPadding(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              padding: EdgeInsets.only(
                left: _isCollapsed ? 64.0 : 240.0,
              ),
              child: Column(
                children: [
                  _buildTopBar(isMobile),
                  Expanded(child: widget.child),
                ],
              ),
            ),
            _buildDesktopSidebar(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(bool isMobile) {
    final double width = MediaQuery.of(context).size.width;

    if (!isMobile) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: Icon(
                AppTheme.isDark(context)
                    ? Icons.light_mode_outlined
                    : Icons.dark_mode_outlined,
                size: 20,
              ),
              onPressed: () {
                themeNotifier.value = AppTheme.isDark(context)
                    ? ThemeMode.light
                    : ThemeMode.dark;
              },
            ),
            const SizedBox(width: 4),
            IconButton(
              icon: const Icon(
                Icons.notifications_outlined,
                size: 20,
              ),
              onPressed: () => context.go('/notifications'),
            ),
          ],
        ),
      );
    }

    // ИСПРАВЛЕНО: Максимально плотная, зажатая шапка Binance
    return Container(
      height: 40.0,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Левая кнопка меню (Бургер) 32x32
          SizedBox(
            width: 32,
            height: 32,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => Scaffold.of(context).openDrawer(),
              child: const Center(
                child: Icon(Icons.menu, size: 22),
              ),
            ),
          ),

          // Правая группа (Сверх-компактный блок иконок)
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Кнопка переключения темы 32x32
              SizedBox(
                width: 32,
                height: 32,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    themeNotifier.value = AppTheme.isDark(context)
                        ? ThemeMode.light
                        : ThemeMode.dark;
                  },
                  child: Center(
                    child: Icon(
                      AppTheme.isDark(context)
                          ? Icons.light_mode_outlined
                          : Icons.dark_mode_outlined,
                      size: 20,
                    ),
                  ),
                ),
              ),
              // Убрали лишний SizedBox(width), иконки теперь стоят плотно

              // Кнопка уведомлений 32x32
              SizedBox(
                width: 32,
                height: 32,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => context.go('/notifications'),
                  child: const Center(
                    child: Icon(
                      Icons.notifications_outlined,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopSidebar() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      width: _isCollapsed ? 64.0 : 240.0,
      height: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.sidebar(context),
        border: Border(
          right: BorderSide(color: AppTheme.bd(context)),
        ),
      ),
      child: ClipRect(
        child: Column(
          children: [
            _buildSidebarHeader(),
            Expanded(child: _buildNavigationList()),
            _buildSidebarFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebarHeader() {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppTheme.bd(context)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppTheme.brand(context).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.bolt,
              color: AppTheme.brand(context),
              size: 18,
            ),
          ),
          Visibility(
            visible: !_isCollapsed,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 12),
                Text(
                  'OSTS',
                  style: TextStyle(
                    color: AppTheme.txt(context),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationList() {
    final currentPath = GoRouterState.of(context).uri.path;

    return ListView(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 8,
      ),
      children: [
        InteractiveNavItem(
          icon: Icons.dashboard,
          label: 'Обзор',
          path: '/',
          currentPath: currentPath,
          isCollapsed: _isCollapsed,
        ),
        InteractiveNavItem(
          icon: Icons.smart_toy,
          label: 'Боты',
          path: '/bots',
          currentPath: currentPath,
          isCollapsed: _isCollapsed,
        ),
        InteractiveNavItem(
          icon: Icons.bar_chart,
          label: 'Аналитика',
          path: '/analytics',
          currentPath: currentPath,
          isCollapsed: _isCollapsed,
        ),
        InteractiveNavItem(
          icon: Icons.vpn_key,
          label: 'API Ключи',
          path: '/api-keys',
          currentPath: currentPath,
          isCollapsed: _isCollapsed,
        ),
        InteractiveNavItem(
          icon: Icons.settings,
          label: 'Настройки',
          path: '/settings',
          currentPath: currentPath,
          isCollapsed: _isCollapsed,
        ),
      ],
    );
  }

  Widget _buildSidebarFooter() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: AppTheme.bd(context)),
        ),
      ),
      child: Column(
        children: [
          FooterActionButton(
            icon: Icons.logout,
            label: 'Выход',
            isCollapsed: _isCollapsed,
            isDestructive: true,
            onTap: () {},
          ),
          FooterActionButton(
            icon: _isCollapsed ? Icons.chevron_right : Icons.chevron_left,
            label: 'Свернуть',
            isCollapsed: _isCollapsed,
            onTap: () => setState(() => _isCollapsed = !_isCollapsed),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileDrawer() {
    return Drawer(
      backgroundColor: AppTheme.sidebar(context),
      child: Column(
        children: [
          const SizedBox(height: 64),
          Expanded(child: _buildNavigationList()),
        ],
      ),
    );
  }

  Widget _buildMobileNav() {
    final currentPath = GoRouterState.of(context).uri.path;

    return BottomNavigationBar(
      backgroundColor: AppTheme.sidebar(context),
      selectedItemColor: AppTheme.brand(context),
      unselectedItemColor: AppTheme.txtMuted(context),
      currentIndex: _getMobileIndex(currentPath),
      onTap: _onMobileTap,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.dashboard), label: 'Обзор'),
        BottomNavigationBarItem(icon: Icon(Icons.smart_toy), label: 'Боты'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Настройки'),
      ],
    );
  }

  int _getMobileIndex(String path) {
    if (path.startsWith('/bots')) return 1;
    if (path.startsWith('/settings')) return 2;
    return 0;
  }

  void _onMobileTap(int index) {
    if (index == 0) context.go('/');
    if (index == 1) context.go('/bots');
    if (index == 2) context.go('/settings');
  }
}
