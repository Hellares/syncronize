import 'package:flutter/foundation.dart';
import 'package:syncronize/src/data/api/dio_config.dart';
import 'package:syncronize/src/data/datasource/local/secure_storage.dart';
import 'package:syncronize/src/data/datasource/remote/service/auth_service.dart';
import 'package:syncronize/src/domain/models/auth_empresa_response.dart';
import 'package:syncronize/src/domain/models/auth_response_register_new.dart';
import 'package:syncronize/src/domain/models/user_register_new.dart';
import 'package:syncronize/src/domain/repository/auth_repository.dart';
import 'package:syncronize/src/domain/utils/resource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService authService;
  final SecureStorage secureStorage;
  
  AuthRepositoryImpl(this.authService, this.secureStorage);

  @override
  Future<Resource<AuthEmpresaResponse>> login(String dni, String password) {
    return authService.login(dni, password);
  }

  @override
  Future<Resource<AuthResponseRegisterNew>> register(UserRegisterNew user) {
    return authService.register(user);
  }
  
  @override
  Future<AuthEmpresaResponse?> getUserSession() async {
    try {
      final userData = await secureStorage.read('user');
      if (userData != null) {
        return AuthEmpresaResponse.fromJson(userData);
      }
      return null;
    } catch (e) {
      if (kDebugMode) print('Error obteniendo sesión de usuario: $e');
      return null;
    }
  }
  
  @override
  Future<void> saveUserSession(AuthEmpresaResponse authResponse) async {
    Stopwatch? stopwatch;
    if (kDebugMode) {
      stopwatch = Stopwatch()..start();
    }
    
    try {
      // Guardar datos completos del usuario
      await secureStorage.save('user', authResponse.toJson());
      
      // Forzar actualización del token en el interceptor de Dio
      _forceAuthInterceptorRefresh();
      
      if (kDebugMode) {
        stopwatch?.stop();
        print('Sesión guardada exitosamente en ${stopwatch?.elapsedMilliseconds}ms');
      }
    } catch (e) {
      if (kDebugMode) {
        stopwatch?.stop();
        print('Error guardando sesión en ${stopwatch?.elapsedMilliseconds}ms: $e');
      }
      rethrow;
    }
  }
  
  @override
  Future<bool> logout() async {
    Stopwatch? totalStopwatch;
    if (kDebugMode) {
      totalStopwatch = Stopwatch()..start();
      print('Iniciando logout completo...');
    }
    
    try {
      // 1. PRIMERO: Notificar al servidor
      Stopwatch? serverStopwatch;
      if (kDebugMode) {
        serverStopwatch = Stopwatch()..start();
      }
      
      final serverLogoutResult = await authService.logout();
      
      if (kDebugMode) {
        serverStopwatch?.stop();
        if (serverLogoutResult is Error) {
          print('Error en logout del servidor (${serverStopwatch?.elapsedMilliseconds}ms): ${(serverLogoutResult as Error).message}');
        } else {
          print('Logout del servidor exitoso en ${serverStopwatch?.elapsedMilliseconds}ms');
        }
      }
      
      // 2. SEGUNDO: Limpiar almacenamiento local
      Stopwatch? localStopwatch;
      if (kDebugMode) {
        localStopwatch = Stopwatch()..start();
      }
      
      await _clearLocalSession();
      
      if (kDebugMode) {
        localStopwatch?.stop();
        print('Sesión local limpiada en ${localStopwatch?.elapsedMilliseconds}ms');
      }
      
      // 3. TERCERO: Limpiar cache del AuthInterceptor
      _forceAuthInterceptorRefresh();
      
      if (kDebugMode) {
        totalStopwatch?.stop();
        print('Logout completo exitoso en ${totalStopwatch?.elapsedMilliseconds}ms');
      }
      
      return true;
      
    } catch (e) {
      if (kDebugMode) {
        totalStopwatch?.stop();
        print('Error en logout (${totalStopwatch?.elapsedMilliseconds}ms): $e');
      }
      
      // Si falla, al menos intentar limpiar local
      try {
        await _clearLocalSession();
        _forceAuthInterceptorRefresh();
        
        if (kDebugMode) print('Logout local completado a pesar del error');
        return true;
      } catch (localError) {
        // Este error SÍ debe ser visible en producción para debugging
        print('Error crítico en logout: $localError');
        return false;
      }
    }
  }

  // Método privado para limpiar sesión local
  Future<void> _clearLocalSession() async {
    try {
      await secureStorage.remove('user');
      if (kDebugMode) print('Sesión local limpiada');
    } catch (e) {
      if (kDebugMode) print('Error limpiando sesión local: $e');
      rethrow;
    }
  }

  // Método privado para limpiar cache del AuthInterceptor
  void _forceAuthInterceptorRefresh() {
    try {
      final authInterceptors = DioConfig.instance.interceptors
          .whereType<OptimizedAuthInterceptor>();
      
      if (authInterceptors.isNotEmpty) {
        authInterceptors.first.forceTokenRefresh();
        if (kDebugMode) print('Cache del AuthInterceptor limpiado');
      } else {
        if (kDebugMode) print('AuthInterceptor no encontrado');
      }
    } catch (e) {
      if (kDebugMode) print('Error limpiando cache del interceptor: $e');
      // No relanzar el error ya que no es crítico
    }
  }

  // Método de utilidad para obtener información de sesión (opcional)
  Future<Map<String, dynamic>?> getSessionInfo() async {
    if (!kDebugMode) return null;
    
    try {
      final userData = await secureStorage.read('user');
      if (userData != null) {
        final authResponse = AuthEmpresaResponse.fromJson(userData);
        return {
          'user_name': authResponse.data?.user.nombres,
          'user_dni': authResponse.data?.user.dni,
          'empresas_count': authResponse.data?.empresas.length ?? 0,
          'needs_empresa_selection': authResponse.data?.needsEmpresaSelection ?? false,
          'token_exists': authResponse.data?.token.isNotEmpty ?? false,
        };
      }
      return null;
    } catch (e) {
      if (kDebugMode) print('Error obteniendo info de sesión: $e');
      return null;
    }
  }

  
}