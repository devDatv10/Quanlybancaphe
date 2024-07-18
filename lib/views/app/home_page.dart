import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quan_ly_ban_ca_phe/themes/theme.dart';
import 'package:quan_ly_ban_ca_phe/views/app/cart_page.dart';
import 'package:quan_ly_ban_ca_phe/views/app/list_product_page.dart';
import 'package:quan_ly_ban_ca_phe/views/app/profile_user_page.dart';
import 'package:quan_ly_ban_ca_phe/widgets/outstanding_product_item.dart';
import 'package:quan_ly_ban_ca_phe/widgets/product_category.dart';
import 'package:quan_ly_ban_ca_phe/widgets/product_popular_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndexBottomBar = 0;
  bool _isListening = false;
  bool _isMicFormVisible = false;
  final _textSearchController = TextEditingController();
  List<DocumentSnapshot> searchResults = [];

  //
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  //SelectedBottomBar
  void _selectedBottomBar(int index) {
    if (index == 0) {
      // Check if the home icon is pressed
      _refreshData(); // Perform the refresh logic
    } else {
      setState(() {
        _selectedIndexBottomBar = index;
      });
    }
  }

  //
  Future<void> _refreshData() async {
    // Implement your refresh logic here
    // For example, you can fetch new data from the server
    // or reset the state of your widget

    // Simulate a delay for demonstration purposes
    await Future.delayed(Duration(seconds: 5));

    setState(() {
      // Update your data or perform any other necessary actions
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: blue,
        title: Container(
          height: 40,
          child: TextField(
            controller: _textSearchController,
            onSubmitted: (String query) {},
            decoration: InputDecoration(
                hintText: 'Tìm kiếm sản phẩm',
                contentPadding: EdgeInsets.symmetric(),
                alignLabelWithHint: true,
                filled: true,
                fillColor: white,
                prefixIcon: const Icon(
                  Icons.search,
                  size: 20,
                ),
                //icon clear
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                        color: background, shape: BoxShape.circle),
                    child: GestureDetector(
                      onTap: () {
                        _textSearchController.clear();
                      },
                      child: Icon(
                        Icons.clear,
                        size: 10,
                      ),
                    ),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(color: white)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(color: white))),
          ),
        ),
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refreshData,
        child: Padding(
          padding: const EdgeInsets.only(left: 18.0, top: 18.0, right: 18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //slide adv
              // SlideImage(
              //   height: 180,
              // ),
              // SizedBox(height: 15),
              // //product category
              ProductCategory(),
              // SizedBox(height: 15),
              // //product popular item
              Text('SẢN PHẨM PHỔ BIẾN',
                  style: GoogleFonts.arsenal(
                      fontSize: 20, fontWeight: FontWeight.bold, color: blue)),
              SizedBox(
                height: 10.0,
              ),
              Expanded(child: ProductPopularItem()),
              SizedBox(
                height: 10.0,
              ),
              //more product popular
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'Xem thêm',
                      style: GoogleFonts.roboto(color: blue, fontSize: 17),
                    ),
                  ),
                ],
              ),
              // hot product
              Text('SẢN PHẨM NỔI BẬT',
                  style: GoogleFonts.arsenal(
                      fontSize: 20, fontWeight: FontWeight.bold, color: blue)),
              SizedBox(
                height: 10.0,
              ),
              Expanded(child: OutstandingProductItem()),
            ],
          ),
        ),
      ),
      //bottom bar
      bottomNavigationBar: BottomNavigationBar(
          // backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: blue,
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndexBottomBar,
          onTap: _selectedBottomBar,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
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
                  child: Icon(Icons.shopping_bag)),
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
                  child: Icon(Icons.person)),
              label: 'Hồ sơ cá nhân',
            ),
          ]),
    );
  }
}
