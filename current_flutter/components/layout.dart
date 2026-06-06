import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:osts_mobile_app/app_theme.dart';
import 'package:osts_mobile_app/components/layout/app_top_bar.dart';
import 'package:osts_mobile_app/components/layout/app_sidebar.dart';
import 'package:osts_mobile_app/components/layout/app_bottom_bar.dart';

class AppLayout extends StatelessWidget {
  final Widget child;

  // Создаем глобальный ключ для прямого контроля состояния Scaffold
  static final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  const AppLayout({
    super.key,
    required this.child,
  });

  int _getSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/bots')) return 1;
    if (location.startsWith('/analytics')) return 2;
    if (location.startsWith('/api-keys')) return 3;
    if (location.startsWith('/settings')) return 4;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    // Управляем шторкой напрямую через GlobalKey в обход контекста
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
      _scaffoldKey.currentState?.closeDrawer();
    }

    switch (index) {
      case 0: context.go('/dashboard'); break;
      case 1: context.go('/bots'); break;
      case 2: context.go('/analytics'); break;
      case 3: context.go('/api-keys'); break;
      case 4: context.go('/settings'); break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool isMobile = width < 900;
    final int currentIndex = _getSelectedIndex(context);

    return Scaffold(
      key: _scaffoldKey, // Привязываем ключ управления
      backgroundColor: AppTheme.bg(context),
      bottomNavigationBar: isMobile ? AppBottomBar(
        currentIndex: currentIndex,
        onTap: (index) => _onItemTapped(index, context),
      ) : null,
      drawer: isMobile ? Drawer(
        backgroundColor: AppTheme.sidebar(context),
        child: AppSidebar(
          currentIndex: currentIndex,
          onItemTapped: (index) => _onItemTapped(index, context),
        ),
      ) : null,
      body: Row(
        children: [
          if (!isMobile)
            AppSidebar(
              currentIndex: currentIndex,
              onItemTapped: (index) => _onItemTapped(index, context),
            ),
          Expanded(
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  AppTopBar(isMobile: isMobile),
                  Divider(height: 1, thickness: 1, color: AppTheme.bd(context)),
                  Expanded(
                    child: child,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
