import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_1/models/product_model.dart';
import 'package:flutter_ecommerce_1/services/store.dart';
import 'package:flutter_ecommerce_1/widgets/custom_text_field.dart';


class EditProduct extends StatefulWidget {
  static const String routeName = 'editProduct';

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _controllerName = TextEditingController();

  TextEditingController _controllerPrice = TextEditingController();

  TextEditingController _controllerDescription = TextEditingController();

  TextEditingController _controllerCategory = TextEditingController();

  TextEditingController _controllerLocation = TextEditingController();

  String _name;

  String _price;

  String _description;

  String _category;

  String _location;

  final _store = Store();


  @override
  void didUpdateWidget(covariant EditProduct oldWidget) {
    setState(() {
      Product product = ModalRoute.of(context).settings.arguments;
      _controllerName.text = product.name;
      _controllerPrice.text = product.price;
      _controllerDescription.text = product.description;
      _controllerCategory.text = product.category;
      _controllerLocation.text = product.location;
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controllerName.dispose();
    _controllerPrice.dispose();
    _controllerDescription.dispose();
    _controllerCategory.dispose();
    _controllerLocation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Product product = ModalRoute.of(context).settings.arguments;
     print(product);
    return Scaffold(
      // resizeToAvoidBottomPadding: true, // this feature if i give the false
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomField(
              controllerS: _controllerName,
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
              controllerS: _controllerPrice,
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
              controllerS: _controllerDescription,
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
              controllerS: _controllerCategory,
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
              controllerS: _controllerLocation,
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
                  _store.editProduct({
                    'productName' : _name,
                    'productPrice' : _price,
                    'productDescription' : _description,
                    'productCategory' : _category,
                    'productLocation' : _location,
                  }, product.id);
                }
                Navigator.of(context).pop();
              },
              child: Text(
                'Update Product',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

