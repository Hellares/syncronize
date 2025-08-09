import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncronize/src/domain/models/sunat_response_new.dart';
import 'package:syncronize/src/domain/use_cases/auth/auth_use_cases.dart';
import 'package:syncronize/src/domain/use_cases/reniec/reniec_use_cases.dart';
import 'package:syncronize/src/domain/utils/resource.dart';
import 'package:syncronize/src/presentation/page/auth/register/bloc/register_cliente_new_events.dart';
import 'package:syncronize/src/presentation/page/auth/register/bloc/register_cliente_new_state.dart';
import 'package:syncronize/src/presentation/utils/bloc_form_item.dart';

class RegisterClienteNewBloc extends Bloc<RegisterClienteNewEvent, RegisterClienteNewState> {
  final ReniecUseCases reniecUseCases;
  final AuthUseCases authUseCases;
  final formKey = GlobalKey<FormState>();

  RegisterClienteNewBloc(this.reniecUseCases, this.authUseCases) 
      : super(const RegisterClienteNewState()) {
    on<RegisterClienteNewInitEvent>(_onInitEvent);
    on<DniSearchChanged>(_onDniSearchChanged);
    on<ConsultarDniPressed>(_onConsultarDniPressed);
    on<EmailChanged>(_onEmailChanged);
    on<PhoneChanged>(_onPhoneChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<ConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<AcceptTermsChanged>(_onAcceptTermsChanged);
    on<RegisterNewSubmitted>(_onRegisterSubmitted);
    on<FormNewReset>(_onFormReset);
    on<ClearAllStates>(_onClearAllStates);
  }

  Future<void> _onInitEvent(RegisterClienteNewInitEvent event, Emitter<RegisterClienteNewState> emit) async {
    emit(state.copyWith(formKey: formKey));
  }

  Future<void> _onDniSearchChanged(DniSearchChanged event, Emitter<RegisterClienteNewState> emit) async {
    emit(state.copyWith(
      dni: BlocFormItem(
        value: event.dni.value,
        error: event.dni.value.isNotEmpty && event.dni.value.length == 8 ? null : 'DNI debe tener 8 dígitos',
      ),
      // Limpiar campos si se cambia el DNI
      nombres: const BlocFormItem(value: ''),
      apellidoPaterno: const BlocFormItem(value: ''),
      apellidoMaterno: const BlocFormItem(value: ''),
      nombreCompleto: const BlocFormItem(value: ''),
      departamento: const BlocFormItem(value: ''),
      provincia: const BlocFormItem(value: ''),
      distrito: const BlocFormItem(value: ''),
      direccion: const BlocFormItem(value: ''),
      // Limpiar el response para eliminar mensajes de error previos
      response: null,
    ));
  }

  Future<void> _onConsultarDniPressed(ConsultarDniPressed event, Emitter<RegisterClienteNewState> emit) async {
    if (state.dni.value.length != 8) {
      emit(state.copyWith(
        dni: state.dni.copyWith(error: 'DNI debe tener 8 dígitos'),
        response: Error('DNI debe tener 8 dígitos'),
      ));
      return;
    }

    emit(state.copyWith(
      isConsultingDni: true,
      response: Loading(),
    ));

    try {
      final result = await reniecUseCases.getDataDniReniec.run(state.dni.value);
      
      if (result is Success<ReniecResponse>) {
        final data = result.data.data;
        emit(state.copyWith(
          nombres: BlocFormItem(value: data.nombres),
          apellidoPaterno: BlocFormItem(value: data.apellidoPaterno),
          apellidoMaterno: BlocFormItem(value: data.apellidoMaterno),
          nombreCompleto: BlocFormItem(value: data.nombreCompleto),
          departamento: BlocFormItem(value: data.departamento),
          provincia: BlocFormItem(value: data.provincia),
          distrito: BlocFormItem(value: data.distrito),
          direccion: BlocFormItem(value: data.direccion),
          isConsultingDni: false,
          response: result,
        ));
      } else if (result is Error) {
        emit(state.copyWith(
          isConsultingDni: false,
          response: result,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isConsultingDni: false,
        response: Error('Error al consultar DNI: $e'),
      ));
    }
  }

  Future<void> _onEmailChanged(EmailChanged event, Emitter<RegisterClienteNewState> emit) async {
    emit(state.copyWith(
      email: BlocFormItem(
        value: event.email.value,
        error: _validateEmail(event.email.value),
      ),
    ));
  }

  Future<void> _onPhoneChanged(PhoneChanged event, Emitter<RegisterClienteNewState> emit) async {
    emit(state.copyWith(
      phone: BlocFormItem(
        value: event.phone.value,
        error: event.phone.value.isNotEmpty ? null : 'Teléfono requerido',
      ),
    ));
  }

  Future<void> _onPasswordChanged(PasswordChanged event, Emitter<RegisterClienteNewState> emit) async {
    emit(state.copyWith(
      password: BlocFormItem(
        value: event.password.value,
        error: _validatePassword(event.password.value),
      ),
    ));
  }

  Future<void> _onConfirmPasswordChanged(ConfirmPasswordChanged event, Emitter<RegisterClienteNewState> emit) async {
    emit(state.copyWith(
      confirmPassword: BlocFormItem(
        value: event.confirmPassword.value,
        error: event.confirmPassword.value == state.password.value ? null : 'Las contraseñas no coinciden',
      ),
    ));
  }

  Future<void> _onAcceptTermsChanged(AcceptTermsChanged event, Emitter<RegisterClienteNewState> emit) async {
    emit(state.copyWith(acceptTerms: event.acceptTerms));
  }

  Future<void> _onRegisterSubmitted(RegisterNewSubmitted event, Emitter<RegisterClienteNewState> emit) async {
    if (!state.acceptTerms) {
      emit(state.copyWith(response: Error('Debe aceptar los términos y condiciones')));
      return;
    }

    // Validar que todos los campos estén completos
    if (state.dni.value.isEmpty || 
        state.nombres.value.isEmpty || 
        state.apellidoPaterno.value.isEmpty ||
        state.apellidoMaterno.value.isEmpty ||
        state.email?.value.isEmpty == true ||
        state.phone?.value.isEmpty == true ||
        state.password.value.isEmpty) {
      emit(state.copyWith(response: Error('Todos los campos son obligatorios')));
      return;
    }

    emit(state.copyWith(
      isRegistering: true,
      response: Loading(),
    ));

    try {
      // // Debug: Imprimir valores del estado antes del registro
      final userToRegister = state.toUserRegister();
      // print('=== DEBUG REGISTRO ===');
      // print('DNI: ${userToRegister.dni}');
      // print('Nombres: ${userToRegister.nombres}');
      // print('Apellido Paterno: ${userToRegister.apellidoPaterno}');
      // print('Apellido Materno: ${userToRegister.apellidoMaterno}');
      // print('Nombre Completo: ${userToRegister.nombreCompleto}');
      // print('Departamento: ${userToRegister.departamento}');
      // print('Provincia: ${userToRegister.provincia}');
      // print('Distrito: ${userToRegister.distrito}');
      // print('Dirección: ${userToRegister.direccion}');
      // print('Email: ${userToRegister.email}');
      // print('Phone: ${userToRegister.phone}');
      // print('Password: ${userToRegister.password}');
      // print('=====================');
      
      final result = await authUseCases.register.run(userToRegister);
      
      if (result is Success) {
        emit(state.copyWith(
          isRegistering: false,
          response: result,
        ));
      } else if (result is Error) {
        emit(state.copyWith(
          isRegistering: false,
          response: result,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isRegistering: false,
        response: Error('Error al registrar usuario: $e'),
      ));
    }
  }

  Future<void> _onFormReset(FormNewReset event, Emitter<RegisterClienteNewState> emit) async {
    formKey.currentState?.reset();
    emit(const RegisterClienteNewState());
    emit(state.copyWith(formKey: formKey));
  }

  String? _validateEmail(String email) {
    if (email.isEmpty) return 'Email requerido';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      return 'Email inválido';
    }
    return null;
  }

  String? _validatePassword(String password) {
    if (password.isEmpty) return 'Contraseña requerida';
    if (password.length < 8) return 'Mínimo 8 caracteres';
    return null;
  }

  Future<void> _onClearAllStates(ClearAllStates event, Emitter<RegisterClienteNewState> emit) async {
    emit(const RegisterClienteNewState());
  }
}