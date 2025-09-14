import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncronize/src/domain/models/empresa_user_roles_response.dart';
import 'package:syncronize/src/domain/use_cases/auth/auth_use_cases.dart';
import 'package:syncronize/src/domain/use_cases/empresa_user_roles/empresa_user_roles_use_cases.dart';
import 'package:syncronize/src/domain/utils/resource.dart';
import 'package:syncronize/src/presentation/page/auth/login/empresa_user_roles/bloc/empresa_user_roles_event.dart';
import 'package:syncronize/src/presentation/page/auth/login/empresa_user_roles/bloc/empresa_user_roles_state.dart';

class EmpresaUserRolesBloc extends Bloc<EmpresaUserRolesEvent, EmpresaUserRolesState> {
  
  AuthUseCases authUseCases;
  EmpresaUserRolesUseCases empresaUserRolesUseCases;

  EmpresaUserRolesBloc(this.authUseCases, this.empresaUserRolesUseCases) : super(const EmpresaUserRolesState()) {
    on<EmpresaUserRolesInitEvent>(_onEmpresaInit);
    on<GetEmpresaUserRoles>(_onGetEmpresaUserRoles);
    on<RefreshEmpresaUserRoles>(_onRefreshEmpresaUserRoles);
    on<RefreshEmpresaUserRolesAuto>(_onRefreshEmpresaUserRolesAuto);
    on<ResetEmpresaUserRolesInitialization>(_onResetInitialization);
    on<AdminLogout>(_onLogout);
  }

  Future<void> _onEmpresaInit(EmpresaUserRolesInitEvent event, Emitter<EmpresaUserRolesState> emit) async {
    // Evitar múltiples inicializaciones
    if (state.isInitialized) {
      return;
    }
    
    // Marcar como inicializado
    emit(state.copyWith(isInitialized: true));
    
    // Obtener token de la sesión guardada
    final authResponse = await authUseCases.getUserSession.run();
    if (authResponse != null && authResponse.data!.token.isNotEmpty) {
      add(GetEmpresaUserRoles(authResponse.data!.token));
    } else {
      emit(state.copyWith(
        response: Error('No hay sesión activa')
      ));
    }
  }


  Future<void> _onGetEmpresaUserRoles(GetEmpresaUserRoles event, Emitter<EmpresaUserRolesState> emit) async {
    emit(state.copyWith(response: Loading()));
    
    final response = await empresaUserRolesUseCases.getEmpresaUserRoles.run(event.token);
    
    if (response is Success<EmpresaUserRolesResponse>) {
      final empresasResponse = response.data;
      emit(state.copyWith(
        response: response,
        empresas: empresasResponse.data,
      ));
    } else {
      emit(state.copyWith(response: response));
    }
  }

  Future<void> _onRefreshEmpresaUserRoles(RefreshEmpresaUserRoles event, Emitter<EmpresaUserRolesState> emit) async {
    emit(state.copyWith(response: Loading()));
    
    final response = await empresaUserRolesUseCases.getEmpresaUserRoles.run(event.token);
    
    if (response is Success<EmpresaUserRolesResponse>) {
      final empresasResponse = response.data;
      emit(state.copyWith(
        response: response,
        empresas: empresasResponse.data,
      ));
    } else {
      emit(state.copyWith(response: response));
    }
  }

  Future<void> _onRefreshEmpresaUserRolesAuto(RefreshEmpresaUserRolesAuto event, Emitter<EmpresaUserRolesState> emit) async {
    // Obtener token de la sesión guardada
    final authResponse = await authUseCases.getUserSession.run();
    if (authResponse != null && authResponse.data!.token.isNotEmpty) {
      // Reutilizar la lógica existente de refresh
      add(RefreshEmpresaUserRoles(token: authResponse.data!.token));
    } else {
      emit(state.copyWith(
        response: Error('No hay sesión activa')
      ));
    }
  }

  Future<void> _onResetInitialization(ResetEmpresaUserRolesInitialization event, Emitter<EmpresaUserRolesState> emit) async {
    emit(state.copyWith(isInitialized: false));
  }

  Future<void> _onLogout(AdminLogout event, Emitter<EmpresaUserRolesState> emit) async {
    try {
      // print('🚪 Iniciando proceso de logout...');
      
      // 1. Mostrar loading
      emit(state.copyWith(response: Loading()));
      
      // 2. Ejecutar logout completo (servidor + local)
      final success = await authUseCases.logout.run();
      
      if (success) {
        // 3. Limpiar estado del BLoC completamente
        emit(state.copyWith(
          response: Initial(),
          empresas: [],
          isInitialized: false,
        ));
        
        // 4. Marcar logout como exitoso para navegación
        emit(state.copyWith(
          response: Success('Sesión cerrada exitosamente'),
          logoutSuccess: true,
        ));
        
        // print('✅ Proceso de logout completado');
        
      } else {
        emit(state.copyWith(
          response: Error('No se pudo cerrar la sesión completamente'),
        ));
      }
      
    } catch (e) {
      // print('❌ Error en proceso de logout: $e');
      
      // Incluso si hay error, intentar limpiar estado local
      emit(state.copyWith(
        response: Error('Error al cerrar sesión: $e'),
        empresas: [],
        isInitialized: false,
      ));
    }
  }

}

