import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quan_ly_ban_ca_phe/models/products.dart';
import 'package:quan_ly_ban_ca_phe/themes/theme.dart';

class ProductForm extends StatelessWidget {
  final Products product;
  final VoidCallback onTap;

  const ProductForm({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
            color: white, borderRadius: BorderRadius.circular(15.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(product.imagePath, height: 170, width: 170,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: GoogleFonts.arsenal(
                      color: black, fontSize: 19, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.oldPrice.toStringAsFixed(3) + 'đ',
                      style: GoogleFonts.roboto(
                          color: grey,
                          fontSize: 15,
                          decoration: TextDecoration.lineThrough),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    //new price
                    Text(
                      product.newPrice.toStringAsFixed(3) + 'đ',
                      style: GoogleFonts.roboto(
                          color: blue,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Icon(
                  Icons.add_shopping_cart,
                  color: red,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}