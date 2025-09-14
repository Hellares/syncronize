import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:syncronize/injection.config.dart';

final locator = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  if (kDebugMode){
    print('📦 Iniciando configuración de GetIt...');
  }  
  await locator.init();
  if (kDebugMode){
    print('✅ GetIt configurado exitosamente');
  } 
}