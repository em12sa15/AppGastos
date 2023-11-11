import 'package:flutter/material.dart';
import 'package:mi_app_gastos/presentation/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'AppGastos',
          style: TextStyle(color: Colors.red),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Login',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                FocusScope.of(context).unfocus(); 

                if (_usernameController.text.trim().isEmpty || _passwordController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Por favor, ingrese tanto el nombre de usuario como la contraseña.'),
                    ),
                  );
                  return;
                }

                // Verificar si el nombre de usuario y la contraseña son válidos
                if (_usernameController.text.trim() == "em12sa15@gmail.com" && _passwordController.text.trim() == "123") {
                  try {
                    // Autenticación de usuario con Firebase Auth
                    await _auth.signInWithEmailAndPassword(
                      email: _usernameController.text.trim() + "@example.com",
                      password: _passwordController.text.trim(),
                    );

                    // Si la autenticación es exitosa, navega a la pantalla de chat
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => ChatScreen()),
                    );
                  } catch (e) {
                    // Manejo de errores
                    if (e is FirebaseAuthException) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error de autenticación: ${e.message}'),
                        ),
                      );
                    } else {
                      print('Error desconocido: $e');
                    }
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Nombre de usuario o contraseña incorrectos.'),
                    ),
                  );
                }
              },
              child: Text('Iniciar Sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
