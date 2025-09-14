import 'package:syncronize/src/domain/repository/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository authRepository;
  
  LogoutUseCase(this.authRepository);
  
  Future<bool> run() => authRepository.logout();
}