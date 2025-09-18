import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncronize/bloc_provider.dart';
import 'package:syncronize/src/presentation/page/auth/list_empresa_roles/user_empresa_roles_list.dart';
// import 'package:syncronize/injection.dart';
// import 'package:syncronize/src/presentation/page/auth/login/empresa_user_roles/empresa_user_page.dart';
import 'package:syncronize/src/presentation/page/auth/login/main_login_page.dart';
import 'package:syncronize/src/presentation/page/auth/register/register_cliente_new_page.dart';
import 'package:syncronize/src/presentation/page/home_page.dart';
import 'package:syncronize/src/presentation/page/splash/splash_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
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
        theme: ThemeData(        
          // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: 'splash',
        routes: {
          'splash': (context) => const SplashPage(),
          'login': (context) => const MainLoginPage(),
          'user/empresa/roles': (context) => const UserEmpresaRolesList(),
          'register/new': (context) => const RegisterClienteNewPage(),
          // 'empresa/user': (context) => const EmpresaUserPage(),
          'home': (context) => const HomePageAlternative(),
        },
      ),
    );
  }
}



  