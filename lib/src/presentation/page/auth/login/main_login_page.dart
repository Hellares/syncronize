import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncronize/core/fonts/app_fonts.dart';
import 'package:syncronize/core/theme/app_colors.dart';
import 'package:syncronize/core/theme/app_gradients.dart';
import 'package:syncronize/core/theme/gradient_container.dart';
import 'package:syncronize/core/widgets/rive_background.dart';
import 'package:syncronize/src/presentation/page/auth/login/cliente/cliente_login_page.dart';
// import 'package:syncronize/src/presentation/page/auth/login/empresa/empresa_login_widget.dart';

class MainLoginPage extends StatefulWidget {
  const MainLoginPage({super.key});

  @override
  State<MainLoginPage> createState() => _MainLoginPageState();
}

class _MainLoginPageState extends State<MainLoginPage> {
  // bool _isEmpresa = false; // false = Cliente, true = Empresa

  @override
  Widget build(BuildContext context) {
    _transparentBar();

    return Scaffold(
      
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: GradientContainer(
        // gradient: AppGradients.blueWhiteBlue(),
        gradient: AppGradients.custom(
          startColor: AppColors.white, 
          middleColor: AppColors.white,
          endColor: const Color.fromARGB(255, 184, 219, 255),
          stops: [0.0, 0.5, 1.0],
        ),
        height: double.infinity,
        child: RiveBackground(
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
                    _buildLogoSection(),
        
                    const SizedBox(height: 30),
        
                    // _buildToggleSwitch(),
        
                    const SizedBox(height: 30),
        
                    _buildContent(),
        
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  

  void _transparentBar() {
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
  }

  Widget _buildLogoSection() {
    return Column(
      children: [
        SvgPicture.asset(
          'assets/img/logoplano2.svg',
          height: 110,
          width: 110,
        ),
        const SizedBox(height: 10),
        Text(
          'Syncronize',
          style: AppFont.airstrikeBold3d.style(
            fontSize: 20,
            color: AppColors.blue2,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  // Widget _buildToggleSwitch() {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Text(
  //           'Cliente',
  //           style: AppFont.pirulentBold.style(
  //             fontSize: 9,
  //             fontWeight: FontWeight.w700,
  //             color: !_isEmpresa ? AppColors.blue : AppColors.grey,
  //           ),
  //         ),
          
  //         const SizedBox(width: 16),
          
  //         // Toggle Switch
  //         GestureDetector(
  //           onTap: () {
  //             setState(() {
  //               _isEmpresa = !_isEmpresa;
  //             });
  //           },
  //           child: AnimatedContainer(
  //             duration: const Duration(milliseconds: 250),
  //             width: 50,
  //             height: 23,
  //             decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(14),
  //               color: _isEmpresa ? AppColors.blue : Colors.grey.shade300,
  //             ),
  //             child: AnimatedAlign(
  //               duration: const Duration(milliseconds: 250),
  //               alignment: _isEmpresa ? Alignment.centerRight : Alignment.centerLeft,
  //               child: Container(
  //                 width: 24,
  //                 height: 24,
  //                 margin: const EdgeInsets.all(2),
  //                 decoration: BoxDecoration(
  //                   shape: BoxShape.circle,
  //                   color: Colors.white,
  //                   boxShadow: [
  //                     BoxShadow(
  //                       color: Colors.black.withValues(alpha: 0.15),
  //                       blurRadius: 4,
  //                       offset: const Offset(0, 2),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
          
  //         const SizedBox(width: 16),
          
  //         Text(
  //           'Empresa',
  //           style: AppFont.pirulentBold.style(
  //             fontSize: 9,
  //             fontWeight: FontWeight.w700,
  //             color: _isEmpresa ? AppColors.blue : AppColors.grey,
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildContent() {
  //   return AnimatedSwitcher(
  //     duration: const Duration(milliseconds: 800),
  //     transitionBuilder: (Widget child, Animation<double> animation) {
  //       return FadeTransition(
  //         opacity: animation,
  //         child: SlideTransition(
  //           position: animation.drive(
  //             Tween(begin: const Offset(0.0, 0.1), end: Offset.zero),
  //           ),
  //           child: child,
  //         ),
  //       );
  //     },
  //     child: _isEmpresa 
  //         ? const EmpresaLoginWidget(key: ValueKey('empresa'))
  //         : const ClienteLoginPage(key: ValueKey('cliente')),
  //   );
  // }
  Widget _buildContent() {
    return const ClienteLoginPage(); // Solo muestra la página de cliente
  }
}