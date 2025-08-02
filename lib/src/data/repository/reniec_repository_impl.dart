
import 'package:syncronize/src/data/datasource/remote/service/reniec_service.dart';
import 'package:syncronize/src/domain/models/sunat_response_new.dart';
import 'package:syncronize/src/domain/repository/reniec_repository.dart';
import 'package:syncronize/src/domain/utils/resource.dart';



class ReniecRepositoryImpl implements ReniecRepository {
  final ReniecService reniecService;
  
  ReniecRepositoryImpl(this.reniecService);

  @override
  Future<Resource<ReniecResponse>> getReniecDni(String numberDni) {
    return reniecService.getDniReniec(numberDni);
  }
}