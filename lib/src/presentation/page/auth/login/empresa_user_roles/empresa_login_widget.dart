import 'package:flutter/material.dart';
import 'package:syncronize/core/theme/app_colors.dart';
import 'package:syncronize/core/theme/app_gradients.dart';
import 'package:syncronize/core/widgets/custom_date_textfiels_container/custom_textfield.dart';
import 'package:syncronize/core/widgets/cutom_button/custom_button.dart';

class EmpresaLoginWidget extends StatefulWidget {
  const EmpresaLoginWidget({super.key});

  @override
  State<EmpresaLoginWidget> createState() => _EmpresaLoginWidgetState();
}

class _EmpresaLoginWidgetState extends State<EmpresaLoginWidget> {
  final _rucController = TextEditingController();
  final _usuarioController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _rucController.dispose();
    _usuarioController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('empresa'),
      children: [
        // Campo RUC
        CustomTextField(
          label: 'RUC Empresa',
          controller: _rucController,
          borderColor: AppColors.blue,
          prefixIcon: Icon(
            Icons.business_outlined,
            color: AppColors.blue,
          ),
          // Si tienes FieldType.ruc, úsalo aquí
        ),

        const SizedBox(height: 20),

        // Campo Usuario
        CustomTextField(
          label: 'Usuario',
          controller: _usuarioController,
          borderColor: AppColors.blue,
          prefixIcon: Icon(
            Icons.person_outlined,
            color: AppColors.blue,
          ),
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
          validator: (value) => (value?.length ?? 0) < 6
              ? 'Contraseña muy corta'
              : null,
        ),

        const SizedBox(height: 16),

        // Enlace "¿Olvidaste tu contraseña?"
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: _handleForgotPassword,
            child: Text(
              '¿Olvidaste tu contraseña?',
              style: TextStyle(
                color: AppColors.blue,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),

        const SizedBox(height: 32),

        // Botón de iniciar sesión empresa
        CustomButton(
          text: 'Iniciar Sesión',
          borderWidth: 0.5,
          textStyle: TextStyle(
            fontFamily: 'Airstrike',
            fontWeight: FontWeight.w700,
          ),
          gradient: AppGradients.custom(
            startColor: AppColors.blue,
            middleColor: AppColors.blue,
            endColor: AppColors.blue,
          ),
          borderColor: AppColors.blue2,
          textColor: AppColors.white,
          borderRadius: 28,
          fontSize: 14,
          onPressed: _handleLogin,
        ),

        const SizedBox(height: 24),

        // Divisor "O"
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

        // Texto "¿No tienes cuenta empresarial?"
        Text(
          '¿No tienes cuenta empresarial?',
          style: TextStyle(
            fontSize: 11,
            color: AppColors.blueGrey,
          ),
        ),

        const SizedBox(height: 16),

        // Botón de registro empresa
        CustomButton(
          text: 'Registrar Empresa',
          textStyle: TextStyle(
            fontFamily: 'Airstrike',
          ),
          gradient: AppGradients.custom(
            startColor: AppColors.green,
            middleColor: AppColors.green,
            endColor: AppColors.green,
          ),
          enableShadows: false,
          borderColor: AppColors.green,
          textColor: AppColors.white,
          borderRadius: 28,
          fontSize: 14,
          fontWeight: FontWeight.w700,
          onPressed: _handleRegister,
        ),
      ],
    );
  }

  void _handleLogin() {
    // TODO: Implementar BLoC para login de empresa
    // context.read<EmpresaLoginBloc>().add(
    //   EmpresaLoginSubmitted(
    //     ruc: _rucController.text,
    //     usuario: _usuarioController.text,
    //     password: _passwordController.text,
    //   ),
    // );
    
    // print('Empresa Login - RUC: ${_rucController.text}, Usuario: ${_usuarioController.text}, Password: ${_passwordController.text}');
  }

  void _handleForgotPassword() {
    // TODO: Navegar a recuperación de contraseña para empresa
    // print('Forgot password - Empresa');
  }

  void _handleRegister() {
    // TODO: Navegar a registro de empresa
    // print('Register - Empresa');
  }
}