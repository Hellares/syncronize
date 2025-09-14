import 'package:flutter/material.dart';
import 'package:syncronize/src/domain/models/empresa.dart';

class EmpresaCard extends StatelessWidget {
  final Empresa empresa;

  const EmpresaCard({super.key, required this.empresa});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: _getEstadoColor(empresa.estado),
          child: Text(
            empresa.razonSocial.substring(0, 1).toUpperCase(),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          empresa.razonSocial,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('RUC: ${empresa.ruc}'),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getEstadoColor(empresa.estado).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    empresa.estado,
                    style: TextStyle(
                      color: _getEstadoColor(empresa.estado),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 4,
              children: empresa.roles
                  .map((role) => Chip(
                        label: Text(
                          role,
                          style: const TextStyle(fontSize: 10),
                        ),
                        backgroundColor: Colors.blue.shade100,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ))
                  .toList(),
            ),
          ],
        ),
        onTap: () {
          // Navegar a detalles de empresa o seleccionarla
          _selectEmpresa(context, empresa);
        },
      ),
    );
  }

  Color _getEstadoColor(String estado) {
    switch (estado.toUpperCase()) {
      case 'ACTIVO':
        return Colors.green;
      case 'EN_REVISION':
        return Colors.orange;
      case 'INACTIVO':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _selectEmpresa(BuildContext context, Empresa empresa) {
    // Implementar lógica para seleccionar empresa
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(empresa.razonSocial),
        content: Text('¿Deseas trabajar con esta empresa?\nRUC: ${empresa.ruc}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Guardar empresa seleccionada y navegar
              _saveSelectedEmpresa(empresa);
            },
            child: const Text('Seleccionar'),
          ),
        ],
      ),
    );
  }

  void _saveSelectedEmpresa(Empresa empresa) {
    // Implementar guardado de empresa seleccionada
    // Navegar a la siguiente pantalla
  }
}