import 'package:flutter/material.dart';
import 'screens/category/categoria_screen.dart';
import 'screens/category/categoria_form_screen.dart';
import 'screens/clientes/cliente_screen.dart';
import 'screens/clientes/clientes_form_screen.dart';
import 'screens/home_screen.dart';

import 'screens/productos/producto_form_screen.dart';
import 'screens/productos/producto_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => HomeScreen(),
        '/categoria': (context) => CategoryScreen(),
        '/categoria/form': (context) => CategoryFormScreen(),
        '/producto/form': (context) => ProductoFormScreen(),
        '/cliente/form': (context) => ClienteFormScreen(),
        '/producto': (context) => ProductoScreen(),
        '/cliente': (context) => ClienteScreen(),
      },
    );
  }
}
