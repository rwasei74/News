import 'package:equatable/equatable.dart';
import '../../models/news_article.dart';

abstract class NewsSearchState extends Equatable {
  const NewsSearchState();

  @override
  List<Object?> get props => [];
}

class NewsSearchInitial extends NewsSearchState {}

class NewsSearchLoading extends NewsSearchState {}

class NewsSearchLoaded extends NewsSearchState {
  final List<NewsArticle> articles;

  const NewsSearchLoaded(this.articles);

  @override
  List<Object?> get props => [articles];
}

class NewsSearchError extends NewsSearchState {
  final String message;

  const NewsSearchError(this.message);

  @override
  List<Object?> get props => [message];
}
