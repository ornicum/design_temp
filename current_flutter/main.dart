import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'app_router.dart';
import 'init/i18n_manager.dart';
import 'init/app_initializer.dart'
if (dart.library.io) 'init/app_initializer_desktop.dart'
if (dart.library.html) 'init/app_initializer_web.dart';

final themeNotifier = ValueNotifier<ThemeMode>(ThemeMode.dark);
late final AppInitializer platformInit;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  platformInit = await getInitializer();
  await platformInit.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Внедряем i18nNotifier через кастомный InheritedNotifier в самый верх дерева
    return I18n(
      notifier: i18nNotifier,
      child: ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
        builder: (context, currentThemeMode, _) {
          return MaterialApp.router(
            title: 'Trading Bot Platform',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: currentThemeMode,
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}
