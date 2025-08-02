import 'package:syncronize/src/domain/repository/reniec_repository.dart';

class GetDataDniReniecUseCase {
  final ReniecRepository reniecRepository;
  
  GetDataDniReniecUseCase(this.reniecRepository);

  run(String numberDni) => reniecRepository.getReniecDni(numberDni);
}