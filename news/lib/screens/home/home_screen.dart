import 'package:flutter/material.dart';
import '../../utils/app_assets.dart';
import '../../utils/app_localizations.dart';
import '../../utils/app_text_styles.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/category_card_item.dart';
import '../category/category_news_screen.dart';
import '../search/news_search_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    // List of all 7 news categories with clean light & dark illustrations
    final categories = [
      {
        'title': localizations.general,
        'category': 'general',
        'lightImage': AppAssets.categoryGeneralClean,
        'darkImage': AppAssets.categoryGeneralDark,
        'alignment': CategoryCardAlignment.imageLeft,
      },
      {
        'title': localizations.business,
        'category': 'business',
        'lightImage': AppAssets.categoryBusinessClean,
        'darkImage': AppAssets.categoryBusinessDark,
        'alignment': CategoryCardAlignment.imageRight,
      },
      {
        'title': localizations.sports,
        'category': 'sports',
        'lightImage': AppAssets.categorySportsClean,
        'darkImage': AppAssets.categorySportsDark,
        'alignment': CategoryCardAlignment.imageLeft,
      },
      {
        'title': localizations.technology,
        'category': 'technology',
        'lightImage': AppAssets.categoryTechnologyClean,
        'darkImage': AppAssets.categoryTechnologyDark,
        'alignment': CategoryCardAlignment.imageRight,
      },
      {
        'title': localizations.science,
        'category': 'science',
        'lightImage': AppAssets.categoryScienceClean,
        'darkImage': AppAssets.categoryScienceDark,
        'alignment': CategoryCardAlignment.imageLeft,
      },
      {
        'title': localizations.health,
        'category': 'health',
        'lightImage': AppAssets.categoryHealthClean,
        'darkImage': AppAssets.categoryHealthDark,
        'alignment': CategoryCardAlignment.imageRight,
      },
      {
        'title': localizations.entertainment,
        'category': 'entertainment',
        'lightImage': AppAssets.categoryEntertainmentClean,
        'darkImage': AppAssets.categoryEntertainmentDark,
        'alignment': CategoryCardAlignment.imageLeft,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(
          localizations.home,
          style: AppTextStyles.headlineSmall,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const NewsSearchScreen()),
              );
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Text(
                localizations.goodMorning,
                style: AppTextStyles.headlineLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final category = categories[index];
                  return CategoryCardItem(
                    title: category['title'] as String,
                    lightImagePath: category['lightImage'] as String,
                    darkImagePath: category['darkImage'] as String,
                    alignment: category['alignment'] as CategoryCardAlignment,
                    onViewAllPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => CategoryNewsScreen(
                            category: category['category'] as String,
                            title: category['title'] as String,
                          ),
                        ),
                      );
                    },
                  );
                },
                childCount: categories.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 24),
          ),
        ],
      ),
    );
  }
}
