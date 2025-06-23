import 'package:dio/dio.dart';

class ApiServices {
  static late Dio dio;

  static void init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://maps.googleapis.com/maps/api/',
        contentType: 'application/json',
        connectTimeout: const Duration(seconds: 15),
      ),
    );
  }

  Future<dynamic> getData({
    required String path,
    Map<String, dynamic>? query,
  }) async {
    var response = await dio.get(
      path,
      queryParameters: query,
    );
    return response.data;
  }

  Future<Response> postData({
    required String path,
    required dynamic data,
    String? token,
  }) async {
    return await dio.post(
      path,
      data: data,
    );
  }

  Future<Response> patchData({
    required String path,
    required dynamic data,
    String? token,
  }) async {
    return await dio.patch(
      path,
      data: data,
    );
  }

  Future<Response> putData({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    return await dio.put(
      path,
      data: data,
    );
  }

  Future<Response> deleteData({
    required String path,
    String? token,
    Map<String, dynamic>? data,
  }) async {
    return await dio.delete(
      path,
      data: data,
    );
  }
}