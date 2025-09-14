// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:syncronize/src/data/datasource/local/secure_storage.dart'
    as _i16;
import 'package:syncronize/src/data/datasource/remote/service/auth_service.dart'
    as _i29;
import 'package:syncronize/src/data/datasource/remote/service/empresa_user_roles_service.dart'
    as _i101;
import 'package:syncronize/src/data/datasource/remote/service/reniec_service.dart'
    as _i304;
import 'package:syncronize/src/di/app_module.dart' as _i564;
import 'package:syncronize/src/domain/repository/auth_repository.dart' as _i542;
import 'package:syncronize/src/domain/repository/empresa_user_roles_repository.dart'
    as _i91;
import 'package:syncronize/src/domain/repository/reniec_repository.dart'
    as _i860;
import 'package:syncronize/src/domain/use_cases/auth/auth_use_cases.dart'
    as _i736;
import 'package:syncronize/src/domain/use_cases/empresa_user_roles/empresa_user_roles_use_cases.dart'
    as _i303;
import 'package:syncronize/src/domain/use_cases/reniec/reniec_use_cases.dart'
    as _i792;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    gh.singleton<_i361.Dio>(() => appModule.dio());
    gh.singleton<_i16.SecureStorage>(() => appModule.secureStorage());
    await gh.singletonAsync<String>(() => appModule.token(), preResolve: true);
    gh.singleton<_i29.AuthService>(() => appModule.authService());
    gh.singleton<_i304.ReniecService>(() => appModule.reniecService());
    gh.singleton<_i101.EmpresaUserRolesService>(
      () => appModule.empresaUserRolesService(),
    );
    gh.singleton<_i542.AuthRepository>(() => appModule.authRepository());
    gh.singleton<_i860.ReniecRepository>(() => appModule.reniecRepository());
    gh.singleton<_i91.EmpresaUserRolesRepository>(
      () => appModule.empresaUserRolesRepository(),
    );
    gh.singleton<_i736.AuthUseCases>(() => appModule.authUseCases());
    gh.singleton<_i792.ReniecUseCases>(() => appModule.reniecUseCases());
    gh.singleton<_i303.EmpresaUserRolesUseCases>(
      () => appModule.empresaUserRolesUseCases(),
    );
    return this;
  }
}

class _$AppModule extends _i564.AppModule {}
