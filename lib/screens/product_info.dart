import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_ecommerce_1/constant.dart';
import 'package:flutter_ecommerce_1/models/product_model.dart';
import 'package:flutter_ecommerce_1/provider/cartItem_provider.dart';
import 'package:flutter_ecommerce_1/screens/cart_screen.dart';
import 'package:provider/provider.dart';

class ProductInfo extends StatefulWidget {
  static const String routeName = 'productInfo';
  @override
  _ProductInfoState createState() => _ProductInfoState();
}

class _ProductInfoState extends State<ProductInfo> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    Product product = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image(
              fit: BoxFit.fill,
              image: AssetImage(product.location),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(Icons.arrow_back_ios),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).pushNamed(CartScreen.routeName);
                    },
                    child: Icon(Icons.shopping_cart),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.3,
                  color: Colors.white.withOpacity(0.5),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        ),
                        Text(product.description,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black45)),
                        Text('\$${product.price}',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black45)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipOval(
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: kMainColor,
                                ),
                                width: MediaQuery.of(context).size.width * 0.3,
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
                                child: GestureDetector(
                                  onTap: () {
                                    add();
                                  },
                                  child: Icon(Icons.add),
                                ),
                              ),
                            ),
                            Text(
                              '$_quantity',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            ClipOval(
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: kMainColor,
                                ),
                                width: MediaQuery.of(context).size.width * 0.3,
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
                                child: GestureDetector(
                                  onTap: () {
                                    subtract();
                                  },
                                  child: Icon(Icons.remove),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                ButtonTheme(
                  minWidth: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                    ),
                    onPressed: () {
                      CartItem cartItem =
                          Provider.of<CartItem>(context, listen: false);
                      product.quantity = _quantity;
                      bool exist = false;
                      for(var productInCart in cartItem.products ) {
                        if(productInCart.id == product.id) {
                          exist = true;
                        }
                      }
                      if(exist) {
                        _scaffoldKey.currentState.showSnackBar(
                          SnackBar(
                            content: Text('you\'ve added this product in cart item.'),
                          ),
                        );
                      }else {
                        cartItem.addProduct(product);
                        _scaffoldKey.currentState.showSnackBar(
                          SnackBar(
                            content: Text('Adding Item'),
                          ),
                        );
                      }
                    },
                    child: Text(
                      'Add to Cart'.toUpperCase(),
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    color: kMainColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void subtract() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  void add() {
    setState(() {
      _quantity++;
    });
  }
}
