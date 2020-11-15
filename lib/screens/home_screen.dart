import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_1/constant.dart';
import 'package:flutter_ecommerce_1/models/product_model.dart';
import 'package:flutter_ecommerce_1/screens/cart_screen.dart';
import 'package:flutter_ecommerce_1/screens/login_screen.dart';
import 'package:flutter_ecommerce_1/screens/product_info.dart';
import 'package:flutter_ecommerce_1/services/auth.dart';
import 'package:flutter_ecommerce_1/services/store.dart';
import 'package:flutter_ecommerce_1/widgets/filter_by_category.dart';
import 'package:flutter_ecommerce_1/widgets/product_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'homeScreen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tabBarIndex = 0;
  final _store = Store();
  int _selectedIndex = 0;
  List<Product> _products;
  final _auth = Auth();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DefaultTabController(
          length: 4,
          child: Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              fixedColor: kMainColor,
              // type: BottomNavigationBarType.fixed, // i will using this feature when i want bottom navigation bar fixed not up with keyboard.
              unselectedItemColor: kUnActiveColor,
              currentIndex: _selectedIndex,
              onTap: (value) async{
                print(value);
                if(value == 3 ) {
                   SharedPreferences pref = await SharedPreferences.getInstance();
                   pref.clear();
                   _auth.signOut();
                   Navigator.of(context).popAndPushNamed(LoginScreen.routeName);
                }
                setState(() {
                  _selectedIndex = value;
                });
              },
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Category'),
                BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Setting'),
                BottomNavigationBarItem(icon: Icon(Icons.close), label: 'SignOut'),
              ],
            ),
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.0,
              bottom: TabBar(
                // indicatorPadding: EdgeInsets.symmetric(vertical: 50.0),
                indicatorColor: kMainColor,
                onTap: (value) {
                  setState(() {
                    _tabBarIndex = value;
                  });
                },
                tabs: [
                  Text(
                    'jacket',
                    style: TextStyle(
                      color: _tabBarIndex == 0 ? Colors.black : kUnActiveColor,
                      fontSize: _tabBarIndex == 0 ? 16 : null,
                    ),
                  ),
                  Text(
                    'trouser',
                    style: TextStyle(
                      color: _tabBarIndex == 1 ? Colors.black : kUnActiveColor,
                      fontSize: _tabBarIndex == 1 ? 16 : null,
                    ),
                  ),
                  Text(
                    'T-shirts',
                    style: TextStyle(
                      color: _tabBarIndex == 2 ? Colors.black : kUnActiveColor,
                      fontSize: _tabBarIndex == 2 ? 16 : null,
                    ),
                  ),
                  Text(
                    'shoes',
                    style: TextStyle(
                      color: _tabBarIndex == 3 ? Colors.black : kUnActiveColor,
                      fontSize: _tabBarIndex == 3 ? 16 : null,
                    ),
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                jacketView(),
                productsView(kTrousers, _products),
                productsView(kTShirts, _products),
                productsView(kShoes, _products),
              ],
            ),
          ),
        ),
        Material(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Discover'.toUpperCase(),
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
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
        ),
      ],
    );
  }

  Widget jacketView() {
    return StreamBuilder<QuerySnapshot>(
      stream: _store.loadingProduct(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          List<Product> products = [];
          for (var doc in snapshot.data.docs) {
            final data = doc.data();
            // if (doc[kProductCategory] == kJackets) {  } // i will using another way to filtering data in ui not from server.
            products.add(Product(
              id: doc.id,
              name: data[kProductName],
              price: data[kProductPrice],
              description: data[kProductDescription],
              category: data[kProductCategory],
              location: data[kProductLocation],
            ));
          }

          /// using this method to filtering data when take spread operator and filtering.
          _products = [...products];
          products.clear();
          products = getProductByCategory(kJackets, _products);
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,

              /// using this method when if i want height greater than width i will value < 1 , and when i want width greater then height value > 1
            ),
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(ProductInfo.routeName,
                        arguments: products[index]);
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
    );
  }
}
