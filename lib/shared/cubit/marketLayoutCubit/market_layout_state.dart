part of 'market_layout_cubit.dart';

@immutable
abstract class MarketLayoutState {}

class MarketLayoutInitial extends MarketLayoutState {}

class LayoutChangeNavBottomBar extends MarketLayoutState {}

//.............................Get Product......................................
class MarketLayoutHomeLoadingState extends MarketLayoutState {}

class MarketLayoutHomeSuccessState extends MarketLayoutState {}

class MarketLayoutHomeErrorState extends MarketLayoutState {
  final String error;

  MarketLayoutHomeErrorState(this.error);
}

//.............................Get Categories...................................
class MarketLayoutCategoriesSuccessState extends MarketLayoutState {}

class MarketLayoutCategoriesErrorState extends MarketLayoutState {
  final String error;

  MarketLayoutCategoriesErrorState(this.error);
}

//.............................ChangeFavourites.................................
class MarketLayoutChangeFavouritesLoadedInNowState extends MarketLayoutState {}

class MarketLayoutChangeFavouritesSuccessState extends MarketLayoutState {
  final ChangeFavoritesModel model;

  MarketLayoutChangeFavouritesSuccessState(this.model);
}

class MarketLayoutChangeFavouritesErrorState extends MarketLayoutState {
  final String error;

  MarketLayoutChangeFavouritesErrorState(this.error);
}

//.............................Get Favourites...................................
class MarketLayoutGetFavouritesLoadedState extends MarketLayoutState {}

class MarketLayoutGetFavouritesSuccessState extends MarketLayoutState {
  final GetFavoritesModel favModel;

  MarketLayoutGetFavouritesSuccessState(this.favModel);
}

class MarketLayoutGetFavouritesErrorState extends MarketLayoutState {
  final String error;

  MarketLayoutGetFavouritesErrorState(this.error);
}

//.................................Settings.&.Profile...........................
class MarketLayoutProfileLoadingState extends MarketLayoutState {}

class MarketLayoutProfileSuccessState extends MarketLayoutState {
  final LoginModel profileModel;

  MarketLayoutProfileSuccessState(this.profileModel);
}

class MarketLayoutProfileErrorState extends MarketLayoutState {
  final String error;

  MarketLayoutProfileErrorState(this.error);
}
//.............................UpData Data......................................

class MarketLayoutUpdateLoadingState extends MarketLayoutState {}

class MarketLayoutUpdateSuccessState extends MarketLayoutState {
  final LoginModel updateModel;

  MarketLayoutUpdateSuccessState(this.updateModel);
}

class MarketLayoutUpdateErrorState extends MarketLayoutState {
  final String error;

  MarketLayoutUpdateErrorState(this.error);
}
