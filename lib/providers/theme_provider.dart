import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

class ThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    var settingsBox = Hive.box('settingsBox');
    var isDark = settingsBox.get('isDarkMode', defaultValue: false);
    return isDark ? ThemeMode.dark : ThemeMode.light;
  }

  void toggleTheme() {
    var settingsBox = Hive.box('settingsBox');
    if (state == ThemeMode.light) {
      state = ThemeMode.dark;
      settingsBox.put('isDarkMode', true);
    } else {
      state = ThemeMode.light;
      settingsBox.put('isDarkMode', false);
    }
  }
}

final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(() {
  return ThemeNotifier();
});
