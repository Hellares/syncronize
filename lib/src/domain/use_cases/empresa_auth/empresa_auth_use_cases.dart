import 'package:syncronize/src/domain/repository/empresa_auth_repository.dart';
import 'package:syncronize/src/domain/use_cases/empresa_auth/clear_empresa_session_usecase.dart';
import 'package:syncronize/src/domain/use_cases/empresa_auth/get_empresa_session_usecase.dart';
import 'package:syncronize/src/domain/use_cases/empresa_auth/login_to_empresa_usecase.dart';
import 'package:syncronize/src/domain/use_cases/empresa_auth/save_empresa_session_usecase.dart';

class EmpresaAuthUseCases {
  final LoginToEmpresaUseCase loginToEmpresa;
  final GetEmpresaSessionUseCase getEmpresaSession;
  final SaveEmpresaSessionUseCase saveEmpresaSession;
  final ClearEmpresaSessionUseCase clearEmpresaSession;

  EmpresaAuthUseCases({
    required EmpresaAuthRepository repository,
  }) : loginToEmpresa = LoginToEmpresaUseCase(repository),
       getEmpresaSession = GetEmpresaSessionUseCase(repository),
       saveEmpresaSession = SaveEmpresaSessionUseCase(repository),
       clearEmpresaSession = ClearEmpresaSessionUseCase(repository);
}