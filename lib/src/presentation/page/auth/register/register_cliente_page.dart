// import 'package:flutter/material.dart';
// import 'package:syncronize/core/fonts/app_fonts.dart';
// import 'package:syncronize/core/theme/app_colors.dart';
// import 'package:syncronize/core/widgets/appbar/custom_appbar.dart';
// import 'package:syncronize/core/widgets/custom_date_textfiels_container/custom_textfield.dart';
// import 'package:syncronize/core/widgets/cutom_button/custom_button.dart';
// import 'package:syncronize/core/widgets/divider_line.dart';
// import 'package:syncronize/core/widgets/rive_background.dart';

// class RegisterClientePage extends StatefulWidget {
//   const RegisterClientePage({super.key});

//   @override
//   State<RegisterClientePage> createState() => _RegisterClientePageState();
// }

// class _RegisterClientePageState extends State<RegisterClientePage> {
//   final _formKey = GlobalKey<FormState>();

//   // Controladores para todos los campos
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//   final _firstNameController = TextEditingController();
//   final _lastNameController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _dniController = TextEditingController();

//   bool _acceptTerms = false;
//   bool _isLoading = false;

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     _firstNameController.dispose();
//     _lastNameController.dispose();
//     _phoneController.dispose();
//     _dniController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(
//         title: 'Crear Cuenta',
//         centerTitle: false,
//         titleStyle: TextStyle(
//           fontFamily: AppFont.pirulentBold.fontFamily,
//           fontSize: 10,
//           color: AppColors.blue2,
//         ),
//       ),
//       body: RiveBackground(
//         blurX: 3,
//         blurY: 3,
//         child: SafeArea(
//           child: Form(
//             key: _formKey,
//             child: SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 20.0,
//                   vertical: 10.0,
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     // const SizedBox(height: 20),

//                     // Logo y título
//                     Column(
//                       children: [
//                         const SizedBox(height: 8),
//                         Text(
//                           'Completa tus datos para registrarte',
//                           style: AppFont.orbitronMedium.style(
//                             color: AppColors.blue2,
//                           ),
//                         ),
//                       ],
//                     ),

//                     const SizedBox(height: 15),

//                     // Campos del formulario
//                     Column(
//                       children: [
//                         // DNI
//                         Row(
                          
//                           children: [
//                             Expanded(
//                               flex: 1,
//                               child: CustomTextField(
//                                 label: 'DNI',
//                                 hintText: 'Digite su de DNI',
//                                 controller: _dniController,
//                                 borderColor: AppColors.blue,
//                                 fieldType: FieldType.dni,
//                                 validator: (value) {
//                                   if (value?.isEmpty ?? true) {
//                                     return 'El DNI es requerido';
//                                   }
//                                   if (value!.length != 8) {
//                                     return 'El DNI debe tener 8 dígitos';
//                                   }
//                                   return null;
//                                 },
//                               ),
//                             ),
//                             const SizedBox(width: 15),

//                             CustomButton(
//                               backgroundColor: AppColors.blue,
//                               borderColor: AppColors.blue,
//                               textColor: AppColors.white,
//                               enableShadows: false,
//                               text: 'Consultar DNI',
                              
//                             )
//                             // const Expanded(
//                             //   // flex: 1,
//                             //   child: SizedBox(),
//                             // ),
//                           ],
//                         ),
//                         const SizedBox(height: 20),
//                         // Apellido
//                         Row(
//                           children: [
//                             Expanded(
//                               child: CustomTextField(
//                                 label: 'Apellido Paterno',
//                                 enabled: false,
//                                 controller: _lastNameController,
//                                 borderColor: AppColors.blue,
//                                 prefixIcon: Icon(
//                                   Icons.person_outline,
//                                   color: AppColors.blue,
//                                 ),
//                                 validator: (value) {
//                                   if (value?.isEmpty ?? true) {
//                                     return 'El apellido es requerido';
//                                   }
//                                   return null;
//                                 },
//                               ),
//                             ),
//                             const SizedBox(width: 14),
//                             Expanded(
//                               child: CustomTextField(
//                                 label: 'Apellido Materno',
//                                 enabled: false,
//                                 controller: _lastNameController,
//                                 borderColor: AppColors.blue,
//                                 prefixIcon: Icon(
//                                   Icons.person_outline,
//                                   color: AppColors.blue,
//                                 ),
//                                 validator: (value) {
//                                   if (value?.isEmpty ?? true) {
//                                     return 'El apellido es requerido';
//                                   }
//                                   return null;
//                                 },
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 16),

