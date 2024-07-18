import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:quan_ly_ban_ca_phe/widgets/product_category_form.dart';
import 'package:quan_ly_ban_ca_phe/views/app/product_page.dart';
import 'package:quan_ly_ban_ca_phe/models/categories.dart';

class ProductCategory extends StatefulWidget {
  const ProductCategory({super.key});

  @override
  State<ProductCategory> createState() => _ProductCategoryState();
}

class _ProductCategoryState extends State<ProductCategory> {
  List<Categories> categories = [];
  int selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Danh mục').get();
    setState(() {
      categories = snapshot.docs.map((doc) => Categories.fromDocument(doc)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return categories.isEmpty
        ? Center(child: CircularProgressIndicator())
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(categories.length, (index) {
              return ProductCategoryForm(
                titleProduct: categories[index].name,
                isSelected: selectedIndex == index,
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                  Get.to(() => ProductPage(categoryName: categories[index].name));
                },
              );
            }),
          );
  }
}
