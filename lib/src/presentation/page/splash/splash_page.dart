// lib/src/presentation/page/splash/splash_page.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncronize/injection.dart';
import 'package:syncronize/src/data/api/dio_config.dart';
import 'package:syncronize/src/data/datasource/local/secure_storage.dart';
import 'package:syncronize/src/domain/models/auth_empresa_response.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> 
    with SingleTickerProviderStateMixin {
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _animationController.forward();
  }

  Future<void> _initializeApp() async {
    Stopwatch? totalStopwatch;
    if (kDebugMode) {
      totalStopwatch = Stopwatch()..start();
      print('🚀 Iniciando configuración de la aplicación...');
    }
    
    try {
      // 1. Configurar dependencias
      Stopwatch? dependenciesStopwatch;
      if (kDebugMode) {
        dependenciesStopwatch = Stopwatch()..start();
        print('⚙️ Configurando dependencias...');
      }
      
      await configureDependencies();
      
      if (kDebugMode) {
        dependenciesStopwatch?.stop();
        print('✅ Dependencias configuradas en ${dependenciesStopwatch?.elapsedMilliseconds}ms');
      }
      
      // 2. Inicializar Dio
      Stopwatch? dioStopwatch;
      if (kDebugMode) {
        dioStopwatch = Stopwatch()..start();
        print('🌐 Inicializando cliente HTTP...');
      }
      
      DioConfig.instance; // Esto inicializa Dio
      
      if (kDebugMode) {
        dioStopwatch?.stop();
        print('✅ Dio inicializado en ${dioStopwatch?.elapsedMilliseconds}ms');
      }
      
      // 3. Pre-cargar SharedPreferences
      Stopwatch? prefsStopwatch;
      if (kDebugMode) {
        prefsStopwatch = Stopwatch()..start();
        print('💾 Verificando almacenamiento local...');
      }
      
      final secureStorage = SecureStorage();
      await secureStorage.read('user'); // Pre-carga las preferencias
      
      if (kDebugMode) {
        prefsStopwatch?.stop();
        print('✅ Almacenamiento verificado en ${prefsStopwatch?.elapsedMilliseconds}ms');
      }
      
      // 4. Esperar mínimo para mostrar splash completo (solo en debug)
      final minSplashTime = kDebugMode ? 2000 : 1000; // 1s en producción, 2s en debug
      final elapsed = totalStopwatch?.elapsedMilliseconds ?? 0;
      final remainingTime = minSplashTime - elapsed;
      
      if (remainingTime > 0) {
        if (kDebugMode) print('⏳ Esperando ${remainingTime}ms para completar splash...');
        await Future.delayed(Duration(milliseconds: remainingTime));
      }
      
      // 5. Verificar sesión activa
      Stopwatch? sessionStopwatch;
      if (kDebugMode) {
        sessionStopwatch = Stopwatch()..start();
        print('🔍 Verificando sesión de usuario...');
      }
      
      final userData = await secureStorage.read('user');
      
      if (kDebugMode) {
        sessionStopwatch?.stop();
        print('✅ Sesión verificada en ${sessionStopwatch?.elapsedMilliseconds}ms');
        totalStopwatch?.stop();
        print('🎯 Inicialización total completada en ${totalStopwatch?.elapsedMilliseconds}ms');
      }
      
      if (!mounted) return;
      
      // 6. Navegar según estado de sesión
      if (userData != null) {
        try {
          final authResponse = AuthEmpresaResponse.fromJson(userData);
          
          if (kDebugMode) {
            print('✅ Sesión activa encontrada para: ${authResponse.data?.user.nombres}');
          }
          
          // Verificar si necesita seleccionar empresa
          if (authResponse.data!.needsEmpresaSelection) {
            _navigateToEmpresaSelection(authResponse);
          } else {
            _navigateToHome();
          }
        } catch (e) {
          if (kDebugMode) print('❌ Error parseando datos de sesión: $e');
          _navigateToLogin();
        }
      } else {
        if (kDebugMode) print('ℹ️ No hay sesión activa, redirigiendo a login');
        _navigateToLogin();
      }
      
    } catch (e) {
      if (kDebugMode) {
        totalStopwatch?.stop();
        print('💥 Error durante inicialización en ${totalStopwatch?.elapsedMilliseconds}ms: $e');
      }
      _showErrorAndRetry(e.toString());
    }
  }

  void _navigateToLogin() {
    if (mounted) {
      Navigator.pushReplacementNamed(context, 'login');
    }
  }

  void _navigateToHome() {
    if (mounted) {
      Navigator.pushReplacementNamed(context, 'home');
    }
  }

  void _navigateToEmpresaSelection(AuthEmpresaResponse authResponse) {
    if (mounted) {
      Navigator.pushReplacementNamed(
        context, 
        'empresa/user',
        arguments: authResponse,
      );
    }
  }

  void _showErrorAndRetry(String error) {
    if (!mounted) return;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Error de inicialización'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('Ocurrió un error al inicializar la aplicación:\n\n$error'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _initializeApp(); // Reintentar
            },
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E3A8A), // Azul profesional
      body: RepaintBoundary( // Optimización de repintado
        child: Center(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo de la aplicación
                      RepaintBoundary( // Evitar repintado innecesario
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.sync,
                            size: 60,
                            color: Color(0xFF1E3A8A),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Nombre de la aplicación
                      const Text(
                        'Syncronize',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Subtítulo
                      Text(
                        'Sistema de Gestión',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withValues(alpha: 0.8),
                          letterSpacing: 1,
                        ),
                      ),
                      
                      const SizedBox(height: 48),
                      
                      // Indicador de carga optimizado
                      RepaintBoundary(
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white.withValues(alpha: 0.8),
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Texto de carga
                      Text(
                        'Inicializando...',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}