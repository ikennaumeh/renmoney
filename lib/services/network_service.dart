import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

class NetworkService {
  final _logger = Logger("NetworkService");
  late final Dio dio;

  final String _baseUrl = "https://api.openweathermap.org/data/2.5/";

  NetworkService() {
    dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 3),
      ),
    );
    if (kDebugMode) {
      dio.interceptors.addAll([
        LogInterceptor(
          responseBody: true,
          error: true,
          requestHeader: true,
          responseHeader: false,
          request: false,
          requestBody: true,
        ),
      ]);
    }
  }

  Future get(
      String path, {
        Map<String, dynamic>? queryParameters,
      }) async {
    try {
      Response response = await dio.get(
        path,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      rethrow;
    } catch (e, s) {
      _logger.severe('Could not make a request to this path: $path', e, s);
    }
  }

  void _handleError(DioException e) {
    throw Exception();
  }
}