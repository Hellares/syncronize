// import 'package:dio/dio.dart';
// import 'package:logger/logger.dart';
// import 'package:syncronize/core/network/dio_client.dart';

// class RetryInterceptor extends Interceptor {
//   final Logger _logger;
//   final int maxRetries;
  
//   RetryInterceptor(
//     this._logger,
//      {this.maxRetries = 1});

//   @override
//   void onError(DioException err, ErrorInterceptorHandler handler) async {
//     // Solo reintentar en errores de red
//     if (_shouldRetry(err) && err.requestOptions.extra['retryCount'] != maxRetries) {
//       _logger.i('🔄 Reintentando petición...');
      
//       err.requestOptions.extra['retryCount'] = 
//         (err.requestOptions.extra['retryCount'] ?? 0) + 1;
      
//       try {
//         final response = await DioClient.instance.dio.request(
//           err.requestOptions.path,
//           data: err.requestOptions.data,
//           options: Options(
//             method: err.requestOptions.method,
//             headers: err.requestOptions.headers,
//           ),
//         );
//         return handler.resolve(response);
//       } catch (e) {
//         _logger.e('Reintento fallido');
//         return handler.next(err);
//       }
//     }
    
//     return handler.next(err);
//   }

//   bool _shouldRetry(DioException err) {
//     return err.type == DioExceptionType.connectionTimeout ||
//            err.type == DioExceptionType.receiveTimeout ||
//            err.type == DioExceptionType.connectionError;
//   }
// }

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class RetryInterceptor extends Interceptor {
  final Logger _logger;
  final int maxRetries;
  final Duration delayBetweenRetries;
  
  RetryInterceptor(
    this._logger, {
    this.maxRetries = 2,
    this.delayBetweenRetries = const Duration(seconds: 2),
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final currentRetryCount = err.requestOptions.extra['retryCount'] ?? 0;
    
    // Solo reintentar si no hemos alcanzado el máximo y es un error reintentable
    if (_shouldRetry(err) && currentRetryCount < maxRetries) {
      final retryCount = currentRetryCount + 1;
      
      _logger.i('🔄 Reintento $retryCount/$maxRetries para ${err.requestOptions.path}');
      
      // Actualizar contador de reintentos
      err.requestOptions.extra['retryCount'] = retryCount;
      
      // Esperar antes del reintento (backoff)
      await Future.delayed(delayBetweenRetries * retryCount);
      
      try {
        // Crear nueva instancia de Dio para evitar conflictos de interceptores
        final dio = Dio(BaseOptions(
          baseUrl: err.requestOptions.baseUrl,
          connectTimeout: const Duration(seconds: 20),
          receiveTimeout: const Duration(seconds: 20),
          sendTimeout: const Duration(seconds: 20),
        ));
        
        final response = await dio.request(
          err.requestOptions.path,
          data: err.requestOptions.data,
          queryParameters: err.requestOptions.queryParameters,
          options: Options(
            method: err.requestOptions.method,
            headers: err.requestOptions.headers,
            contentType: err.requestOptions.contentType,
            responseType: err.requestOptions.responseType,
            extra: err.requestOptions.extra,
          ),
        );
        
        _logger.i('✅ Reintento exitoso después de $retryCount intentos');
        return handler.resolve(response);
        
      } catch (retryError) {
        _logger.w('❌ Reintento $retryCount falló: ${retryError.toString()}');
        
        // Si es el último reintento, devolver el error
        if (retryCount >= maxRetries) {
          _logger.e('🚫 Máximo de reintentos alcanzado para ${err.requestOptions.path}');
          return handler.next(err);
        }
        
        // Si no es el último reintento, intentar de nuevo
        final newError = retryError is DioException ? retryError : err;
        newError.requestOptions.extra['retryCount'] = retryCount;
        return onError(newError, handler);
      }
    }
    
    // No reintentar, devolver error original
    return handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    // Solo reintentar en errores de conectividad, no en errores de negocio
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.connectionError:
        return true;
      case DioExceptionType.badResponse:
        // Reintentar solo en errores 5xx (servidor), no 4xx (cliente)
        final statusCode = err.response?.statusCode;
        return statusCode != null && statusCode >= 500;
      default:
        return false;
    }
  }
}