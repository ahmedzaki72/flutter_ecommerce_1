import 'package:flutter/material.dart';

class ModalProvider with ChangeNotifier {

  bool isLoading = false;

  changeIsLoading (bool value) {
    isLoading = value;
    notifyListeners();
  }
}