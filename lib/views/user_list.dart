import 'package:flutter/material.dart';
import 'package:flutter_crud/components/user_tile.dart';
import 'package:flutter_crud/models/user.dart';
import 'package:flutter_crud/provider/users.dart';
import 'package:flutter_crud/routes/app_routes.dart';
import 'package:provider/provider.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();

  List<User> userList;
}

class _UserListState extends State<UserList> {
  @override
  initState() {
    super.initState();
    var loadedUsers = getAll();
    setState(() {
      widget.userList = loadedUsers;
    });
  }

  List<User> getAll() {
    var teste = Provider.of<Users>(context).all;

    return teste;
  }

  @override
  Widget build(BuildContext context) {
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
      body: ListView.builder(
        itemCount: widget.userList.length,
        itemBuilder: (ctx, i) => UserTile(widget.userList[i]),
      ),
    );
  }
}
