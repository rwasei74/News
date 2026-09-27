import 'package:flutter/material.dart';

/// AppLocalizations handles Arabic and English translations cleanly without bulky boilerplate.
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('en'));
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('ar'),
  ];

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_title': 'News App',
      'home': 'Home',
      'go_to_home': 'Go To Home',
      'good_morning': 'Good Morning\nHere is Some News For You',
      'search': 'Search',
      'view_all': 'View All',
      'categories': 'Categories',
      'theme': 'Theme',
      'language': 'Language',
      'dark_mode': 'Dark',
      'light_mode': 'Light',
      'arabic': 'Arabic',
      'english': 'English',
      'general': 'General',
      'business': 'Business',
      'sports': 'Sports',
      'technology': 'Technology',
      'science': 'Science',
      'health': 'Health',
      'entertainment': 'Entertainment',
      'supervised_by': 'Supervised by Mohamed Nabil',
    },
    'ar': {
      'app_title': 'تطبيق الأخبار',
      'home': 'الرئيسية',
      'go_to_home': 'الذهاب إلى الرئيسية',
      'good_morning': 'صباح الخير\nإليك بعض الأخبار لك',
      'search': 'بحث',
      'view_all': 'عرض الكل',
      'categories': 'الأقسام',
      'theme': 'المظهر',
      'language': 'اللغة',
      'dark_mode': 'داكن',
      'light_mode': 'فاتح',
      'arabic': 'العربية',
      'english': 'الإنجليزية',
      'general': 'عام',
      'business': 'أعمال',
      'sports': 'رياضة',
      'technology': 'تكنولوجيا',
      'science': 'علوم',
      'health': 'صحة',
      'entertainment': 'ترفيه',
      'supervised_by': 'إشراف محمد نبيل',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }

  // Common Getters
  String get appTitle => translate('app_title');
  String get home => translate('home');
  String get goodMorning => translate('good_morning');
  String get search => translate('search');
  String get viewAll => translate('view_all');
  String get categories => translate('categories');
  String get theme => translate('theme');
  String get language => translate('language');
  String get darkMode => translate('dark_mode');
  String get lightMode => translate('light_mode');
  String get arabic => translate('arabic');
  String get english => translate('english');
  String get general => translate('general');
  String get business => translate('business');
  String get sports => translate('sports');
  String get technology => translate('technology');
  String get science => translate('science');
  String get health => translate('health');
  String get entertainment => translate('entertainment');
  String get supervisedBy => translate('supervised_by');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
