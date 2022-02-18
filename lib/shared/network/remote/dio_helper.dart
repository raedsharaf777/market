import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
//....................Dio Server................................................

class DioHelper {
  static late Dio dio;

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://student.valuxapps.com/api/',
        receiveDataWhenStatusError: true,
        //عشان الهيدير دا ثابت مش بيتغير
      ),
    );
  }

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    String lang = 'ar',
    String? token,
  }) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
      'lang': lang,
      'Authorization': token??'',
    };
    return await dio.get(
      url,
      queryParameters: query,
    );
  }

  static Future<Response> postData({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? query,
    String lang = 'ar',
    String? token,
  }) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
      'lang': lang,
      'Authorization': token??'',
    };
    return dio.post(
      url,
      queryParameters: query,
      data: data,
    );
  }

  static Future<Response> putData({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? query,
    String lang = 'ar',
    String? token,
  }) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
      'lang': lang,
      'Authorization': token??'',
    };
    return dio.put(
      url,
      queryParameters: query,
      data: data,
    );
  }

//........................Http server...........................................
  static Future getAccessToken({
    required String url,
    required Map<String, dynamic> data,
  }) async {
    try {
      await http
          .post(
        Uri.parse('https://student.valuxapps.com/api${url}'),
        //هيحصل ايرور لو شغلت ال هيدررر
        //    headers: {
        //   'lang': 'ar',
        //   'Content-Type': 'application/json',
        // },
        body: data,
      )
          .then((response) {
        print("Reponse status : ${response.statusCode}");
        print("Response body : ${response.body}");

        return response.body;
      });
    } catch (e) {
      print('the error of http --------------->${e.toString()}');
    }
  }
}
