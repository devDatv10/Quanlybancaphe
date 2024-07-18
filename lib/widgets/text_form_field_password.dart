import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/services.dart';
import 'package:quan_ly_ban_ca_phe/themes/theme.dart';

class TextFormFieldPassword extends StatefulWidget {
  final String hintText;
  final IconData prefixIconData;
  final Widget? suffixIcon;
  final Color iconColor;
  final TextEditingController controller;
  final bool obscureText;
  final List<TextInputFormatter>? inputFormatters; // Thêm tham số inputFormatters

  const TextFormFieldPassword({
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
  _TextFormFieldPasswordState createState() => _TextFormFieldPasswordState();
}

class _TextFormFieldPasswordState extends State<TextFormFieldPassword> {
  bool _isValid = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.controller,
          obscureText: widget.obscureText,
          inputFormatters: widget.inputFormatters,
          onChanged: (text) {
            setState(() {
              _isValid = text.length >= 6;
            });
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
              borderSide: BorderSide(
                  color: _isValid ? white : red)
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                  color: _isValid ? white : red),
            ),
          ),
        ),
        SizedBox(height: 5),
        _isValid
            ? SizedBox()
            : Text(
                'Mật khẩu phải có độ dài ít nhất 6 ký tự',
                style:  GoogleFonts.roboto(color: red, fontSize: 15),
              ),
      ],
    );
  }
}