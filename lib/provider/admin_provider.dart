import 'package:flutter/material.dart';

class AdminProvider with ChangeNotifier {

  bool isAdmin = false;

  changeIsAdmin(bool value) {
    isAdmin = value;
    notifyListeners();
  }
}