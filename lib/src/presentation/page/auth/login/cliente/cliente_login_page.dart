import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncronize/core/widgets/loadings/custom_loading.dart';
import 'package:syncronize/core/widgets/snack.dart';
import 'package:syncronize/src/domain/utils/resource.dart';
import 'package:syncronize/src/presentation/page/auth/login/cliente/bloc/login_bloc.dart';
import 'package:syncronize/src/presentation/page/auth/login/cliente/bloc/login_event.dart';
import 'package:syncronize/src/presentation/page/auth/login/cliente/bloc/login_state.dart';
import 'package:syncronize/src/presentation/page/auth/login/cliente/cliente_login_content.dart';

class ClienteLoginPage extends StatefulWidget {
  const ClienteLoginPage({super.key});

  @override
  State<ClienteLoginPage> createState() => _ClienteLoginPageState();
}

class _ClienteLoginPageState extends State<ClienteLoginPage> {
  LoginBloc? _bloc;

  @override
  void initState() {
    super.initState();
    // Inicializar el BLoC cuando se monta el widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bloc?.add(const InitEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    _bloc = BlocProvider.of<LoginBloc>(context);

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        final responseState = state.response;
        if (responseState is Error) {
          SnackBarHelper.showError(context, responseState.message);
        } else if (responseState is Success) {
          // SnackBarHelper.showSuccess(context, 'Login exitoso');
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          final responseState = state.response;
          if (responseState is Loading) {
            return Stack(
              children: [
                ClienteLoginContent(_bloc, state),
                CustomLoading.login(),
              ],
            );
          }
          return ClienteLoginContent(_bloc, state);
        },
      ),
    );
  }
}
