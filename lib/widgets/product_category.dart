import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quan_ly_ban_ca_phe/widgets/product_category_form.dart';
import 'package:quan_ly_ban_ca_phe/models/categories.dart';

class ProductCategory extends StatefulWidget {
  const ProductCategory({super.key});

  @override
  State<ProductCategory> createState() => _ProductCategoryState();
}

class _ProductCategoryState extends State<ProductCategory> {
  Future<List<Categories>> fetchCategories() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Danh mục').get();
    return snapshot.docs.map((doc) => Categories.fromDocument(doc)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Categories>>(
      future: fetchCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No categories found'));
        } else {
          List<Categories> categories = snapshot.data!;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: categories.map((category) {
              return ProductCategoryForm(
                titleProduct: category.name,
                destinationPage: _getDestinationPage(category.name),
              );
            }).toList(),
          );
        }
      },
    );
  }

  Widget _getDestinationPage(String categoryName) {
    switch (categoryName) {
      case 'Cà phê':
        return CoffeePage();
      case 'Freeze':
        return FreezePage();
      case 'Trà':
        return TeaPage();
      case 'Bánh mì':
        return BreadPage();
      default:
        return OtherPage();
    }
  }
}
