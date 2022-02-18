import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market/constants/constants.dart';
import 'package:market/models/search_model.dart';
import 'package:market/shared/network/end_points.dart';
import 'package:market/shared/network/remote/dio_helper.dart';
import 'package:meta/meta.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  SearchModel? searchModel;

  static SearchCubit get(context) => BlocProvider.of(context);

  void searchData(String text) {
    emit(SearchLoadingState());
    DioHelper.postData(
      url: SEARCH,
      token: token,
      lang: 'en',
      data: {
        "text": "${text}",
      },
    ).then((value) {
      searchModel = SearchModel.fromJson(value.data);
      print(searchModel!.data!.data![0].name);
      emit(SearchSuccessState(searchModel));
    }).catchError((error) {
      print('the error of Search cubit---->> ${error.toString()}');
      emit(SearchErrorState(error));
    });
  }
}
