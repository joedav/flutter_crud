import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_crud/data/dummy_users.dart';
import 'package:flutter_crud/models/user.dart';

class Users with ChangeNotifier {
  Map<String, User> _items = {...DUMMY_USERS};

  List<User> get all {
    return [..._items.values];
  }

  int get count {
    return _items.length;
  }

  User byIndex(int i) {
    return _items.values.elementAt(i);
  }

  void put(User user) {
    if (user != null) {
      if (user.id != null &&
          user.id.isNotEmpty &&
          _items.containsKey(user.id)) {
        // alterar

        _items.update(user.id, (_) => user);
      } else {
        // adicionar
        String id = Random().nextDouble().toString();

        _items.putIfAbsent(
          id,
          () => User(
              id: id,
              name: user.name,
              email: user.email,
              avatarUrl: user.avatarUrl),
        );
      }

      notifyListeners();
    }
  }

  void remove(User user) {
    if (user != null && user.id != null && user.id.trim().isNotEmpty) {
      _items.remove(user.id);
    }

    notifyListeners();
  }
}
