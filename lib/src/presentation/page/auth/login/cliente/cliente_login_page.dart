// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:syncronize/core/widgets/loadings/custom_loading.dart';
// import 'package:syncronize/core/widgets/snack.dart';
// import 'package:syncronize/src/domain/models/auth_empresa_response.dart';
// import 'package:syncronize/src/domain/utils/resource.dart';
// import 'package:syncronize/src/presentation/page/auth/login/cliente/bloc/login_bloc.dart';
// import 'package:syncronize/src/presentation/page/auth/login/cliente/bloc/login_event.dart';
// import 'package:syncronize/src/presentation/page/auth/login/cliente/bloc/login_state.dart';
// import 'package:syncronize/src/presentation/page/auth/login/cliente/cliente_login_content.dart';

// class ClienteLoginPage extends StatefulWidget {
//   const ClienteLoginPage({super.key});

//   @override
//   State<ClienteLoginPage> createState() => _ClienteLoginPageState();
// }

// class _ClienteLoginPageState extends State<ClienteLoginPage> {
//   LoginBloc? _bloc;

//   @override
//   void initState() {
//     super.initState();
//     // Inicializar el BLoC cuando se monta el widget
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _bloc?.add(const InitEvent());
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     _bloc = BlocProvider.of<LoginBloc>(context);

