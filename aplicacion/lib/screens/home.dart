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
      // Redirige a la pantalla de horarios
      Navigator.pushNamed(context, '/horarios');
      return;
    }
    if (index == 3) {
      final codigoAlumno = Provider.of<LoginViewModel>(context, listen: false).codigoAlumno;
      if (codigoAlumno != null && codigoAlumno.isNotEmpty) {
        Navigator.pushNamed(
          context,
          '/perfil',
          arguments: codigoAlumno,
        );
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
        return const Center(child: Text('Pantalla Principal', style: TextStyle(fontSize: 24)));
      case 1:
        return const Center(child: Text('Horario', style: TextStyle(fontSize: 24)));
      case 2:
        return const Center(child: Text('Categorías', style: TextStyle(fontSize: 24)));
      default:
        return const Center(child: Text('Pantalla no definida', style: TextStyle(fontSize: 18)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/login',
                (route) => false,
              );
            },
          ),
        ],
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
      _BarItem(icon: Icons.category, label: 'Categorías'),
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
          decoration: isSelected
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