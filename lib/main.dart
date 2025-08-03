import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncronize/bloc_provider.dart';
import 'package:syncronize/core/theme/app_theme.dart';
import 'package:syncronize/injection.dart';
import 'package:syncronize/src/presentation/page/auth/login/main_login_page.dart';
import 'package:syncronize/src/presentation/page/auth/register/register_cliente_new_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: blocProviders,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Syncronize',
        theme: AppTheme.lightTheme,
        initialRoute: 'login',
        routes: {
          'login': (context) => const MainLoginPage(),
          // 'registerCliente': (context) => const RegisterClientePage(),
          'register/new': (BuildContext context) => const RegisterClienteNewPage(),
        },
      ),
    );
  }
}
