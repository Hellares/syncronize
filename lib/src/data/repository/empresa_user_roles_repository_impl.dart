import 'package:syncronize/src/data/datasource/remote/service/empresa_user_roles_service.dart';
import 'package:syncronize/src/domain/models/empresa_user_roles_response.dart';
import 'package:syncronize/src/domain/repository/empresa_user_roles_repository.dart';
import 'package:syncronize/src/domain/utils/resource.dart';

class EmpresaUserRolesRepositoryImpl implements EmpresaUserRolesRepository{

  EmpresaUserRolesService empresaUserRolesService;
  EmpresaUserRolesRepositoryImpl(this.empresaUserRolesService);

  @override
  Future<Resource<EmpresaUserRolesResponse>> getEmpresaUserRoles(String token) {
    return empresaUserRolesService.getUserEmpresasRoles(token);
  }

}