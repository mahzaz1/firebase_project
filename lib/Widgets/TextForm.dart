import 'package:flutter/material.dart';

class TextForm extends StatelessWidget {
  const TextForm(
      {Key? key,
      required this.labelText,
      required this.hintText,
      required this.keyboardType,
      required this.controller,
      required this.validator,
        this.obsecure = false,
        required this.icon,
         this.onIconTap
      })
      : super(key: key);

  final String labelText;
  final String hintText;
  final Icon icon;
  final TextInputType keyboardType;
  final VoidCallback? onIconTap;
  final TextEditingController controller;
  final String? Function(String?) validator;
  final bool obsecure;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      obscureText: obsecure,

      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        suffixIcon: InkWell(child: icon,onTap: onIconTap,),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.deepPurple)),
      ),
    );
  }
}
