import 'package:flutter/foundation.dart';

class ApiConfig {
  static const String localApi = "192.168.100.3:3000";
  static const String productionApi = 'api-gateway.syncronize.net.pe';
  
  // Determinar automáticamente el entorno basado en kReleaseMode
  static bool get isProduction => kReleaseMode;

  static String get apiSyncronize => isProduction ? productionApi : localApi;

  // URL base para Dio
  static String get baseUrl => isProduction 
    ? 'https://$productionApi'
    : 'http://$localApi';

  static Uri getUri(String path) {
    return isProduction
      ? Uri.https(apiSyncronize, path)
      : Uri.http(apiSyncronize, path);
  }

  // Configuraciones específicas por entorno
  static Duration get connectTimeout => isProduction 
    ? const Duration(seconds: 8)  // Más tiempo en producción (red externa)
    : const Duration(seconds: 5); // Menos tiempo en desarrollo (red local)

  static Duration get receiveTimeout => isProduction 
    ? const Duration(seconds: 10) 
    : const Duration(seconds: 8);

  static Duration get sendTimeout => isProduction 
    ? const Duration(seconds: 8) 
    : const Duration(seconds: 5);

  // Headers específicos por entorno
  static Map<String, String> get headers {
    final baseHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Connection': 'keep-alive',
    };

    if (isProduction) {
      // Headers adicionales para producción
      baseHeaders.addAll({
        'X-API-Version': '1.0',
        'X-Client-Platform': 'flutter',
      });
    }

    return baseHeaders;
  }

  // Configuraciones de retry por entorno
  static int get maxRetries => isProduction ? 2 : 1;
  static Duration get retryDelay => isProduction 
    ? const Duration(milliseconds: 500)
    : const Duration(milliseconds: 300);

  // Info de debugging
  static void logEnvironmentInfo() {
    if (kDebugMode) {
      print('🌐 Entorno: ${isProduction ? "PRODUCCIÓN" : "DESARROLLO"}');
      print('🔗 Base URL: $baseUrl');
      print('⏱️ Timeouts: Connect=${connectTimeout.inSeconds}s, Receive=${receiveTimeout.inSeconds}s');
    }
  }
}