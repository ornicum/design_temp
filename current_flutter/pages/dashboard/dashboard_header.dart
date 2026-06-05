import 'package:flutter/material.dart';
import 'package:osts_mobile_app/app_theme.dart';
import 'package:osts_mobile_app/init/i18n_manager.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(
        left: 2, top: 2, bottom: 0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            I18n.t(context, 'dash_welcome'), // ПЕРЕВЕДЕНО
            style: TextStyle(
              fontSize: width < 600 ? 22 : 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.txt(context),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            I18n.t(context, 'dash_overview'), // ПЕРЕВЕДЕНО
            style: TextStyle(
              fontSize: 13,
              color: AppTheme.txtMuted(context),
            ),
          ),
        ],
      ),
    );
  }
}