//     return BlocListener<LoginBloc, LoginState>(
//       listener: (context, state) {
//         final responseState = state.response;
//         if (responseState is Error) {
//           SnackBarHelper.showError(context, '${responseState.statusCode ?? ''}: ${responseState.message}'
//           );
//         } else if (responseState is Success) {
//           final authResponse = responseState.data as AuthEmpresaResponse;
//           // _bloc?.add(LoginFormReset());
//           _bloc?.add(LoginSaveUserSession(authResponse: authResponse));
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             if(authResponse.data!.needsEmpresaSelection){
//               // Navigator.pushNamed(context, '/select-empresa', arguments: authResponse);
//               Navigator.pushReplacementNamed(context, 'empresa/user');
//             }
//             else {
//               // Navigator.pushReplacementNamed(context, 'empresa/user');
//             }
//           });
//         }
//       },
//       child: BlocBuilder<LoginBloc, LoginState>(
//         builder: (context, state) {
//           final responseState = state.response;
//           if (responseState is Loading) {
//             return Stack(
//               children: [
//                 ClienteLoginContent(_bloc, state),
//                 CustomLoading.login(),
//               ],
//             );
//           }
//           return ClienteLoginContent(_bloc, state);
//         },
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:syncronize/core/widgets/loadings/custom_loading.dart';
// import 'package:syncronize/core/widgets/snack.dart';
// import 'package:syncronize/src/domain/models/auth_empresa_response.dart';
// import 'package:syncronize/src/domain/utils/resource.dart';
// import 'package:syncronize/src/presentation/page/auth/login/cliente/bloc/login_bloc.dart';
// import 'package:syncronize/src/presentation/page/auth/login/cliente/bloc/login_event.dart';
// import 'package:syncronize/src/presentation/page/auth/login/cliente/bloc/login_state.dart';
// import 'package:syncronize/src/presentation/page/auth/login/cliente/cliente_login_content.dart';

// class ClienteLoginPage extends StatefulWidget {
//   const ClienteLoginPage({super.key});

//   @override
//   State<ClienteLoginPage> createState() => _ClienteLoginPageState();
// }

// class _ClienteLoginPageState extends State<ClienteLoginPage> {
//   LoginBloc? _bloc;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _bloc?.add(const InitEvent());
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     _bloc = BlocProvider.of<LoginBloc>(context);

//     return BlocListener<LoginBloc, LoginState>(
//       listener: (context, state) {
//         final responseState = state.response;
        
//         if (responseState is Error) {
//           // Manejo mejorado de errores
//           _handleError(context, responseState);
          
//         } else if (responseState is Success) {
//           final authResponse = responseState.data as AuthEmpresaResponse;
//           _bloc?.add(LoginSaveUserSession(authResponse: authResponse));
          
//           // Mostrar mensaje de éxito
//           SnackBarHelper.showSuccess(
//             context, 
//             'Bienvenido ${authResponse.data?.user.nombres ?? ''}'
//           );
          
//           // Navegar según necesidad
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             if (authResponse.data!.needsEmpresaSelection) {
//               Navigator.pushReplacementNamed(
//                 context, 
//                 'empresa/user',
//                 arguments: authResponse
//               );
//             } else {
//               Navigator.pushReplacementNamed(context, 'home');
//             }
//           });
//         }
//       },
//       child: BlocBuilder<LoginBloc, LoginState>(
//         builder: (context, state) {
//           final responseState = state.response;
          
//           if (responseState is Loading) {
//             return Stack(
//               children: [
//                 ClienteLoginContent(_bloc, state),
//                 CustomLoading.login(),
//               ],
//             );
//           }
          
//           return ClienteLoginContent(_bloc, state);
//         },
//       ),
//     );
//   }

//   // Método mejorado para manejar errores
//   void _handleError(BuildContext context, Error error) {
    
//     // Usar los helpers del Error mejorado
//     if (error.isAuthError) {
//       // Error de autenticación - Mostrar diálogo
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           icon: Icon(Icons.lock_outline, color: Colors.red, size: 48),
//           title: Text('Error de autenticación'),
//           content: Text(error.message),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 _bloc?.add(const ClearError());
//                 Future.delayed(Duration(milliseconds: 100), () {
//                   // Si tienes acceso al focus node del DNI, úsalo aquí
//                   // FocusScope.of(context).requestFocus(_dniFocus);
//                 });
//               },
              
//               child: Text('Entendido'),
//             ),
//           ],
//         ),
//       );
      
//     } else if (error.isNetworkError) {
//       // Error de red - Mostrar con opción de reintentar
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           icon: Icon(Icons.wifi_off, color: Colors.orange, size: 48),
//           title: Text('Error de conexión'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(error.message),
//               SizedBox(height: 8),
//               Text(
//                 'Verifica tu conexión a internet e intenta nuevamente',
//                 style: TextStyle(fontSize: 12, color: Colors.grey),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 _bloc?.add(const ClearError());
//               },
//               child: Text('Cancelar'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 _bloc?.add(const LoginSubmit()); // Reintentar
//               },
//               child: Text('Reintentar'),
//             ),
//           ],
//         ),
//       );
      
//     } else if (error.isValidationError) {
//       // Error de validación - SnackBar simple
//       SnackBarHelper.showWarning(context, error.message);
      
//     } else if (error.isServerError) {
//       // Error del servidor
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           icon: Icon(Icons.cloud_off, color: Colors.red, size: 48),
//           title: Text('Error del servidor'),
//           content: Text(
//             'El servicio no está disponible en este momento. '
//             'Por favor, intenta más tarde.'
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 _bloc?.add(const ClearError());
//               },
//               child: Text('Entendido'),
//             ),
//           ],
//         ),
//       );
      
//     } else {
//       // Error genérico - SnackBar
//       SnackBarHelper.showError(
//         context, 
//         error.message.isNotEmpty ? error.message : 'Ha ocurrido un error'
//       );
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncronize/core/widgets/loadings/custom_loading.dart';
import 'package:syncronize/core/widgets/snack.dart';
import 'package:syncronize/src/domain/models/auth_empresa_response.dart';
import 'package:syncronize/src/domain/utils/resource.dart';
import 'package:syncronize/src/presentation/page/auth/login/cliente/bloc/login_bloc.dart';
import 'package:syncronize/src/presentation/page/auth/login/cliente/bloc/login_event.dart';
import 'package:syncronize/src/presentation/page/auth/login/cliente/bloc/login_state.dart';
import 'package:syncronize/src/presentation/page/auth/login/cliente/cliente_login_content.dart';

class ClienteLoginPage extends StatefulWidget {
  const ClienteLoginPage({super.key});

  @override
  State<ClienteLoginPage> createState() => _ClienteLoginPageState();
}

class _ClienteLoginPageState extends State<ClienteLoginPage> {
  LoginBloc? _bloc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bloc?.add(const InitEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    _bloc = BlocProvider.of<LoginBloc>(context);

    return RepaintBoundary(
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          final responseState = state.response;
          
          if (responseState is Error) {
            // Defer error handling para evitar bloquear UI
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _handleError(context, responseState);
            });
            
          } else if (responseState is Success) {
            final authResponse = responseState.data as AuthEmpresaResponse;
            _bloc?.add(LoginSaveUserSession(authResponse: authResponse));
            
            // Defer navegación y mostrar éxito
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _handleSuccess(context, authResponse);
            });
          }
        },
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            final responseState = state.response;
            
            if (responseState is Loading) {
              return Stack(
                children: [
                  ClienteLoginContent(_bloc, state),
                  CustomLoading.login(),
                ],
              );
            }
            
            return ClienteLoginContent(_bloc, state);
          },
        ),
      ),
    );
  }

  // Método optimizado para manejar errores
  void _handleError(BuildContext context, Error error) {
    // Verificar que el widget sigue montado
    if (!mounted) return;
    
    // Limpiar error primero
    _bloc?.add(const ClearError());
    
    if (error.isAuthError) {
      // Error de autenticación - UX optimizada con SnackBar
      SnackBarHelper.showError(
        context, 
        'Credenciales incorrectas. Verifica tu DNI y contraseña.'
      );
      
    } else if (error.isNetworkError) {
      // Error de red con opción de reintentar
      _showNetworkErrorDialog(context);
      
    } else if (error.isValidationError) {
      // Error de validación - SnackBar simple
      SnackBarHelper.showWarning(context, error.message);
      
    } else if (error.isServerError) {
      // Error del servidor
      _showServerErrorDialog(context);
      
    } else {
      // Error genérico
      SnackBarHelper.showError(
        context, 
        error.message.isNotEmpty ? error.message : 'Ha ocurrido un error inesperado'
      );
    }
  }

  // Método para manejar éxito
  void _handleSuccess(BuildContext context, AuthEmpresaResponse authResponse) {
    if (!mounted) return;
    
    // Mostrar mensaje de bienvenida
    final userName = authResponse.data?.user.nombres ?? 'Usuario';
    SnackBarHelper.showSuccess(
      context, 
      'Bienvenido $userName'
    );
    
    // Navegar según necesidad
    if (authResponse.data!.needsEmpresaSelection) {
      Navigator.pushReplacementNamed(
        context, 
        'empresa/user',
        arguments: authResponse
      );
    } else {
      Navigator.pushReplacementNamed(context, 'home');
    }
  }

  // Diálogo para errores de red
  void _showNetworkErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.wifi_off, color: Colors.orange, size: 48),
        title: const Text('Error de conexión'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('No se pudo conectar con el servidor.'),
            SizedBox(height: 8),
            Text(
              'Verifica tu conexión a internet e intenta nuevamente.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Reintentar login con los datos actuales
              Future.delayed(const Duration(milliseconds: 100), () {
                _bloc?.add(const LoginSubmit());
              });
            },
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  // Diálogo para errores del servidor
  void _showServerErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.cloud_off, color: Colors.red, size: 48),
        title: const Text('Servicio no disponible'),
        content: const Text(
          'El servicio no está disponible en este momento. '
          'Por favor, intenta más tarde.'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }
}