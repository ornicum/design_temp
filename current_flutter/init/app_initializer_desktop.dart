import 'dart:io' show Platform, Directory;
import 'package:flutter/foundation.dart'
    show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_rust_bridge/'
    'flutter_rust_bridge_for_generated_io.dart';
import 'package:osts_mobile_app/src/rust/'
    'frb_generated.dart';
import 'app_initializer.dart';

// Критически важно для условного импорта!
export 'app_initializer.dart';

class DesktopInitializer
    implements AppInitializer {
  @override
  Future<void> initialize() async {
    dynamic externalLibrary;

    if (Platform.isLinux && kDebugMode) {
      final String projectDir =
          Directory.current.path;
      final config =
      ExternalLibraryLoaderConfig(
        stem: 'rust_lib_osts_mobile_app',
        ioDirectory:
        '$projectDir/rust/target/debug/',
        webPrefix: 'pkg/',
      );
      externalLibrary =
      await loadExternalLibrary(config);
    }

    await RustLib.init(
      externalLibrary: externalLibrary,
    );
  }

  @override
  void syncThemeWithWeb(ThemeMode mode) {}
}

Future<AppInitializer> getInitializer() async =>
    DesktopInitializer();
