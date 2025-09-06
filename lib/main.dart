// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:syncronize/bloc_provider.dart';
// import 'package:syncronize/core/network/dio_client.dart';
// import 'package:syncronize/core/theme/app_theme.dart';
// import 'package:syncronize/injection.dart';
// import 'package:syncronize/src/presentation/page/auth/login/empresa_user_roles/empresa_user_page.dart';
// import 'package:syncronize/src/presentation/page/auth/login/main_login_page.dart';
// import 'package:syncronize/src/presentation/page/auth/register/register_cliente_new_page.dart';


// void main() async {
//   DioClient.instance;
//   WidgetsFlutterBinding.ensureInitialized();
//   await configureDependencies();

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: blocProviders,
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'Syncronize',
//         theme: AppTheme.lightTheme,
//         initialRoute: 'login',
//         routes: {
//           'login': (context) => const MainLoginPage(),
//           // 'registerCliente': (context) => const RegisterClientePage(),
//           'register/new': (BuildContext context) => const RegisterClienteNewPage(),
//           'empresa/user': (BuildContext context) => const EmpresaUserPage(),
//         },
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncronize/bloc_provider.dart';
import 'package:syncronize/core/network/dio_client.dart';
import 'package:syncronize/core/theme/app_theme.dart';
import 'package:syncronize/injection.dart';
import 'package:syncronize/src/presentation/page/auth/login/empresa_user_roles/empresa_user_page.dart';
import 'package:syncronize/src/presentation/page/auth/login/main_login_page.dart';
import 'package:syncronize/src/presentation/page/auth/register/register_cliente_new_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Pre-calentar GetIt sin bloquear
  scheduleMicrotask(() => DioClient.instance);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Syncronize',
      theme: AppTheme.lightTheme,
      home: const UltraFastInitializer(),
      // Las rutas ahora están disponibles pero no se usan directamente
      // porque necesitamos inicializar los BLoCs primero
      routes: {
        'login': (context) => const MainLoginPage(),
        'register/new': (context) => const RegisterClienteNewPage(),
        'empresa/user': (context) => const EmpresaUserPage(),
      },
    );
  }
}

class UltraFastInitializer extends StatefulWidget {
  const UltraFastInitializer({super.key});

  @override
  State<UltraFastInitializer> createState() => _UltraFastInitializerState();
}

class _UltraFastInitializerState extends State<UltraFastInitializer> {
  @override
  void initState() {
    super.initState();
    _ultraFastInit();
  }

  Future<void> _ultraFastInit() async {
    // Solo 2 frames de espera para mostrar algo al usuario
    await Future.delayed(const Duration(milliseconds: 32));
    
    try {
      // Inicialización en microtasks para no bloquear
      await for (final _ in Stream.periodic(const Duration(milliseconds: 16)).take(1)) {
        await configureDependencies();
      }
      
      if (mounted) {
        // Reemplazar toda la app con la versión que incluye BLoCs
        Navigator.of(context).pushAndRemoveUntil(
          PageRouteBuilder(
            pageBuilder: (_, _, _) => const AppWithBlocs(),
            transitionDuration: const Duration(milliseconds: 150),
            transitionsBuilder: (_, animation, _, child) {
              return FadeTransition(
                opacity: Tween(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeOut)
                ),
                child: child,
              );
            },
          ),
          (route) => false,
        );
      }
    } catch (e) {
      // Error handling mínimo
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => ErrorWidget(e)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}

// Nueva clase que envuelve toda la app con BLoCs
class AppWithBlocs extends StatelessWidget {
  const AppWithBlocs({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: blocProviders, // Todos los BLoCs disponibles aquí
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Syncronize',
        theme: AppTheme.lightTheme,
        home: const MainLoginPage(), // Ir directamente al login
        routes: {
          'login': (context) => const MainLoginPage(),
          'register/new': (context) => const RegisterClienteNewPage(),
          'empresa/user': (context) => const EmpresaUserPage(), // Ahora tiene acceso a todos los BLoCs
        },
      ),
    );
  }
}