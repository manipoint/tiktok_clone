import 'package:flutter/material.dart';

import 'package:tiktok_clone/constants.dart';

class TextInputField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool isObscure;
  final IconData icon;
  const TextInputField(
      {Key? key,
      required this.controller,
      required this.labelText,
      required this.isObscure,
      required this.icon,
    })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style:const TextStyle(
          color: Colors.white70,
          fontSize: 16,
        ) ,
      cursorColor: Colors.white,
    
      controller: controller,
      obscureText: isObscure,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(
          icon,
          color: Colors.white70,
        ),
        labelStyle: const TextStyle(
          color: Colors.white70,
          fontSize: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: borderColor),
        ),
      ),
    );
  }
}


class TextInputFieldWithValidator extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? Function(String? value) validator;
  final bool isObscure;
  final IconData icon;
  const TextInputFieldWithValidator(
      {Key? key,
      required this.controller,
      required this.labelText,
      required this.isObscure,
      required this.icon,
      required this.validator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style:const TextStyle(
          color: Colors.white70,
          fontSize: 16,
        ) ,
      cursorColor: Colors.white,
      validator: validator,
      controller: controller,
      obscureText: isObscure,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(
          icon,
          color: Colors.white70,
        ),
        labelStyle: const TextStyle(
          color: Colors.white70,
          fontSize: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: borderColor),
        ),
      ),
    );
  }
}
