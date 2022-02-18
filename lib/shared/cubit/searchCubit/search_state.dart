part of 'search_cubit.dart';

@immutable
abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoadingState extends SearchState {}

class SearchSuccessState extends SearchState {
  final SearchModel? searchModel;

  SearchSuccessState(this.searchModel);
}

class SearchErrorState extends SearchState {
  final String error;

  SearchErrorState(this.error);
}
