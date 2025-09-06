import 'package:injectable/injectable.dart';
import 'package:syncronize/src/data/datasource/local/shared_preference.dart';
import 'package:syncronize/src/data/datasource/remote/service/auth_service.dart';
import 'package:syncronize/src/data/datasource/remote/service/empresa_user_roles_service.dart';
import 'package:syncronize/src/data/datasource/remote/service/reniec_service.dart';
import 'package:syncronize/src/data/repository/auth_repository_impl.dart';
import 'package:syncronize/src/data/repository/empresa_user_roles_repository_impl.dart';
import 'package:syncronize/src/data/repository/reniec_repository_impl.dart';
import 'package:syncronize/src/domain/models/auth_response.dart';
import 'package:syncronize/src/domain/repository/auth_repository.dart';
import 'package:syncronize/src/domain/repository/empresa_user_roles_repository.dart';
import 'package:syncronize/src/domain/repository/reniec_repository.dart';
import 'package:syncronize/src/domain/use_cases/auth/auth_use_cases.dart';
import 'package:syncronize/src/domain/use_cases/auth/get_user_session_usecase.dart';
import 'package:syncronize/src/domain/use_cases/auth/login_use_case.dart';
import 'package:syncronize/src/domain/use_cases/auth/register_use_case.dart';
import 'package:syncronize/src/domain/use_cases/auth/save_user_session_usecase.dart';
import 'package:syncronize/src/domain/use_cases/empresa_user_roles/empresa_user_roles_use_cases.dart';
import 'package:syncronize/src/domain/use_cases/empresa_user_roles/get_empresa_user_roles_usecase.dart';
import 'package:syncronize/src/domain/use_cases/reniec/get_data_dni_reniec_use_case.dart';
import 'package:syncronize/src/domain/use_cases/reniec/reniec_use_cases.dart';

@module
abstract class AppModule {

  @injectable
  SharedPref get sharedPref => SharedPref();

  @injectable
  Future<String> get token async{
    String token = "";
    final userSession = await sharedPref.read('user');      
      if(userSession != null){
        AuthResponse authResponse = AuthResponse.fromJson(userSession);
        token = authResponse.data.token;
      }
    return token;
  }
  
  @injectable
  AuthService get authService => AuthService();

  @injectable
  AuthRepository get authRepository => AuthRepositoryImpl(authService, sharedPref);

  @injectable
  ReniecService get reniecService => ReniecService();

  @injectable
  ReniecRepository get reniecRepository => ReniecRepositoryImpl(reniecService);

  @injectable
  EmpresaUserRolesService get empresaUserRolesService => EmpresaUserRolesService();

  @injectable
  EmpresaUserRolesRepository get empresaUserRolesRepository => EmpresaUserRolesRepositoryImpl(empresaUserRolesService);



  @injectable
  AuthUseCases get authUseCases => AuthUseCases(
        login: LoginUseCase(authRepository),
        register: RegisterUseCase(authRepository),
        saveUserSession: SaveUserSessionUseCase(authRepository),
        getUserSession: GetUserSessionUseCase(authRepository),
      );

  @injectable
  ReniecUseCases get reniecUseCases => ReniecUseCases(
        getDataDniReniec: GetDataDniReniecUseCase(reniecRepository),
      );

  @injectable
  EmpresaUserRolesUseCases get empresaUserRolesUseCases => EmpresaUserRolesUseCases(
        getEmpresaUserRoles: GetEmpresaUserRolesUsecase(empresaUserRolesRepository),
      );
}