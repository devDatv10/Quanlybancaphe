import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quan_ly_ban_ca_phe/models/products.dart';
import 'package:quan_ly_ban_ca_phe/views/app/product_detail_page.dart';
import 'package:quan_ly_ban_ca_phe/widgets/product_form.dart';

class ProductPopularItem extends StatefulWidget {
  const ProductPopularItem({Key? key});

  @override
  State<ProductPopularItem> createState() => _ProductPopularItemState();
}

class _ProductPopularItemState extends State<ProductPopularItem> {
  late Stream<List<Products>> productsStream;

  @override
  void initState() {
    super.initState();
    productsStream = FirebaseFirestore.instance
        .collection('Sản phẩm phổ biến')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Products.fromDocument(doc)).toList());
  }

  void _navigateToProductDetails(int index, List<Products> products) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => ProductDetailPage(product: products[index]),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: StreamBuilder<List<Products>>(
        stream: productsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            List<Products> productPopular = snapshot.data ?? [];
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 18.0,
                childAspectRatio: 0.64,
              ),
              itemCount: productPopular.length,
              itemBuilder: (context, index) => ProductForm(
                product: productPopular[index],
                onTap: () => _navigateToProductDetails(index, productPopular),
              ),
            );
          }
        },
      ),
    );
  }
}