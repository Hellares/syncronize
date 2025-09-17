import 'package:equatable/equatable.dart';

abstract class ListEmpresaRolesEvent extends Equatable{
  const ListEmpresaRolesEvent();
  @override
  List<Object?> get props => [];
}

class GetListEmpresaRolesEvent extends ListEmpresaRolesEvent {
  const GetListEmpresaRolesEvent();
}