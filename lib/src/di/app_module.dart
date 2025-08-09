import 'package:injectable/injectable.dart';
import 'package:syncronize/src/data/datasource/remote/service/auth_service.dart';
import 'package:syncronize/src/data/datasource/remote/service/reniec_service.dart';
import 'package:syncronize/src/data/repository/auth_repository_impl.dart';
import 'package:syncronize/src/data/repository/reniec_repository_impl.dart';
import 'package:syncronize/src/domain/repository/auth_repository.dart';
import 'package:syncronize/src/domain/repository/reniec_repository.dart';
import 'package:syncronize/src/domain/use_cases/auth/auth_use_cases.dart';
import 'package:syncronize/src/domain/use_cases/auth/login_use_case.dart';
import 'package:syncronize/src/domain/use_cases/auth/register_use_case.dart';
import 'package:syncronize/src/domain/use_cases/reniec/get_data_dni_reniec_use_case.dart';
import 'package:syncronize/src/domain/use_cases/reniec/reniec_use_cases.dart';

@module
abstract class AppModule {
  
  @injectable
  AuthService get authService => AuthService();

  @injectable
  AuthRepository get authRepository => AuthRepositoryImpl(authService);

  @injectable
  ReniecService get reniecService => ReniecService();

  @injectable
  ReniecRepository get reniecRepository => ReniecRepositoryImpl(reniecService);

  @injectable
  AuthUseCases get authUseCases => AuthUseCases(
        login: LoginUseCase(authRepository),
        register: RegisterUseCase(authRepository)
      );

  @injectable
  ReniecUseCases get reniecUseCases => ReniecUseCases(
        getDataDniReniec: GetDataDniReniecUseCase(reniecRepository),
      );
}