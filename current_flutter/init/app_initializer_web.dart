import 'package:flutter/material.dart';
import 'package:osts_mobile_app/src/rust/'
    'frb_generated.dart';
import 'package:universal_html/html.dart'
as html;
import '../main.dart';
import 'app_initializer.dart';

// Критически важно для условного импорта!
export 'app_initializer.dart';

class WebInitializer implements AppInitializer {
  @override
  Future<void> initialize() async {
    await RustLib.init();

    final saved =
    html.window.localStorage['theme'];
    if (saved == 'light') {
      themeNotifier.value = ThemeMode.light;
    } else {
      themeNotifier.value = ThemeMode.dark;
    }
  }

  @override
  void syncThemeWithWeb(ThemeMode mode) {
    final root =
        html.document.documentElement;
    if (root != null) {
      if (mode == ThemeMode.dark) {
        root.classList.add('dark');
        html.window.localStorage['theme'] =
        'dark';
      } else {
        root.classList.remove('dark');
        html.window.localStorage['theme'] =
        'light';
      }
    }
  }
}

Future<AppInitializer> getInitializer() async =>
    WebInitializer();
