import 'package:equatable/equatable.dart';
import 'package:syncronize/src/domain/models/auth_response.dart';

abstract class EmpresaAuthState extends Equatable {
  const EmpresaAuthState();
  
  @override
  List<Object?> get props => [];
}

class EmpresaAuthInitial extends EmpresaAuthState {
  const EmpresaAuthInitial();
}

class EmpresaAuthLoading extends EmpresaAuthState {
  const EmpresaAuthLoading();
}

class EmpresaAuthSuccess extends EmpresaAuthState {
  final AuthResponse authResponse;
  final String empresaId;
  
  const EmpresaAuthSuccess(this.authResponse, this.empresaId);
  
  @override
  List<Object?> get props => [authResponse, empresaId];
}

class EmpresaAuthError extends EmpresaAuthState {
  final String message;
  
  const EmpresaAuthError(this.message);
  
  @override
  List<Object?> get props => [message];
}

class EmpresaAuthLoggedOut extends EmpresaAuthState {
  const EmpresaAuthLoggedOut();
}