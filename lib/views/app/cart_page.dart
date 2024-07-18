import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quan_ly_ban_ca_phe/themes/theme.dart';
import 'package:quan_ly_ban_ca_phe/views/app/home_page.dart';
import 'package:quan_ly_ban_ca_phe/views/app/list_product_page.dart';
import 'package:quan_ly_ban_ca_phe/views/app/profile_user_page.dart';
import 'package:quan_ly_ban_ca_phe/widgets/order_form.dart';

class CartPage extends StatefulWidget {
  const CartPage();

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  int _selectedIndexBottomBar = 2;
  late List<CartItem> cartItems = [];
  void _selectedBottomBar(int index) {
    setState(() {
      _selectedIndexBottomBar = index;
    });
  }

  @override
  void initState() {
    super.initState();
    // Gọi hàm lấy dữ liệu từ Firebase
    fetchCartItems();
  }

  // Hàm để lấy dữ liệu từ cơ sở dữ liệu Firebase
  // Trong _CartPageState
  Future<void> fetchCartItems() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('Giỏ hàng').get();

      List<CartItem> items = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return CartItem(
          doc.id, // Lấy ID của sản phẩm
          data['productImage'],
          data['productName'],
          data['newPrice'].toDouble(),
          data['totalPrice'].toDouble(),
          data['quantity'],
          data['selectedSize'],
        );
      }).toList();

      setState(() {
        cartItems = items;
      });
    } catch (e) {
      print('Error fetching cart items: $e');
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text('GIỎ HÀNG',
            style: GoogleFonts.arsenal(
                color: blue,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: grey,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          IconButton(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => BillPage()),
                // );
              },
              icon: Icon(Icons.shopping_cart_checkout, color: grey))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 18.0, top: 18.0, right: 18.0),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            // Kiểm tra xem giỏ hàng có trống hay không
            cartItems.isEmpty
                ? Column(
                  children: [
                    SizedBox(height: 300,),
                    Center(
                      child: Text(
                        'Giỏ hàng trống',
                        style: TextStyle(color: black, fontSize: 18),
                      ),
                    ),
                  ],
                )
                : Column(
                    children: [
                      // Truyền danh sách sản phẩm vào OrderForm
                      OrderForm(cartItems: cartItems),
                    ],
                  ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          // backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: blue,
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndexBottomBar,
          onTap: _selectedBottomBar,
          items: [
            BottomNavigationBarItem(
              icon: GestureDetector(
                onTap: (){
                   Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                  );
                },
                child: Icon(Icons.home)),
              label: 'Trang chủ',
            ),
            BottomNavigationBarItem(
              icon: GestureDetector(
                onTap: () {
                  // Điều hướng đến trang mới ở đây
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
              label: 'Hồ sơ',
            ),
          ]),
    );
  }
}

// Trong class CartItem, thêm trường productId
class CartItem {
  String productId;
  final String productImage;
  final String productName;
  final double newPrice;
  final double totalPrice;
  final int quantity;
  final String selectedSize;

  CartItem(this.productId, this.productImage, this.productName, this.newPrice,
      this.totalPrice, this.quantity, this.selectedSize);
}