import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_1/constant.dart';
import 'package:flutter_ecommerce_1/provider/admin_provider.dart';
import 'package:flutter_ecommerce_1/provider/cartItem_provider.dart';
import 'package:flutter_ecommerce_1/provider/modal_provider.dart';
import 'package:flutter_ecommerce_1/screens/admin/add_product.dart';
import 'package:flutter_ecommerce_1/screens/admin/admin_screen.dart';
import 'package:flutter_ecommerce_1/screens/admin/edit_product.dart';
import 'package:flutter_ecommerce_1/screens/admin/manage_product.dart';
import 'package:flutter_ecommerce_1/screens/admin/order_details.dart';
import 'package:flutter_ecommerce_1/screens/admin/order_screen.dart';
import 'package:flutter_ecommerce_1/screens/cart_screen.dart';
import 'package:flutter_ecommerce_1/screens/home_screen.dart';
import 'package:flutter_ecommerce_1/screens/login_screen.dart';
import 'package:flutter_ecommerce_1/screens/product_info.dart';
import 'package:flutter_ecommerce_1/screens/signup_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  bool isUserLoggedIn = false;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot){
        if(!snapshot.hasData) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }else{
            isUserLoggedIn = snapshot.data.getBool(kKeepMeLoggedIn) ?? false ;
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<ModalProvider>(
                create: (context) => ModalProvider(),
              ),
              ChangeNotifierProvider<AdminProvider>(
                create: (context) => AdminProvider(),
              ),
              ChangeNotifierProvider<CartItem>(
                create: (context) => CartItem(),
              ),
            ],
            child: MaterialApp(
              theme: ThemeData(
                fontFamily: 'Pacifico',
              ),
              debugShowCheckedModeBanner: false,
              home: isUserLoggedIn ? HomeScreen() :  LoginScreen(),
              routes: {
                LoginScreen.routeName: (context) => LoginScreen(),
                SignupScreen.routeName: (context) => SignupScreen(),
                HomeScreen.routeName: (context) => HomeScreen(),
                AdminScreen.routeName: (context) => AdminScreen(),
                AddProduct.routeName: (context) => AddProduct(),
                ManageProduct.routeName: (context) => ManageProduct(),
                EditProduct.routeName: (context) => EditProduct(),
                ProductInfo.routeName: (context) => ProductInfo(),
                CartScreen.routeName : (context) => CartScreen(),
                OrderScreen.routeName : (context) => OrderScreen(),
                OrderDetails.routeName : (context) => OrderDetails(),
              },
            ),
          );
        }
    });
  }
}
