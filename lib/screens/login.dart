import 'package:flutter/material.dart';
import 'package:appgastos/models/expense.dart';
import 'package:appgastos/screens/expense_create.dart'; 

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true; // Para controlar si la contraseña está oculta o no

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Inicio de sesión',
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nombre de usuario',
                  filled: true,
                  fillColor: Colors.white,
                ),
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                obscureText: _obscurePassword,
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ExpenseCreateForm()),
                  );
                },
                child: Text(
                  'Iniciar sesión',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.deepPurple,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
