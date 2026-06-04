import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:osts_mobile_app/pages/bots_page.dart';
import 'components/layout.dart';
import 'pages/dashboard_page.dart';
import 'pages/login_page.dart';

bool isUserAuthenticated = true;

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final bool loggingIn = state.uri.path == '/login';
    if (!isUserAuthenticated && !loggingIn) return '/login';
    if (isUserAuthenticated && loggingIn) return '/';
    return null;
  },
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    // ИСПРАВЛЕНО: Маршрутизатор ShellRoute прокидывает child в AppLayout
    ShellRoute(
      builder: (context, state, child) {
        return AppLayout(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const DashboardPage(),
        ),
        GoRoute(
          path: '/bots',
          builder: (context, state) => const BotsPage(),
        ),
      ],
    ),
  ],
);
