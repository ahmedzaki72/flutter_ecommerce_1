import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_1/constant.dart';
import 'package:flutter_ecommerce_1/provider/modal_provider.dart';
import 'package:flutter_ecommerce_1/screens/home_screen.dart';
import 'package:flutter_ecommerce_1/services/auth.dart';
import 'package:flutter_ecommerce_1/widgets/custom_text_field.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';




class SignupScreen extends StatelessWidget {
  static const String routeName = 'SignupScreen';
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String email, password, name;
  final _auth = Auth();

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
                SizedBox(height: height * 0.1 ,),
                CustomField(
                  hint: 'Enter your username',
                  icon: Icons.person,
                  onSave: (value) {
                    name = value;
                  },
                  onPress: (value) {
                    if(value.isEmpty || value.length < 3){
                      return 'please enter username or usename lessthan 5 charchter';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                CustomField(
                  hint: 'Enter your email',
                  icon: Icons.email,
                  type: TextInputType.emailAddress,
                  onSave: (value){
                    email = value;
                  },
                  onPress: (value) {
                    if(value.isEmpty || !value.contains('@')){
                      return 'please enter your correct email';
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
                  onSave: (value){
                    password = value;
                  },
                  onPress: (value) {
                    if(value.isEmpty || value.length < 6) {
                      return 'please enter correct password or password less than 6 charchter';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: height * 0.05,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 120.0),
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    color: Colors.black,
                    onPressed: () async{
                      FocusScope.of(context).unfocus();
                      final modalProvider = Provider.of<ModalProvider>(context, listen: false);
                      modalProvider.changeIsLoading(true);
                      if(_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        try{
                          _formKey.currentState.save();
                          final authResult = await _auth.signUp( name.trim() ,email.trim(), password.trim());
                          modalProvider.changeIsLoading(false);
                          Navigator.pushNamed(context, HomeScreen.routeName);
                          print(authResult.user.uid);
                        } on FirebaseAuthException catch(e) {
                          if(e.code == 'weak-password'){
                            modalProvider.changeIsLoading(false);
                            _scaffoldKey.currentState.showSnackBar(
                              SnackBar(
                                content: Text('the password provider too weak '),
                              ),
                            );
                          }else if(e.code == 'email-already-in-use'){
                            modalProvider.changeIsLoading(false);
                            _scaffoldKey.currentState.showSnackBar(
                              SnackBar(
                                content: Text('the account is already exists for that email'),
                              ),
                            );
                          }
                        }
                      }
                      modalProvider.changeIsLoading(false);
                    },
                    child: Text(
                      'SignUp',
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
                      'Do have an account?',
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

