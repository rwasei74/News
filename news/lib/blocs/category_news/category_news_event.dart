import 'package:equatable/equatable.dart';

abstract class CategoryNewsEvent extends Equatable {
  const CategoryNewsEvent();

  @override
  List<Object?> get props => [];
}

class LoadCategoryNews extends CategoryNewsEvent {
  final String category;
  final String? sourceId;

  const LoadCategoryNews({required this.category, this.sourceId});

  @override
  List<Object?> get props => [category, sourceId];
}

class LoadMoreCategoryNews extends CategoryNewsEvent {}

class ChangeCategorySource extends CategoryNewsEvent {
  final String? sourceId;
  const ChangeCategorySource(this.sourceId);

  @override
  List<Object?> get props => [sourceId];
}
