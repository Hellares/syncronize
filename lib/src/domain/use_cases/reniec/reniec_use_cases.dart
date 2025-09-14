import 'package:syncronize/src/domain/repository/reniec_repository.dart';
import 'package:syncronize/src/domain/use_cases/reniec/get_data_dni_reniec_use_case.dart';

class ReniecUseCases {
  final GetDataDniReniecUseCase getDataDniReniec;
  
  ReniecUseCases(ReniecRepository reniecRepository, {
    required this.getDataDniReniec,
  });
}