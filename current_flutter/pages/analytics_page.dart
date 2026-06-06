import 'package:flutter/material.dart';
import 'package:osts_mobile_app/app_theme.dart';
import 'package:osts_mobile_app/init/i18n_manager.dart';
import 'package:osts_mobile_app/data/repositories/analytics_mock_repository.dart';
import 'package:osts_mobile_app/data/models/analytics_models.dart';
import 'analytics/analytics_stats_grid.dart';
import 'analytics/analytics_charts_section.dart';
import 'analytics/analytics_bots_table.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  // Получаем готовую модель данных из репозитория
  final RustAnalyticsState _analyticsState = AnalyticsMockRepository.getMockState();

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              I18n.t(context, 'analytics_screen_title'),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.txt(context), letterSpacing: -0.5),
            ),
            const SizedBox(height: 2),
            Text(
              I18n.t(context, 'analytics_screen_subtitle'),
              style: TextStyle(fontSize: 13, color: AppTheme.txtMuted(context)),
            ),
            const SizedBox(height: 24),
            AnalyticsStatsGrid(metrics: _analyticsState.topMetrics),
            const SizedBox(height: 20),
            AnalyticsChartsSection(width: width, state: _analyticsState),
            const SizedBox(height: 20),
            AnalyticsBotsTable(bots: _analyticsState.tableBots),
          ],
        ),
      ),
    );
  }
}
