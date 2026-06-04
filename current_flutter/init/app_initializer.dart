import 'package:flutter/material.dart';

abstract class AppInitializer {
  Future<void> initialize();
  void syncThemeWithWeb(ThemeMode mode);
}

// Заглушка, которая будет подменяться сборщиком
Future<AppInitializer> getInitializer() =>
    throw UnsupportedError('Cannot create initializer');
