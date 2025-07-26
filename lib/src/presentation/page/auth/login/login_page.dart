import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncronize/core/fonts/app_fonts.dart';
import 'package:syncronize/core/theme/app_colors.dart';
import 'package:syncronize/core/widgets/rive_background.dart';
// Importa tus widgets separados
import 'cliente_login_widget.dart';
import 'empresa_login_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isEmpresa = false; // false = Cliente, true = Empresa

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: RiveBackground(
        blurX: 3,
        blurY: 3,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 30.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo
                  Column(
                    children: [
                      SvgPicture.asset(
                        'assets/img/logoplano2.svg',
                        height: 110,
                        width: 110,
                      ),
                      Text(
                        'Syncronize',
                        style: AppFont.airstrikeBold3d.style(
                          fontSize: 21,
                          color: AppColors.blue2,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Toggle minimalista
                  _buildToggleSwitch(),

                  const SizedBox(height: 30),

                  // Contenido dinámico basado en el toggle
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: animation.drive(
                            Tween(begin: const Offset(0.0, 0.1), end: Offset.zero),
                          ),
                          child: child,
                        ),
                      );
                    },
                    child: _isEmpresa 
                        ? const EmpresaLoginWidget() 
                        : const ClienteLoginWidget(),
                  ),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToggleSwitch() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Cliente',
            style: AppFont.pirulentBold.style(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: !_isEmpresa ? AppColors.blue : AppColors.grey,
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Toggle Switch
          GestureDetector(
            onTap: () {
              setState(() {
                _isEmpresa = !_isEmpresa;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 50,
              height: 25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: _isEmpresa ? AppColors.blue : Colors.grey.shade300,
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 250),
                alignment: _isEmpresa ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 24,
                  height: 24,
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          Text(
            'Empresa',
            style: AppFont.pirulentBold.style(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: _isEmpresa ? AppColors.blue : AppColors.grey,
            ),
          )
        ],
      ),
    );
  }
}