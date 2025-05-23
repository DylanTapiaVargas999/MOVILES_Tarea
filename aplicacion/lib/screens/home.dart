import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../wiewmodels/login_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  void _onTabTapped(int index) {
    if (index == 0) {
      Navigator.pushNamed(context, '/formulario');

      return;
    }
    if (index == 1) {
      Navigator.pushNamed(context, '/horarios');

      return;
    }
    if (index == 2) {
      Navigator.pushNamed(context, '/respuesta');

      return;
    }
    if (index == 3) {
      final codigoAlumno =
          Provider.of<LoginViewModel>(context, listen: false).codigoAlumno;
      if (codigoAlumno != null && codigoAlumno.isNotEmpty) {
        Navigator.pushNamed(context, '/perfil', arguments: codigoAlumno);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se encontró el código del alumno')),
        );
      }
      return;
    }
    setState(() {
      currentIndex = index;
    });
  }

  Widget _buildContent() {
    switch (currentIndex) {
      case 0:
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF003366).withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Icon(Icons.school, color: Color(0xFF003366), size: 64),
                ),
                const SizedBox(height: 28),
                Text(
                  'Bienvenido',
                  style: TextStyle(
                    fontSize: 26,
                    color: Color(0xFF003366),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Sistema de Permisos para Laboratorios',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF377CC8),
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 18),
                Text(
                  'Solicita permisos para ingresar a los diferentes laboratorios de la Facultad de Ingeniería de Sistemas de manera fácil, rápida y organizada.',
                  style: TextStyle(fontSize: 15, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      case 1:
        return const Center(
          child: Text('Horario', style: TextStyle(fontSize: 24)),
        );
      case 2:
        return const Center(
          child: Text('Respuestas', style: TextStyle(fontSize: 24)),
        );
      default:
        return const Center(
          child: Text('Pantalla no definida', style: TextStyle(fontSize: 18)),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        backgroundColor: Color(0xFF003366),
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: _buildContent(),
      bottomNavigationBar: _CustomBottomBar(
        currentIndex: currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}

class _CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _CustomBottomBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final items = [
      _BarItem(icon: Icons.home, label: 'Inicio'),
      _BarItem(icon: Icons.schedule, label: 'Horario'),
      _BarItem(icon: Icons.assignment_turned_in, label: 'Respuestas'),
      _BarItem(icon: Icons.person, label: 'Perfil'),
    ];

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            items.length,
            (index) => _buildNavIcon(items[index], index),
          ),
        ),
      ),
    );
  }

  Widget _buildNavIcon(_BarItem item, int index) {
    final isSelected = currentIndex == index;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => onTap(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration:
              isSelected
                  ? BoxDecoration(
                    color: const Color(0xFF377CC8).withOpacity(0.10),
                    borderRadius: BorderRadius.circular(16),
                  )
                  : null,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                item.icon,
                color: isSelected ? const Color(0xFF377CC8) : Colors.black26,
                size: isSelected ? 28 : 24,
              ),
              const SizedBox(height: 2),
              Text(
                item.label,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                  fontSize: 12,
                  color: isSelected ? const Color(0xFF377CC8) : Colors.black38,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BarItem {
  final IconData icon;
  final String label;
  const _BarItem({required this.icon, required this.label});
}
