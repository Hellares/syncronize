// import 'package:equatable/equatable.dart';

// abstract class EmpresaUserRolesEvent extends Equatable {
//   const EmpresaUserRolesEvent();

//   @override
//   List<Object> get props => [];
// }

// class EmpresaUserRolesInitEvent extends EmpresaUserRolesEvent {
//   const EmpresaUserRolesInitEvent();
// }

// class GetEmpresaUserRoles extends EmpresaUserRolesEvent {
//   final String token;
//   const GetEmpresaUserRoles(this.token);

//   @override
//   List<Object> get props => [token];
// }

// class RefreshEmpresaUserRoles extends EmpresaUserRolesEvent {
//   final String token;
//   const RefreshEmpresaUserRoles({required this.token});

//   @override
//   List<Object> get props => [token];
// }

// // Nuevo evento para refresh sin token (maneja internamente)
// class RefreshEmpresaUserRolesAuto extends EmpresaUserRolesEvent {
//   const RefreshEmpresaUserRolesAuto();
// }

// class ResetEmpresaUserRolesInitialization extends EmpresaUserRolesEvent {
//   const ResetEmpresaUserRolesInitialization();
// }

// class AdminLogout extends EmpresaUserRolesEvent{
//   const AdminLogout();
// }