// import 'package:dio/dio.dart';
// // import 'package:pretty_dio_logger/pretty_dio_logger.dart';
// // import 'retry_interceptor.dart';

// class ApiClient {
//   late Dio dio;

//   ApiClient() {
//     dio = Dio(
//       BaseOptions(
//         baseUrl: Environment.baseUrl,
//         connectTimeout: const Duration(seconds: 15),
//         receiveTimeout: const Duration(seconds: 15),
//         headers: {"Accept": "application/json"},
//       ),
//     );

//     dio.interceptors.addAll([
//       // PrettyDioLogger(
//       //   requestHeader: true,
//       //   requestBody: true,
//       //   responseBody: true,
//       //   responseHeader: false,
//       //   compact: true,
//       // ),

//       // Token Interceptor
//       InterceptorsWrapper(
//         onRequest: (options, handler) async {
//           final token = await _getToken();
//           if (token != null) {
//             options.headers["Authorization"] = "Bearer $token";
//           }
//           return handler.next(options);
//         },
//         onError: (DioException e, handler) {
//           if (e.response?.statusCode == 401) {
//             // TODO: refresh token or logout
//           }
//           return handler.next(e);
//         },
//       ),

//       // Retry logic
//       // RetryInterceptor(dio: dio),
//     ]);
//   }

//   Future<String?> _getToken() async {
//     // Fetch from secure storage
//     return null;
//   }
// }

import 'package:dio/dio.dart';
import 'package:sanam_laundry/core/config/environment.dart';

class DioClient {
  static final Dio _dio =
      Dio(
          BaseOptions(
            baseUrl: Environment.baseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 15),
            responseType: ResponseType.json,
          ),
        )
        ..interceptors.add(
          LogInterceptor(
            request: true,
            requestBody: true,
            responseBody: true,
            responseHeader: false,
          ),
        );

  static Dio get instance => _dio;
}
