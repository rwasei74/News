import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_localizations.dart';
import '../../utils/app_theme_config.dart';

/// AppDrawer renders the sleek drawer designed with:
/// - White "News App" header
/// - Dark background (#171717)
/// - "Go To Home" navigation item
/// - "Theme" dropdown selector (Dark / Light)
/// - "Language" dropdown selector (English / Arabic)
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final currentLocale = Localizations.localeOf(context);

    return Drawer(
      backgroundColor: AppColors.darkBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // White Header Container with "News App"
          Container(
            height: 180,
            color: Colors.white,
            alignment: Alignment.center,
            child: Text(
              localizations.appTitle,
              style: const TextStyle(
                color: Color(0xFF171717),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              children: [
                // Go To Home
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.home_outlined,
                          color: Colors.white,
                          size: 26,
                        ),
                        const SizedBox(width: 16),
                        Text(
                          localizations.translate('go_to_home'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const Divider(color: Color(0xFF333333), height: 32),

                // Theme Section
                Row(
                  children: [
                    const Icon(
                      Icons.palette_outlined,
                      color: Colors.white,
                      size: 22,
                    ),
                    const SizedBox(width: 14),
                    Text(
                      localizations.theme,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ValueListenableBuilder<ThemeMode>(
                  valueListenable: AppThemeConfig.themeModeNotifier,
                  builder: (context, themeMode, _) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.darkBackground,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<ThemeMode>(
                          value: themeMode,
                          isExpanded: true,
                          dropdownColor: const Color(0xFF222222),
                          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                          items: [
                            DropdownMenuItem(
                              value: ThemeMode.dark,
                              child: Text(localizations.darkMode),
                            ),
                            DropdownMenuItem(
                              value: ThemeMode.light,
                              child: Text(localizations.lightMode),
                            ),
                          ],
                          onChanged: (newMode) {
                            if (newMode != null) {
                              AppThemeConfig.setThemeMode(newMode);
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),

                const Divider(color: Color(0xFF333333), height: 32),

                // Language Section
                Row(
                  children: [
                    const Icon(
                      Icons.public,
                      color: Colors.white,
                      size: 22,
                    ),
                    const SizedBox(width: 14),
                    Text(
                      localizations.language,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.darkBackground,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: currentLocale.languageCode,
                      isExpanded: true,
                      dropdownColor: const Color(0xFF222222),
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      items: [
                        DropdownMenuItem(
                          value: 'en',
                          child: Text(localizations.english),
                        ),
                        DropdownMenuItem(
                          value: 'ar',
                          child: Text(localizations.arabic),
                        ),
                      ],
                      onChanged: (newLang) {
                        if (newLang != null) {
                          AppThemeConfig.setLocale(Locale(newLang));
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
