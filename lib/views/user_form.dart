import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud/models/user.dart';
import 'package:flutter_crud/provider/users.dart';
import 'package:provider/provider.dart';

class UserForm extends StatefulWidget {
  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _form = GlobalKey<FormState>();

  final Map<String, String> _formData = {};

  void _loadUser(User user) {
    if (user != null && user.id.isNotEmpty && user.id != null) {
      _formData['id'] = user.id;
      _formData['name'] = user.name;
      _formData['email'] = user.email;
      _formData['avatarUrl'] = user.avatarUrl;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final User user = ModalRoute.of(context).settings.arguments;
    if (user != null) _loadUser(user);
  }

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    var avatar;
    if (_formData.containsKey('avatarUrl') &&
        _formData['avatarUrl'].isNotEmpty &&
        _formData['avatarUrl'] != '') {
      avatar = NetworkImage(_formData['avatarUrl']);
    } else {
      avatar = AssetImage('assets/smiley.png');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Form Usuário'),
        actions: [
          IconButton(
            icon: Icon(Icons.save_outlined),
            onPressed: () async {
              final bool isValid = _form.currentState.validate();

              if (isValid) {
                _form.currentState.save();

                setState(() {
                  _isLoading = true;
                });

                await Provider.of<Users>(context, listen: false).put(
                  User(
                    id: _formData['id'],
                    name: _formData['name'],
                    email: _formData['email'],
                    avatarUrl: _formData['avatarUrl'],
                  ),
                );

                setState(() {
                  _isLoading = false;
                });

                Navigator.of(context).pop();
              }
            },
            color: Colors.cyan,
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _formData['name'],
                      decoration: InputDecoration(
                        labelText: 'Nome',
                      ),
                      validator: (value) {
                        if (value.isEmpty || value == null || value == '')
                          return "Nome inválido";
                        if (value.length < 3)
                          return 'Nome deve conter no mínimo 3 caracteres';

                        return null;
                      },
                      onSaved: (value) {
                        _formData['name'] = value;
                      },
                    ),
                    TextFormField(
                      initialValue: _formData['email'],
                      decoration: InputDecoration(labelText: 'Email'),
                      validator: (value) {
                        if (value.isEmpty || value == null || value == '')
                          return "Email inválido";
                        if (value.length < 7 ||
                            !value.contains('@') ||
                            !value.contains('.'))
                          return 'Email deve conter @ e .';

                        return null;
                      },
                      onSaved: (value) {
                        _formData['email'] = value;
                      },
                    ),
                    TextFormField(
                      initialValue: _formData['avatarUrl'],
                      decoration: InputDecoration(labelText: 'Avatar Url'),
                      onSaved: (value) {
                        _formData['avatarUrl'] = value;
                      },
                    ),
                    Image(
                      image: avatar,
                      width: 250,
                      height: 250,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
