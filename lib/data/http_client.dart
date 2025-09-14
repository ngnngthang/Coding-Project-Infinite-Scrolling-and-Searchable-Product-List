import 'package:dio/dio.dart';

typedef Json = Map<String, dynamic>;

class NetworkClient {
  static NetworkClient? _instance;
  bool _initialized = false;

  NetworkClient._internal(this.baseUrl);

  factory NetworkClient({required String baseUrl}) {
    _instance ??= NetworkClient._internal(baseUrl);
    return _instance!;
  }

  final String baseUrl;
  final Dio _dio = Dio();

  Future<void> initClient() async {
    if (_initialized) return;

    _dio.options.baseUrl = baseUrl;

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.baseUrl = baseUrl;
          handler.next(options);
        },
        onResponse: (response, handler) {
          // Handle responses globally
          handler.next(response);
        },
        onError: (error, handler) {
          // Handle errors globally
          handler.next(error);
        },
      ),
    );

    _dio.options.connectTimeout = const Duration(seconds: 60);
    _dio.options.receiveTimeout = const Duration(seconds: 60);
    _initialized = true;
  }

  static NetworkClient get instance {
    if (_instance == null) {
      throw Exception(
        'NetworkClient not initialized. Call NetworkClient(baseUrl: ...) first.',
      );
    }
    return _instance!;
  }

  Future<Json> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? requestBody,
  }) async {
    try {
      final response = await _dio.get(
        url,
        queryParameters: queryParameters,
        data: requestBody,
      );
      return response.data;
    } on DioException catch (error) {
      return error.response?.data as Json;
    }
  }

  Future<Json> post(
    String url, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? requestBody,
  }) async {
    try {
      final response = await _dio.post(
        url,
        queryParameters: queryParameters,
        data: requestBody,
      );
      return response.data;
    } on DioException catch (error) {
      return error.response?.data as Json;
    }
  }

  Future<Json> put(
    String url, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? requestBody,
  }) async {
    try {
      final response = await _dio.put(
        url,
        queryParameters: queryParameters,
        data: requestBody,
      );
      return response.data;
    } on DioException catch (error) {
      return error.response?.data as Json;
    }
  }

  Future<Json> delete(
    String url, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? requestBody,
  }) async {
    try {
      final response = await _dio.delete(
        url,
        queryParameters: queryParameters,
        data: requestBody,
      );

      return response.data;
    } on DioException catch (error) {
      return error.response?.data as Json;
    }
  }
}
