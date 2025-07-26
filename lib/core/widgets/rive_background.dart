import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'dart:ui';

// Widget reutilizable para fondo Rive
class RiveBackground extends StatelessWidget {
  final Widget child;
  final String? riveAsset;
  final double blurX;
  final double blurY;
  final Color? overlayColor;
  final double overlayOpacity;

  const RiveBackground({
    super.key,
    required this.child,
    this.riveAsset = 'assets/animations/logorive8.riv',
    this.blurX = 20,
    this.blurY = 20,
    this.overlayColor,
    this.overlayOpacity = 0.3,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Animación Rive de fondo
        Positioned.fill(
          child: RiveAnimation.asset(
            riveAsset!,
            fit: BoxFit.cover,
            onInit: (artboard) {
              // Intentar usar State Machine primero
              if (artboard.stateMachines.isNotEmpty) {
                final controller = StateMachineController.fromArtboard(
                  artboard,
                  artboard.stateMachines.first.name,
                );
                if (controller != null) {
                  artboard.addController(controller);
                  return;
                }
              }
              
              // Si no hay State Machine, usar animaciones simples
              if (artboard.animations.isNotEmpty) {
                final animation = artboard.animations.firstWhere(
                  (anim) => anim.name.toLowerCase().contains('onboard'),
                  orElse: () => artboard.animations.first,
                );
                artboard.addController(SimpleAnimation(animation.name));
              }
            },
          ),
        ),
        
        // Filtro de desenfoque (blur)
        if (blurX > 0 || blurY > 0)
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: blurX, sigmaY: blurY),
              child: SizedBox(),
            ),
          ),
        
        // Contenido de la pantalla
        child,
      ],
    );
  }
}