//                         CustomTextField(
//                           label: 'Nombres',
//                           enabled: false,
//                           controller: _firstNameController,
//                           borderColor: AppColors.blue,
//                           prefixIcon: Icon(
//                             Icons.person_outline,
//                             color: AppColors.blue,
//                           ),
//                           validator: (value) {
//                             if (value?.isEmpty ?? true) {
//                               return 'El nombre es requerido';
//                             }
//                             return null;
//                           },
//                         ),

//                         const SizedBox(height: 16),

//                         CustomTextField(
//                           label: 'Departamento',
//                           enabled: false,
//                           controller: _firstNameController,
//                           borderColor: AppColors.blue,
//                           prefixIcon: Icon(
//                             Icons.location_on_outlined,
//                             color: AppColors.blue,
//                           ),
//                           validator: (value) {
//                             if (value?.isEmpty ?? true) {
//                               return 'El nombre es requerido';
//                             }
//                             return null;
//                           },
//                         ),

//                         const SizedBox(height: 16),

//                         Row(
//                           children: [
//                             Expanded(
//                               child: CustomTextField(
//                                 label: 'Provincia',
//                                 enabled: false,
//                                 controller: _lastNameController,
//                                 borderColor: AppColors.blue,
//                                 prefixIcon: Icon(
//                                   Icons.location_on_outlined,
//                                   color: AppColors.blue,
//                                 ),
//                                 validator: (value) {
//                                   if (value?.isEmpty ?? true) {
//                                     return 'El apellido es requerido';
//                                   }
//                                   return null;
//                                 },
//                               ),
//                             ),
//                             const SizedBox(width: 14),
//                             Expanded(
//                               child: CustomTextField(
//                                 label: 'Distrito',
//                                 enabled: false,
//                                 controller: _lastNameController,
//                                 borderColor: AppColors.blue,
//                                 prefixIcon: Icon(
//                                   Icons.location_on_outlined,
//                                   color: AppColors.blue,
//                                 ),
//                                 validator: (value) {
//                                   if (value?.isEmpty ?? true) {
//                                     return 'El apellido es requerido';
//                                   }
//                                   return null;
//                                 },
//                               ),
//                             ),
//                           ],
//                         ),

//                         const SizedBox(height: 16),

//                         CustomTextField(
//                           label: 'Dirección',
//                           enabled: false,
//                           controller: _firstNameController,
//                           borderColor: AppColors.blue,
//                           prefixIcon: Icon(
//                             Icons.location_on_outlined,
//                             color: AppColors.blue,
//                           ),
//                           validator: (value) {
//                             if (value?.isEmpty ?? true) {
//                               return 'El nombre es requerido';
//                             }
//                             return null;
//                           },
//                         ),

//                         const SizedBox(height: 16),

//                         // Email
//                         CustomTextField(
//                           label: 'Email',
//                           hintText: 'example@gmail.com',
//                           controller: _emailController,
//                           borderColor: AppColors.blue,
//                           prefixIcon: Icon(
//                             Icons.email_outlined,
//                             color: AppColors.blue,
//                           ),
//                           validator: (value) {
//                             if (value?.isEmpty ?? true) {
//                               return 'El email es requerido';
//                             }
//                             if (!RegExp(
//                               r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
//                             ).hasMatch(value!)) {
//                               return 'Ingresa un email válido';
//                             }
//                             return null;
//                           },
//                         ),

