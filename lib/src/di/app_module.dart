import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:syncronize/src/data/api/dio_config.dart';
import 'package:syncronize/src/data/datasource/local/secure_storage.dart';
import 'package:syncronize/src/data/datasource/remote/service/auth_service.dart';
import 'package:syncronize/src/data/datasource/remote/service/reniec_service.dart';
import 'package:syncronize/src/data/repository/auth_repository_impl.dart';
import 'package:syncronize/src/data/repository/reniec_repository_impl.dart';
import 'package:syncronize/src/domain/repository/auth_repository.dart';
import 'package:syncronize/src/domain/repository/reniec_repository.dart';
import 'package:syncronize/src/domain/use_cases/auth/auth_use_cases.dart';
import 'package:syncronize/src/domain/use_cases/auth/get_user_session_usecase.dart';
import 'package:syncronize/src/domain/use_cases/auth/login_use_case.dart';
import 'package:syncronize/src/domain/use_cases/auth/logout_usecase.dart';
import 'package:syncronize/src/domain/use_cases/auth/register_use_case.dart';
import 'package:syncronize/src/domain/use_cases/auth/save_user_session_usecase.dart';
import 'package:syncronize/src/domain/use_cases/reniec/get_data_dni_reniec_use_case.dart';
import 'package:syncronize/src/domain/use_cases/reniec/reniec_use_cases.dart';

@module
abstract class AppModule {
  
  // ✅ CORE DEPENDENCIES - Solo UNA instancia
  @singleton
  Dio dio() {
    if (kDebugMode) print('🔧 Creando Dio singleton');
    return DioConfig.instance;
  }
  
  @singleton
  SecureStorage secureStorage() {
    if (kDebugMode) print('🔒 Creando SecureStorage singleton');
    return SecureStorage();
  }
  
  // ✅ ELIMINAR token preResolve - Causa problemas de inicialización
  // El token se obtendrá dinámicamente cuando se necesite
  
  // ✅ SERVICES - Factory en lugar de Singleton
  // Esto evita la duplicación pero mantiene performance
  @injectable
  AuthService authService(Dio dio) {
    if (kDebugMode) print('🔐 Creando AuthService');
    return AuthService(); // Usa DioConfig.instance internamente
  }
  
  @injectable
  ReniecService reniecService() {
    if (kDebugMode) print('🆔 Creando ReniecService');
    return ReniecService();
  }
  
  

  
  // ✅ REPOSITORIES - Singleton con dependencias inyectadas
  @singleton
  AuthRepository authRepository(AuthService authService, SecureStorage secureStorage) {
    if (kDebugMode) print('📚 Creando AuthRepository singleton');
    return AuthRepositoryImpl(authService, secureStorage);
  }
  
  @singleton
  ReniecRepository reniecRepository(ReniecService reniecService) {
    if (kDebugMode) print('📚 Creando ReniecRepository singleton');
    return ReniecRepositoryImpl(reniecService);
  }
  
  
  
  // ✅ USE CASES CONTAINERS - Singleton optimizado
  @singleton
  AuthUseCases authUseCases(AuthRepository authRepository) {
    if (kDebugMode) print('🎯 Creando AuthUseCases singleton');
    
    return AuthUseCases(
      login: LoginUseCase(authRepository),
      register: RegisterUseCase(authRepository),
      saveUserSession: SaveUserSessionUseCase(authRepository),
      getUserSession: GetUserSessionUseCase(authRepository),
      logout: LogoutUseCase(authRepository),
    );
  }
  
  @singleton
  ReniecUseCases reniecUseCases(ReniecRepository reniecRepository) {
    if (kDebugMode) print('🎯 Creando ReniecUseCases singleton');
    
    return ReniecUseCases(
      reniecRepository,
      getDataDniReniec: GetDataDniReniecUseCase(reniecRepository),
    );
  }

  
}