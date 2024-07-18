import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:quan_ly_ban_ca_phe/themes/theme.dart';

class TextFormFieldEmail extends StatefulWidget {
  final String hintText;
  final IconData prefixIconData;
  final Widget? suffixIcon;
  final Color iconColor;
  final TextEditingController controller;
  final bool obscureText;
  final List<TextInputFormatter>? inputFormatters;

  const TextFormFieldEmail({
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
  _TextFormFieldEmailState createState() => _TextFormFieldEmailState();
}

class _TextFormFieldEmailState extends State<TextFormFieldEmail> {
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
              _isValid = _validateEmail(text);
            });
          },
          decoration: InputDecoration(
            hintText: widget.hintText,
            contentPadding: EdgeInsets.all(15),
            filled: true,
            fillColor: Colors.white,
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
                  color: _isValid ? Colors.white : red)
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                  color: _isValid ? Colors.white : red),
            ),
          ),
        ),
        SizedBox(height: 5),
        _isValid ? SizedBox() : Text('Email chưa hợp lệ', style: GoogleFonts.arsenal(color: red, fontSize: 15)),
      ],
    );
  }

  bool _validateEmail(String email) {
    final RegExp emailRegex =
        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    return emailRegex.hasMatch(email);
  }
}