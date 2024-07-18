import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quan_ly_ban_ca_phe/themes/theme.dart';

class ProductCategoryForm extends StatelessWidget {
  final String titleProduct;
  final bool isSelected;
  final Function() onTap;

  const ProductCategoryForm({
    Key? key,
    required this.titleProduct,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 25,
        width: 70,
        decoration: BoxDecoration(
          color: isSelected ? blue : white,
          borderRadius: BorderRadius.circular(8.0),
          border: !isSelected
              ? Border.all(
                  color: blue,
                  width: 1,
                )
              : null,
        ),
        child: Center(
          child: Text(
            titleProduct,
            style: GoogleFonts.arsenal(
              color: isSelected ? white : blue,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