//                         const SizedBox(height: 16),

//                         CustomTextFieldHelpers.phone(
//                           label: 'Teléfono',
//                           controller: _phoneController,
//                           borderColor: AppColors.blue,
//                         ),

//                         const SizedBox(height: 16),

//                         // Contraseña
//                         CustomTextField(
//                           label: 'Contraseña',
//                           hintText: 'Mínimo 8 caracteres',
//                           controller: _passwordController,
//                           borderColor: AppColors.blue,
//                           prefixIcon: Icon(
//                             Icons.lock_outlined,
//                             color: AppColors.blue,
//                           ),
//                           obscureText: true,
//                           validator: (value) {
//                             if (value?.isEmpty ?? true) {
//                               return 'La contraseña es requerida';
//                             }
//                             if (value!.length < 8) {
//                               return 'La contraseña debe tener al menos 8 caracteres';
//                             }
//                             return null;
//                           },
//                         ),

//                         const SizedBox(height: 16),

//                         // Confirmar contraseña
//                         CustomTextField(
//                           label: 'Confirmar Contraseña',
//                           hintText: 'Repite tu contraseña',
//                           controller: _confirmPasswordController,
//                           borderColor: AppColors.blue,
//                           prefixIcon: Icon(
//                             Icons.lock_outlined,
//                             color: AppColors.blue,
//                           ),
//                           obscureText: true,
//                           validator: (value) {
//                             if (value?.isEmpty ?? true) {
//                               return 'Confirma tu contraseña';
//                             }
//                             if (value != _passwordController.text) {
//                               return 'Las contraseñas no coinciden';
//                             }
//                             return null;
//                           },
//                         ),

//                         const SizedBox(height: 24),

