import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'wiewmodels/login_viewmodel.dart';
import 'wiewmodels/register_viewmodel.dart';
import 'wiewmodels/horarios.viewmodel.dart';
import 'wiewmodels/formulario_reserva_viewmodel.dart';
import 'wiewmodels/perfil_viewmodel.dart';
import 'routers/routers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => RegisterViewModel()),
        ChangeNotifierProvider(create: (_) => HorariosViewModel()),
        ChangeNotifierProvider(create: (_) => ReservaViewModel()),
        ChangeNotifierProvider(create: (_) => PerfilViewModel()),
      ],
      child: MaterialApp(
        title: 'Sistema de Reservas',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/login',
        onGenerateRoute: AppRouters.generateRoute,
      ),
    );
  }
}
