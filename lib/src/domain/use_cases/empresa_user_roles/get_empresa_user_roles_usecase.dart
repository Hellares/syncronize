import 'package:syncronize/src/domain/models/empresa_user_roles_response.dart';
import 'package:syncronize/src/domain/repository/empresa_user_roles_repository.dart';
import 'package:syncronize/src/domain/utils/resource.dart';

class GetEmpresaUserRolesUsecase {
  EmpresaUserRolesRepository repository;
  GetEmpresaUserRolesUsecase(this.repository);

  // Future<Resource<EmpresaUserRolesResponse>> run(String token) => repository.getEmpresaUserRoles(token);
  Future<Resource<EmpresaUserRolesResponse>> run(String token) => repository.getEmpresaUserRoles(token);
}
