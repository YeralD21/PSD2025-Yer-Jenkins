import 'package:capachica/features/auth/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _data = {};

  _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime(1990),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (date != null) setState(() => _data['fechaNacimiento'] = date);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nombre'),
                onSaved: (v) => _data['nombre'] = v,
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Apellidos'),
                onSaved: (v) => _data['apellidos'] = v,
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Teléfono'),
                keyboardType: TextInputType.phone,
                onSaved: (v) => _data['telefono'] = v,
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Dirección'),
                onSaved: (v) => _data['direccion'] = v,
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Foto URL'),
                onSaved: (v) => _data['fotoPerfilUrl'] = v,
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(_data['fechaNacimiento'] == null
                        ? 'Fecha de nacimiento'
                        : (_data['fechaNacimiento'] as DateTime)
                        .toLocal()
                        .toString()
                        .split(' ')[0]),
                  ),
                  TextButton(
                    onPressed: _selectDate,
                    child: Text('Seleccionar'),
                  )
                ],
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Subdivision ID'),
                keyboardType: TextInputType.number,
                onSaved: (v) => _data['subdivisionId'] = int.tryParse(v!),
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                onSaved: (v) => _data['email'] = v,
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                onSaved: (v) => _data['password'] = v,
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              SizedBox(height: 20),
              auth.status == AuthStatus.authenticating
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final success = await auth.register(
                      nombre: _data['nombre'],
                      apellidos: _data['apellidos'],
                      telefono: _data['telefono'],
                      direccion: _data['direccion'],
                      fotoPerfilUrl: _data['fotoPerfilUrl'],
                      fechaNacimiento: _data['fechaNacimiento'],
                      subdivisionId: _data['subdivisionId'],
                      email: _data['email'],
                      password: _data['password'],
                    );
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Usuario registrado exitosamente'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(auth.errorMessage ?? 'Error en el registro'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}