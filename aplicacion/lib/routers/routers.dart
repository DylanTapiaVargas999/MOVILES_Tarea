import 'package:aplicacion/screens/reserva.dart';
import 'package:flutter/material.dart';
import '../screens/login.dart';
import '../screens/register.dart';
import '../screens/home.dart';
import '../screens/perfil.dart';
import '../screens/horarios.dart';
import '../screens/soporte/soporte_screen.dart';
import '../screens/admin/admin_screen.dart';

class AppRouters {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case '/register':
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case '/formulario':
        return MaterialPageRoute(builder: (_) => SeleccionarReservaScreen());
      case '/perfil':
        final codigoAlumno = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => PerfilScreen(codigoAlumno: codigoAlumno),
        );
      case '/horarios':
        return MaterialPageRoute(builder: (_) => HorariosScreen());
      case '/soporte':
        return MaterialPageRoute(builder: (_) => SoporteScreen());
      case '/admin':
        return MaterialPageRoute(builder: (_) => AdminScreen());
      default:
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(
                body: Center(
                  child: Text('Ruta no encontrada: ${settings.name}'),
                ),
              ),
        );
    }
  }
}
