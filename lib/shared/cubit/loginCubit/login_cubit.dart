import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market/models/login_model.dart';
import 'package:market/shared/network/remote/dio_helper.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

import '../../network/end_points.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());
  LoginModel? loginModel;

  static LoginCubit get(context) => BlocProvider.of(context);

  void userLogin({
    required String email,
    required String password,
  }) {
    emit(LoginLoadingState());

    DioHelper.postData(
      url: LOGIN,
      data: {
        'email': '${email}',
        'password': '${password}',
      },
    ).then((value) {

      // print(value.data);
      loginModel = LoginModel.fromJson(value.data);
      // عملت ال token كدا واديت ليه قيمه علشان لما اعمل خروج ميكونش فاضي ويضرب error
     // token = loginModel!.data!.token;
      emit(LoginSuccessState(loginModel!));
    }).catchError((error) {
      print('the error of login cubit---->> ${error.toString()}');
      emit(LoginErrorState(error.toString()));
    });
  }

  IconData suffixIcon = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffixIcon =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(LoginChangeVisibilityState());
  }

//.........................Http server..........................................
//   void userTest({
//     required String email,
//     required String password,
//   }) {
//     emit(LoginLoadingState());
//     print('loadiiiiiiiiiiiiiiiiiiiiiiiiiig');
//     DioHelper.getAccessToken(
//       url: '/login',
//       data: {
//         'email': email,
//         'password': password,
//       },
//     ).then((value) {
//       print('succiiiiiiiiiiiiiiiiiiiiiiiiiig');
//       emit(LoginSuccessState());
//     }).catchError((error) {
//       print('the errrrrrrrrrror ${error.toString()}');
//       emit(LoginErrorState(error.toString()));
//     });
//   }
//..............................................................................
// void getData({
//   required String email,
//   required String password,
// }) async {
//   emit(LoginLoadingState());
//   String apiEndpoint = 'https://student.valuxapps.com/api/login';
//   final Uri url = Uri.parse(apiEndpoint);
//   Map<String, String> headers = {
//     'Content-Type': 'application/json',
//   };
//   final body = jsonEncode({
//     'email': email,
//     'password': password,
//   });
//   final response = await http
//       .post(
//     url,
//     headers: headers,
//     body: body,
//   )
//       .then((value) {
//     print(value.body);
//     emit(LoginSuccessState());
//   }).catchError((error) {
//     print('the errrrrrrrrrror ${error.toString()}');
//     emit(LoginErrorState(error.toString()));
//   });
// }
}
