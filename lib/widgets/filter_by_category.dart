import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_1/models/product_model.dart';

List<Product> getProductByCategory(String kJackets, List<Product> _products) {

  List<Product> products = [];
  try{
    for (var product in _products) {
      if(product.category == kJackets) {
        products.add(product);
      }
    }
  } on Error catch (e) {
    print(e);
  }

  return products;
}
