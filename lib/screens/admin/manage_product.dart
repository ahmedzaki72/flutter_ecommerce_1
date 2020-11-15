import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ecommerce_1/constant.dart';
import 'package:flutter_ecommerce_1/models/product_model.dart';
import 'package:flutter_ecommerce_1/screens/admin/edit_product.dart';
import 'package:flutter_ecommerce_1/services/store.dart';

class ManageProduct extends StatefulWidget {
  static const String routeName = 'manageProduct';
  @override
  _ManageProductState createState() => _ManageProductState();
}

class _ManageProductState extends State<ManageProduct> {
  final _store = Store();

  // @override
  // void initState() {
  //   super.initState();
  //   getListProduct();
  //   print(products);
  // }
  //
  // void getListProduct() async{
  //    products = await _store.loadingProduct();
  // }
  /// i will using feature builder using this widget when i have data from server and i want this data a pear when get from server

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _store.loadingProduct(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            List<Product> products = [];
            for (var doc in snapshot.data.docs) {
              final data = doc.data();
              products.add(Product(
                id:doc.id,
                name: data[kProductName],
                price: data[kProductPrice],
                description: data[kProductDescription],
                category: data[kProductCategory],
                location: data[kProductLocation],
              ));
            }

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,

                /// using this method when if i want height greater than width i will value < 1 , and when i want width greater then height value > 1
              ),
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  child: GestureDetector(
                    onTapUp: (details) {
                      double dx =
                          details.globalPosition.dx; // this give me space left,
                      double dy =
                          details.globalPosition.dy; // this give me space top,
                      double dx2 = MediaQuery.of(context).size.width -
                          dx; // this give me space right.
                      double dy2 = MediaQuery.of(context).size.width -
                          dy; // this give me space bottom.
                      showMenu(
                        context: context,
                        position: RelativeRect.fromLTRB(dx, dy, dx2, dy2),
                        items: [
                          MyPopupMenuItem(
                             child: Text('Editing'),
                            onClick: (){
                               Navigator.of(context).pushNamed(EditProduct.routeName, arguments: products[index]);
                            },
                          ),
                          MyPopupMenuItem(
                            child: Text('Deleting'),
                            onClick: () {
                              _store.deletingProduct(products[index].id);
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    offset: Offset(0, 2),
                                    blurRadius: 4.0,
                                  )
                                ]),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Image(
                                fit: BoxFit.fill,
                                image: AssetImage(products[index].location),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 30.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(20.0),
                                bottomLeft: Radius.circular(20.0),
                              ),
                              color: Colors.white.withOpacity(0.6),
                            ),
                            width: MediaQuery.of(context).size.width,
                            height: 60.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${products[index].name}'),
                                Text('\$${products[index].price}'),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
              itemCount: products.length,
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Something error to get data'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

/// here i will create class and inherited PopMenuItem and do overrider some function

class MyPopupMenuItem<T> extends PopupMenuItem<T> {
  final Widget child;
  final Function onClick;
  MyPopupMenuItem({@required this.child,@required this.onClick}):super(child: child);

  @override
  PopupMenuItemState<T, PopupMenuItem<T>> createState() {
      return MyPopupMenuItemState();
  }
}

class MyPopupMenuItemState<T, PopupMenuItem> extends PopupMenuItemState<T, MyPopupMenuItem<T>> {

  @override
  void handleTap() {
    widget.onClick();
  }
}
