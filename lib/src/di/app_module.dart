import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:syncronize/src/data/api/dio_config.dart';
import 'package:syncronize/src/data/datasource/local/secure_storage.dart';
import 'package:syncronize/src/data/datasource/remote/service/auth_service.dart';
import 'package:syncronize/src/data/datasource/remote/service/empresa_user_roles_service.dart';
import 'package:syncronize/src/data/datasource/remote/service/reniec_service.dart';
import 'package:syncronize/src/data/repository/auth_repository_impl.dart';
import 'package:syncronize/src/data/repository/empresa_user_roles_repository_impl.dart';
import 'package:syncronize/src/data/repository/reniec_repository_impl.dart';
import 'package:syncronize/src/domain/repository/auth_repository.dart';
import 'package:syncronize/src/domain/repository/empresa_user_roles_repository.dart';
import 'package:syncronize/src/domain/repository/reniec_repository.dart';
import 'package:syncronize/src/domain/use_cases/auth/auth_use_cases.dart';
import 'package:syncronize/src/domain/use_cases/auth/get_user_session_usecase.dart';
import 'package:syncronize/src/domain/use_cases/auth/login_use_case.dart';
import 'package:syncronize/src/domain/use_cases/auth/logout_usecase.dart';
import 'package:syncronize/src/domain/use_cases/auth/register_use_case.dart';
import 'package:syncronize/src/domain/use_cases/auth/save_user_session_usecase.dart';
import 'package:syncronize/src/domain/use_cases/empresa_user_roles/empresa_user_roles_use_cases.dart';
import 'package:syncronize/src/domain/use_cases/empresa_user_roles/get_empresa_user_roles_usecase.dart';
import 'package:syncronize/src/domain/use_cases/reniec/get_data_dni_reniec_use_case.dart';
import 'package:syncronize/src/domain/use_cases/reniec/reniec_use_cases.dart';

@module
abstract class AppModule {
  
  // CORE DEPENDENCIES
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
  
  @preResolve
  @singleton
  Future<String> token() async {
    try {
      final secureStorage = SecureStorage();
      final userData = await secureStorage.read('user');
      if (userData != null) {
        final token = userData['data']?['token'] ?? '';
        if (kDebugMode && token.isNotEmpty) {
          print('🔑 Token cargado desde caché');
        }
        return token;
      }
      if (kDebugMode) print('⚠️ No hay token en caché');
      return '';
    } catch (e) {
      if (kDebugMode) print('❌ Error cargando token: $e');
      return '';
    }
  }
  
  // SERVICES - Singleton
  @singleton
  AuthService authService() {
    if (kDebugMode) print('🔐 Creando AuthService singleton');
    return AuthService();
  }
  
  @singleton
  ReniecService reniecService() {
    if (kDebugMode) print('🆔 Creando ReniecService singleton');
    return ReniecService();
  }
  
  @singleton
  EmpresaUserRolesService empresaUserRolesService() {
    if (kDebugMode) print('🏢 Creando EmpresaUserRolesService singleton');
    return EmpresaUserRolesService();
  }
  
  // REPOSITORIES - Singleton
  @singleton
  AuthRepository authRepository() {
    if (kDebugMode) print('📚 Creando AuthRepository singleton');
    return AuthRepositoryImpl(authService(), secureStorage());
  }
  
  @singleton
  ReniecRepository reniecRepository() {
    if (kDebugMode) print('📚 Creando ReniecRepository singleton');
    return ReniecRepositoryImpl(reniecService());
  }
  
  @singleton
  EmpresaUserRolesRepository empresaUserRolesRepository() {
    if (kDebugMode) print('📚 Creando EmpresaUserRolesRepository singleton');
    return EmpresaUserRolesRepositoryImpl(empresaUserRolesService());
  }
  
  // USE CASES CONTAINERS - Singleton creando use cases internamente
  @singleton
  AuthUseCases authUseCases() {
    if (kDebugMode) print('🎯 Creando AuthUseCases singleton');
    
    // ✅ Obtener repository singleton una sola vez
    final authRepo = authRepository();
    
    // ✅ Crear todos los use cases usando la misma instancia del repository
    return AuthUseCases(
      login: LoginUseCase(authRepo),
      register: RegisterUseCase(authRepo),
      saveUserSession: SaveUserSessionUseCase(authRepo),
      getUserSession: GetUserSessionUseCase(authRepo),
      logout: LogoutUseCase(authRepo),
    );
  }
  
  @singleton
  ReniecUseCases reniecUseCases() {
    if (kDebugMode) print('🎯 Creando ReniecUseCases singleton');
    
    // ✅ Obtener repository singleton una sola vez
    final reniecRepo = reniecRepository();
    
    return ReniecUseCases(
      reniecRepo,
      getDataDniReniec: GetDataDniReniecUseCase(reniecRepo),
    );
  }

  @singleton
  EmpresaUserRolesUseCases empresaUserRolesUseCases() {
    if (kDebugMode) print('🎯 Creando EmpresaUserRolesUseCases singleton');
    
    // ✅ Obtener repository singleton una sola vez
    final empresaRepo = empresaUserRolesRepository();
    
    return EmpresaUserRolesUseCases(
      getEmpresaUserRoles: GetEmpresaUserRolesUsecase(empresaRepo),
    );
  }
}