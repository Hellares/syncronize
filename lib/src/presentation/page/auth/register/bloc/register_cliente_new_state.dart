// src/presentation/pages/auth/register_new/bloc/register_cliente_new_state.dart

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:syncronize/src/domain/models/user_register_new.dart';
import 'package:syncronize/src/domain/utils/resource.dart';
import 'package:syncronize/src/presentation/utils/bloc_form_item.dart';

class RegisterClienteNewState extends Equatable {
  final BlocFormItem dni;
  final BlocFormItem nombres;
  final BlocFormItem apellidoPaterno;
  final BlocFormItem apellidoMaterno;
  final BlocFormItem departamento;
  final BlocFormItem provincia;
  final BlocFormItem distrito;
  final BlocFormItem direccion;
  final BlocFormItem? email;
  final BlocFormItem? phone;
  final BlocFormItem password;
  final BlocFormItem confirmPassword;
  final bool acceptTerms;
  final bool isConsultingDni;
  final bool isRegistering;
  final GlobalKey<FormState>? formKey;
  final Resource? response;

  const RegisterClienteNewState({
    this.dni = const BlocFormItem(error: 'Ingrese su DNI'),
    this.nombres = const BlocFormItem(error: 'Nombres requeridos'),
    this.apellidoPaterno = const BlocFormItem(error: 'Apellido paterno requerido'),
    this.apellidoMaterno = const BlocFormItem(error: 'Apellido materno requerido'),
    this.departamento = const BlocFormItem(error: 'Departamento requerido'),
    this.provincia = const BlocFormItem(error: 'Provincia requerida'),
    this.distrito = const BlocFormItem(error: 'Distrito requerido'),
    this.direccion = const BlocFormItem(error: 'Dirección requerida'),
    this.email = const BlocFormItem(error: 'Email requerido'),
    this.phone = const BlocFormItem(error: 'Teléfono requerido'),
    this.password = const BlocFormItem(error: 'Contraseña requerida'),
    this.confirmPassword = const BlocFormItem(error: 'Confirme su contraseña'),
    this.acceptTerms = false,
    this.isConsultingDni = false,
    this.isRegistering = false,
    this.formKey,
    this.response,
  });

  UserRegisterNew toUserRegister() => UserRegisterNew(
        dni: dni.value,
        nombres: nombres.value,
        apellidoPaterno: apellidoPaterno.value,
        apellidoMaterno: apellidoMaterno.value,
        departamento: departamento.value,
        provincia: provincia.value,
        distrito: distrito.value,
        direccion: direccion.value,
        email: email?.value,
        phone: phone?.value,
        password: password.value,
      );

  RegisterClienteNewState copyWith({
    BlocFormItem? dni,
    BlocFormItem? nombres,
    BlocFormItem? apellidoPaterno,
    BlocFormItem? apellidoMaterno,
    BlocFormItem? departamento,
    BlocFormItem? provincia,
    BlocFormItem? distrito,
    BlocFormItem? direccion,
    BlocFormItem? email,
    BlocFormItem? phone,
    BlocFormItem? password,
    BlocFormItem? confirmPassword,
    bool? acceptTerms,
    bool? isConsultingDni,
    bool? isRegistering,
    GlobalKey<FormState>? formKey,
    Resource? response,
  }) {
    return RegisterClienteNewState(
      dni: dni ?? this.dni,
      nombres: nombres ?? this.nombres,
      apellidoPaterno: apellidoPaterno ?? this.apellidoPaterno,
      apellidoMaterno: apellidoMaterno ?? this.apellidoMaterno,
      departamento: departamento ?? this.departamento,
      provincia: provincia ?? this.provincia,
      distrito: distrito ?? this.distrito,
      direccion: direccion ?? this.direccion,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      acceptTerms: acceptTerms ?? this.acceptTerms,
      isConsultingDni: isConsultingDni ?? this.isConsultingDni,
      isRegistering: isRegistering ?? this.isRegistering,
      formKey: formKey ?? this.formKey,
      response: response ?? this.response,
    );
  }

  @override
  List<Object?> get props => [
        dni,
        nombres,
        apellidoPaterno,
        apellidoMaterno,
        departamento,
        provincia,
        distrito,
        direccion,
        email,
        phone,
        password,
        confirmPassword,
        acceptTerms,
        isConsultingDni,
        isRegistering,
        formKey,
        response,
      ];
}