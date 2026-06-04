import 'package:flutter/material.dart';
import 'package:osts_mobile_app/app_theme.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Padding(
      // ИСПРАВЛЕНО: Все отступы урезаны ровно в 2 раза
      padding: const EdgeInsets.only(
        left: 2,
        top: 2,
        bottom: 0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Добро пожаловать',
            style: TextStyle(
              fontSize: width < 600 ? 22 : 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.txt(context),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Обзор вашего торгового портфеля',
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
