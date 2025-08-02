
import 'package:equatable/equatable.dart';
import 'package:syncronize/src/presentation/utils/bloc_form_item.dart';

abstract class RegisterClienteNewEvent extends Equatable {
  const RegisterClienteNewEvent();
  @override
  List<Object?> get props => [];
}

class RegisterClienteNewInitEvent extends RegisterClienteNewEvent {
  const RegisterClienteNewInitEvent();
}

class DniSearchChanged extends RegisterClienteNewEvent {
  final BlocFormItem dni;
  const DniSearchChanged({required this.dni});
  @override
  List<Object?> get props => [dni];
}

class ConsultarDniPressed extends RegisterClienteNewEvent {
  const ConsultarDniPressed();
}

class EmailChanged extends RegisterClienteNewEvent {
  final BlocFormItem email;
  const EmailChanged({required this.email});
  @override
  List<Object?> get props => [email];
}

class PhoneChanged extends RegisterClienteNewEvent {
  final BlocFormItem phone;
  const PhoneChanged({required this.phone});
  @override
  List<Object?> get props => [phone];
}

class PasswordChanged extends RegisterClienteNewEvent {
  final BlocFormItem password;
  const PasswordChanged({required this.password});
  @override
  List<Object?> get props => [password];
}

class ConfirmPasswordChanged extends RegisterClienteNewEvent {
  final BlocFormItem confirmPassword;
  const ConfirmPasswordChanged({required this.confirmPassword});
  @override
  List<Object?> get props => [confirmPassword];
}

class AcceptTermsChanged extends RegisterClienteNewEvent {
  final bool acceptTerms;
  const AcceptTermsChanged({required this.acceptTerms});
  @override
  List<Object?> get props => [acceptTerms];
}

class RegisterNewSubmitted extends RegisterClienteNewEvent {
  const RegisterNewSubmitted();
}

class FormNewReset extends RegisterClienteNewEvent {
  const FormNewReset();
}