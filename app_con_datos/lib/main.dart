import 'package:app_con_datos/screens/gastos/lista_gastos.dart';
import 'package:flutter/material.dart';
import 'screens/category/categoria_screen.dart';
import 'screens/category/categoria_form_screen.dart';
import 'screens/clientes/cliente_screen.dart';
import 'screens/clientes/clientes_form_screen.dart';
import 'screens/gastos/gastos_form.dart';
import 'screens/home_screen.dart';
import 'screens/productos/producto_form_screen.dart';
import 'screens/productos/producto_screen.dart';
import 'screens/providers/providers_form_screen.dart';
import 'screens/providers/provider_screen.dart';
//compras
import 'screens/compras/compra_screen.dart';
import 'screens/compras/compra_form_screen.dart';

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
        '/provider': (context) => ProviderScreen(),
        '/provider/form': (context) => ProvidersFormScreen(),
        '/cliente': (context) => ClienteScreen(),
        '/lista_gastos': (context) => GastoScreen(),
        '/gastos/form': (context) => GastoFormScreen(),
        //compras
        '/compras': (context) => CompraScreen(),
        '/compra/form': (context) => CompraFormScreen(),
      },
    );
  }
}
