// import 'dart:convert';
// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
// import 'package:syncronize/src/data/api/api_config.dart';
// import 'package:syncronize/src/data/api/dio_config.dart';
// import 'package:syncronize/src/domain/models/auth_response.dart';
// import 'package:syncronize/src/domain/utils/resource.dart';

// class EmpresaAuthService {
//   final Dio _dio;

//   EmpresaAuthService() : _dio = DioConfig.instance;

//   // Login to specific empresa
//   Future<Resource<AuthResponse>> loginToEmpresa(String userToken, String empresaId) async {
//     Stopwatch? totalStopwatch;
//     if (kDebugMode) {
//       totalStopwatch = Stopwatch()..start();
//     }
    
//     try {
//       if (kDebugMode) print('🏢 EmpresaAuthService: Iniciando login para empresa $empresaId');

//       // 1. PETICIÓN con headers de auth
//       Stopwatch? networkStopwatch;
//       if (kDebugMode) {
//         networkStopwatch = Stopwatch()..start();
//       }
      
//       final response = await _dio.post(
//         '/api/auth/empresa/login',
//         data: {'empresaId': empresaId},
//         options: Options(
//           sendTimeout: ApiConfig.sendTimeout,
//           receiveTimeout: ApiConfig.receiveTimeout,
//           headers: {
//             'Authorization': 'Bearer $userToken',
//             'X-Request-Type': 'empresa_login',
//           },
//         ),
//       );
      
//       if (kDebugMode) {
//         networkStopwatch?.stop();
//         print('📡 Red: ${networkStopwatch?.elapsedMilliseconds}ms - Status: ${response.statusCode}');
//       }

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         // 2. PARSING
//         Stopwatch? parseStopwatch;
//         if (kDebugMode) {
//           parseStopwatch = Stopwatch()..start();
//         }
        
//         final jsonString = response.data is String 
//             ? response.data as String 
//             : jsonEncode(response.data);
            
//         AuthResponse authResponse;
//         if (jsonString.length > 50000) {
//           if (kDebugMode) print('📦 JSON grande (${jsonString.length} chars), usando isolate...');
//           authResponse = await compute(_parseAuthResponseInIsolate, jsonString);
//         } else {
//           authResponse = AuthResponse.fromJson(response.data);
//         }
        
//         if (kDebugMode) {
//           parseStopwatch?.stop();
//           totalStopwatch?.stop();
          
//           print('⚡ Parsing: ${parseStopwatch?.elapsedMilliseconds}ms');
//           print('👤 Empresa Token: ${authResponse.data.token.isNotEmpty ? 'Obtenido' : 'Vacío'}');
//           print('⏱️ Total EmpresaAuthService: ${totalStopwatch?.elapsedMilliseconds}ms');
//         }
        
//         return Success(authResponse);
//       } else {
//         if (kDebugMode) {
//           totalStopwatch?.stop();
//           print('❌ Empresa login falló en ${totalStopwatch?.elapsedMilliseconds}ms - Status: ${response.statusCode}');
//         }
//         return Error(_extractErrorMessage(response.data));
//       }
      
//     } on DioException catch (e) {
//       if (kDebugMode) {
//         totalStopwatch?.stop();
//         print('💥 DioException en ${totalStopwatch?.elapsedMilliseconds}ms: ${e.type} - ${e.message}');
//       }
//       return Error(_handleDioError(e));
//     } catch (e) {
//       if (kDebugMode) {
//         totalStopwatch?.stop();
//         print('💥 Error inesperado en ${totalStopwatch?.elapsedMilliseconds}ms: $e');
//       }
//       return Error('Error inesperado: ${e.toString()}');
//     }
//   }

//   // Validate empresa token
//   Future<Resource<bool>> validateEmpresaToken(String empresaToken) async {
//     try {
//       final response = await _dio.get(
//         '/api/auth/empresa/validate',
//         options: Options(
//           headers: {'Authorization': 'Bearer $empresaToken'},
//         ),
//       );

//       return Success(response.statusCode == 200);
//     } on DioException catch (e) {
//       return Error(_handleDioError(e));
//     } catch (e) {
//       return Error('Error inesperado');
//     }
//   }

//   // Logout from empresa
//   Future<Resource<bool>> logoutFromEmpresa(String empresaToken) async {
//     try {
//       final response = await _dio.post(
//         '/api/auth/empresa/logout',
//         options: Options(
//           headers: {'Authorization': 'Bearer $empresaToken'},
//           sendTimeout: const Duration(seconds: 5),
//           receiveTimeout: const Duration(seconds: 8),
//         ),
//       );

//       return Success(response.statusCode == 200 || response.statusCode == 204);
//     } on DioException catch (e) {
//       return Success(true); // Continue with local cleanup
//     } catch (e) {
//       return Success(true);
//     }
//   }

//   // HELPER methods from AuthService
//   String _extractErrorMessage(dynamic data) {
//     try {
//       if (data is Map<String, dynamic>) {
//         if (data['message'] is List) {
//           final messages = data['message'] as List;
//           return messages.take(3).join(', ');
//         } else if (data['message'] is String) {
//           return data['message'];
//         } else if (data['error'] is String) {
//           return data['error'];
//         }
//       }
//       return 'Error en el servidor';
//     } catch (e) {
//       return 'Error procesando respuesta del servidor';
//     }
//   }

//   String _handleDioError(DioException error) {
//     switch (error.type) {
//       case DioExceptionType.connectionTimeout:
//         return 'Conexión lenta. Verifica tu internet.';
//       case DioExceptionType.sendTimeout:
//         return 'Envío lento. Intenta nuevamente.';
//       case DioExceptionType.receiveTimeout:
//         return 'Servidor lento. Intenta más tarde.';
//       case DioExceptionType.connectionError:
//         return 'Sin conexión. Verifica tu internet.';
//       case DioExceptionType.badResponse:
//         final statusCode = error.response?.statusCode;
//         switch (statusCode) {
//           case 400:
//             return _extractErrorMessage(error.response?.data);
//           case 401:
//             return 'Token inválido o expirado';
//           case 403:
//             return 'Acceso denegado a la empresa';
//           case 404:
//             return 'Empresa no encontrada';
//           case 429:
//             return 'Muchas peticiones. Espera un momento.';
//           case 500:
//           case 502:
//           case 503:
//           case 504:
//             return 'Servidor no disponible. Intenta más tarde.';
//           default:
//             return 'Error del servidor ($statusCode)';
//         }
//       case DioExceptionType.cancel:
//         return 'Operación cancelada';
//       case DioExceptionType.unknown:
//         final message = error.message ?? '';
//         if (message.contains('SocketException')) {
//           return 'Sin internet';
//         }
//         return 'Error de conexión';
//       default:
//         return 'Error inesperado';
//     }
//   }
// }

// // ISOLATE FUNCTION
// AuthResponse _parseAuthResponseInIsolate(String jsonString) {
//   Stopwatch? stopwatch;
//   if (kDebugMode) {
//     stopwatch = Stopwatch()..start();
//   }
  
//   try {
//     final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
//     final result = AuthResponse.fromJson(jsonMap);
    
//     if (kDebugMode) {
//       stopwatch?.stop();
//       print('🔄 Parsing en isolate: ${stopwatch?.elapsedMilliseconds}ms');
//     }
    
//     return result;
//   } catch (e) {
//     if (kDebugMode) {
//       stopwatch?.stop();
//       print('❌ Error parsing en isolate (${stopwatch?.elapsedMilliseconds}ms): $e');
//     }
//     rethrow;
//   }
// }