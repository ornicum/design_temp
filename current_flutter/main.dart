import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'app_router.dart';

// Импортируем интерфейс напрямую в область видимости
import 'init/app_initializer.dart'
if (dart.library.io) 'init/app_initializer_desktop.dart'
if (dart.library.html) 'init/app_initializer_web.dart';

final themeNotifier =
ValueNotifier<ThemeMode>(ThemeMode.dark);

// Теперь тип AppInitializer виден без префиксов
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
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, _) {
        return MaterialApp.router(
          title: 'Trading Bot Platform',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: currentMode,
          routerConfig: appRouter,
        );
      },
    );
  }
}
