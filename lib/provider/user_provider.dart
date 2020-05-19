import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:githubusersearch/model/user.dart';

class UserProvider extends ChangeNotifier {
  final List<User> _users = [];
  String query = "";
  int page = 1;
  UnmodifiableListView<User> get users => UnmodifiableListView(_users);

  void add(User user, {int index}) {
    final existingUser = _users.firstWhere((element) => element.id == user.id,
        orElse: () => null);
    if (existingUser == null) {
      if (index != null) {
        _users.insert(index, user);
      } else {
        _users.add(user);
      }
      notifyListeners();
    }
  }

  void reset() {
    query = "";
    page = 1;
    _users.clear();
    notifyListeners();
  }
}
