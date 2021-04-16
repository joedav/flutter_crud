import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:flutter_crud/data/dummy_users.dart';
import 'package:flutter_crud/models/user.dart';
import 'package:http/http.dart' as http;

class Users with ChangeNotifier {
  String _baseUrl = "https://flutter-crud-teste-default-rtdb.firebaseio.com/";

  Map<String, User> _items = {/*...DUMMY_USERS*/};

  List<User> get all {
    //final usersBackend = getAll();
    //_items.addAll(usersBackend);

    return [..._items.values];
  }

  Future<void> loadUsers() async {
    final response = await http.get(Uri.parse("$_baseUrl/users.json"));
    Map<String, dynamic> data = json.decode(response.body);
    data.forEach((userId, userData) {
      _items.addAll({
        userId: User(
          id: userId,
          name: userData["name"],
          email: userData["email"],
          avatarUrl: userData["avatarUrl"],
        )
      });
    });
  }

  // FutureOr<Map<String, User>> getAll() async {
  //   final response = await http.get(Uri.parse("$_baseUrl/users.json"),
  //       headers: {"Accept": "application/json"});
  //   final Map<dynamic, dynamic> convertDataToJson =
  //       json.decode(response.body) as Map<String, dynamic>;
  //   Map<String, User> users = {};

  //   convertDataToJson.forEach((key, value) {
  //     users.addAll(
  //       {
  //         key: User(
  //           id: key,
  //           name: value["name"],
  //           email: value["email"],
  //           avatarUrl: value["avatarUrl"],
  //         ),
  //       },
  //     );
  //   });

  //   return users;
  // }

  int get count {
    return _items.length;
  }

  User byIndex(int i) {
    return _items.values.elementAt(i);
  }

  Future<void> put(User user) async {
    if (user != null) {
      if (user.id != null &&
          user.id.isNotEmpty &&
          _items.containsKey(user.id)) {
        // alterar
        var uriPatch = Uri.parse("$_baseUrl/users/${user.id}/.json");
        await http.patch(
          uriPatch,
          body: json.encode(
            {
              "name": user.name,
              "email": user.email,
              "avatarUrl": user.avatarUrl
            },
          ),
        );
        _items.update(user.id, (_) => user);
      } else {
        var uriPost = Uri.parse("$_baseUrl/users.json");
        final response = await http.post(
          uriPost,
          body: json.encode(
            {
              "name": user.name,
              "email": user.email,
              "avatarUrl": user.avatarUrl
            },
          ),
        );

        final id = json.decode(response.body)["name"];
        print(json.decode(response.body));

        _items.putIfAbsent(
          id,
          () => User(
            id: id,
            name: user.name,
            email: user.email,
            avatarUrl: user.avatarUrl,
          ),
        );
      }

      notifyListeners();
    }
  }

  void remove(User user) async {
    if (user != null && user.id != null && user.id.trim().isNotEmpty) {
      Uri uriDelete = Uri.parse("$_baseUrl/users/${user.id}.json");
      await http.delete(uriDelete);
      _items.remove(user.id);
    }

    notifyListeners();
  }
}
