import 'package:syncronize/src/domain/models/empresa_user_roles_response.dart';
import 'package:syncronize/src/domain/utils/resource.dart';

abstract class EmpresaUserRolesRepository {
  Future<Resource<EmpresaUserRolesResponse>> getEmpresaUserRoles(String token);
}