import 'package:flutter/material.dart';
import 'package:mi_app_gastos/presentation/gasto_categoria.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Gastos',
      home: GastosScreen(),
    );
  }
}
