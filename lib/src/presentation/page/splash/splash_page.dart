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
  
  String _statusText = 'Inicializando...';

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

  void _updateStatus(String status) {
    if (mounted) {
      setState(() {
        _statusText = status;
      });
    }
  }

  Future<void> _initializeApp() async {
    Stopwatch? totalStopwatch;
    if (kDebugMode) {
      totalStopwatch = Stopwatch()..start();
      print('🚀 Iniciando configuración de la aplicación...');
    }
    
    try {
      // 1. Configurar dependencias en background
      _updateStatus('Configurando dependencias...');
      
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
      
      // 2. Inicializar servicios básicos en paralelo
      _updateStatus('Inicializando servicios...');
      
      await Future.wait([
        _initializeDio(),
        _initializeStorage(),
      ]);
      
      // 3. Tiempo mínimo para UX (solo en debug)
      final minSplashTime = kDebugMode ? 1500 : 800; // Reducido
      final elapsed = totalStopwatch?.elapsedMilliseconds ?? 0;
      final remainingTime = minSplashTime - elapsed;
      
      if (remainingTime > 0) {
        _updateStatus('Preparando interfaz...');
        if (kDebugMode) print('⏳ Esperando ${remainingTime}ms para completar splash...');
        await Future.delayed(Duration(milliseconds: remainingTime));
      }
      
      // 4. Verificar sesión activa
      _updateStatus('Verificando sesión...');
      
      Stopwatch? sessionStopwatch;
      if (kDebugMode) {
        sessionStopwatch = Stopwatch()..start();
        print('🔍 Verificando sesión de usuario...');
      }
      
      final secureStorage = SecureStorage();
      final userData = await secureStorage.read('user');
      
      if (kDebugMode) {
        sessionStopwatch?.stop();
        print('✅ Sesión verificada en ${sessionStopwatch?.elapsedMilliseconds}ms');
        totalStopwatch?.stop();
        print('🎯 Inicialización total completada en ${totalStopwatch?.elapsedMilliseconds}ms');
      }
      
      if (!mounted) return;
      
      // 5. Navegar según estado de sesión
      _updateStatus('Cargando...');
      
      await Future.delayed(const Duration(milliseconds: 200)); // Breve delay para UX
      
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

  // ✅ OPTIMIZACIÓN: Inicializar Dio sin bloquear
  Future<void> _initializeDio() async {
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
  }

  // ✅ OPTIMIZACIÓN FINAL: Storage initialization no bloquea UX
  Future<void> _initializeStorage() async {
    Stopwatch? prefsStopwatch;
    if (kDebugMode) {
      prefsStopwatch = Stopwatch()..start();
      print('💾 Verificando almacenamiento local...');
    }
    
    try {
      final secureStorage = SecureStorage();
      
      // ✅ TIMEOUT para evitar que storage lento bloquee indefinidamente
      await Future.any([
        secureStorage.warmUpCache(),
        Future.delayed(const Duration(seconds: 2)), // Max 2s para warmup
      ]);
      
      if (kDebugMode) {
        prefsStopwatch?.stop();
        print('✅ Almacenamiento verificado en ${prefsStopwatch?.elapsedMilliseconds}ms');
      }
    } catch (e) {
      if (kDebugMode) {
        prefsStopwatch?.stop();
        print('⚠️ Storage warmup timeout/error (${prefsStopwatch?.elapsedMilliseconds}ms): $e');
      }
      // Continuar sin cache - no es crítico para funcionamiento
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
                      
                      // Texto de carga DINÁMICO
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Text(
                          _statusText,
                          key: ValueKey(_statusText),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
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