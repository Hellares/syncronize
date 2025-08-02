import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncronize/src/domain/use_cases/auth/auth_use_cases.dart';
import 'package:syncronize/src/domain/utils/resource.dart';
import 'package:syncronize/src/presentation/page/auth/login/cliente/bloc/login_event.dart';
import 'package:syncronize/src/presentation/page/auth/login/cliente/bloc/login_state.dart';
import 'package:syncronize/src/presentation/utils/bloc_form_item.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState>{

  AuthUseCases authUseCases;

  LoginBloc(this.authUseCases) : super(const LoginState()) {
    on<InitEvent>(_onInitEvent);
    on<DniChanged>(_onDniChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<LoginSubmit>(_onLoginSubmit);
   
  }
  final formKey = GlobalKey<FormState>();

  Future<void> _onInitEvent(InitEvent event, Emitter<LoginState> emit) async {
    // AuthResponse? authResponse = await authUseCases.getUserSession.run();
    emit( state.copyWith( formKey: formKey ) );
    // if (authResponse != null) {
    //   emit(
    //     state.copyWith(
    //       response: Success(authResponse), // AuthResponse -> user, token
    //       formKey: formKey
    //     )
    //   );
    // }
  }

  Future<void> _onDniChanged(DniChanged event, Emitter<LoginState> emit) async {
    emit(
      state.copyWith(
        dni: BlocFormItem(
          value: event.dni.value,
          error: event.dni.value.isNotEmpty ? null : 'Ingresa el email'
        ),
        formKey: formKey
      )
    );
  }
  
  Future<void> _onPasswordChanged(PasswordChanged event, Emitter<LoginState> emit) async {
    emit(
      state.copyWith(
        password: BlocFormItem(
          value: event.password.value,
          error: event.password.value.isNotEmpty && event.password.value.length >= 6 ? null : 'Ingresa el password'
        ),
        formKey: formKey
      )
    );
  }
  
  Future<void> _onLoginSubmit(LoginSubmit event, Emitter<LoginState> emit) async {
    emit(
      state.copyWith(
        response: Loading(),
        formKey: formKey
      ),
    );
    Resource response = await authUseCases.login.run(state.dni.value, state.password.value); 
   
    emit(
      state.copyWith(
        response: response,
        formKey: formKey
      )
    );
  }
}