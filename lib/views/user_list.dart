import 'package:flutter/material.dart';
import 'package:flutter_crud/components/user_tile.dart';
import 'package:flutter_crud/models/user.dart';
import 'package:flutter_crud/provider/users.dart';
import 'package:flutter_crud/routes/app_routes.dart';
import 'package:provider/provider.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();

  bool isLoading = false;
}

class _UserListState extends State<UserList> {
  @override
  initState() {
    super.initState();
    setState(() {
      widget.isLoading = true;
    });
    Provider.of<Users>(context, listen: false).loadUsers().then((value) => {
          setState(() {
            widget.isLoading = false;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    Users provider = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de usuários'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.USER_FORM);
            },
            color: Colors.cyan,
          )
        ],
      ),
      body: widget.isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: provider.count,
              itemBuilder: (ctx, i) => UserTile(provider.all[i]),
            ),
    );
  }
}
