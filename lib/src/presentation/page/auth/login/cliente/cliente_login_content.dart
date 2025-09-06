import 'package:flutter/material.dart';
import 'package:syncronize/core/fonts/app_fonts.dart';
import 'package:syncronize/core/theme/app_colors.dart';
import 'package:syncronize/core/widgets/animations/page_animation_routes.dart';
import 'package:syncronize/core/widgets/custom_date_textfiels_container/custom_textfield.dart';
import 'package:syncronize/core/widgets/cutom_button/custom_button.dart';
import 'package:syncronize/core/widgets/divider_line.dart';
import 'package:syncronize/src/presentation/page/auth/login/cliente/bloc/login_bloc.dart';
import 'package:syncronize/src/presentation/page/auth/login/cliente/bloc/login_event.dart';
import 'package:syncronize/src/presentation/page/auth/login/cliente/bloc/login_state.dart';
import 'package:syncronize/src/presentation/page/auth/register/register_cliente_new_page.dart';
import 'package:syncronize/src/presentation/utils/bloc_form_item.dart';

// class ClienteLoginContent extends StatelessWidget {
//   final LoginBloc? bloc;
//   final LoginState state;

//   const ClienteLoginContent(this.bloc, this.state, {super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: state.formKey,
//       child: Column(
//         children: [
          
//           CustomTextField(
//             label: 'DNI',
//             borderColor: AppColors.blue,
//             fieldType: FieldType.dni,
//             onChanged: (text) {
//               bloc?.add(DniChanged(dni: BlocFormItem(value: text)));
//             },
//           ),

//           const SizedBox(height: 20),

//           CustomTextField(
//             label: 'Contraseña',
//             hintText: 'Mínimo 6 caracteres',
//             borderColor: AppColors.blue,
//             prefixIcon: Icon(Icons.lock_outlined, color: AppColors.blue),
//             obscureText: true,
//             onChanged: (text) {
//               bloc?.add(PasswordChanged(password: BlocFormItem(value: text)));
//             },
//           ),

//           const SizedBox(height: 16),


//           Align(
//             alignment: Alignment.centerRight,
//             child: TextButton(
//               onPressed: () {},
//               child: Text(
//                 '¿Olvidaste tu contraseña?',
//                 style: TextStyle(
//                   color: AppColors.blue,
//                   fontSize: 11,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//           ),

//           const SizedBox(height: 32),

//           //! Botón de iniciar sesión
//           CustomButton(
//             text: 'Iniciar Sesión',
//             borderWidth: 0.5,
//             textStyle: AppFont.pirulentBold.style( fontSize: 12),
//             backgroundColor: AppColors.blue,
//             borderRadius: 28,
//             // onPressed: () {
//             //   bloc?.add(LoginSubmit());
//             // },
//             onPressed: (state.dni.value.isEmpty || 
//                        state.password.value.isEmpty ||
//                        state.dni.error != null || 
//                        state.password.error != null)
//                 ? null
//                 : () => bloc?.add(LoginSubmit()),
//           ),

//           const SizedBox(height: 24),

//           DividerLine(),

//           const SizedBox(height: 24),

//           Text(
//             '¿No tienes cuenta?',
//             style: TextStyle(fontSize: 11, color: AppColors.blueGrey),
//           ),

//           const SizedBox(height: 16),

//           // Botón de registro
//           CustomButton(
//             text: 'Crear Cuenta',
//             textStyle: AppFont.pirulentBold.style( fontSize: 12),
//             backgroundColor: AppColors.green,
//             enableShadows: false,
//             borderColor: AppColors.green,
//             textColor: AppColors.white,
//             borderRadius: 28,
//             // onPressed: () {
//             //   Navigator.pushNamed(context, 'register/new');
//             // },
//             onPressed: (){
//               Navigator.push(context, PageAnimationRoutes(widget: const RegisterClienteNewPage(), ejex: 0.8, ejey: 0.8));
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }


class ClienteLoginContent extends StatefulWidget {
  final LoginBloc? bloc;
  final LoginState state;

  const ClienteLoginContent(this.bloc, this.state, {super.key});

  @override
  State<ClienteLoginContent> createState() => _ClienteLoginContentState();
}

class _ClienteLoginContentState extends State<ClienteLoginContent> {
  late TextEditingController _dniController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _dniController = TextEditingController(text: widget.state.dni.value);
    _passwordController = TextEditingController(text: widget.state.password.value);
  }

  @override
  void didUpdateWidget(ClienteLoginContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (mounted) {
      if (widget.state.dni.value != _dniController.text) {
        _dniController.text = widget.state.dni.value;
      }
      if (widget.state.password.value != _passwordController.text) {
        _passwordController.text = widget.state.password.value;
      }
    }
  }

  @override
  void dispose() {
    _dniController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Form(
        key: widget.state.formKey,
        child: Column(
          children: [
            CustomTextField(
              controller: _dniController,
              label: 'DNI',
              borderColor: widget.state.dni.error != null 
                  ? Colors.red 
                  : AppColors.blue,
              fieldType: FieldType.dni,
              enableRealTimeValidation: false,
              onChanged: (text) {
                widget.bloc?.add(DniChanged(dni: BlocFormItem(value: text)));
              },
            ),

            if (widget.state.dni.error != null) ...[
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.state.dni.error!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 20),

            CustomTextField(
              controller: _passwordController,
              label: 'Contraseña',
              hintText: 'Mínimo 6 caracteres',
              borderColor: widget.state.password.error != null 
                  ? Colors.red 
                  : AppColors.blue,
              prefixIcon: Icon(Icons.lock_outlined, color: AppColors.blue),
              obscureText: true,
              enableRealTimeValidation: false,
              onChanged: (text) {
                widget.bloc?.add(PasswordChanged(password: BlocFormItem(value: text)));
              },
              onSubmitted: (_) {
                if (_canSubmit()) {
                  widget.bloc?.add(const LoginSubmit());
                }
              },
            ),

            if (widget.state.password.error != null) ...[
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.state.password.error!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],

            // Resto de tu UI...
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

            CustomButton(
              text: 'Iniciar Sesión',
              borderWidth: 0.5,
              textStyle: AppFont.pirulentBold.style(fontSize: 12),
              backgroundColor: AppColors.blue,
              borderRadius: 28,
              onPressed: _canSubmit() ? () => widget.bloc?.add(const LoginSubmit()) : null,
            ),

            const SizedBox(height: 24),

            DividerLine(),

            const SizedBox(height: 24),

            Text(
              '¿No tienes cuenta?',
              style: TextStyle(fontSize: 11, color: AppColors.blueGrey),
            ),

            const SizedBox(height: 16),

            CustomButton(
              text: 'Crear Cuenta',
              textStyle: AppFont.pirulentBold.style(fontSize: 12),
              backgroundColor: AppColors.green,
              enableShadows: false,
              borderColor: AppColors.green,
              textColor: AppColors.white,
              borderRadius: 28,
              onPressed: () {
                Navigator.push(
                  context, 
                  PageAnimationRoutes(
                    widget: const RegisterClienteNewPage(), 
                    ejex: 0.8, 
                    ejey: 0.8
                  )
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  bool _canSubmit() {
    return widget.state.dni.value.isNotEmpty &&
           widget.state.password.value.isNotEmpty &&
           widget.state.dni.error == null &&
           widget.state.password.error == null;
  }
}