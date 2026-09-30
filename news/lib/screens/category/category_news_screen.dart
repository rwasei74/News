import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../blocs/category_news/category_news_bloc.dart';
import '../../models/news_article.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_localizations.dart';
import '../../widgets/app_drawer.dart';
import '../search/news_search_screen.dart';

class CategoryNewsScreen extends StatelessWidget {
  const CategoryNewsScreen({
    super.key,
    required this.category,
    required this.title,
  });

  final String category;
  final String title;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoryNewsBloc()..add(LoadCategoryNews(category: category)),
      child: _CategoryNewsView(title: title, category: category),
    );
  }
}

class _CategoryNewsView extends StatefulWidget {
  const _CategoryNewsView({required this.title, required this.category});

  final String title;
  final String category;

  @override
  State<_CategoryNewsView> createState() => _CategoryNewsViewState();
}

class _CategoryNewsViewState extends State<_CategoryNewsView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= 280) {
      context.read<CategoryNewsBloc>().add(LoadMoreCategoryNews());
    }
  }

  Future<void> _openArticle(NewsArticle article) async {
    final uri = Uri.tryParse(article.url);
    if (uri == null || !await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).translate('open_error'))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final localizations = AppLocalizations.of(context);
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final secondaryColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(widget.title),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: localizations.search,
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
      body: BlocBuilder<CategoryNewsBloc, CategoryNewsState>(
        builder: (context, state) {
          if (state is CategoryNewsInitial || state is CategoryNewsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CategoryNewsError) {
            return _NewsError(
              message: state.message,
              onRetry: () => context.read<CategoryNewsBloc>().add(LoadCategoryNews(category: widget.category)),
            );
          } else if (state is CategoryNewsLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<CategoryNewsBloc>().add(LoadCategoryNews(category: widget.category, sourceId: state.selectedSourceId));
              },
              child: CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 52,
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        scrollDirection: Axis.horizontal,
                        children: [
                          _SourceChip(
                            label: localizations.translate('all_sources'),
                            selected: state.selectedSourceId == null,
                            onTap: () => context.read<CategoryNewsBloc>().add(const ChangeCategorySource(null)),
                          ),
                          ...state.sources.map(
                            (source) => _SourceChip(
                              label: source.name,
                              selected: state.selectedSourceId == source.id,
                              onTap: () => context.read<CategoryNewsBloc>().add(ChangeCategorySource(source.id)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (state.articles.isEmpty)
                    SliverFillRemaining(
                      child: Center(
                        child: Text(
                          localizations.translate('no_news'),
                          style: TextStyle(color: secondaryColor),
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      sliver: SliverList.separated(
                        itemCount: state.articles.length + (state.isLoadingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == state.articles.length) {
                            return const Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          return _NewsArticleCard(
                            article: state.articles[index],
                            textColor: textColor,
                            secondaryColor: secondaryColor,
                            isArabic: Localizations.localeOf(context).languageCode == 'ar',
                            onTap: () => _openArticle(state.articles[index]),
                          );
                        },
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                      ),
                    ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _SourceChip extends StatelessWidget {
  const _SourceChip({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: isDark ? Colors.white : AppColors.primary,
        labelStyle: TextStyle(
          color: selected
              ? (isDark ? AppColors.darkBackground : Colors.white)
              : (isDark ? Colors.white : AppColors.lightTextPrimary),
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
    );
  }
}

class _NewsArticleCard extends StatelessWidget {
  const _NewsArticleCard({
    required this.article,
    required this.textColor,
    required this.secondaryColor,
    required this.isArabic,
    required this.onTap,
  });

  final NewsArticle article;
  final Color textColor;
  final Color secondaryColor;
  final bool isArabic;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: isDark ? AppColors.darkCard : AppColors.lightCard,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: isDark ? Colors.white70 : AppColors.lightBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(9),
                child: AspectRatio(
                  aspectRatio: 1.8,
                  child: article.imageUrl?.isNotEmpty == true
                      ? CachedNetworkImage(
                          imageUrl: article.imageUrl!,
                          fit: BoxFit.cover,
                          placeholder: (_, _) => const Center(child: CircularProgressIndicator()),
                          errorWidget: (_, _, _) => _ImageFallback(color: secondaryColor),
                        )
                      : _ImageFallback(color: secondaryColor),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 10, 4, 2),
                child: Text(
                  article.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: textColor, fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 4, 4, 2),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        article.author?.isNotEmpty == true
                            ? '${article.sourceName} · ${article.author}'
                            : article.sourceName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: secondaryColor, fontSize: 11),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _relativeTime(article.publishedAt, isArabic),
                      style: TextStyle(color: secondaryColor, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: Center(child: Icon(Icons.image_not_supported_outlined, color: color)),
    );
  }
}

class _NewsError extends StatelessWidget {
  const _NewsError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_outlined, size: 44),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onRetry,
              child: Text(AppLocalizations.of(context).translate('retry')),
            ),
          ],
        ),
      ),
    );
  }
}

String _relativeTime(DateTime publishedAt, bool isArabic) {
  final difference = DateTime.now().difference(publishedAt.toLocal());
  if (difference.inMinutes < 1) return isArabic ? 'الآن' : 'Just now';
  if (difference.inMinutes < 60) {
    return isArabic ? 'منذ ${difference.inMinutes} دقيقة' : '${difference.inMinutes} min ago';
  }
  if (difference.inHours < 24) {
    return isArabic ? 'منذ ${difference.inHours} ساعة' : '${difference.inHours}h ago';
  }
  return isArabic ? 'منذ ${difference.inDays} يوم' : '${difference.inDays}d ago';
}
