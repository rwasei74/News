import 'package:equatable/equatable.dart';
import '../../models/news_article.dart';
import '../../models/news_source.dart';

abstract class CategoryNewsState extends Equatable {
  const CategoryNewsState();

  @override
  List<Object?> get props => [];
}

class CategoryNewsInitial extends CategoryNewsState {}

class CategoryNewsLoading extends CategoryNewsState {}

class CategoryNewsLoaded extends CategoryNewsState {
  final List<NewsArticle> articles;
  final List<NewsSource> sources;
  final String? selectedSourceId;
  final bool hasMore;
  final int page;
  final bool isLoadingMore;

  const CategoryNewsLoaded({
    required this.articles,
    required this.sources,
    this.selectedSourceId,
    required this.hasMore,
    required this.page,
    this.isLoadingMore = false,
  });

  CategoryNewsLoaded copyWith({
    List<NewsArticle>? articles,
    List<NewsSource>? sources,
    String? Function()? selectedSourceId,
    bool? hasMore,
    int? page,
    bool? isLoadingMore,
  }) {
    return CategoryNewsLoaded(
      articles: articles ?? this.articles,
      sources: sources ?? this.sources,
      selectedSourceId: selectedSourceId != null ? selectedSourceId() : this.selectedSourceId,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [articles, sources, selectedSourceId, hasMore, page, isLoadingMore];
}

class CategoryNewsError extends CategoryNewsState {
  final String message;

  const CategoryNewsError(this.message);

  @override
  List<Object?> get props => [message];
}
