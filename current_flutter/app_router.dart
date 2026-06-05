import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:osts_mobile_app/components/layout.dart';
import 'package:osts_mobile_app/pages/dashboard_page.dart';
import 'package:osts_mobile_app/pages/bots_page.dart';
import 'package:osts_mobile_app/pages/analytics_page.dart';
import 'package:osts_mobile_app/pages/api_keys_page.dart';
import 'package:osts_mobile_app/pages/settings_page.dart';
import 'package:osts_mobile_app/pages/login_page.dart';
import 'package:osts_mobile_app/pages/notifications_page.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/dashboard',
  routes: [
    GoRoute(
      path: '/login',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const LoginScreen(),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return AppLayout(child: child);
      },
      routes: [
        GoRoute(
          path: '/dashboard',
          parentNavigatorKey: _shellNavigatorKey,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: DashboardPage(),
          ),
        ),
        GoRoute(
          path: '/bots',
          parentNavigatorKey: _shellNavigatorKey,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: BotsPage(),
          ),
        ),
        GoRoute(
          path: '/analytics',
          parentNavigatorKey: _shellNavigatorKey,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: AnalyticsScreen(), // СИНХРОНИЗИРОВАНО: Реальное имя класса
          ),
        ),
        GoRoute(
          path: '/api-keys',
          parentNavigatorKey: _shellNavigatorKey,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ApiKeysScreen(), // СИНХРОНИЗИРОВАНО: Реальное имя класса
          ),
        ),
        GoRoute(
          path: '/settings',
          parentNavigatorKey: _shellNavigatorKey,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: SettingsScreen(), // СИНХРОНИЗИРОВАНО: Реальное имя класса
          ),
        ),
        GoRoute(
          path: '/notifications',
          parentNavigatorKey: _shellNavigatorKey,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: NotificationsScreen(), // СИНХРОНИЗИРОВАНО: Реальное имя класса
          ),
        ),
      ],
    ),
  ],
  redirect: (context, state) {
    return null;
  },
);
