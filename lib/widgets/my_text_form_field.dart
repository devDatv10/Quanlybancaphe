import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:quan_ly_ban_ca_phe/themes/theme.dart';

class MyTextFormField extends StatefulWidget {
  final String hintText;
  final IconData prefixIconData;
  final Widget? suffixIcon;
  final Color iconColor;
  final TextEditingController controller;
  final bool obscureText;
  final List<TextInputFormatter>? inputFormatters;

  const MyTextFormField({
    Key? key,
    required this.hintText,
    required this.prefixIconData,
    this.suffixIcon,
    required this.controller,
    required this.iconColor,
    this.obscureText = false,
    this.inputFormatters,
  }) : super(key: key);

  @override
  _MyTextFormFieldState createState() => _MyTextFormFieldState();
}

class _MyTextFormFieldState extends State<MyTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.obscureText,
      inputFormatters: widget.inputFormatters,
      validator: (text) {
        if (text == null || text.isEmpty) {
          return 'Required ${widget.hintText}';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: widget.hintText,
        contentPadding: EdgeInsets.all(15),
        filled: true,
        fillColor: white,
        prefixIcon: Icon(
          widget.prefixIconData,
          color: widget.iconColor,
        ),
        suffixIcon: widget.suffixIcon != null
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    widget.controller.clear();
                  });
                },
                child: widget.suffixIcon,
              )
            : null,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.white),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}