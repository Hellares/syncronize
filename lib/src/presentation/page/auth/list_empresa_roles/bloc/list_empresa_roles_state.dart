import 'package:equatable/equatable.dart';
import 'package:syncronize/src/domain/models/auth_empresa_response.dart';

class ListEmpresaRolesState  extends Equatable{

  final List<Empresa?>? empresas;

  const ListEmpresaRolesState({
    this.empresas
  });

  ListEmpresaRolesState copyWith({
    List<Empresa?>? empresas,
  }) {
    return ListEmpresaRolesState(
      empresas: empresas,
    );
  }
  
  @override
  List<Object?> get props => [empresas];
}