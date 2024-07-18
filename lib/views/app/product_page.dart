import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quan_ly_ban_ca_phe/models/products.dart';
import 'package:quan_ly_ban_ca_phe/themes/theme.dart';
import 'package:quan_ly_ban_ca_phe/views/app/cart_page.dart';
import 'package:quan_ly_ban_ca_phe/views/app/home_page.dart';
import 'package:quan_ly_ban_ca_phe/views/app/list_product_page.dart';
import 'package:quan_ly_ban_ca_phe/views/app/profile_user_page.dart';
import 'package:quan_ly_ban_ca_phe/widgets/product_form.dart';

class ProductPage extends StatefulWidget {
  final String categoryName;

  const ProductPage({Key? key, required this.categoryName}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int _selectedIndexBottomBar = 1;
  late Stream<List<Products>> productsStream;

  void _selectedBottomBar(int index) {
    setState(() {
      _selectedIndexBottomBar = index;
    });
  }

  @override
  void initState() {
    super.initState();
    productsStream = FirebaseFirestore.instance
        .collection(widget.categoryName)
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
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.categoryName.toUpperCase(),
          style: GoogleFonts.arsenal(
            color: blue,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: blue,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CartPage(),
                ));
              },
              icon: Icon(
                Icons.shopping_cart,
                color: blue,
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<Products>>(
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
            List<Products> products = snapshot.data ?? [];
            return Padding(
              padding: EdgeInsets.only(left: 18.0, top: 18.0, right: 18.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 18.0,
                  mainAxisSpacing: 18.0,
                  childAspectRatio: 0.64,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) => ProductForm(
                  product: products[index],
                  onTap: () => _navigateToProductDetails(index, products),
                ),
              ),
            );
          }
        },
      ),
      //bottom bar
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        selectedItemColor: blue,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndexBottomBar,
        onTap: _selectedBottomBar,
        items: [
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ),
                );
              },
              child: Icon(Icons.home),
            ),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListProductPage(),
                  ),
                );
              },
              child: Icon(Icons.local_cafe),
            ),
            label: 'Đồ uống',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartPage(),
                  ),
                );
              },
              child: Icon(Icons.shopping_cart),
            ),
            label: 'Giỏ hàng',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileUserPage(),
                  ),
                );
              },
              child: Icon(Icons.person),
            ),
            label: 'Hồ sơ',
          ),
        ],
      ),
    );
  }
}
