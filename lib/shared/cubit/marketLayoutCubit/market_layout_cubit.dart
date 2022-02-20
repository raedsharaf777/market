import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market/constants/constants.dart';
import 'package:market/models/home_model.dart';
import 'package:market/models/login_model.dart';
import 'package:market/models/logout_model.dart';
import 'package:market/modules/categories/categories_screen.dart';
import 'package:market/modules/favorites/favorites_screen.dart';
import 'package:market/modules/login/login_screen.dart';
import 'package:market/modules/products/products_screen.dart';
import 'package:market/modules/settings/settings_screen.dart';
import 'package:market/shared/components/components.dart';
import 'package:market/shared/network/local/cache_helper.dart';
import 'package:market/shared/network/remote/dio_helper.dart';
import 'package:meta/meta.dart';
import '../../../models/categories_model.dart';
import '../../../models/change_favorites_model.dart';
import '../../../models/get_favorites_model.dart';
import '../../network/end_points.dart';

part 'market_layout_state.dart';

class MarketLayoutCubit extends Cubit<MarketLayoutState> {
  MarketLayoutCubit() : super(MarketLayoutInitial());
  HomeModel? homeModel;
  CategoriesModel? categoriesModel;
  ChangeFavoritesModel? changeFavoritesModel;
  GetFavoritesModel? getFavoritesModel;
  LoginModel? profileModel;
  LoginModel? updateModel;
  LogOutModel? logOutModel;

  static MarketLayoutCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  List<BottomNavigationBarItem> bottomItems = [
    const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    const BottomNavigationBarItem(icon: Icon(Icons.apps), label: 'Categories'),
    const BottomNavigationBarItem(
        icon: Icon(Icons.favorite), label: 'Favorites'),
    const BottomNavigationBarItem(
        icon: Icon(Icons.settings), label: 'Settings'),
  ];
  List<Widget> screens = [
    const ProductsScreen(),
    const CategoriesScreen(),
    const FavoritesScreen(),
    SettingsScreen(),
  ];

  void changeBottomNavBar(int index) {
    currentIndex = index;
    emit(LayoutChangeNavBottomBar());
  }

//.................................Get Home Data................................
  Map<int, bool> favourites = {};

  void getHomeData() {
    emit(MarketLayoutHomeLoadingState());
    DioHelper.getData(
      url: HOME,
      token: token,
      lang: 'en',
    ).then((value) {
      print(value.data);
      homeModel = HomeModel.fromJson(value.data);
      //بعملت دي عشان اعدي علي ال favourite واملها عشان اعرف استخدمها
      homeModel!.data!.products!.forEach((element) {
        favourites.addAll({
          element.id!: element.inFavorites!,
        });
      });
      //   print(favourites.toString());
      emit(MarketLayoutHomeSuccessState());
    }).catchError((error) {
      print('the error of Home cubit---->> ${error.toString()}');
      emit(MarketLayoutHomeErrorState(error.toString()));
    });
  }

//.................................Get Categories Data..........................
  void getCategoriesData() {
    DioHelper.getData(
      url: Categories,
      token: token,
      lang: 'en',
    ).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);
      emit(MarketLayoutCategoriesSuccessState());
    }).catchError((error) {
      print('the error of Categories cubit---->> ${error.toString()}');
      emit(MarketLayoutCategoriesErrorState(error));
    });
  }

//.................................ChangeFavourites.............................
  void changeFavourite(int productId) {
    //عكست المصفوفه عشان دي عشان اخلي زرار الفيفوريت ينور ويطفي ف نفس اللحظه
    favourites[productId] = !favourites[productId]!;
    emit(MarketLayoutChangeFavouritesLoadedInNowState());
    DioHelper.postData(
      url: FAVOURITES,
      data: {
        'product_id': productId,
      },
      token: token,
    ).then((value) {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);
      if (!changeFavoritesModel!.status!) {
        favourites[productId] = !favourites[productId]!;
      } else {
        // عملتها هنا عشان تمسح العنصر من الفيفوريت لو عملت ليها unlike من الفيفوريت نفسها
        getFavouritesData();
      }
      // print(value.data);
      emit(MarketLayoutChangeFavouritesSuccessState(changeFavoritesModel!));
    }).catchError((error) {
      favourites[productId] = !favourites[productId]!;
      print('the error of ChangeFavourites cubit---->> ${error.toString()}');
      emit(MarketLayoutChangeFavouritesErrorState(error));
    });
  }

//.................................Get Favourites Data..........................
  void getFavouritesData() {
    // عملت loading emit عشان هيلف ويمسح اللي عملت ليه unlike
    emit(MarketLayoutGetFavouritesLoadedState());
    DioHelper.getData(
      url: FAVOURITES,
      token: token,
      lang: 'en',
    ).then((value) {
      getFavoritesModel = GetFavoritesModel.fromJson(value.data);
      //print(value.data);
      emit(MarketLayoutGetFavouritesSuccessState(getFavoritesModel!));
    }).catchError((error) {
      print('the error of Get Favourites Data cubit---->> ${error.toString()}');
      emit(MarketLayoutGetFavouritesErrorState(error));
    });
  }

//.................................Settings&Profile...........................

  void getProfileData() {
    emit(MarketLayoutProfileLoadingState());
    DioHelper.getData(
      url: PROFILE,
      token: token,
      lang: 'en',
    ).then((value) {
      profileModel = LoginModel.fromJson(value.data);
      emit(MarketLayoutProfileSuccessState(profileModel!));
    }).catchError((error) {
      print('the error of Get Profile Data cubit---->> ${error.toString()}');
      emit(MarketLayoutProfileErrorState(error));
    });
  }

//.................................Update.......................................

  void updateUserData({
    required String name,
    required String email,
    required String phone,
  }) {
    emit(MarketLayoutUpdateLoadingState());
    DioHelper.putData(
      url: UPDATEPROFILE,
      token: token,
      lang: 'en',
      data: {
        'name': name,
        'email': email,
        'phone': phone,
      },
    ).then((value) {
      updateModel = LoginModel.fromJson(value.data);
      emit(MarketLayoutUpdateSuccessState(updateModel!));
      if (state is MarketLayoutUpdateSuccessState) {
        return getProfileData();
      }
    }).catchError((error) {
      print('the error of Home cubit---->> ${error.toString()}');
      emit(MarketLayoutUpdateErrorState(error.toString()));
    });
  }

//...................................LogOut.....................................
//   void logOutUser() {
//     emit(MarketLayoutLogOutLoadingState());
//     DioHelper.postData(
//       url: LOGOUT,
//       token: token,
//       data: {
//         "fcm_token": "SomeFcmToken",
//       },
//     ).then((value) {
//       logOutModel = LogOutModel.fromJson(value.data);
//
//       emit(MarketLayoutLogOutSuccessState(logOutModel));
//     }).catchError((error) {
//       print('the error of LogOut cubit---->> ${error.toString()}');
//       emit(MarketLayoutLogOutErrorState(error.toString()));
//     });
//   }

  void logOutUserByCacheHelper(context) {
    emit(MarketLayoutLogOutLoadingState());
    CacheHelper.removeData(key: 'token')!.then((value) {
      if (value == true) {
        navigateAndFinish(context: context, widget: LoginScreen());
      }
      emit(MarketLayoutLogOutSuccessState());
    }).catchError((error) {
      print('the error of LogOut cubit---->> ${error.toString()}');
      emit(MarketLayoutLogOutErrorState(error.toString()));
    });
  }
}