//                         // Checkbox términos y condiciones
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Checkbox(
//                               value: _acceptTerms,
//                               onChanged: (value) {
//                                 setState(() {
//                                   _acceptTerms = value ?? false;
//                                 });
//                               },
//                               activeColor: AppColors.blue,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(4),
//                               ),
//                             ),
//                             Expanded(
//                               child: GestureDetector(
//                                 onTap: () {
//                                   setState(() {
//                                     _acceptTerms = !_acceptTerms;
//                                   });
//                                 },
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(top: 18),
//                                   child: RichText(
//                                     text: TextSpan(
//                                       style: TextStyle(
//                                         fontSize: 10,
//                                         color: AppColors.blueGrey,
//                                       ),
//                                       children: [
//                                         const TextSpan(text: 'Acepto los '),
//                                         TextSpan(
//                                           text: 'Términos y Condiciones',
//                                           style: TextStyle(
//                                             color: AppColors.blue,
//                                             fontWeight: FontWeight.w600,
//                                             decoration:
//                                                 TextDecoration.underline,
//                                           ),
//                                         ),
//                                         const TextSpan(text: ' y la '),
//                                         TextSpan(
//                                           text: 'Política de Privacidad',
//                                           style: TextStyle(
//                                             color: AppColors.blue,
//                                             fontWeight: FontWeight.w600,
//                                             decoration:
//                                                 TextDecoration.underline,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),

//                         const SizedBox(height: 32),

//                         // Botón registrar
//                         CustomButton(
//                           text: _isLoading ? 'Registrando...' : 'Crear Cuenta',
//                           textStyle: AppFont.airstrikeBold3d.style(
//                             fontSize: 16,
//                           ),
//                           backgroundColor: AppColors.green,
//                           enableShadows: false,
//                           borderRadius: 28,
//                           onPressed: _isLoading ? null : _handleRegister,
//                         ),

//                         const SizedBox(height: 24),

//                         // Divisor
//                         DividerLine(),

//                         const SizedBox(height: 24),

//                         // ¿Ya tienes cuenta?
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               '¿Ya tienes cuenta? ',
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: AppColors.blueGrey,
//                               ),
//                             ),
//                             GestureDetector(
//                               onTap: () => Navigator.of(context).pop(),
//                               child: Text(
//                                 'Iniciar Sesión',
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                   color: AppColors.blue,
//                                   fontWeight: FontWeight.w600,
//                                   decoration: TextDecoration.underline,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),

//                     const SizedBox(height: 40),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void _handleRegister() async {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }

//     if (!_acceptTerms) {
//       _showSnackBar('Debes aceptar los términos y condiciones');
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       // TODO: Implementar BLoC para registro
//       // context.read<RegisterClienteBloc>().add(
//       //   RegisterClienteSubmitted(
//       //     email: _emailController.text,
//       //     password: _passwordController.text,
//       //     firstName: _firstNameController.text,
//       //     lastName: _lastNameController.text,
//       //     phone: _phoneController.text,
//       //     dni: _dniController.text,
//       //   ),
//       // );

//       // Simulación de registro
//       await Future.delayed(const Duration(seconds: 2));

//       print('Registro - Email: ${_emailController.text}');
//       print(
//         'Registro - Nombre: ${_firstNameController.text} ${_lastNameController.text}',
//       );
//       print('Registro - DNI: ${_dniController.text}');
//       print('Registro - Teléfono: ${_phoneController.text}');

//       _showSnackBar('¡Cuenta creada exitosamente!');

//       // Navegar al login o dashboard
//       Navigator.of(context).pop();
//     } catch (e) {
//       _showSnackBar('Error al crear la cuenta. Intenta nuevamente.');
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   void _showSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: AppColors.blue,
//         duration: const Duration(seconds: 3),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:syncronize/core/fonts/app_fonts.dart';
import 'package:syncronize/core/theme/app_colors.dart';
import 'package:syncronize/core/widgets/appbar/custom_appbar.dart';
import 'package:syncronize/core/widgets/custom_date_textfiels_container/custom_textfield.dart';
import 'package:syncronize/core/widgets/cutom_button/custom_button.dart';
import 'package:syncronize/core/widgets/divider_line.dart';
import 'package:syncronize/core/widgets/rive_background.dart';

class RegisterClientePage extends StatefulWidget {
  const RegisterClientePage({super.key});

  @override
  State<RegisterClientePage> createState() => _RegisterClientePageState();
}

class _RegisterClientePageState extends State<RegisterClientePage> {
  final _formKey = GlobalKey<FormState>();

  // Controladores para todos los campos - CORREGIDOS
  final _dniController = TextEditingController();
  final _paternalSurnameController = TextEditingController();
  final _maternalSurnameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _departmentController = TextEditingController();
  final _provinceController = TextEditingController();
  final _districtController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _acceptTerms = false;
  bool _isLoading = false;
  bool _isDniValidated = false; // Para controlar si el DNI fue consultado

  @override
  void dispose() {
    _dniController.dispose();
    _paternalSurnameController.dispose();
    _maternalSurnameController.dispose();
    _firstNameController.dispose();
    _departmentController.dispose();
    _provinceController.dispose();
    _districtController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Crear Cuenta',
        centerTitle: false,
        titleStyle: TextStyle(
          fontFamily: AppFont.pirulentBold.fontFamily,
          fontSize: 10,
          color: AppColors.blue2,
        ),
      ),
      body: RiveBackground(
        blurX: 3,
        blurY: 3,
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Logo y título
                    Column(
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          'Completa tus datos para registrarte',
                          style: AppFont.orbitronMedium.style(
                            color: AppColors.blue2,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    // Campos del formulario
                    Column(
                      children: [
                        // DNI - CORREGIDO
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: CustomTextField(
                                label: 'DNI',
                                hintText: 'Digite su DNI',
                                controller: _dniController,
                                borderColor: AppColors.blue,
                                fieldType: FieldType.dni,
                                validator: (value) {
                                  if (value?.isEmpty ?? true) {
                                    return 'El DNI es requerido';
                                  }
                                  if (value!.length != 8) {
                                    return 'El DNI debe tener 8 dígitos';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              flex: 1,
                              child: CustomButton(
                                backgroundColor: AppColors.blue,
                                borderColor: AppColors.blue,
                                textColor: AppColors.white,
                                enableShadows: false,
                                text: 'Consultar\nDNI',
                                onPressed: _consultarDni, // AGREGADO
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Apellidos - CORREGIDOS
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                label: 'Apellido Paterno',
                                enabled: _isDniValidated,
                                controller: _paternalSurnameController, // CORREGIDO
                                borderColor: AppColors.blue,
                                prefixIcon: Icon(
                                  Icons.person_outline,
                                  color: AppColors.blue,
                                ),
                                validator: (value) {
                                  if (value?.isEmpty ?? true) {
                                    return 'El apellido paterno es requerido';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: CustomTextField(
                                label: 'Apellido Materno',
                                enabled: _isDniValidated,
                                controller: _maternalSurnameController, // CORREGIDO
                                borderColor: AppColors.blue,
                                prefixIcon: Icon(
                                  Icons.person_outline,
                                  color: AppColors.blue,
                                ),
                                validator: (value) {
                                  if (value?.isEmpty ?? true) {
                                    return 'El apellido materno es requerido';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Nombres - CORREGIDO
                        CustomTextField(
                          label: 'Nombres',
                          enabled: _isDniValidated,
                          controller: _firstNameController, // YA ESTABA CORRECTO
                          borderColor: AppColors.blue,
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color: AppColors.blue,
                          ),
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Los nombres son requeridos';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        // Departamento - CORREGIDO
                        CustomTextField(
                          label: 'Departamento',
                          enabled: _isDniValidated,
                          controller: _departmentController, // CORREGIDO
                          borderColor: AppColors.blue,
                          prefixIcon: Icon(
                            Icons.location_on_outlined,
                            color: AppColors.blue,
                          ),
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'El departamento es requerido';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        // Provincia y Distrito - CORREGIDOS
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                label: 'Provincia',
                                enabled: _isDniValidated,
                                controller: _provinceController, // CORREGIDO
                                borderColor: AppColors.blue,
                                prefixIcon: Icon(
                                  Icons.location_on_outlined,
                                  color: AppColors.blue,
                                ),
                                validator: (value) {
                                  if (value?.isEmpty ?? true) {
                                    return 'La provincia es requerida';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: CustomTextField(
                                label: 'Distrito',
                                enabled: _isDniValidated,
                                controller: _districtController, // CORREGIDO
                                borderColor: AppColors.blue,
                                prefixIcon: Icon(
                                  Icons.location_on_outlined,
                                  color: AppColors.blue,
                                ),
                                validator: (value) {
                                  if (value?.isEmpty ?? true) {
                                    return 'El distrito es requerido';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Dirección - CORREGIDO
                        CustomTextField(
                          label: 'Dirección',
                          enabled: _isDniValidated,
                          controller: _addressController, // CORREGIDO
                          borderColor: AppColors.blue,
                          prefixIcon: Icon(
                            Icons.location_on_outlined,
                            color: AppColors.blue,
                          ),
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'La dirección es requerida';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        // Email
                        CustomTextField(
                          label: 'Email',
                          hintText: 'example@gmail.com',
                          controller: _emailController,
                          borderColor: AppColors.blue,
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: AppColors.blue,
                          ),
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'El email es requerido';
                            }
                            if (!RegExp(
                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                            ).hasMatch(value!)) {
                              return 'Ingresa un email válido';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        // Teléfono
                        CustomTextFieldHelpers.phone(
                          label: 'Teléfono',
                          controller: _phoneController,
                          borderColor: AppColors.blue,
                        ),

                        const SizedBox(height: 16),

                        // Contraseña
                        CustomTextField(
                          label: 'Contraseña',
                          hintText: 'Mínimo 8 caracteres',
                          controller: _passwordController,
                          borderColor: AppColors.blue,
                          prefixIcon: Icon(
                            Icons.lock_outlined,
                            color: AppColors.blue,
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'La contraseña es requerida';
                            }
                            if (value!.length < 8) {
                              return 'La contraseña debe tener al menos 8 caracteres';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        // Confirmar contraseña
                        CustomTextField(
                          label: 'Confirmar Contraseña',
                          hintText: 'Repite tu contraseña',
                          controller: _confirmPasswordController,
                          borderColor: AppColors.blue,
                          prefixIcon: Icon(
                            Icons.lock_outlined,
                            color: AppColors.blue,
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Confirma tu contraseña';
                            }
                            if (value != _passwordController.text) {
                              return 'Las contraseñas no coinciden';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 24),

                        // Checkbox términos y condiciones
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: _acceptTerms,
                              onChanged: (value) {
                                setState(() {
                                  _acceptTerms = value ?? false;
                                });
                              },
                              activeColor: AppColors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _acceptTerms = !_acceptTerms;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 18),
                                  child: RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: AppColors.blueGrey,
                                      ),
                                      children: [
                                        const TextSpan(text: 'Acepto los '),
                                        TextSpan(
                                          text: 'Términos y Condiciones',
                                          style: TextStyle(
                                            color: AppColors.blue,
                                            fontWeight: FontWeight.w600,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                        const TextSpan(text: ' y la '),
                                        TextSpan(
                                          text: 'Política de Privacidad',
                                          style: TextStyle(
                                            color: AppColors.blue,
                                            fontWeight: FontWeight.w600,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // Botón registrar
                        CustomButton(
                          text: _isLoading ? 'Registrando...' : 'Crear Cuenta',
                          textStyle: AppFont.airstrikeBold3d.style(
                            fontSize: 16,
                          ),
                          backgroundColor: AppColors.green,
                          enableShadows: false,
                          borderRadius: 28,
                          onPressed: _isLoading ? null : _handleRegister,
                        ),

                        const SizedBox(height: 24),

                        // Divisor
                        DividerLine(),

                        const SizedBox(height: 24),

                        // ¿Ya tienes cuenta?
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '¿Ya tienes cuenta? ',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.blueGrey,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Text(
                                'Iniciar Sesión',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.blue,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // MÉTODO AGREGADO para consultar DNI
  void _consultarDni() async {
    if (_dniController.text.isEmpty || _dniController.text.length != 8) {
      _showSnackBar('Ingresa un DNI válido de 8 dígitos');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Implementar consulta real a API del RENIEC
      await Future.delayed(const Duration(seconds: 2));

      // Simulación de datos obtenidos
      _paternalSurnameController.text = 'TORRES';
      _maternalSurnameController.text = 'LEDEZMA';
      _firstNameController.text = 'JAMES JOHEL';
      _departmentController.text = 'LA LIBERTAD';
      _provinceController.text = 'TRUJILLO';
      _districtController.text = 'VICTOR LARCO HERRERA';
      _addressController.text = 'LOS OLIVOS 130 LOS MANGUTOS';

      setState(() {
        _isDniValidated = true;
      });

      _showSnackBar('Datos obtenidos exitosamente');
    } catch (e) {
      _showSnackBar('Error al consultar DNI. Intenta nuevamente.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handleRegister() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_acceptTerms) {
      _showSnackBar('Debes aceptar los términos y condiciones');
      return;
    }

    if (!_isDniValidated) {
      _showSnackBar('Debes consultar el DNI primero');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Implementar BLoC para registro
      await Future.delayed(const Duration(seconds: 2));

      print('Registro - DNI: ${_dniController.text}');
      print('Registro - Apellidos: ${_paternalSurnameController.text} ${_maternalSurnameController.text}');
      print('Registro - Nombres: ${_firstNameController.text}');
      print('Registro - Email: ${_emailController.text}');
      print('Registro - Teléfono: ${_phoneController.text}');

      _showSnackBar('¡Cuenta creada exitosamente!');
      Navigator.of(context).pop();
    } catch (e) {
      _showSnackBar('Error al crear la cuenta. Intenta nuevamente.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.blue,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}