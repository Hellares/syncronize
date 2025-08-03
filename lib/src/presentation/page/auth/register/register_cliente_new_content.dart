// src/presentation/pages/auth/register_new/register_cliente_new_content.dart
import 'package:flutter/material.dart';
import 'package:syncronize/core/fonts/app_fonts.dart';
import 'package:syncronize/core/theme/app_colors.dart';
import 'package:syncronize/core/widgets/custom_date_textfiels_container/custom_textfield.dart';
import 'package:syncronize/core/widgets/cutom_button/custom_button.dart';
import 'package:syncronize/core/widgets/snack.dart';
import 'package:syncronize/src/presentation/page/auth/register/bloc/register_cliente_new_bloc.dart';
import 'package:syncronize/src/presentation/page/auth/register/bloc/register_cliente_new_events.dart';
import 'package:syncronize/src/presentation/page/auth/register/bloc/register_cliente_new_state.dart';
import 'package:syncronize/src/presentation/utils/bloc_form_item.dart';

class RegisterClienteNewContent extends StatefulWidget {
  final RegisterClienteNewBloc? bloc;
  final RegisterClienteNewState state;

  const RegisterClienteNewContent(this.bloc, this.state, {super.key});

  @override
  State<RegisterClienteNewContent> createState() =>
      _RegisterClienteNewContentState();
}

