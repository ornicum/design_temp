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
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // 1. Уведомления (Колокольчик)
            IconButton(
              icon: const Icon(Icons.notifications_outlined, size: 20),
              onPressed: () => context.go('/notifications'),
            ),
            const SizedBox(width: 4),

            // 2. Переключатель темы оформления (Солнышко)
            IconButton(
              icon: Icon(AppTheme.isDark(context) ? Icons.light_mode_outlined : Icons.dark_mode_outlined, size: 20),
              onPressed: () => themeNotifier.value = AppTheme.isDark(context) ? ThemeMode.light : ThemeMode.dark,
            ),
            const SizedBox(width: 4),

            // 3. Выбор языка с динамическим флагом активной локали
            PopupMenuButton<AppLanguage>(
              icon: Text(
                currentLang == AppLanguage.ru ? '🇷🇺' : '🇺🇸',
                style: const TextStyle(fontSize: 20),
              ),
              tooltip: 'Смена языка / Change Language',
              color: AppTheme.surface(context),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: AppTheme.bd(context), width: 1),
              ),
              onSelected: (AppLanguage language) {
                i18nNotifier.setLanguage(language);
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<AppLanguage>>[
                PopupMenuItem<AppLanguage>(
                  value: AppLanguage.ru,
                  child: Row(
                    children: [
                      const Text('🇷🇺  ', style: TextStyle(fontSize: 16)),
                      Text(
                        'Русский',
                        style: TextStyle(
                          color: currentLang == AppLanguage.ru ? AppTheme.brand(context) : AppTheme.txt(context),
                          fontWeight: currentLang == AppLanguage.ru ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      if (currentLang == AppLanguage.ru) ...[
                        const Spacer(),
                        Icon(Icons.check, size: 16, color: AppTheme.brand(context)),
                      ]
                    ],
                  ),
                ),
                PopupMenuItem<AppLanguage>(
                  value: AppLanguage.en,
                  child: Row(
                    children: [
                      const Text('🇺🇸  ', style: TextStyle(fontSize: 16)),
                      Text(
                        'English',
                        style: TextStyle(
                          color: currentLang == AppLanguage.en ? AppTheme.brand(context) : AppTheme.txt(context),
                          fontWeight: currentLang == AppLanguage.en ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      if (currentLang == AppLanguage.en) ...[
                        const Spacer(),
                        Icon(Icons.check, size: 16, color: AppTheme.brand(context)),
                      ]
                    ],
                  ),
                ),
              ],
            ),

            // 4. Вертикальный разделитель зон
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                height: 20,
                child: VerticalDivider(width: 1, thickness: 1, color: AppTheme.bd(context)),
              ),
            ),

            // 5. Твой оригинальный аватар с неоновой рамкой
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.brand(context).withOpacity(0.5), width: 1.5),
                image: const DecorationImage(
                  image: NetworkImage('https://unsplash.com'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      height: 40.0,
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
              // Мобильный переключатель языка с флагом
              PopupMenuButton<AppLanguage>(
                icon: Text(
                  currentLang == AppLanguage.ru ? '🇷🇺' : '🇺🇸',
                  style: const TextStyle(fontSize: 18),
                ),
                tooltip: 'Language',
                color: AppTheme.surface(context),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: AppTheme.bd(context), width: 1),
                ),
                onSelected: (AppLanguage language) {
                  i18nNotifier.setLanguage(language);
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<AppLanguage>>[
                  PopupMenuItem<AppLanguage>(
                    value: AppLanguage.ru,
                    child: Row(
                      children: [
                        const Text('🇷🇺  ', style: TextStyle(fontSize: 16)),
                        Text(
                          'Русский',
                          style: TextStyle(
                            color: currentLang == AppLanguage.ru ? AppTheme.brand(context) : AppTheme.txt(context),
                            fontWeight: currentLang == AppLanguage.ru ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        if (currentLang == AppLanguage.ru) ...[
                          const Spacer(),
                          Icon(Icons.check, size: 16, color: AppTheme.brand(context)),
                        ]
                      ],
                    ),
                  ),
                  PopupMenuItem<AppLanguage>(
                    value: AppLanguage.en,
                    child: Row(
                      children: [
                        const Text('🇺🇸  ', style: TextStyle(fontSize: 16)),
                        Text(
                          'English',
                          style: TextStyle(
                            color: currentLang == AppLanguage.en ? AppTheme.brand(context) : AppTheme.txt(context),
                            fontWeight: currentLang == AppLanguage.en ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        if (currentLang == AppLanguage.en) ...[
                          const Spacer(),
                          Icon(Icons.check, size: 16, color: AppTheme.brand(context)),
                        ]
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 32,
                height: 32,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => themeNotifier.value = AppTheme.isDark(context) ? ThemeMode.light : ThemeMode.dark,
                  child: Center(child: Icon(AppTheme.isDark(context) ? Icons.light_mode_outlined : Icons.dark_mode_outlined, size: 20)),
                ),
              ),
              SizedBox(
                width: 32,
                height: 32,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => context.go('/notifications'),
                  child: const Center(child: Icon(Icons.notifications_outlined, size: 20)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
