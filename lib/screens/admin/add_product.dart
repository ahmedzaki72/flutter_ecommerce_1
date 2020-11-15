import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_1/models/product_model.dart';
import 'package:flutter_ecommerce_1/services/store.dart';
import 'package:flutter_ecommerce_1/widgets/custom_text_field.dart';

class AddProduct extends StatelessWidget {
  static const String routeName = 'addProductScreen';
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _name;
  String _price;
  String _description;
  String _category;
  String _location;
  final _store = Store();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomField(
              hint: 'product Name',
              onSave: (value) {
                _name = value;
              },
              onPress: (value) {
                if (value.isEmpty || value.length <= 2) {
                  return 'please enter product name';
                }
                return null;
              },
            ),
            SizedBox(
              height: 10.0,
            ),
            CustomField(
              hint: 'product Price',
              onSave: (value) {
                _price = value;
              },
              onPress: (value) {
                if (value.isEmpty) {
                  return 'please enter price product';
                }
                return null;
              },
            ),
            SizedBox(
              height: 10.0,
            ),
            CustomField(
              hint: 'product Description',
              onSave: (value) {
                _description = value;
              },
              onPress: (value) {
                if (value.isEmpty || value.length <= 5) {
                  return 'please enter description greater then 5 character';
                }
                return null;
              },
            ),
            SizedBox(
              height: 10.0,
            ),
            CustomField(
              hint: 'product Category',
              onSave: (value) {
                _category = value;
              },
              onPress: (value) {
                if (value.isEmpty) {
                  return 'please enter category name';
                }
                return null;
              },
            ),
            SizedBox(
              height: 10.0,
            ),
            CustomField(
              hint: 'product Location',
              onSave: (value) {
                _location = value;
              },
              onPress: (value) {
                if (value.isEmpty) {
                  return 'please enter images url';
                }
                return null;
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            RaisedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  _store.addUser(
                    Product(
                      name: _name,
                      price: _price,
                      description: _description,
                      category: _category,
                      location: _location,
                    ),
                  );
                }
              },
              child: Text(
                'Add Product',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
