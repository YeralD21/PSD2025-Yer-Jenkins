import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Perfil')),
      body: provider.profile == null
          ? Center(child: CircularProgressIndicator())
          : ListTile(
              title: Text(provider.profile!.name),
              subtitle: Text(provider.profile!.email),
            ),
    );
  }
}