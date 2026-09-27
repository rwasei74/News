import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/news_article.dart';
import '../../services/news_api_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_localizations.dart';

class NewsSearchScreen extends StatefulWidget {
  const NewsSearchScreen({super.key});

  @override
  State<NewsSearchScreen> createState() => _NewsSearchScreenState();
}

class _NewsSearchScreenState extends State<NewsSearchScreen> {
  final _controller = TextEditingController();
  final _service = NewsApiService();
  List<NewsArticle> _articles = [];
  String? _errorMessage;
  var _isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _search(String value) async {
    final query = value.trim();
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final articles = await _service.searchNews(query);
      if (mounted) setState(() => _articles = articles);
    } on NewsApiException catch (error) {
      if (mounted) setState(() => _errorMessage = error.message);
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
    final localizations = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondaryColor =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: TextField(
          controller: _controller,
          autofocus: true,
          textInputAction: TextInputAction.search,
          onSubmitted: _search,
          decoration: InputDecoration(
            hintText: localizations.translate('search_hint'),
            border: InputBorder.none,
          ),
        ),
        actions: [
          IconButton(
            tooltip: localizations.search,
            icon: const Icon(Icons.search),
            onPressed: () => _search(_controller.text),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(_errorMessage!, textAlign: TextAlign.center),
                  ),
                )
              : _articles.isEmpty
                  ? Center(
                      child: Text(
                        localizations.translate('search_prompt'),
                        style: TextStyle(color: secondaryColor),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: _articles.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final article = _articles[index];
                        return _SearchResultTile(
                          article: article,
                          onTap: () => _openArticle(article),
                        );
                      },
                    ),
    );
  }
}

class _SearchResultTile extends StatelessWidget {
  const _SearchResultTile({required this.article, required this.onTap});

  final NewsArticle article;
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
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(9),
                child: SizedBox(
                  width: 104,
                  height: 82,
                  child: article.imageUrl?.isNotEmpty == true
                      ? CachedNetworkImage(
                          imageUrl: article.imageUrl!,
                          fit: BoxFit.cover,
                          errorWidget: (_, _, _) => const Icon(Icons.image_not_supported_outlined),
                        )
                      : const Icon(Icons.image_not_supported_outlined),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      article.sourceName,
                      style: TextStyle(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        fontSize: 12,
                      ),
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
