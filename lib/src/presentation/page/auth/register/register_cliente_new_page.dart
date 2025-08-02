// src/presentation/pages/auth/register_new/register_cliente_new_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncronize/core/fonts/app_fonts.dart';
import 'package:syncronize/core/theme/app_colors.dart';
import 'package:syncronize/core/widgets/appbar/custom_appbar.dart';
import 'package:syncronize/core/widgets/loadings/custom_loading.dart';
import 'package:syncronize/core/widgets/snack.dart';
import 'package:syncronize/src/domain/models/auth_response_register_new.dart';
import 'package:syncronize/src/domain/utils/resource.dart';
import 'package:syncronize/src/presentation/page/auth/register/bloc/register_cliente_new_bloc.dart';
import 'package:syncronize/src/presentation/page/auth/register/bloc/register_cliente_new_state.dart';
import 'package:syncronize/src/presentation/page/auth/register/register_cliente_new_content.dart';


class RegisterClienteNewPage extends StatefulWidget {
  const RegisterClienteNewPage({super.key});

  @override
  State<RegisterClienteNewPage> createState() => _RegisterClienteNewPageState();
}

class _RegisterClienteNewPageState extends State<RegisterClienteNewPage> {
  RegisterClienteNewBloc? _bloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _bloc = BlocProvider.of<RegisterClienteNewBloc>(context);
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Crear Cuenta',
        centerTitle: false,
        titleStyle: TextStyle(
          fontFamily: AppFont.pirulentBold.fontFamily,
          fontSize: 10,
          color: AppColors.blue2,
        ),
      ),
      body: BlocListener<RegisterClienteNewBloc, RegisterClienteNewState>(
        listener: (context, state) {
          final responseState = state.response;
          
          if (responseState is Error) {
            // Fluttertoast.showToast(
            //   msg: responseState.message,
            //   toastLength: Toast.LENGTH_LONG,
            //   backgroundColor: Colors.red,
            //   textColor: Colors.white,
            // );
            SnackBarHelper.showError(context, responseState.message);
          } else if (responseState is Success<AuthResponseRegisterNew>) {
            // Fluttertoast.showToast(
            //   msg: '¡Cuenta creada exitosamente!',
            //   toastLength: Toast.LENGTH_LONG,
            //   backgroundColor: Colors.green,
            //   textColor: Colors.white,
            // );
            SnackBarHelper.showSuccess(context, '¡Cuenta creada exitosamente!');
            // Navegar al login o dashboard
            Navigator.of(context).pop();
          }
        },
        child: BlocBuilder<RegisterClienteNewBloc, RegisterClienteNewState>(
          builder: (context, state) {
            // final responseState = state.response;
            
            return Stack(
              children: [
                RegisterClienteNewContent(_bloc, state),
                // if (state.isConsultingDni || state.isRegistering)
                //   Container(
                //     color: Colors.black26,
                //     child: const Center(
                //       child: CircularProgressIndicator(),
                //     ),
                //   ),
                if (state.isRegistering )
                  CustomLoading.registering()
              ],
            );
          },
        ),
      ),
    );
  }
}