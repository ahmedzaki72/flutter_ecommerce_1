import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_1/constant.dart';

class CustomField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final Function(String) onPress;
  final TextInputType type;
  final bool secureText;
  final Function(String) onSave;
  final TextEditingController controllerS;

  CustomField({
    @required this.hint,
    this.icon,
    this.onPress,
    this.type,
    this.secureText = false,
    this.onSave,
    this.controllerS,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        controller: controllerS,
        obscureText: secureText,
        validator: onPress,
        onSaved: onSave,
        cursorColor: kMainColor,
        keyboardType: type,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(
            icon,
            color: kMainColor,
          ),
          fillColor: kInputColor,
          filled: true,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.white, width: 0.8),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.white, width: 0.8),
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide(width: 0.8)),
        ),
      ),
    );
  }
}
