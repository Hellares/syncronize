import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:syncronize/core/fonts/app_fonts.dart';
import 'package:syncronize/core/theme/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leftWidget;
  final String? leftIconPath; // Para SVG o imagen
  final IconData? leftIcon; // Para iconos de Material
  final VoidCallback? onLeftTap;
  final String? title;
  final TextStyle? titleStyle;
  final Color backgroundColor;
  final bool showLogo;
  final String? logoPath; // Path del Lottie
  final double logoSize;
  final double elevation;
  final bool centerTitle;
  final Color? iconColor;

  const CustomAppBar({
    super.key,
    this.leftWidget,
    this.leftIconPath,
    this.leftIcon,
    this.onLeftTap,
    this.title,
    this.titleStyle,
    this.backgroundColor = Colors.transparent,
    this.showLogo = true,
    this.logoPath = 'assets/animations/logo1.json',
    this.logoSize = 30,
    this.elevation = 0,
    this.centerTitle = true,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: elevation,
      centerTitle: centerTitle,
      automaticallyImplyLeading: false,
      title: _buildTitle(),
      leading: _buildLeftWidget(context),
      actions: showLogo ? [_buildLogoWidget()] : null,
      iconTheme: IconThemeData(
        color: iconColor ?? AppColors.blue,
      ),
    );
  }

  Widget? _buildTitle() {
    if (title == null) return null;
    
    return Text(
      title!,
      // style: titleStyle ??
      //     TextStyle(
      //       fontFamily: 'pirulen',
      //       fontSize: 11,
      //       color: AppColors.blue2,
      //     ),
      style: titleStyle ?? AppFont.pirulentBold.style(
        fontSize: 11,
        color: AppColors.blue2,
      ),
    );
  }

  Widget? _buildLeftWidget(BuildContext context) {
    // Si se proporciona un widget personalizado, usarlo
    if (leftWidget != null) {
      return GestureDetector(
        onTap: onLeftTap,
        child: leftWidget!,
      );
    }

    // Si se proporciona un path de imagen/SVG
    if (leftIconPath != null) {
      return GestureDetector(
        onTap: onLeftTap,
        child: Container(
          margin: const EdgeInsets.all(8),
          child: leftIconPath!.endsWith('.svg')
              ? _buildSvgIcon()
              : _buildImageIcon(),
        ),
      );
    }

    // Si se proporciona un icono de Material
    if (leftIcon != null) {
      return IconButton(
        icon: Icon(
          leftIcon!,
          color: iconColor ?? AppColors.blue,
        ),
        onPressed: onLeftTap,
      );
    }

    // Por defecto, mostrar flecha atrás si hay navegación
    if (Navigator.of(context).canPop()) {
      return IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: iconColor ?? AppColors.blue,
        ),
        onPressed: onLeftTap ?? () => Navigator.of(context).pop(),
      );
    }

    return null;
  }

  Widget _buildSvgIcon() {
    // Si tienes flutter_svg instalado
    // return SvgPicture.asset(
    //   leftIconPath!,
    //   width: 24,
    //   height: 24,
    //   colorFilter: ColorFilter.mode(
    //     iconColor ?? AppColors.blue,
    //     BlendMode.srcIn,
    //   ),
    // );
    
    // Fallback si no tienes flutter_svg
    return Icon(
      Icons.image,
      color: iconColor ?? AppColors.blue,
    );
  }

  Widget _buildImageIcon() {
    return Image.asset(
      leftIconPath!,
      width: 20,
      height: 20,
      color: iconColor ?? AppColors.blue,
    );
  }

  Widget _buildLogoWidget() {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      child: Center(
        child: Lottie.asset(
          logoPath!,
          width: logoSize,
          height: logoSize,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// Ejemplos de uso del CustomAppBar

class AppBarExamples {
  
  // 1. AppBar básico con logo (para páginas principales)
  static CustomAppBar basic({String? title}) {
    return CustomAppBar(
      title: title,
      showLogo: true,
    );
  }

  // 2. AppBar con flecha atrás (para páginas secundarias)
  static CustomAppBar withBackButton({
    String? title,
    VoidCallback? onBack,
  }) {
    return CustomAppBar(
      title: title,
      leftIcon: Icons.arrow_back_ios,
      onLeftTap: onBack,
      showLogo: true,
    );
  }

  // 3. AppBar con icono personalizado
  static CustomAppBar withCustomIcon({
    String? title,
    IconData? icon,
    VoidCallback? onIconTap,
  }) {
    return CustomAppBar(
      title: title,
      leftIcon: icon,
      onLeftTap: onIconTap,
      showLogo: true,
    );
  }

  // 4. AppBar con imagen/avatar
  static CustomAppBar withImage({
    String? title,
    String? imagePath,
    VoidCallback? onImageTap,
  }) {
    return CustomAppBar(
      title: title,
      leftIconPath: imagePath,
      onLeftTap: onImageTap,
      showLogo: true,
    );
  }

  // 5. AppBar con widget completamente personalizado
  static CustomAppBar withCustomWidget({
    String? title,
    Widget? customWidget,
    VoidCallback? onWidgetTap,
  }) {
    return CustomAppBar(
      title: title,
      leftWidget: customWidget,
      onLeftTap: onWidgetTap,
      showLogo: true,
    );
  }

  // 6. AppBar sin logo (minimalista)
  static CustomAppBar withoutLogo({
    String? title,
    IconData? leftIcon,
    VoidCallback? onLeftTap,
  }) {
    return CustomAppBar(
      title: title,
      leftIcon: leftIcon,
      onLeftTap: onLeftTap,
      showLogo: false,
    );
  }

  // 7. AppBar con fondo colorido
  static CustomAppBar colored({
    String? title,
    Color? backgroundColor,
    Color? iconColor,
    Color? textColor,
  }) {
    return CustomAppBar(
      title: title,
      backgroundColor: backgroundColor ?? AppColors.blue,
      iconColor: iconColor ?? Colors.white,
      titleStyle: TextStyle(
        fontFamily: 'Airstrike',
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: textColor ?? Colors.white,
      ),
      showLogo: true,
    );
  }
}