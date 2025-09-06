import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:syncronize/injection.config.dart';

final locator = GetIt.instance;

// @InjectableInit()
// // ignore: await_only_futures
// Future<void> configureDependencies() async => await locator.init();

// final locator = GetIt.instance;

// Flag para controlar la inicialización
bool _isMinimalInitialized = false;
bool _isFullyInitialized = false;

@InjectableInit()
Future<void> configureDependencies() async {
  if (_isFullyInitialized) return; // Evitar doble inicialización
  
  if (!_isMinimalInitialized) {
    // Si no se hizo inicialización mínima, hacer completa
    await locator.init();
    _isFullyInitialized = true;
  } else {
    // Solo registrar lo que falta (servicios adicionales)
    await _registerAdditionalServices();
    _isFullyInitialized = true;
  }
}

// Inicialización mínima para login
Future<void> configureMinimalDependencies() async {
  if (_isMinimalInitialized || _isFullyInitialized) return;
  
  try {
    // Solo registrar servicios críticos para login
    await locator.init();
    _isMinimalInitialized = true;
  } catch (e) {
    print('Error en inicialización mínima: $e');
    rethrow;
  }
}

// Registrar servicios adicionales (si es necesario)
Future<void> _registerAdditionalServices() async {
  // Aquí puedes registrar servicios específicos que no estaban en la inicial
  // Si todos los servicios ya están en init(), este método puede estar vacío
}

// Reset para testing o reinicialización
void resetDependencies() {
  locator.reset();
  _isMinimalInitialized = false;
  _isFullyInitialized = false;
}