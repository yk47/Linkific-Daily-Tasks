import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;

/// Dio HTTP Client Service demonstrating:
/// - Interceptors (logging, auth, error handling)
/// - Request cancellation
/// - Better than http package
class DioService extends GetxService {
  late final Dio _dio;
  final RxString _lastLog = ''.obs;
  final RxList<String> _logs = <String>[].obs;

  String get lastLog => _lastLog.value;
  List<String> get logs => _logs;

  @override
  void onInit() {
    super.onInit();
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://jsonplaceholder.typicode.com',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    _setupInterceptors();
  }

  void _setupInterceptors() {
    // Logging interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final log = '[REQUEST] ${options.method} ${options.uri}';
          _addLog(log);
          handler.next(options);
        },
        onResponse: (response, handler) {
          final log =
              '[RESPONSE] ${response.statusCode} ${response.requestOptions.uri}';
          _addLog(log);
          handler.next(response);
        },
        onError: (error, handler) {
          final log =
              '[ERROR] ${error.type.name} ${error.requestOptions.uri}';
          _addLog(log);
          handler.next(error);
        },
      ),
    );

    // Retry interceptor
    _dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) {
          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 429) {
            _addLog('[RETRY] Rate limited, retrying...');
            await Future.delayed(const Duration(seconds: 2));
            final response = await _dio.fetch(error.requestOptions);
            handler.resolve(response);
            return;
          }
          handler.next(error);
        },
      ),
    );
  }

  void _addLog(String log) {
    _lastLog.value = log;
    _logs.insert(0, log);
    if (_logs.length > 50) _logs.removeLast();
  }

  /// GET request with cancellation support
  Future<Response?> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        _addLog('[CANCELLED] Request cancelled: $path');
      }
      _handleError(e);
      return null;
    }
  }

  /// POST request
  Future<Response?> post(
    String path, {
    dynamic data,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      _handleError(e);
      return null;
    }
  }

  /// Download file with progress tracking
  Future<void> downloadFile(
    String urlPath,
    String savePath, {
    ProgressCallback? onProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      await _dio.download(
        urlPath,
        savePath,
        onReceiveProgress: onProgress,
        cancelToken: cancelToken,
      );
      _addLog('[DOWNLOAD] Completed: $urlPath');
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  void _handleError(DioException e) {
    String message;
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        message = 'Connection timeout';
        break;
      case DioExceptionType.sendTimeout:
        message = 'Send timeout';
        break;
      case DioExceptionType.receiveTimeout:
        message = 'Receive timeout';
        break;
      case DioExceptionType.badResponse:
        message = 'Server error: ${e.response?.statusCode}';
        break;
      case DioExceptionType.cancel:
        message = 'Request cancelled';
        break;
      default:
        message = 'Network error: ${e.message}';
    }
    _addLog('[ERROR] $message');
  }

  /// Create a CancelToken for request cancellation
  CancelToken createCancelToken() => CancelToken();

  /// Dispose resources
  void dispose() {
    _dio.close();
  }
}