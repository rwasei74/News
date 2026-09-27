import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'utils/app_colors.dart';
import 'utils/app_localizations.dart';
import 'utils/app_routes.dart';
import 'utils/app_theme_config.dart';

void main() {
  runApp(const NewsApp());
}

class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: AppThemeConfig.localeNotifier,
      builder: (context, currentLocale, _) {
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: AppThemeConfig.themeModeNotifier,
          builder: (context, currentThemeMode, _) {
            return MaterialApp(
              title: 'News App',
              debugShowCheckedModeBanner: false,

              // Localization setup
              locale: currentLocale,
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],

              // Light Theme
              theme: ThemeData(
                useMaterial3: true,
                brightness: Brightness.light,
                textTheme: GoogleFonts.interTextTheme(),
                scaffoldBackgroundColor: AppColors.lightBackground,
                appBarTheme: const AppBarTheme(
                  backgroundColor: AppColors.lightBackground,
                  foregroundColor: AppColors.lightTextPrimary,
                  elevation: 0,
                ),
                colorScheme: const ColorScheme.light(
                  primary: AppColors.primary,
                  surface: AppColors.lightSurface,
                  onSurface: AppColors.lightTextPrimary,
                ),
              ),

              // Dark Theme
              darkTheme: ThemeData(
                useMaterial3: true,
                brightness: Brightness.dark,
                textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
                scaffoldBackgroundColor: AppColors.darkBackground,
                appBarTheme: const AppBarTheme(
                  backgroundColor: AppColors.darkBackground,
                  foregroundColor: AppColors.darkTextPrimary,
                  elevation: 0,
                ),
                colorScheme: const ColorScheme.dark(
                  primary: AppColors.darkSurface,
                  surface: AppColors.darkSurface,
                  onSurface: AppColors.darkTextPrimary,
                ),
              ),

              themeMode: currentThemeMode,
              initialRoute: AppRoutes.splash,
              onGenerateRoute: AppRoutes.onGenerateRoute,
            );
          },
        );
      },
    );
  }
}
