import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:syncronize/core/network/dio_client.dart';
import 'package:syncronize/src/domain/models/backend_error_response.dart';
import 'package:syncronize/src/domain/utils/resource.dart';

abstract class BaseService {
  final Dio dio = DioClient.instance.dio;
  final Logger logger = Logger();

  // Método genérico para manejar respuestas
  Future<Resource<T>> handleResponse<T>({
    required Future<Response> Function() request,
    required T Function(Map<String, dynamic>) fromJson,
    String? entityName,
  }) async {
    try {
      final response = await request();
      
      logger.d('Response status: ${response.statusCode}');

      // Respuesta exitosa
      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final data = fromJson(response.data);
          logger.i('✅ ${entityName ?? 'Request'} exitoso');
          return Success<T>(data);
        } catch (parseError) {
          logger.e('Error parseando respuesta exitosa: $parseError');
          return Error<T>(
            'Error al procesar la respuesta',
            statusCode: response.statusCode,
            errorCode: 'PARSE_ERROR',
          );
        }
      } 
      
      // Respuesta de error
      else {
        return _handleErrorResponse<T>(response);
      }
      
    } on DioException catch (e) {
      return _handleDioException<T>(e);
    } catch (e) {
      logger.e('Error inesperado: $e');
      return Error<T>(
        'Ha ocurrido un error inesperado',
        statusCode: 500,
        errorCode: 'UNEXPECTED_ERROR',
      );
    }
  }

  // Manejo centralizado de respuestas de error
  Resource<T> _handleErrorResponse<T>(Response response) {
    try {
      final errorResponse = BackendErrorResponse.fromJson(response.data);
      
      logger.w('Error del servidor:');
      logger.w('  Status: ${errorResponse.status}');
      logger.w('  Code: ${errorResponse.code}');
      logger.w('  Message: ${errorResponse.message}');
      
      return Error<T>(
        errorResponse.userFriendlyMessage,
        statusCode: errorResponse.status,
        errorCode: errorResponse.code,
        details: errorResponse.details,
      );
    } catch (parseError) {
      logger.e('Error parseando respuesta de error: $parseError');
      
      String errorMessage = 'Error en el servidor';
      if (response.data is Map) {
        errorMessage = response.data['message'] ?? 
                      response.data['error'] ?? 
                      errorMessage;
      }
      
      return Error<T>(
        errorMessage,
        statusCode: response.statusCode,
        errorCode: 'SERVER_ERROR',
      );
    }
  }

  // Manejo centralizado de DioException
  Resource<T> _handleDioException<T>(DioException e) {
    logger.e('DioException: ${e.type}');
    
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return Error<T>(
          'Tiempo de conexión agotado. Verifica tu internet',
          statusCode: 504,
          errorCode: 'GATEWAY_TIMEOUT',
        );
        
      case DioExceptionType.receiveTimeout:
        return Error<T>(
          'El servidor está tardando demasiado en responder',
          statusCode: 504,
          errorCode: 'GATEWAY_TIMEOUT',
        );
        
      case DioExceptionType.connectionError:
        return Error<T>(
          'No se puede conectar con el servidor',
          statusCode: 503,
          errorCode: 'SERVICE_UNAVAILABLE',
        );
        
      default:
        if (e.response != null) {
          try {
            final errorResponse = BackendErrorResponse.fromJson(e.response!.data);
            return Error<T>(
              errorResponse.userFriendlyMessage,
              statusCode: errorResponse.status,
              errorCode: errorResponse.code,
              details: errorResponse.details,
            );
          } catch (_) {
            return Error<T>(
              'Error en el servidor',
              statusCode: e.response?.statusCode ?? 500,
              errorCode: 'SERVER_ERROR',
            );
          }
        }
        
        return Error<T>(
          'Error de conexión',
          statusCode: 503,
          errorCode: 'NETWORK_ERROR',
        );
    }
  }
}