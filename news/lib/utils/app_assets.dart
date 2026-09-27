/// AppAssets provides strongly-typed, centralized references to all image and icon assets.
class AppAssets {
  AppAssets._();

  static const String _imagesPath = 'assets/images';

  // Splash & Logos
  static const String newsLogoLight = '$_imagesPath/news_logo.png'; // White microphone for Dark mode
  static const String newsLogoDark = '$_imagesPath/news_logo_dark.png'; // Dark microphone for Light mode
  static const String newsLogoTransparent = '$_imagesPath/news_logo (1).png';

  // Categories (Clean Light mode versions without embedded texts)
  static const String categoryGeneralClean = '$_imagesPath/general_clean.png';
  static const String categoryBusinessClean = '$_imagesPath/business_clean.png';
  static const String categorySportsClean = '$_imagesPath/sports_clean.png';
  static const String categoryTechnologyClean = '$_imagesPath/technology_clean.png';
  static const String categoryScienceClean = '$_imagesPath/science_clean.png';
  static const String categoryHealthClean = '$_imagesPath/health_clean.png';
  static const String categoryEntertainmentClean = '$_imagesPath/entertainment_clean.png';

  // Categories (Dark mode versions with matching #1D1D1D dark card background)
  static const String categoryGeneralDark = '$_imagesPath/general_dark.png';
  static const String categoryBusinessDark = '$_imagesPath/business_dark.png';
  static const String categorySportsDark = '$_imagesPath/sports_dark.png';
  static const String categoryTechnologyDark = '$_imagesPath/technology_dark.png';
  static const String categoryScienceDark = '$_imagesPath/science_dark.png';
  static const String categoryHealthDark = '$_imagesPath/health_dark.png';
  static const String categoryEntertainmentDark = '$_imagesPath/entertainment_dark.png';
}
