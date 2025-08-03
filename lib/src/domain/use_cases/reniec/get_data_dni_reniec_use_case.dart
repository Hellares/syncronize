import 'package:syncronize/src/domain/models/sunat_response_new.dart';
import 'package:syncronize/src/domain/repository/reniec_repository.dart';
import 'package:syncronize/src/domain/utils/resource.dart';

class GetDataDniReniecUseCase {
  final ReniecRepository reniecRepository;
  
  GetDataDniReniecUseCase(this.reniecRepository);

  // run(String numberDni) => reniecRepository.getReniecDni(numberDni);
  //o
  Future<Resource<ReniecResponse>> run(String numberDni) => reniecRepository.getReniecDni(numberDni);
}