import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncronize/injection.dart';
import 'package:syncronize/src/domain/use_cases/auth/auth_use_cases.dart';
import 'package:syncronize/src/domain/use_cases/reniec/reniec_use_cases.dart';
import 'package:syncronize/src/presentation/page/auth/login/cliente/bloc/login_bloc.dart';
import 'package:syncronize/src/presentation/page/auth/login/cliente/bloc/login_event.dart';
import 'package:syncronize/src/presentation/page/auth/login/empresa_user_roles/bloc/empresa_user_roles_bloc.dart';
import 'package:syncronize/src/presentation/page/auth/register/bloc/register_cliente_new_bloc.dart';
import 'package:syncronize/src/presentation/page/auth/register/bloc/register_cliente_new_events.dart';

List<BlocProvider> blocProviders = [

  BlocProvider<LoginBloc>(create: (context) => LoginBloc(locator<AuthUseCases>()).. add(InitEvent())),

  BlocProvider<RegisterClienteNewBloc>(create: (context) => RegisterClienteNewBloc(locator<ReniecUseCases>(),locator<AuthUseCases>(),)..add(RegisterClienteNewInitEvent())),
  BlocProvider<EmpresaUserRolesBloc>(create: (context) => EmpresaUserRolesBloc(locator<AuthUseCases>(), locator())),

];