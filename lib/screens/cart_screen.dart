import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ecommerce_1/constant.dart';
import 'package:flutter_ecommerce_1/models/product_model.dart';
import 'package:flutter_ecommerce_1/provider/cartItem_provider.dart';
import 'package:flutter_ecommerce_1/screens/product_info.dart';
import 'package:flutter_ecommerce_1/services/store.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  static const String routeName = 'cartScreen';

  @override
  Widget build(BuildContext context) {
    List<Product> products = Provider.of<CartItem>(context).products;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double appBarHeight = AppBar().preferredSize.height;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: Text(
          'MyCart',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          LayoutBuilder(
            builder: (context, constrains) {
              if (products.isNotEmpty) {
                return Container(
                  height: screenHeight -
                      (screenHeight * 0.07) -
                      appBarHeight -
                      statusBarHeight,
                  child: ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: Card(
                          child: ListTile(
                              onTap: () {
                                print('working');
                              },
                              tileColor: Colors.orange[100],
                              leading: CircleAvatar(
                                backgroundImage:
                                    AssetImage(products[index].location),
                              ),
                              title: Text(products[index].name),
                              subtitle: Text(products[index].price),
                              trailing: Column(
                                children: [
                                  Text(products[index].quantity.toString()),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      Provider.of<CartItem>(context,
                                              listen: false)
                                          .deleteProduct(products[index]);
                                      Navigator.of(context).pushNamed(
                                          ProductInfo.routeName,
                                          arguments: products[index]);
                                    },
                                    child: Icon(
                                      Icons.edit,
                                      size: 15.0,
                                      color: Colors.green,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Provider.of<CartItem>(context,
                                              listen: false)
                                          .deleteProduct(products[index]);
                                    },
                                    child: Icon(
                                      Icons.delete,
                                      size: 15.0,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      );
                    },
                  ),
                );
              } else {
                return Container(
                  height: screenHeight -
                      (screenHeight * 0.07) -
                      appBarHeight -
                      statusBarHeight,
                  child: Center(
                    child: Text('Not have any order.'),
                  ),
                );
              }
            },
          ),
          ButtonTheme(
            minWidth: screenWidth,
            height: screenHeight * 0.07,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10.0),
                  topLeft: Radius.circular(10.0)),
            ),
            child: RaisedButton(
              onPressed: () {
                showCustomDialog(context, products);
              },
              color: kMainColor,
              child: Text(
                'order'.toUpperCase(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> showCustomDialog(context , List<Product> products) async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
        double totalPrice = getTotalPrice(products);
          return AlertDialog(
            title: Text('Total price = \$ $totalPrice'),
            content: Text('Confirm Order Now.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  try{
                    Store _store = Store();
                    _store.storeOrder({
                      kTotalPrice : totalPrice
                    }, products);
                    Navigator.of(context).pop();
                  }catch (e) {
                    print(e.message);
                  }
                },
                child: Text('OK'),
              ),
            ],
          );
        });
  }

  getTotalPrice(List<Product> products) {
    double price = 0;
    for(var product in products) {
      price += product.quantity * double.parse(product.price);
    }
    return price;
  }

}
