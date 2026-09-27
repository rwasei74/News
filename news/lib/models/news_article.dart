class NewsArticle {
  const NewsArticle({
    required this.title,
    required this.url,
    required this.sourceName,
    required this.publishedAt,
    this.author,
    this.imageUrl,
  });

  final String title;
  final String url;
  final String sourceName;
  final DateTime publishedAt;
  final String? author;
  final String? imageUrl;

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    final source = json['source'] as Map<String, dynamic>? ?? const {};
    return NewsArticle(
      title: (json['title'] as String?)?.trim().isNotEmpty == true
          ? (json['title'] as String).trim()
          : 'Untitled news',
      url: json['url'] as String? ?? '',
      sourceName: source['name'] as String? ?? 'News source',
      author: json['author'] as String?,
      imageUrl: json['urlToImage'] as String?,
      publishedAt: DateTime.tryParse(json['publishedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}
