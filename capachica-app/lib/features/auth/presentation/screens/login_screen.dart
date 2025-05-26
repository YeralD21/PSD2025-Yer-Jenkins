import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:capachica/features/auth/providers/auth_provider.dart';
import 'package:capachica/features/panels/superadmin/presentation/screens/superadmin_home_screen.dart';
import 'package:capachica/features/auth/presentation/screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Verificar si ya estamos autenticados
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.status == AuthStatus.authenticated) {
        _navigateBasedOnRole(authProvider.userRole);
      }
    });
  }

  void _navigateBasedOnRole(String? role) {
    if (role == null) return;
    
    final normalizedRole = role.toLowerCase();
    switch (normalizedRole) {
      case 'superadmin':
        Navigator.of(context).pushReplacementNamed('/superadmin');
        break;
      case 'emprendedor':
        Navigator.of(context).pushReplacementNamed('/emprendedor');
        break;
      case 'user':
        Navigator.of(context).pushReplacementNamed('/user');
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Rol de usuario no válido: $role'),
            backgroundColor: Colors.red,
          ),
        );
    }
  }

  void _handleLogin(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final authProvider = context.read<AuthProvider>();
      await authProvider.login(_emailController.text.trim(), _passwordController.text);
      
      if (!mounted) return;

      // Verificar el rol del usuario
      if (authProvider.userRole == 'superadmin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const SuperAdminHomeScreen(),
          ),
        );
      } else {
        // Navegación para otros roles
        _navigateBasedOnRole(authProvider.userRole);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final isLoading = authProvider.status == AuthStatus.authenticating;

    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio de Sesión'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo o imagen (opcional)
              Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: Icon(
                  Icons.travel_explore,
                  size: 100,
                  color: Theme.of(context).primaryColor,
                ),
              ),

              // Email field
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Correo electrónico',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu correo';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Ingresa un correo válido';
                  }
                  return null;
                },
                enabled: !isLoading,
              ),
              SizedBox(height: 16),

              // Password field
              TextFormField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu contraseña';
                  }
                  return null;
                },
                enabled: !isLoading,
              ),
              SizedBox(height: 24),

              // Login button
              ElevatedButton(
                onPressed: isLoading ? null : () => _handleLogin(context),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('INICIAR SESIÓN', style: TextStyle(fontSize: 16)),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Register link
              TextButton(
  onPressed: isLoading
      ? null
      : () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegisterScreen()),
          );
        },
  child: Text('¿No tienes cuenta? Regístrate aquí'),
),
            ],
          ),
        ),
      ),
    );
  }
}