import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncronize/src/domain/models/auth_empresa_response.dart';
import 'package:syncronize/src/domain/use_cases/auth/auth_use_cases.dart';
import 'package:syncronize/src/domain/utils/resource.dart';
import 'package:syncronize/src/presentation/page/auth/login/cliente/bloc/login_event.dart';
import 'package:syncronize/src/presentation/page/auth/login/cliente/bloc/login_state.dart';
import 'package:syncronize/src/presentation/utils/bloc_form_item.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState>{

  AuthUseCases authUseCases;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  LoginBloc(this.authUseCases) : super(const LoginState()) {
    on<InitEvent>(_onInitEvent);
    on<DniChanged>(_onDniChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<LoginSubmit>(_onLoginSubmit);
    on<LoginSaveUserSession>(_onLoginSaveUserSession);
    on<ClearError>(_onClearError);
   
  }
  

  Future<void> _onInitEvent(InitEvent event, Emitter<LoginState> emit) async {
    AuthEmpresaResponse? authResponse = await authUseCases.getUserSession.run();
    emit( state.copyWith( formKey: formKey ) );
    if (authResponse != null) {
      emit(
        state.copyWith(
          response: Success(authResponse), // AuthResponse -> user, token
          formKey: formKey
        )
      );
    }
  }
  

  Future<void>_onLoginSaveUserSession(LoginSaveUserSession event, Emitter<LoginState> emit) async {
    await authUseCases.saveUserSession.run(event.authResponse);
  }

  
    
  Future<void> _onDniChanged(DniChanged event, Emitter<LoginState> emit) async {
  // Limpiar error si existe
  if (state.response is Error) {
    emit(state.copyWith(response: Initial()));
  }

  String? dniError;
  if (event.dni.value.isNotEmpty && !RegExp(r'^\d{8}$').hasMatch(event.dni.value)) {
    dniError = 'DNI inválido (8 dígitos)';
  }
  
  emit(
    state.copyWith(
      dni: BlocFormItem(
        value: event.dni.value,
        error: dniError, // null si no hay error
      ),
      formKey: formKey
    )
  );
}
  

  Future<void> _onPasswordChanged(PasswordChanged event, Emitter<LoginState> emit) async {
  // Limpiar error si existe
  if (state.response is Error) {
    emit(state.copyWith(response: Initial()));
  }

  String? passwordError;
  if (event.password.value.isNotEmpty && event.password.value.length < 6) {
    passwordError = 'Mínimo 6 caracteres';
  }
  
  emit(
    state.copyWith(
      password: BlocFormItem(
        value: event.password.value,
        error: passwordError, // null si no hay error
      ),
      formKey: formKey
    )
  );
}

  
  
  // Future<void> _onLoginSubmit(LoginSubmit event, Emitter<LoginState> emit) async {
  //   // Validación del formulario
  //   if (state.dni.error != null || state.password.error != null) {
  //     emit(state.copyWith(
  //       response: Error('Por favor, completa el formulario correctamente', statusCode: 400),
  //       formKey: formKey
  //     ));
  //     return;
  //   }
    
  //   // Iniciar loading
  //   emit(state.copyWith(response: Loading(), formKey: formKey));
    
  //   // Realizar login
  //   final response = await authUseCases.login.run(state.dni.value, state.password.value);
    
  //   // // Log para debugging
  //   // if (response is Error<AuthEmpresaResponse>) {
  //   //   print('❌ Error en login:');
  //   //   print('   Mensaje: ${response.message}');
  //   //   print('   Status: ${response.statusCode}');
  //   //   print('   Code: ${response.errorCode}');
      
  //   //   // Análisis del tipo de error
  //   //   if (response.isAuthError) {
  //   //     print('   Tipo: Error de autenticación');
  //   //   } else if (response.isNetworkError) {
  //   //     print('   Tipo: Error de red');
  //   //   } else if (response.isValidationError) {
  //   //     print('   Tipo: Error de validación');
  //   //   }
  //   // } else if (response is Success<AuthEmpresaResponse>) {
  //   //   final authResponse = response.data;
  //   //   print('✅ Login exitoso:');
  //   //   print('   Usuario: ${authResponse.data?.user.nombres}');
  //   //   print('   Empresas: ${authResponse.data?.empresas.length ?? 0}');
  //   //   print('   Necesita selección: ${authResponse.data?.needsEmpresaSelection}');
  //   // }
    
  //   emit(state.copyWith(response: response, formKey: formKey));
  // }

  Future<void> _onLoginSubmit(LoginSubmit event, Emitter<LoginState> emit) async {
  // Validación al momento del submit
  String? dniError;
  String? passwordError;
  
  if (state.dni.value.isEmpty) {
    dniError = 'DNI requerido';
  } else if (!RegExp(r'^\d{8}$').hasMatch(state.dni.value)) {
    dniError = 'DNI inválido (8 dígitos)';
  }
  
  if (state.password.value.isEmpty) {
    passwordError = 'Contraseña requerida';
  } else if (state.password.value.length < 6) {
    passwordError = 'Mínimo 6 caracteres';
  }
  
  if (dniError != null || passwordError != null) {
    emit(state.copyWith(
      dni: state.dni.copyWith(error: dniError),
      password: state.password.copyWith(error: passwordError),
      formKey: formKey
    ));
    return;
  }
  
  // Continuar con el login si no hay errores...
  emit(state.copyWith(response: Loading(), formKey: formKey));
  final response = await authUseCases.login.run(state.dni.value, state.password.value);
  emit(state.copyWith(response: response, formKey: formKey));
}

  // NUEVO: Limpiar errores
  Future<void> _onClearError(ClearError event, Emitter<LoginState> emit) async {
    // Solo limpiar el error, no tocar el formulario
    emit(state.copyWith(
      response: Initial(),
      formKey: formKey
    ));
  }
}