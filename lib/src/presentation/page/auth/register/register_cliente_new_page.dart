import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncronize/core/fonts/app_fonts.dart';
import 'package:syncronize/core/theme/app_colors.dart';
import 'package:syncronize/core/theme/gradient_container.dart';
import 'package:syncronize/core/widgets/appbar/custom_appbar.dart';
import 'package:syncronize/core/widgets/loadings/custom_loading.dart';
import 'package:syncronize/core/widgets/snack.dart';
import 'package:syncronize/src/domain/models/auth_response_register_new.dart';
import 'package:syncronize/src/domain/utils/resource.dart';
import 'package:syncronize/src/presentation/page/auth/register/bloc/register_cliente_new_bloc.dart';
import 'package:syncronize/src/presentation/page/auth/register/bloc/register_cliente_new_events.dart';
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
  void dispose() {
    // Limpiar todos los estados del Bloc antes de destruir la pantalla
    _bloc?.add(const ClearAllStates());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _bloc = BlocProvider.of<RegisterClienteNewBloc>(context);
    
    return Scaffold(
      extendBodyBehindAppBar: true, // Extiende el body detrás del AppBar
      // backgroundColor: Colors.transparent, // Fondo transparente del Scaffold
      appBar: CustomAppBar(
        title: 'Crear Cuenta',
        centerTitle: false,
        titleStyle: TextStyle(
          fontFamily: AppFont.pirulentBold.fontFamily,
          fontSize: 10,
          color: AppColors.blue2,
        ),
        // Si tu CustomAppBar no maneja la transparencia, puedes necesitar:
        // backgroundColor: Colors.transparent,
        // elevation: 0,
      ),
      body: GradientContainer(
        child: SafeArea(
          child: BlocListener<RegisterClienteNewBloc, RegisterClienteNewState>(
            listenWhen: (previous, current) {
              // Solo escuchar cuando el response cambie y no sea null
              return previous.response != current.response && current.response != null;
            },
            listener: (context, state) {
              final responseState = state.response;
              
              if (responseState is Error) {
                SnackBarHelper.showError(context, responseState.message);
              } else if (responseState is Success<AuthResponseRegisterNew>) {
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
        ),
      ),
    );
  }
}