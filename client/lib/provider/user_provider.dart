import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  int userId;

  UserProvider({this.userId = 0});

  void setUserId({required int userId}) {
    this.userId = userId;
    notifyListeners();
  }

  int getUserId() {
    return userId;
  }
}