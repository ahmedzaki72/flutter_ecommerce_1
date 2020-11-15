import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_1/models/product_model.dart';
import 'package:flutter_ecommerce_1/screens/product_info.dart';
import 'package:flutter_ecommerce_1/widgets/filter_by_category.dart';


Widget  productsView(String category, List<Product> allProducts) {
  List<Product> products;
  products = getProductByCategory(category, allProducts);
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
          onTap: () {
            Navigator.of(context).pushNamed(ProductInfo.routeName, arguments: products[index]);
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
}