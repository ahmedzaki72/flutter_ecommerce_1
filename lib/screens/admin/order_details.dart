import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_1/models/product_model.dart';
import 'package:flutter_ecommerce_1/services/store.dart';
import '../../constant.dart';

class OrderDetails extends StatelessWidget {
  static const String routeName = 'orderDetails';

  @override
  Widget build(BuildContext context) {
    String documentId = ModalRoute.of(context).settings.arguments;
    Store _store = Store();

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _store.loadingOrderDetails(documentId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Product> products = [];
            for (var doc in snapshot.data.docs) {
              final data = doc.data();
              products.add(Product(
                id: data['id'],
                name: data['name'],
                quantity: data['quantity'],
                price: data['price'],
                category: data['category'],
              ));
            }
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.all(10),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.orange[200],
                            ),
                            height: MediaQuery.of(context).size.height * 0.2,
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'product name  : ${products[index].name}',
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'quantity :  ${products[index].quantity}',
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'category : ${products[index].category}',
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: ButtonTheme(
                          buttonColor: kMainColor,
                            child: RaisedButton(
                          onPressed: () {},
                          child: Text('Confirm'),
                        ),),
                      ),
                      SizedBox(width: 10.0,),
                      Expanded(
                        child: ButtonTheme(
                            buttonColor: kMainColor,
                            child: RaisedButton(
                              onPressed: () {},
                              child: Text('Delete'),
                            )),
                      ),
                    ],
                  ),
                )
              ],
            );
          } else {
            return Center(
              child: Text(
                'Loading...',
                style: TextStyle(fontSize: 20.0, color: kMainColor),
              ),
            );
          }
        },
      ),
    );
  }
}
