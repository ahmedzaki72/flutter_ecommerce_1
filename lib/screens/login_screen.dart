import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ecommerce_1/constant.dart';
import 'package:flutter_ecommerce_1/provider/admin_provider.dart';
import 'package:flutter_ecommerce_1/provider/modal_provider.dart';
import 'package:flutter_ecommerce_1/screens/admin/admin_screen.dart';
import 'package:flutter_ecommerce_1/screens/home_screen.dart';
import 'package:flutter_ecommerce_1/screens/signup_screen.dart';
import 'package:flutter_ecommerce_1/services/auth.dart';
import 'package:flutter_ecommerce_1/widgets/custom_text_field.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'loginScreen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String email, password;

  final _auth = Auth();

  final adminPassword = 'admin123456';
  bool keepMeLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: kMainColor,
      body: ModalProgressHUD(
        inAsyncCall: Provider.of<ModalProvider>(context).isLoading,
        child: Container(
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image(
                          image: AssetImage('assets/icons/icons1.png'),
                        ),
                        Positioned(
                          bottom: 0,
                          child: Text(
                            'Buy it',
                            style: TextStyle(
                              fontSize: 25.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.1,
                ),
                CustomField(
                  hint: 'Enter your email',
                  icon: Icons.email,
                  type: TextInputType.emailAddress,
                  onSave: (value) {
                    email = value;
                  },
                  onPress: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'please enter your email or correct email';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                CustomField(
                  hint: 'Enter your Password',
                  icon: Icons.lock,
                  secureText: true,
                  onSave: (value) {
                    password = value;
                  },
                  onPress: (value) {
                    if (value.isEmpty || value.length < 6) {
                      return 'password is empty or password less then 6 charchter';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      Checkbox(
                        checkColor: Colors.white,
                        activeColor: Colors.grey,
                        value: keepMeLoggedIn,
                        onChanged: (value) {
                          setState(() {
                            print(value);
                            keepMeLoggedIn = value;
                          });
                        },
                      ),
                      Text(
                        'Remember Me',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 120.0),
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    color: Colors.black,
                    onPressed: () {
                      if(keepMeLoggedIn == true) {
                        keepUserLoggedIn();
                      }
                      /// this is method using to validation between to admin and user.
                      validation(context);
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account?',
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, SignupScreen.routeName);
                      },
                      child: Text(
                        'signup',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          final adminProvider = Provider.of<AdminProvider>(
                              context,
                              listen: false);
                          adminProvider.changeIsAdmin(true);
                        },
                        child: Text(
                          'i\'m an admin',
                          style: TextStyle(
                              color: Provider.of<AdminProvider>(context).isAdmin
                                  ? kMainColor
                                  : Colors.white),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.2,
                      ),
                      GestureDetector(
                        onTap: () {
                          final adminProvider = Provider.of<AdminProvider>(
                              context,
                              listen: false);
                          adminProvider.changeIsAdmin(false);
                        },
                        child: Text(
                          'i\'m a user',
                          style: TextStyle(
                              color: Provider.of<AdminProvider>(context).isAdmin
                                  ? Colors.white
                                  : kMainColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void validation(BuildContext context) async {
    FocusScope.of(context).unfocus();
    final modelProvider = Provider.of<ModalProvider>(context, listen: false);

    modelProvider.changeIsLoading(true);
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      /// using this line because i want to save data from textField saved to  email and password.
      if (Provider.of<AdminProvider>(context, listen: false).isAdmin) {
        if (password == adminPassword) {
          try {
            // _formKey.currentState.save();
            final authResult =
                await _auth.signIn(email.trim(), password.trim());
            modelProvider.changeIsLoading(false);
            Navigator.pushNamed(context, AdminScreen.routeName);
            // print(authResult.user.uid);
          } catch (e) {
            modelProvider.changeIsLoading(false);
            _scaffoldKey.currentState.showSnackBar(
              SnackBar(
                content: Text('This is not admin'),
              ),
            );
          }
        } else {
          modelProvider.changeIsLoading(false);
          _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: Text('something want wrong'),
            ),
          );
        }
      } else {
        try {
          _formKey.currentState.save();
          final authResult = await _auth.signIn(email, password);
          modelProvider.changeIsLoading(false);
          Navigator.pushNamed(context, HomeScreen.routeName);
          print(authResult.user.uid);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            modelProvider.changeIsLoading(false);
            _scaffoldKey.currentState.showSnackBar(
              SnackBar(
                content: Text('no user found for that email '),
              ),
            );
          } else if (e.code == 'wrong-password') {
            modelProvider.changeIsLoading(false);
            _scaffoldKey.currentState.showSnackBar(
              SnackBar(
                content: Text('wrong password provider for that user'),
              ),
            );
          }
        }
      }
    }
    modelProvider.changeIsLoading(false);
  }

  void keepUserLoggedIn() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(kKeepMeLoggedIn, keepMeLoggedIn);
  }
}
