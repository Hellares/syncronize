import 'package:flutter/material.dart';
import 'package:syncronize/core/fonts/app_fonts.dart';
import 'package:syncronize/core/theme/app_colors.dart';
import 'package:syncronize/core/widgets/appbar/custom_appbar.dart';
import 'package:syncronize/core/widgets/custom_date_textfiels_container/custom_textfield.dart';
import 'package:syncronize/core/widgets/cutom_button/custom_button.dart';
import 'package:syncronize/core/widgets/rive_background.dart';

class RegisterClientePage extends StatefulWidget {
  const RegisterClientePage({super.key});

  @override
  State<RegisterClientePage> createState() => _RegisterClientePageState();
}

class _RegisterClientePageState extends State<RegisterClientePage> {
  final _formKey = GlobalKey<FormState>();
  
  // Controladores para todos los campos
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dniController = TextEditingController();
  
  bool _acceptTerms = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _dniController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      // extendBodyBehindAppBar: true,
      // extendBody: true,
      appBar: CustomAppBar(
        title: 'Crear Cuenta',
        centerTitle: false,
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
                    // const SizedBox(height: 20),
                    
                    // Logo y título
                    Column(
                      children: [
                        // SvgPicture.asset(
                        //   'assets/img/logoplano2.svg',
                        //   height: 100,
                        //   width: 100,
                        // ),
                        // const SizedBox(height: 16),
                        // Text(
                        //   'Crear Cuenta',
                        //   style: TextStyle(
                        //     fontFamily: 'Airstrike',
                        //     fontSize: 24,
                        //     fontWeight: FontWeight.w700,
                        //     color: AppColors.blue2,
                        //   ),
                        // ),
                        const SizedBox(height: 8),
                        Text(
                          'Completa tus datos para registrarte',
                          style: AppFont.orbitronMedium.style(
                            color: AppColors.blue2,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Campos del formulario
                    Column(
                      children: [
                        // DNI
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: CustomTextField(                     
                                label: 'DNI',
                                controller: _dniController,
                                borderColor: AppColors.green,
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
                            const Expanded(
                              flex: 1,
                              child: SizedBox(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Nombre
                        CustomTextField(
                          label: 'Nombre',
                          controller: _firstNameController,
                          borderColor: AppColors.blue,
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color: AppColors.blue,
                          ),
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'El nombre es requerido';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        // Apellido
                        CustomTextField(
                          label: 'Apellido',
                          controller: _lastNameController,
                          borderColor: AppColors.blue,
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color: AppColors.blue,
                          ),
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'El apellido es requerido';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Email
                        CustomTextField(
                          label: 'Email',
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
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
                              return 'Ingresa un email válido';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        // Teléfono
                        CustomTextField(
                          label: 'Teléfono',
                          controller: _phoneController,
                          borderColor: AppColors.blue,
                          prefixIcon: Icon(
                            Icons.phone_outlined,
                            color: AppColors.blue,
                          ),
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'El teléfono es requerido';
                            }
                            if (value!.length < 9) {
                              return 'Ingresa un teléfono válido';
                            }
                            return null;
                          },
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
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Colors.black.withValues(alpha: 0.3),
                                thickness: 1,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'O',
                                style: TextStyle(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.black.withValues(alpha: 0.3),
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // ¿Ya tienes cuenta?
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '¿Ya tienes cuenta? ',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.blueGrey,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Text(
                                'Iniciar Sesión',
                                style: TextStyle(
                                  fontSize: 14,
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

  void _handleRegister() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_acceptTerms) {
      _showSnackBar('Debes aceptar los términos y condiciones');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Implementar BLoC para registro
      // context.read<RegisterClienteBloc>().add(
      //   RegisterClienteSubmitted(
      //     email: _emailController.text,
      //     password: _passwordController.text,
      //     firstName: _firstNameController.text,
      //     lastName: _lastNameController.text,
      //     phone: _phoneController.text,
      //     dni: _dniController.text,
      //   ),
      // );

      // Simulación de registro
      await Future.delayed(const Duration(seconds: 2));
      
      print('Registro - Email: ${_emailController.text}');
      print('Registro - Nombre: ${_firstNameController.text} ${_lastNameController.text}');
      print('Registro - DNI: ${_dniController.text}');
      print('Registro - Teléfono: ${_phoneController.text}');
      
      _showSnackBar('¡Cuenta creada exitosamente!');
      
      // Navegar al login o dashboard
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