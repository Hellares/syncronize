import 'package:syncronize/src/domain/use_cases/auth/get_user_session_usecase.dart';
import 'package:syncronize/src/domain/use_cases/auth/login_use_case.dart';
//import 'package:syncronize/src/domain/use_cases/auth/logout_usecase.dart';
import 'package:syncronize/src/domain/use_cases/auth/register_use_case.dart';
import 'package:syncronize/src/domain/use_cases/auth/save_user_session_usecase.dart';

class AuthUseCases {
  
  LoginUseCase login;
  RegisterUseCase register;
  SaveUserSessionUseCase saveUserSession;
  GetUserSessionUseCase getUserSession;
  //LogoutUseCase logout;

  AuthUseCases({
    required this.login,
    required this.register,
    required this.saveUserSession,
    required this.getUserSession,
    //required this.logout
  });
}