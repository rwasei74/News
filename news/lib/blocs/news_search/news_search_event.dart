import 'package:equatable/equatable.dart';

abstract class NewsSearchEvent extends Equatable {
  const NewsSearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchNews extends NewsSearchEvent {
  final String query;

  const SearchNews(this.query);

  @override
  List<Object?> get props => [query];
}
