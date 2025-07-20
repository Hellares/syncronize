import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Necesitas agregar flutter_svg a pubspec.yaml
import 'package:syncronize/core/theme/app_colors.dart';
import 'package:syncronize/core/theme/app_gradients.dart';
import 'package:syncronize/core/widgets/custom_date_textfiels_container/custom_textfield.dart';
import 'package:syncronize/core/widgets/cutom_button/custom_button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final _passwordController = TextEditingController();
    final _dniController = TextEditingController();
    
    return Scaffold(
      body: GradientContainer(
        gradient: AppGradients.sinfondo,
        width: double.infinity,
        height: double.infinity,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo/Avatar mejorado con SVG
                  Center(
                    child: SvgPicture.asset(
                      'assets/img/logo-01.svg', // Cambia por tu ruta de SVG
                      height: 200,
                      width: 200,
                    ),
                  ),
                  
                  const SizedBox(height: 5),
                  
                  // Título mejorado
                  // Text(
                  //   'Syncronize',
                  //   style: TextStyle(
                  //     fontSize: 28,
                  //     fontWeight: FontWeight.w700,
                  //     color: AppColors.black54,
                  //     letterSpacing: 1.2,
                  //   ),
                  // ),
                  
                  const SizedBox(height: 40),
                  
                  // Text(
                  //   'Inicia sesión para continuar',
                  //   style: TextStyle(
                  //     fontSize: 16,
                  //     fontWeight: FontWeight.w700,
                  //     color: AppColors.blue,
                  //   ),
                  // ),
                  
                  // Container para los campos de entrada
                  Column(
                    children: [
                      // Campo DNI con icono mejorado
                      CustomTextField(
                        label: 'DNI',
                        
                        controller: _dniController,
                        borderColor: AppColors.blue,
                        fieldType: FieldType.dni,
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Campo contraseña
                      CustomTextField(
                        label: 'Contraseña',
                        hintText: 'Mínimo 6 caracteres',
                        borderColor: AppColors.blue,
                        controller: _passwordController,
                        prefixIcon: Icon(
                          Icons.lock_outlined,
                          color: AppColors.blue,
                        ),
                        obscureText: true,
                        validator: (value) => 
                         (value?.length ?? 0) < 6 ? 'Contraseña muy corta' : null,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Enlace "¿Olvidaste tu contraseña?"
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // Navegar a página de recuperación
                          },
                          child: Text(
                            '¿Olvidaste tu contraseña?',
                            style: TextStyle(
                              color: AppColors.blue,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Botón de iniciar sesión mejorado
                  CustomButton(
                    text: 'Iniciar Sesión',
                    gradient: AppGradients.custom(
                      startColor: const Color.fromARGB(255, 223, 238, 253), 
                      middleColor: AppColors.white, 
                      endColor: const Color.fromARGB(255, 223, 238, 253),
                      ),
                    borderColor: AppColors.blue,
                    textColor: AppColors.blue2,
                    borderRadius: 28,
                    fontSize: 16,
                    onPressed: () {
                      // Lógica de login
                      _handleLogin(_dniController.text, _passwordController.text);
                    },
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Divisor "O"
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: AppColors.black54.withOpacity(0.3),
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'O',
                          style: TextStyle(
                            color: AppColors.black54.withOpacity(0.7),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: AppColors.black54.withOpacity(0.3),
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Texto "¿No tienes cuenta?"
                  Text(
                    '¿No tienes cuenta?',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.black54.withOpacity(0.7),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Botón de registro mejorado
                  CustomButton(
                    text: 'Crear Cuenta',
                    gradient: AppGradients.sinfondo,
                    borderColor: AppColors.red,
                    textColor: AppColors.blue2,
                    borderRadius: 28,
                    fontSize: 16,
                    onPressed: () {
                      // Navegar a página de registro
                    },
                  ),
                  
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  void _handleLogin(String dni, String password) {
    // Aquí puedes agregar la lógica de autenticación
    print('Login attempt - DNI: $dni, Password: $password');
  }
}