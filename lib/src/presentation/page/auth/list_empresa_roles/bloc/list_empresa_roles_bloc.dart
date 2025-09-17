import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncronize/src/domain/models/auth_empresa_response.dart';
import 'package:syncronize/src/domain/use_cases/auth/auth_use_cases.dart';
import 'package:syncronize/src/presentation/page/auth/list_empresa_roles/bloc/list_empresa_roles_event.dart';
import 'package:syncronize/src/presentation/page/auth/list_empresa_roles/bloc/list_empresa_roles_state.dart';

class ListEmpresaRolesBloc extends Bloc<ListEmpresaRolesEvent, ListEmpresaRolesState> {
  AuthUseCases authUseCases;
  ListEmpresaRolesBloc(this.authUseCases) : super(const ListEmpresaRolesState()) {
    on<GetListEmpresaRolesEvent>(_onGetListEmpresaRolesEvent);
  }

  Future<void> _onGetListEmpresaRolesEvent(GetListEmpresaRolesEvent event, Emitter<ListEmpresaRolesState> emit) async {
    AuthEmpresaResponse? authEmpresaResponse = await authUseCases.getUserSession.run();
    emit(state.copyWith(
      empresas: authEmpresaResponse?.data?.empresas
    ));
  }
}