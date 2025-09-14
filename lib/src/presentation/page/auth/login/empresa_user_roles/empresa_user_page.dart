import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncronize/src/domain/utils/resource.dart';
import 'package:syncronize/src/presentation/page/auth/login/empresa_user_roles/bloc/empresa_user_roles_bloc.dart';
import 'package:syncronize/src/presentation/page/auth/login/empresa_user_roles/bloc/empresa_user_roles_event.dart';
import 'package:syncronize/src/presentation/page/auth/login/empresa_user_roles/bloc/empresa_user_roles_state.dart';
import 'package:syncronize/src/presentation/page/auth/login/empresa_user_roles/empresa_card.dart';

class EmpresaUserPage extends StatefulWidget {
  const EmpresaUserPage({super.key});

  @override
  State<EmpresaUserPage> createState() => _EmpresaUserPageState();
}

class _EmpresaUserPageState extends State<EmpresaUserPage> {
  EmpresaUserRolesBloc? _bloc;

  @override
  void initState() {
    super.initState();    
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _bloc!.add(EmpresaUserRolesInitEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    _bloc = BlocProvider.of<EmpresaUserRolesBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Empresas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _bloc!.add(const RefreshEmpresaUserRolesAuto());
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _bloc!.add(const AdminLogout());
            },
          ),
        ],
      ),
      body: BlocListener<EmpresaUserRolesBloc, EmpresaUserRolesState>(
        listener: (context, state) {
          final responseState = state.response;
          if (responseState is Error) {
            // SnackBarHelper.showError(context, responseState.message);
          }
        },
        child: BlocBuilder<EmpresaUserRolesBloc, EmpresaUserRolesState>(
          builder: (context, state) {
            final responseState = state.response;

            if (responseState is Loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.empresas.isEmpty && responseState is Success) {
              return const Center(
                child: Text('No tienes empresas asociadas'),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                _bloc!.add(const RefreshEmpresaUserRolesAuto());
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.empresas.length,
                itemBuilder: (context, index) {
                  final empresa = state.empresas[index];
                  return EmpresaCard(empresa: empresa);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}