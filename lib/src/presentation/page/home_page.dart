import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Página de inicio"),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          '¡Bienvenido a la página de inicio!',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
} 