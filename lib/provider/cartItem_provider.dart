import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_1/models/product_model.dart';

class CartItem extends ChangeNotifier {

  List<Product>  products = [];

  addProduct(Product product) {
    products.add(product);
    notifyListeners();
  }
  deleteProduct(Product product) {
    products.remove(product);
    notifyListeners();
  }
}