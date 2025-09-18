import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncronize/core/widgets/logout/logout_button.dart';
import 'package:syncronize/src/domain/models/auth_empresa_response.dart';
import 'package:syncronize/src/presentation/page/auth/list_empresa_roles/bloc/list_empresa_roles_bloc.dart';
import 'package:syncronize/src/presentation/page/auth/list_empresa_roles/bloc/list_empresa_roles_state.dart';
import 'package:syncronize/src/presentation/page/auth/list_empresa_roles/empresa_card.dart';

class UserEmpresaRolesList extends StatefulWidget {
  const UserEmpresaRolesList({super.key});

  @override
  State<UserEmpresaRolesList> createState() => _UserEmpresaRolesListState();
}

class _UserEmpresaRolesListState extends State<UserEmpresaRolesList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Empresas'),
        actions: [          
          LogoutButton.appBar()
        ],
      ),
      body:  BlocBuilder<ListEmpresaRolesBloc, ListEmpresaRolesState>(
        builder: (context, state ) {
          return Column(
            children: [
              Container(
                  margin: EdgeInsets.only(bottom: 20, top: 15),
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.08,
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    'Seleccione una empresa',
                    style: TextStyle(
                      fontFamily: "pirulen",
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              Center(
                child: ListView(
                 shrinkWrap: true,
                        children: state.empresas != null ? (state.empresas?.map((Empresa? empresa){
                          return empresa != null ? EmpresaCard(empresa:empresa) : Container();
                        }).toList()) as List<Widget> : [],
                ),
              ),
            ],
          );
        }
      ),    
     
    );
  }
}