class _RegisterClienteNewContentState extends State<RegisterClienteNewContent> {
  late TextEditingController _dniController;
  late TextEditingController _nombresController;
  late TextEditingController _apellidoPaternoController;
  late TextEditingController _apellidoMaternoController;
  late TextEditingController _departamentoController;
  late TextEditingController _provinciaController;
  late TextEditingController _distritoController;
  late TextEditingController _direccionController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _listenToStateChanges();
  }

  void _initializeControllers() {
    _dniController = TextEditingController(text: widget.state.dni.value);
    _nombresController = TextEditingController(
      text: widget.state.nombres.value,
    );
    _apellidoPaternoController = TextEditingController(
      text: widget.state.apellidoPaterno.value,
    );
    _apellidoMaternoController = TextEditingController(
      text: widget.state.apellidoMaterno.value,
    );
    _departamentoController = TextEditingController(
      text: widget.state.departamento.value,
    );
    _provinciaController = TextEditingController(
      text: widget.state.provincia.value,
    );
    _distritoController = TextEditingController(
      text: widget.state.distrito.value,
    );
    _direccionController = TextEditingController(
      text: widget.state.direccion.value,
    );
    _emailController = TextEditingController(
      text: widget.state.email?.value ?? '',
    );
    _phoneController = TextEditingController(
      text: widget.state.phone?.value ?? '',
    );
    _passwordController = TextEditingController(
      text: widget.state.password.value,
    );
    _confirmPasswordController = TextEditingController(
      text: widget.state.confirmPassword.value,
    );
  }

  void _listenToStateChanges() {
    widget.bloc?.stream.listen((state) {
      if (mounted) {
        _dniController.text = state.dni.value;
        _nombresController.text = state.nombres.value;
        _apellidoPaternoController.text = state.apellidoPaterno.value;
        _apellidoMaternoController.text = state.apellidoMaterno.value;
        _departamentoController.text = state.departamento.value;
        _provinciaController.text = state.provincia.value;
        _distritoController.text = state.distrito.value;
        _direccionController.text = state.direccion.value;
      }
    });
  }

  @override
  void dispose() {
    _dniController.dispose();
    _nombresController.dispose();
    _apellidoPaternoController.dispose();
    _apellidoMaternoController.dispose();
    _departamentoController.dispose();
    _provinciaController.dispose();
    _distritoController.dispose();
    _direccionController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Form(
        key: widget.state.formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 8),

              // Título
              Text(
                'Completa tus datos para registrarte',
                style: AppFont.orbitronMedium.style(color: AppColors.blue2),
              ),

              const SizedBox(height: 20),

              // Sección DNI y consulta
              _buildDniSection(),

              const SizedBox(height: 30),

              // Título datos personales
              Text(
                'Datos Personales',
                style: AppFont.orbitronMedium.style(
                  fontSize: 12,
                  color: AppColors.blue2,
                ),
              ),

              const SizedBox(height: 20),

              // Campos de datos personales
              _buildPersonalDataFields(),

              const SizedBox(height: 35),

              Text(
                'Datos de Contacto',
                style: AppFont.orbitronMedium.style(
                  fontSize: 12,
                  color: AppColors.blue2,
                ),
              ),

              // const SizedBox(height: 10),

              // Campos de contacto y seguridad
              _buildContactAndSecurityFields(),

              const SizedBox(height: 24),

              // Checkbox términos y condiciones
              _buildTermsCheckbox(),

              const SizedBox(height: 32),

              // Botón registrar
              _buildRegisterButton(),

              const SizedBox(height: 24),

              // Link a login
              _buildLoginLink(),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDniSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: CustomTextField(
              label: 'DNI',
              hintText: 'Digite su de DNI',
              controller: _dniController,
              borderColor: AppColors.blue,
              fieldType: FieldType.dni,
              onChanged: (text) {
                widget.bloc?.add(
                  DniSearchChanged(dni: BlocFormItem(value: text)),
                );
              },
              validator: (value) {
                if (value?.isEmpty ?? true) return 'DNI requerido';
                if (value!.length != 8) return 'DNI debe tener 8 dígitos';
                return null;
              },
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: CustomButton(
                backgroundColor: AppColors.blue,
                borderColor: AppColors.blue,
                textColor: AppColors.white,
                enableShadows: false,
                text: 'Consultar DNI',
                onPressed: widget.state.isConsultingDni
                    ? null
                    : () {
                        widget.bloc?.add(const ConsultarDniPressed());
                      },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalDataFields() {
    return Column(
      children: [
        // Apellidos
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: _apellidoPaternoController,
                label: 'Apellido Paterno',
                borderColor: AppColors.blue,
                enabled: false,
                prefixIcon: const Icon(
                  Icons.person_outline,
                  color: AppColors.blue,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: CustomTextField(
                controller: _apellidoMaternoController,
                label: 'Apellido Materno',
                borderColor: AppColors.blue,
                enabled: false,
                prefixIcon: const Icon(
                  Icons.person_outline,
                  color: AppColors.blue,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Nombres
        CustomTextField(
          controller: _nombresController,
          label: 'Nombres',
          borderColor: AppColors.blue,
          enabled: false,
          prefixIcon: const Icon(Icons.person_outline, color: AppColors.blue),
        ),

        const SizedBox(height: 16),

        // Departamento
        CustomTextField(
          controller: _departamentoController,
          label: 'Departamento',
          borderColor: AppColors.blue,
          enabled: false,
          prefixIcon: const Icon(
            Icons.location_on_outlined,
            color: Colors.blue,
          ),
        ),

        const SizedBox(height: 16),

        // Provincia y Distrito
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: _provinciaController,
                label: 'Provincia',
                borderColor: AppColors.blue,
                enabled: false,
                prefixIcon: const Icon(
                  Icons.location_on_outlined,
                  color: AppColors.blue,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: CustomTextField(
                controller: _distritoController,
                label: 'Distrito',
                borderColor: AppColors.blue,
                enabled: false,
                prefixIcon: const Icon(
                  Icons.location_on_outlined,
                  color: AppColors.blue,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Dirección
        CustomTextField(
          controller: _direccionController,
          label: 'Dirección',
          borderColor: AppColors.blue,
          enabled: false,
          prefixIcon: const Icon(
            Icons.location_on_outlined,
            color: AppColors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildContactAndSecurityFields() {
    return Column(
      children: [
        // Email
        CustomTextField(
          controller: _emailController,
          label: 'Email',
          borderColor: AppColors.blue,
          keyboardType: TextInputType.emailAddress,
          prefixIcon: const Icon(Icons.email_outlined, color: AppColors.blue),
          onChanged: (text) {
            widget.bloc?.add(EmailChanged(email: BlocFormItem(value: text)));
          },
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Email requerido';
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
              return 'Email inválido';
            }
            return null;
          },
        ),

        const SizedBox(height: 16),

        // Teléfono
        // CustomTextField(
        //   controller: _phoneController,
        //   label: 'Teléfono',
        //   borderColor: AppColors.blue,
        //   keyboardType: TextInputType.phone,
        //   prefixIcon: const Icon(Icons.phone_outlined, color: AppColors.blue),
          // onChanged: (text) {
          //   widget.bloc?.add(PhoneChanged(phone: BlocFormItem(value: text)));
          // },
        //   validator: (value) {
        //     if (value?.isEmpty ?? true) return 'Teléfono requerido';
        //     return null;
        //   },
        // ),
        CustomTextFieldHelpers.phone(
          label: 'Teléfono',
          controller: _phoneController,
          borderColor: AppColors.blue,
          onChanged: (text) {
            widget.bloc?.add(PhoneChanged(phone: BlocFormItem(value: text)));
          },
        ),

        const SizedBox(height: 16),

        // Contraseña
        CustomTextField(
          controller: _passwordController,
          label: 'Contraseña',
          borderColor: AppColors.blue,
          obscureText: true,
          prefixIcon: const Icon(Icons.lock_outlined, color: AppColors.blue),
          onChanged: (text) {
            widget.bloc?.add(
              PasswordChanged(password: BlocFormItem(value: text)),
            );
          },
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Contraseña requerida';
            if (value!.length < 8) return 'Mínimo 8 caracteres';
            return null;
          },
        ),

        const SizedBox(height: 16),

        // Confirmar contraseña
        CustomTextField(
          controller: _confirmPasswordController,
          label: 'Confirmar Contraseña',
          borderColor: AppColors.blue,
          obscureText: true,
          prefixIcon: const Icon(Icons.lock_outlined, color: AppColors.blue),
          onChanged: (text) {
            widget.bloc?.add(
              ConfirmPasswordChanged(
                confirmPassword: BlocFormItem(value: text),
              ),
            );
          },
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Confirme su contraseña';
            if (value != _passwordController.text) {
              return 'Las contraseñas no coinciden';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: widget.state.acceptTerms,
          onChanged: (value) {
            widget.bloc?.add(AcceptTermsChanged(acceptTerms: value ?? false));
          },
          activeColor: AppColors.blue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              widget.bloc?.add(
                AcceptTermsChanged(acceptTerms: !widget.state.acceptTerms),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 18),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
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
    );
  }

  Widget _buildRegisterButton() {
    return CustomButton(
      text: widget.state.isRegistering ? 'Registrando...' : 'Crear Cuenta',
      backgroundColor: AppColors.blue,
      borderColor: AppColors.blue,
      textColor: AppColors.white,
      textStyle: AppFont.airstrikeBold3d.style(fontSize: 16),
      borderWidth: 0,
      // sizeFont: 16,
      onPressed: widget.state.isRegistering
          ? null
          : () {
              if (widget.state.formKey!.currentState!.validate()) {
                if (!widget.state.acceptTerms) {
                  // Fluttertoast.showToast(
                  //   msg: 'Debe aceptar los términos y condiciones',
                  //   toastLength: Toast.LENGTH_LONG,
                  // );
                  SnackBarHelper.showWarning(
                    context,
                    'Debe aceptar los términos y condiciones',
                  );
                  return;
                }
                widget.bloc?.add(const RegisterNewSubmitted());
              } else {
                // Fluttertoast.showToast(
                //   msg: 'Complete todos los campos correctamente',
                //   toastLength: Toast.LENGTH_LONG,
                // );
                SnackBarHelper.showWarning(
                  context,
                  'Complete todos los campos correctamente',
                );
              }
            },
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          '¿Ya tienes cuenta? ',
          style: TextStyle(fontSize: 12, color: Colors.grey),
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
    );
  }
}
