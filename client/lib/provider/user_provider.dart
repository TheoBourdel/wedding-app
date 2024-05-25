import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  int userId;
  String role;

  UserProvider({this.userId = 0, this.role = ''});

  void setUserId({required int userId}) {
    this.userId = userId;
    notifyListeners();
  }

  void setUserRole({required String role}) {
    this.role = role;
    notifyListeners();
  }

  int getUserId() {
    return userId;
  }

  String getUserRole() {
    return role;
  }
}