import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:syncronize/core/network/interceptors/auth_interceptor.dart';
import 'package:syncronize/core/network/interceptors/logger_interceptor.dart';
import 'package:syncronize/core/network/interceptors/retry_interceptor.dart';

class DioClient {
  static DioClient? _instance;
  static Dio? _dio;
  final Logger _logger = Logger();

  // Singleton pattern
  static DioClient get instance {
    _instance ??= DioClient._init();
    return _instance!;
  }

  DioClient._init() {
    _dio = Dio(BaseOptions(
      baseUrl: String.fromEnvironment('API_URL', defaultValue: 'http://192.168.100.3:3000'),
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      validateStatus: (status) {
        return status != null && status >= 200 && status < 600;
      },
      // Configuraciones adicionales para mejorar la conectividad
      headers: {
        'Connection': 'keep-alive',
        'Accept': 'application/json',
      },
    ));

    _dio!.interceptors.add(LoggerInterceptor(_logger));
    _dio!.interceptors.add(RetryInterceptor(_logger, maxRetries: 2));
    _dio!.interceptors.add(AuthInterceptor());
  }

  Dio get dio => _dio!;

  // Método para verificar conectividad
  // Future<bool> checkConnectivity() async {
  //   try {
  //     final response = await _dio!.get('/health', 
  //       options: Options(
  //         receiveTimeout: const Duration(seconds: 5),
  //         sendTimeout: const Duration(seconds: 5),
  //       )
  //     );
  //     return response.statusCode == 200;
  //   } catch (e) {
  //     _logger.e('Servidor no disponible: $e');
  //     return false;
  //   }
  // }
}