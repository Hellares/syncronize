import 'package:flutter/material.dart';
import 'package:syncronize/core/fonts/app_fonts.dart';
import 'package:syncronize/core/theme/app_colors.dart';
import 'package:syncronize/core/widgets/custom_date_textfiels_container/custom_textfield.dart';
import 'package:syncronize/core/widgets/cutom_button/custom_button.dart';
import 'package:syncronize/core/widgets/divider_line.dart';
import 'package:syncronize/src/presentation/page/auth/login/cliente/bloc/login_bloc.dart';
import 'package:syncronize/src/presentation/page/auth/login/cliente/bloc/login_event.dart';
import 'package:syncronize/src/presentation/page/auth/login/cliente/bloc/login_state.dart';
import 'package:syncronize/src/presentation/utils/bloc_form_item.dart';

class ClienteLoginContent extends StatelessWidget {
  final LoginBloc? bloc;
  final LoginState state;

  const ClienteLoginContent(this.bloc, this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: state.formKey,
      child: Column(
        children: [
          CustomTextField(
            label: 'DNI',
            borderColor: AppColors.blue,
            fieldType: FieldType.dni,
            onChanged: (text) {
              bloc?.add(DniChanged(dni: BlocFormItem(value: text)));
            },
          ),

          const SizedBox(height: 20),

          CustomTextField(
            label: 'Contraseña',
            hintText: 'Mínimo 6 caracteres',
            borderColor: AppColors.blue,
            prefixIcon: Icon(Icons.lock_outlined, color: AppColors.blue),
            obscureText: true,
            onChanged: (text) {
              bloc?.add(PasswordChanged(password: BlocFormItem(value: text)));
            },
          ),

          const SizedBox(height: 16),


          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
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

          //! Botón de iniciar sesión
          CustomButton(
            text: 'Iniciar Sesión',
            borderWidth: 0.5,
            textStyle: AppFont.airstrike3d.style(fontWeight: FontWeight.w700),
            backgroundColor: AppColors.blue,
            borderRadius: 28,
            onPressed: () {
              bloc?.add(LoginSubmit());
            },
          ),

          const SizedBox(height: 24),

          DividerLine(),

          const SizedBox(height: 24),

          Text(
            '¿No tienes cuenta?',
            style: TextStyle(fontSize: 11, color: AppColors.blueGrey),
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
            onPressed: () {
              Navigator.pushNamed(context, 'register/new');
            },
          ),
        ],
      ),
    );
  }
}
