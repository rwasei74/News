import 'package:flutter/material.dart';

/// AppThemeConfig manages runtime theme and language state cleanly without complex dependencies.
class AppThemeConfig {
  static final ValueNotifier<ThemeMode> themeModeNotifier =
      ValueNotifier<ThemeMode>(ThemeMode.dark);

  static final ValueNotifier<Locale> localeNotifier =
      ValueNotifier<Locale>(const Locale('en'));

  static void toggleTheme() {
    if (themeModeNotifier.value == ThemeMode.dark) {
      themeModeNotifier.value = ThemeMode.light;
    } else {
      themeModeNotifier.value = ThemeMode.dark;
    }
  }

  static void setThemeMode(ThemeMode mode) {
    themeModeNotifier.value = mode;
  }

  static void toggleLanguage() {
    if (localeNotifier.value.languageCode == 'en') {
      localeNotifier.value = const Locale('ar');
    } else {
      localeNotifier.value = const Locale('en');
    }
  }

  static void setLocale(Locale locale) {
    localeNotifier.value = locale;
  }
}
