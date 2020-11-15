import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_1/constant.dart';
import 'package:flutter_ecommerce_1/screens/admin/add_product.dart';
import 'package:flutter_ecommerce_1/screens/admin/manage_product.dart';
import 'package:flutter_ecommerce_1/screens/admin/order_screen.dart';

class AdminScreen extends StatelessWidget {
  static const String routeName = 'adminScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'This is Admin',
            style: TextStyle(
              fontSize: 30.0,
            ),
          ),
          SizedBox(
            width: double.infinity,
          ),
          RaisedButton(
            onPressed: () {
              Navigator.pushNamed(context, AddProduct.routeName);
            },
            child: Text('Add Product'),
          ),
          RaisedButton(
            onPressed: () {
              Navigator.pushNamed(context, ManageProduct.routeName);
            },
            child: Text('Manage Product'),
          ),
          RaisedButton(
            onPressed: () {
              Navigator.of(context).pushNamed(OrderScreen.routeName);
            },
            child: Text('View Product'),
          ),
        ],
      ),
    );
  }
}
