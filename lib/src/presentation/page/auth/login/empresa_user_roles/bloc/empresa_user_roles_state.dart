import 'package:equatable/equatable.dart';
import 'package:syncronize/src/domain/models/empresa.dart';
import 'package:syncronize/src/domain/utils/resource.dart';

class EmpresaUserRolesState extends Equatable {
  final Resource? response;
  final List<Empresa> empresas;
  final bool isInitialized;

  const EmpresaUserRolesState({
    this.response,
    this.empresas = const [],
    this.isInitialized = false,
  });
  
  EmpresaUserRolesState copyWith({
    Resource? response,
    List<Empresa>? empresas,
    bool? isInitialized,
  }) {
    return EmpresaUserRolesState(
      response: response ?? this.response,
      empresas: empresas ?? this.empresas,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }

  @override
  List<Object?> get props => [response, empresas, isInitialized];
}