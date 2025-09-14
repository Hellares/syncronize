import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:syncronize/src/data/api/api_config.dart';
import 'package:syncronize/src/data/datasource/local/shared_preference.dart';
import 'package:syncronize/src/domain/models/auth_empresa_response.dart';

class DioConfig {
  static Dio? _dio;
  
  static Dio get instance {
    _dio ??= _createDio();
    return _dio!;
  }

  static Dio _createDio() {
    // Log info del entorno
    ApiConfig.logEnvironmentInfo();

    final dio = Dio(BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: ApiConfig.connectTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
      sendTimeout: ApiConfig.sendTimeout,
      headers: ApiConfig.headers,
      
      // Configuraciones optimizadas
      persistentConnection: true,
      followRedirects: false,
      maxRedirects: 0,
      validateStatus: (status) => status != null && status < 500,
    ));

    // Interceptores según entorno
    dio.interceptors.addAll([
      OptimizedAuthInterceptor(),
      
      // Retry con configuración por entorno
      SmartRetryInterceptor(),
      
      // Logs solo en desarrollo
      if (kDebugMode) LogInterceptor(
        requestBody: false,
        responseBody: false,
        requestHeader: false,
        responseHeader: false,
        logPrint: (obj) => debugPrint('[DIO] $obj'),
      ),
    ]);

    if (kDebugMode) {
      print('✅ Dio configurado para ${ApiConfig.isProduction ? "producción" : "desarrollo"}');
    }

    return dio;
  }

  static void resetInstance() {
    _dio?.close(force: true);
    _dio = null;
  }
}

// Interceptor de autenticación optimizado (sin cambios)
class OptimizedAuthInterceptor extends Interceptor {
  String? _cachedToken;
  DateTime? _tokenCacheTime;
  static const Duration _cacheValidDuration = Duration(minutes: 5);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (!_isAuthEndpoint(options.path)) {
      final token = await _getTokenOptimized();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      _clearTokenCache();
    }
    handler.next(err);
  }

  bool _isAuthEndpoint(String path) {
    return path.contains('/login') || 
           path.contains('/register') || 
           path.contains('/auth/login') || 
           path.contains('/auth/register');
  }

  Future<String?> _getTokenOptimized() async {
    if (_cachedToken != null && 
        _tokenCacheTime != null && 
        DateTime.now().difference(_tokenCacheTime!) < _cacheValidDuration) {
      return _cachedToken;
    }
    
    try {
      final sharedPref = SharedPref();
      final userData = await sharedPref.read('user');
      if (userData != null) {
        final authResponse = AuthEmpresaResponse.fromJson(userData);
        _cachedToken = authResponse.data?.token;
        _tokenCacheTime = DateTime.now();
        return _cachedToken;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error obteniendo token: $e');
      }
    }
    
    return null;
  }

  void _clearTokenCache() {
    _cachedToken = null;
    _tokenCacheTime = null;
  }

  void forceTokenRefresh() {
    _clearTokenCache();
  }
}

// Interceptor de retry inteligente usando configuración de ApiConfig
class SmartRetryInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final retryCount = (err.requestOptions.extra['retryCount'] ?? 0) as int;
    
    if (_shouldRetry(err) && retryCount < ApiConfig.maxRetries) {
      final newRetryCount = retryCount + 1;
      err.requestOptions.extra['retryCount'] = newRetryCount;
      
      if (kDebugMode) {
        print('🔄 Retry $newRetryCount/${ApiConfig.maxRetries} para ${err.requestOptions.path}');
      }
      
      await Future.delayed(ApiConfig.retryDelay);
      
      try {
        final response = await DioConfig.instance.request(
          err.requestOptions.path,
          data: err.requestOptions.data,
          queryParameters: err.requestOptions.queryParameters,
          options: Options(
            method: err.requestOptions.method,
            headers: err.requestOptions.headers,
            sendTimeout: err.requestOptions.sendTimeout,
            receiveTimeout: err.requestOptions.receiveTimeout,
          ),
        );
        
        if (kDebugMode) print('✅ Retry exitoso');
        handler.resolve(response);
        return;
      } catch (retryError) {
        if (kDebugMode) print('❌ Retry $newRetryCount falló');
      }
    }
    
    handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    return (err.type == DioExceptionType.connectionTimeout ||
            err.type == DioExceptionType.receiveTimeout ||
            err.type == DioExceptionType.connectionError ||
            (err.response?.statusCode ?? 0) >= 500) &&
           !err.requestOptions.path.contains('/login') &&
           !err.requestOptions.path.contains('/register');
  }
}

// Configuraciones específicas para casos especiales
class DioConfigSpecial {
  // Para uploads de archivos grandes
  static Dio createUploadDio() {
    final dio = Dio(BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: const Duration(seconds: 30), // Más tiempo para uploads
      receiveTimeout: const Duration(seconds: 60),
      sendTimeout: const Duration(seconds: 60),
      headers: ApiConfig.headers,
    ));

    dio.interceptors.add(OptimizedAuthInterceptor());
    return dio;
  }

  // Para servicios externos (sin auth)
  static Dio createExternalDio(String baseUrl) {
    return Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 10),
    ));
  }
}