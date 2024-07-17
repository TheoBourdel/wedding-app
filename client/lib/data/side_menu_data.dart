import 'package:client/model/menu_model.dart';
import 'package:flutter/material.dart';

class SideMenuData {
  final menu = const <MenuModel>[
    MenuModel(icon: Icons.home, title: 'Dashboard'),
    MenuModel(icon: Icons.person, title: 'Categorie'),
    MenuModel(icon: Icons.people, title: 'Utilisateurs'),
    MenuModel(icon: Icons.history, title: 'Historique'),
    MenuModel(icon: Icons.file_open, title: 'Logs'),
    MenuModel(icon: Icons.logout, title: 'SignOut'),
  ];
}