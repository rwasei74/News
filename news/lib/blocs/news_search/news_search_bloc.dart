import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/news_api_service.dart';
import 'news_search_event.dart';
import 'news_search_state.dart';

export 'news_search_event.dart';
export 'news_search_state.dart';

class NewsSearchBloc extends Bloc<NewsSearchEvent, NewsSearchState> {
  final NewsApiService _service;

  NewsSearchBloc({NewsApiService? service})
      : _service = service ?? NewsApiService(),
        super(NewsSearchInitial()) {
    on<SearchNews>(_onSearchNews);
  }

  Future<void> _onSearchNews(
    SearchNews event,
    Emitter<NewsSearchState> emit,
  ) async {
    final query = event.query.trim();
    if (query.isEmpty) return;

    emit(NewsSearchLoading());
    try {
      final articles = await _service.searchNews(query);
      emit(NewsSearchLoaded(articles));
    } on NewsApiException catch (error) {
      emit(NewsSearchError(error.message));
    } catch (e) {
      emit(NewsSearchError(e.toString()));
    }
  }
}
