import 'package:flutter/material.dart';
import 'package:syncronize/core/fonts/app_fonts.dart';
import 'package:syncronize/core/theme/app_colors.dart';
import 'package:syncronize/core/widgets/custom_date_textfiels_container/custom_textfield.dart';
import 'package:syncronize/core/widgets/cutom_button/custom_button.dart';

class ClienteLoginWidget extends StatefulWidget {
  const ClienteLoginWidget({super.key});

  @override
  State<ClienteLoginWidget> createState() => _ClienteLoginWidgetState();
}

class _ClienteLoginWidgetState extends State<ClienteLoginWidget> {
  final _passwordController = TextEditingController();
  final _dniController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _dniController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('cliente'),
      children: [
        // Campo DNI
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

        // Botón de iniciar sesión
        CustomButton(
          text: 'Iniciar Sesión',
          borderWidth: 0.5,
          textStyle: AppFont.airstrikeBold3d.style(),
          backgroundColor: AppColors.blue,
          borderRadius: 28,
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
                  fontSize: 14,
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

        // Texto "¿No tienes cuenta?"
        Text(
          '¿No tienes cuenta?',
          style: TextStyle(
            fontSize: 11,
            color: AppColors.blueGrey,
          ),
        ),

        const SizedBox(height: 16),

        // Botón de registro
        CustomButton(
          text: 'Crear Cuenta',
          textStyle: AppFont.airstrikeBold3d.style(),
          backgroundColor: AppColors.green,
          enableShadows: false,
          borderColor: AppColors.green,
          textColor: AppColors.white,
          borderRadius: 28,
          onPressed: _handleRegister,
        ),
      ],
    );
  }

  void _handleLogin() {
    // TODO: Implementar BLoC para login de cliente
    // context.read<ClienteLoginBloc>().add(
    //   ClienteLoginSubmitted(
    //     dni: _dniController.text,
    //     password: _passwordController.text,
    //   ),
    // );
    
    print('Cliente Login - DNI: ${_dniController.text}, Password: ${_passwordController.text}');
  }

  void _handleForgotPassword() {
    // TODO: Navegar a recuperación de contraseña para cliente
    print('Forgot password - Cliente');
  }

  void _handleRegister() {
    Navigator.pushNamed(context, 'registerCliente');
  }
}