import 'package:dio/dio.dart';

class ApiService {
  final Dio dio;
  ApiService(this.dio);

  Future<Response> get(String path, {Map<String, dynamic>? query}) async {
    return await dio.get(path, queryParameters: query);
  }

  Future<Response> post(String path, {dynamic data}) async {
    return await dio.post(path, data: data);
  }
}
