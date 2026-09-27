import 'package:dio/dio.dart';

import '../models/news_article.dart';
import '../models/news_source.dart';

class NewsApiException implements Exception {
  const NewsApiException(this.message);

  final String message;
}

class NewsApiService {
  NewsApiService({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: 'https://newsapi.org/v2',
                connectTimeout: const Duration(seconds: 12),
                receiveTimeout: const Duration(seconds: 12),
              ),
            );

  final Dio _dio;
  static const _apiKey = String.fromEnvironment('NEWS_API_KEY');

  Future<List<NewsArticle>> getTopHeadlines({
    required String category,
    String? sourceId,
    int page = 1,
  }) async {
    final data = await _get(
      '/top-headlines',
      sourceId == null
          ? {
              'country': 'us',
              'category': category,
              'pageSize': 20,
              'page': page,
            }
          : {'sources': sourceId, 'pageSize': 20, 'page': page},
    );
    final articles = data['articles'] as List<dynamic>? ?? [];
    return articles
        .whereType<Map<String, dynamic>>()
        .map(NewsArticle.fromJson)
        .where((article) => article.url.isNotEmpty)
        .toList();
  }

  Future<List<NewsSource>> getSources(String category) async {
    final data = await _get('/top-headlines/sources', {'category': category});
    final sources = data['sources'] as List<dynamic>? ?? [];
    return sources
        .whereType<Map<String, dynamic>>()
        .map(NewsSource.fromJson)
        .where((source) => source.id.isNotEmpty)
        .toList();
  }

  Future<List<NewsArticle>> searchNews(String query) async {
    final data = await _get('/everything', {
      'q': query,
      'searchIn': 'title,description',
      'sortBy': 'publishedAt',
      'pageSize': 20,
    });
    final articles = data['articles'] as List<dynamic>? ?? [];
    return articles
        .whereType<Map<String, dynamic>>()
        .map(NewsArticle.fromJson)
        .where((article) => article.url.isNotEmpty)
        .toList();
  }

  Future<Map<String, dynamic>> _get(
    String path,
    Map<String, dynamic> queryParameters,
  ) async {
    if (_apiKey.isEmpty) {
      throw const NewsApiException(
        'News API key is missing. Run the app with NEWS_API_KEY configured.',
      );
    }

    try {
      final response = await _dio.get<Map<String, dynamic>>(
        path,
        queryParameters: {...queryParameters, 'apiKey': _apiKey},
      );
      final data = response.data;
      if (data == null || data['status'] != 'ok') {
        throw NewsApiException(data?['message'] as String? ?? 'Unable to load news.');
      }
      return data;
    } on DioException catch (error) {
      final data = error.response?.data;
      if (data is Map<String, dynamic> && data['message'] is String) {
        throw NewsApiException(data['message'] as String);
      }
      throw const NewsApiException(
        'Could not reach the news service. Check your internet connection.',
      );
    }
  }
}
