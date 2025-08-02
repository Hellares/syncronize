

import 'package:syncronize/src/domain/models/sunat_response_new.dart';
import 'package:syncronize/src/domain/utils/resource.dart';

abstract class ReniecRepository {
  Future<Resource<ReniecResponse>> getReniecDni(String numberDni);
}