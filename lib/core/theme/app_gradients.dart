import 'package:flutter/material.dart';
import 'package:syncronize/core/theme/app_colors.dart';

// CLASE PARA GRADIENTES REUTILIZABLES
class AppGradients {
  // Prevenir instanciación
  AppGradients._();

  // GRADIENTE PRINCIPAL 
  static LinearGradient get fondo => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFFFFF),  // blanco
      Color(0xFFD2EDFF),  // azul claro
      Color(0xFFF8CCFF),  // rosa claro
    ],
    stops: [0.0, 0.7, 1.0],
  );

  // VARIACIONES DEL GRADIENTE PRINCIPAL
  static LinearGradient fondoVertical() => const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFFFFFF),  // blanco
      Color(0xFFD2EDFF),  // azul claro
      Color(0xFFF8CCFF),  // rosa claro
    ],
    stops: [0.0, 0.7, 1.0],
  );

  static LinearGradient fondoHorizontal() => const LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFFFFFFFF),  // blanco
      Color(0xFFD2EDFF),  // azul claro
      Color(0xFFF8CCFF),  // rosa claro
    ],
    stops: [0.0, 0.8, 1.0],
  );

 
  // GRADIENTE PERSONALIZABLE
  static LinearGradient custom({
    required Color startColor,
    required Color middleColor, 
    required Color endColor,
    Alignment begin = Alignment.topLeft,
    Alignment end = Alignment.bottomRight,
    List<double>? stops,
  }) {
    return LinearGradient(
      begin: begin,
      end: end,
      colors: [startColor, middleColor, endColor],
      stops: stops ?? [0.0, 0.7, 1.0],
    );
  }

  static LinearGradient get sinfondo => const LinearGradient(
    colors: [
    Color(0xFFFFFFFF),  // blanco
    Color(0xFFFFFFFF),  // blanco
  ],
  );
}

// EXTENSION PARA FACILITAR EL USO
extension GradientExtension on Widget {
  Widget withGradientBackground(LinearGradient gradient) {
    return Container(
      decoration: BoxDecoration(gradient: gradient),
      child: this,
    );
  }
}

class GradientContainer extends StatelessWidget {
  final Widget? child;
  final LinearGradient? gradient;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  

  final Color? borderColor;
  final double? borderWidth;
  

  final bool enableShadow;
  final List<BoxShadow>? customShadows;
  final ShadowStyle shadowStyle;

  const GradientContainer({
    super.key,
    this.child,
    this.gradient,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.borderColor = AppColors.white,
    this.borderWidth = 0.5,
    this.padding,
    this.margin,
    this.width,
    this.height,
    // Nuevas propiedades
    this.enableShadow = true,
    this.customShadows,
    this.shadowStyle = ShadowStyle.none,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        gradient: gradient ?? AppGradients.fondo,
        borderRadius: borderRadius,
        border: (borderColor != null && borderWidth != null)
          ? Border.all(color: borderColor!, width: borderWidth!)
          : null,
        boxShadow: _buildBoxShadows(),
      ),
      child: child,
    );
  }

  // MÉTODO PARA CONSTRUIR SOMBRAS
  List<BoxShadow>? _buildBoxShadows() {
    if (!enableShadow) return null;
    
    // Si hay sombras personalizadas, usarlas
    if (customShadows != null) {
      return customShadows;
    }
    
    // Generar sombras por defecto según el estilo
    return _getDefaultShadows();
  }

  // 🌟 SOMBRAS PREDEFINIDAS SEGÚN ESTILO
  List<BoxShadow> _getDefaultShadows() {
    switch (shadowStyle) {
      case ShadowStyle.none:
        return [];       
              
      case ShadowStyle.neumorphic:
        return [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            offset: const Offset(4, 4),
            blurRadius: 8,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.8),
            offset: const Offset(-4, -4),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ];
        
      case ShadowStyle.colorful:
        // Sombra basada en el color del borde
        Color shadowColor = _getColorfulShadow();
        return [
          BoxShadow(
            color: shadowColor.withValues(alpha: 0.43),
            offset: const Offset(0, 3),
            blurRadius: 4,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.18),
            offset: const Offset(-2, -2),
            blurRadius: 4,
            spreadRadius: -1,
          ),
        ];
        
      case ShadowStyle.glow:
        Color glowColor = borderColor ?? AppColors.blue;
        return [
          BoxShadow(
            color: glowColor.withValues(alpha: 0.4),
            offset: const Offset(0, 0),
            blurRadius: 2,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: glowColor.withValues(alpha: 0.2),
            offset: const Offset(0, 0),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ];
    }
  }

  // GENERAR SOMBRA COLORIDA BASADA EN BORDER COLOR
  Color _getColorfulShadow() {
    if (borderColor == null) return AppColors.blue;
    
    // Casos específicos para colores conocidos
    if (borderColor == AppColors.blue) {
      return const Color(0xFF1565C0);
    } else if (borderColor == AppColors.red) {
      return const Color(0xFFD32F2F);
    } else if (borderColor == AppColors.green) {
      return const Color(0xFF388E3C);
    } else if (borderColor == AppColors.orange) {
      return const Color(0xFFE65100);
    // } else if (borderColor == AppColors.purple) {
    //   return const Color(0xFF7B1FA2);
    } else {
      // Para cualquier otro color, generar una versión más oscura
      HSLColor hsl = HSLColor.fromColor(borderColor!);
      return HSLColor.fromAHSL(
        1.0,
        hsl.hue,
        (hsl.saturation * 0.8).clamp(0.0, 1.0),
        (hsl.lightness * 0.6).clamp(0.0, 0.8),
      ).toColor();
    }
  }
}


enum ShadowStyle {
  none,        // Sin sombra
  neumorphic,  // Estilo neumórfico
  colorful,    // Sombra colorida basada en borderColor
  glow,        // Efecto de brillo/glow
}

