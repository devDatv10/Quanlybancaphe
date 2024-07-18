import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quan_ly_ban_ca_phe/themes/theme.dart';

class ButtonAddToCart extends StatelessWidget {
  final String text;
  final Function()? onTap;

  const ButtonAddToCart({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 50,
        width: 160,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: blue),
            borderRadius: BorderRadius.circular(40)
          ),
          child: Center(
            child: Text(
              text,
              style: GoogleFonts.arsenal(color: blue, fontWeight: FontWeight.bold, fontSize: 19),
            ),
          ),
        ),
      ),
    );
  }
}