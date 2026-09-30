import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/news_article.dart';
import '../../models/news_source.dart';
import '../../services/news_api_service.dart';
import 'category_news_event.dart';
import 'category_news_state.dart';

export 'category_news_event.dart';
export 'category_news_state.dart';

class CategoryNewsBloc extends Bloc<CategoryNewsEvent, CategoryNewsState> {
  final NewsApiService _service;
  String? _currentCategory;

  CategoryNewsBloc({NewsApiService? service})
      : _service = service ?? NewsApiService(),
        super(CategoryNewsInitial()) {
    on<LoadCategoryNews>(_onLoadCategoryNews);
    on<LoadMoreCategoryNews>(_onLoadMoreCategoryNews);
    on<ChangeCategorySource>(_onChangeCategorySource);
  }

  Future<void> _onLoadCategoryNews(
    LoadCategoryNews event,
    Emitter<CategoryNewsState> emit,
  ) async {
    _currentCategory = event.category;
    emit(CategoryNewsLoading());

    try {
      final results = await Future.wait([
        _service.getTopHeadlines(
          category: event.category,
          sourceId: event.sourceId,
        ),
        _service.getSources(event.category),
      ]);

      final articles = results[0] as List<NewsArticle>;
      final sources = results[1] as List<NewsSource>;

      emit(CategoryNewsLoaded(
        articles: articles,
        sources: sources,
        selectedSourceId: event.sourceId,
        hasMore: articles.length == 20,
        page: 1,
      ));
    } on NewsApiException catch (error) {
      emit(CategoryNewsError(error.message));
    } catch (e) {
      emit(CategoryNewsError(e.toString()));
    }
  }

  Future<void> _onChangeCategorySource(
    ChangeCategorySource event,
    Emitter<CategoryNewsState> emit,
  ) async {
    if (state is CategoryNewsLoaded && _currentCategory != null) {
      final currentState = state as CategoryNewsLoaded;
      if (currentState.selectedSourceId == event.sourceId) return;

      emit(CategoryNewsLoading());
      try {
        final articles = await _service.getTopHeadlines(
          category: _currentCategory!,
          sourceId: event.sourceId,
        );

        emit(currentState.copyWith(
          articles: articles,
          selectedSourceId: () => event.sourceId,
          hasMore: articles.length == 20,
          page: 1,
        ));
      } on NewsApiException catch (error) {
        emit(CategoryNewsError(error.message));
      } catch (e) {
        emit(CategoryNewsError(e.toString()));
      }
    }
  }

  Future<void> _onLoadMoreCategoryNews(
    LoadMoreCategoryNews event,
    Emitter<CategoryNewsState> emit,
  ) async {
    if (state is CategoryNewsLoaded && _currentCategory != null) {
      final currentState = state as CategoryNewsLoaded;
      if (currentState.isLoadingMore || !currentState.hasMore) return;

      emit(currentState.copyWith(isLoadingMore: true));
      try {
        final nextPage = currentState.page + 1;
        final nextArticles = await _service.getTopHeadlines(
          category: _currentCategory!,
          sourceId: currentState.selectedSourceId,
          page: nextPage,
        );

        emit(currentState.copyWith(
          articles: List.of(currentState.articles)..addAll(nextArticles),
          page: nextPage,
          hasMore: nextArticles.length == 20,
          isLoadingMore: false,
        ));
      } on NewsApiException {
        emit(currentState.copyWith(isLoadingMore: false));
      } catch (e) {
        emit(currentState.copyWith(isLoadingMore: false));
      }
    }
  }
}
