import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/news_article.dart';
import '../../models/news_source.dart';
import '../../services/news_api_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_localizations.dart';
import '../../widgets/app_drawer.dart';
import '../search/news_search_screen.dart';

class CategoryNewsScreen extends StatefulWidget {
  const CategoryNewsScreen({
    super.key,
    required this.category,
    required this.title,
  });

  final String category;
  final String title;

  @override
  State<CategoryNewsScreen> createState() => _CategoryNewsScreenState();
}

class _CategoryNewsScreenState extends State<CategoryNewsScreen> {
  final _service = NewsApiService();
  final _scrollController = ScrollController();
  final List<NewsArticle> _articles = [];
  List<NewsSource> _sources = [];
  String? _selectedSourceId;
  String? _errorMessage;
  var _isLoading = true;
  var _isLoadingMore = false;
  var _hasMore = true;
  var _page = 1;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadMoreWhenNeeded);
    _loadInitial();
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_loadMoreWhenNeeded)
      ..dispose();
    super.dispose();
  }

  Future<void> _loadInitial() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _page = 1;
      _hasMore = true;
    });

    try {
      final results = await Future.wait([
        _service.getTopHeadlines(
          category: widget.category,
          sourceId: _selectedSourceId,
        ),
        _service.getSources(widget.category),
      ]);
      if (!mounted) return;
      setState(() {
        _articles
          ..clear()
          ..addAll(results[0] as List<NewsArticle>);
        _sources = results[1] as List<NewsSource>;
        _hasMore = _articles.length == 20;
      });
    } on NewsApiException catch (error) {
      if (mounted) _errorMessage = error.message;
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loadMoreWhenNeeded() async {
    if (!_scrollController.hasClients ||
        _isLoading ||
        _isLoadingMore ||
        !_hasMore ||
        _scrollController.position.extentAfter > 280) {
      return;
    }

    setState(() => _isLoadingMore = true);
    try {
      final nextPage = _page + 1;
      final nextArticles = await _service.getTopHeadlines(
        category: widget.category,
        sourceId: _selectedSourceId,
        page: nextPage,
      );
      if (!mounted) return;
      setState(() {
        _page = nextPage;
        _articles.addAll(nextArticles);
        _hasMore = nextArticles.length == 20;
      });
    } on NewsApiException {
      // The existing results remain usable if loading another page fails.
    } finally {
      if (mounted) setState(() => _isLoadingMore = false);
    }
  }

  Future<void> _selectSource(String? sourceId) async {
    if (sourceId == _selectedSourceId) return;
    setState(() => _selectedSourceId = sourceId);
    await _loadInitial();
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
    final secondaryColor =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? _NewsError(message: _errorMessage!, onRetry: _loadInitial)
              : RefreshIndicator(
                  onRefresh: _loadInitial,
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
                                selected: _selectedSourceId == null,
                                onTap: () => _selectSource(null),
                              ),
                              ..._sources.map(
                                (source) => _SourceChip(
                                  label: source.name,
                                  selected: _selectedSourceId == source.id,
                                  onTap: () => _selectSource(source.id),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (_articles.isEmpty)
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
                            itemCount: _articles.length + (_isLoadingMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == _articles.length) {
                                return const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Center(child: CircularProgressIndicator()),
                                );
                              }
                              return _NewsArticleCard(
                                article: _articles[index],
                                textColor: textColor,
                                secondaryColor: secondaryColor,
                                isArabic: Localizations.localeOf(context).languageCode == 'ar',
                                onTap: () => _openArticle(_articles[index]),
                              );
                            },
                            separatorBuilder: (_, _) => const SizedBox(height: 12),
                          ),
                        ),
                    ],
                  ),
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
  final Future<void> Function() onRetry;

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
