import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ecommerce_1/constant.dart';
import 'package:flutter_ecommerce_1/models/order_modal.dart';
import 'package:flutter_ecommerce_1/screens/admin/order_details.dart';
import 'package:flutter_ecommerce_1/services/store.dart';

class OrderScreen extends StatelessWidget {
  static const String routeName = "orderScreen";
  Store _store = Store();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _store.loadingOrder(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text('there is no order'),
            );
          } else {
            List<Order> orders = [];
            for (var doc in snapshot.data.docs) {
              final data = doc.data();
              orders.add(Order(
                id: doc.documentID,
                totalPrice: data[kTotalPrice],
              ));
            }
            return ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.all(10),
                    child: GestureDetector(
                      onTap: (){
                        Navigator.of(context).pushNamed(OrderDetails.routeName, arguments: orders[index].id );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.orange[200],
                        ),
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Price = \$${orders[index].totalPrice}',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                });
          }
        },
      ),
    );
  }
}
