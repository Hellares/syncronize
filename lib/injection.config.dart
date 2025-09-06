// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:syncronize/src/data/datasource/local/shared_preference.dart'
    as _i397;
import 'package:syncronize/src/data/datasource/remote/service/auth_service.dart'
    as _i29;
// import 'package:syncronize/src/data/datasource/remote/service/empresa_auth_service.dart'
//     as _i681;
import 'package:syncronize/src/data/datasource/remote/service/empresa_user_roles_service.dart'
    as _i101;
import 'package:syncronize/src/data/datasource/remote/service/reniec_service.dart'
    as _i304;
import 'package:syncronize/src/di/app_module.dart' as _i564;
import 'package:syncronize/src/domain/repository/auth_repository.dart' as _i542;
// import 'package:syncronize/src/domain/repository/empresa_auth_repository.dart'
//     as _i405;
import 'package:syncronize/src/domain/repository/empresa_user_roles_repository.dart'
    as _i91;
import 'package:syncronize/src/domain/repository/reniec_repository.dart'
    as _i860;
import 'package:syncronize/src/domain/use_cases/auth/auth_use_cases.dart'
    as _i736;
// import 'package:syncronize/src/domain/use_cases/empresa_auth/empresa_auth_use_cases.dart'
//     as _i923;
import 'package:syncronize/src/domain/use_cases/empresa_user_roles/empresa_user_roles_use_cases.dart'
    as _i303;
import 'package:syncronize/src/domain/use_cases/reniec/reniec_use_cases.dart'
    as _i792;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    gh.factory<_i397.SharedPref>(() => appModule.sharedPref);
    gh.factoryAsync<String>(() => appModule.token);
    gh.factory<_i29.AuthService>(() => appModule.authService);
    gh.factory<_i542.AuthRepository>(() => appModule.authRepository);
    gh.factory<_i304.ReniecService>(() => appModule.reniecService);
    gh.factory<_i860.ReniecRepository>(() => appModule.reniecRepository);

    gh.factory<_i101.EmpresaUserRolesService>(
      () => appModule.empresaUserRolesService,
    );
    gh.factory<_i91.EmpresaUserRolesRepository>(
      () => appModule.empresaUserRolesRepository,
    );
    gh.factory<_i736.AuthUseCases>(() => appModule.authUseCases);
    gh.factory<_i792.ReniecUseCases>(() => appModule.reniecUseCases);
    gh.factory<_i303.EmpresaUserRolesUseCases>(
      () => appModule.empresaUserRolesUseCases,
    );
    return this;
  }
}

class _$AppModule extends _i564.AppModule {}
