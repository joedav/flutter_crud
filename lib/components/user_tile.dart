import 'package:flutter/material.dart';
import 'package:flutter_crud/models/user.dart';
import 'package:flutter_crud/provider/users.dart';
import 'package:flutter_crud/routes/app_routes.dart';
import 'package:provider/provider.dart';

class UserTile extends StatelessWidget {
  final User user;

  const UserTile(this.user);

  @override
  Widget build(BuildContext context) {
    final avatar = user.avatarUrl == null || user.avatarUrl.isEmpty
        ? CircleAvatar(
            child: Icon(Icons.person_rounded),
          )
        : CircleAvatar(
            backgroundImage: NetworkImage(user.avatarUrl),
          );

    return ListTile(
      leading: avatar,
      title: Text(user.name),
      subtitle: Text(user.email),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit_rounded),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(AppRoutes.USER_FORM, arguments: user);
              },
              color: Colors.green,
            ),
            IconButton(
              icon: Icon(Icons.delete_forever_rounded),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text('Confirmação de exclusão'),
                    content: Text("Tem certeza que deseja excluir o usuário: ${user.name}"),
                    actions: <Widget>[
                      TextButton(
                        child: Text('Sim'),
                        onPressed: () => Navigator.of(context).pop(true),
                      ),
                      TextButton(
                        child: Text('Não'),
                        onPressed: () => Navigator.of(context).pop(false),
                      ),
                    ],
                  ),
                ).then(
                  (confirmation) {
                    if (confirmation) {
                      Provider.of<Users>(context, listen: false).remove(user);
                    }
                  },
                );
              },
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
