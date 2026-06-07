import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:osts_mobile_app/app_theme.dart';
import 'package:osts_mobile_app/main.dart';
import 'package:osts_mobile_app/init/i18n_manager.dart';

class AppTopBar extends StatelessWidget {
  final bool isMobile;

  const AppTopBar({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final AppLanguage currentLang = I18n.of(context).currentLanguage;

    if (!isMobile) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4), // Сжали вертикальный отступ шапки
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined, size: 20),
              onPressed: () => context.go('/notifications'),
            ),
            const SizedBox(width: 4),
            IconButton(
              icon: Icon(AppTheme.isDark(context) ? Icons.light_mode_outlined : Icons.dark_mode_outlined, size: 20),
              onPressed: () => themeNotifier.value = AppTheme.isDark(context) ? ThemeMode.light : ThemeMode.dark,
            ),
            const SizedBox(width: 4),
            _buildLanguagePicker(context, currentLang, 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                height: 20,
                child: VerticalDivider(width: 1, thickness: 1, color: AppTheme.bd(context)),
              ),
            ),
            _buildAvatar(context, 28),
          ],
        ),
      );
    }

    return Container(
      height: 48.0,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 32,
            height: 32,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => Scaffold.of(context).openDrawer(),
              child: const Center(child: Icon(Icons.menu, size: 22)),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 32,
                height: 32,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => context.go('/notifications'),
                  child: const Center(child: Icon(Icons.notifications_outlined, size: 20)),
                ),
              ),
              const SizedBox(width: 2),
              SizedBox(
                width: 32,
                height: 32,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => themeNotifier.value = AppTheme.isDark(context) ? ThemeMode.light : ThemeMode.dark,
                  child: Center(child: Icon(AppTheme.isDark(context) ? Icons.light_mode_outlined : Icons.dark_mode_outlined, size: 20)),
                ),
              ),
              const SizedBox(width: 2),
              _buildLanguagePicker(context, currentLang, 18),
              const SizedBox(width: 6),
              _buildAvatar(context, 26),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLanguagePicker(BuildContext context, AppLanguage currentLang, double size) {
    return PopupMenuButton<AppLanguage>(
      icon: Text(
        currentLang == AppLanguage.ru ? '🇷🇺' : '🇺🇸',
        style: TextStyle(fontSize: size),
      ),
      tooltip: 'Language',
      color: AppTheme.surface(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: AppTheme.bd(context), width: 1),
      ),
      onSelected: (AppLanguage language) => i18nNotifier.setLanguage(language),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<AppLanguage>>[
        PopupMenuItem<AppLanguage>(
          value: AppLanguage.en,
          child: _buildLanguageItem(context, '🇺🇸 ', 'English', currentLang == AppLanguage.en),
        ),
        PopupMenuItem<AppLanguage>(
          value: AppLanguage.ru,
          child: _buildLanguageItem(context, '🇷🇺 ', 'Русский', currentLang == AppLanguage.ru),
        ),
      ],
    );
  }

  Widget _buildLanguageItem(BuildContext context, String flag, String name, bool isSelected) {
    return Row(
      children: [
        Text(flag, style: const TextStyle(fontSize: 16)),
        Text(
          name,
          style: TextStyle(
            color: isSelected ? AppTheme.brand(context) : AppTheme.txt(context),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        if (isSelected) ...[
          const Spacer(),
          Icon(Icons.check, size: 16, color: AppTheme.brand(context)),
        ]
      ],
    );
  }

  Widget _buildAvatar(BuildContext context, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppTheme.brand(context).withOpacity(0.5), width: 1.5),
        image: const DecorationImage(
          image: NetworkImage('https://unsplash.com'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
