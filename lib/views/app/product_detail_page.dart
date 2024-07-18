import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quan_ly_ban_ca_phe/models/products.dart';
import 'package:quan_ly_ban_ca_phe/themes/theme.dart';
import 'package:quan_ly_ban_ca_phe/views/app/cart_page.dart';
import 'package:quan_ly_ban_ca_phe/widgets/button_add_to_cart.dart';
import 'package:quan_ly_ban_ca_phe/widgets/button_buy_now.dart';
import 'package:quan_ly_ban_ca_phe/widgets/size_product.dart';

class ProductDetailPage extends StatefulWidget {
  final Products product;
  const ProductDetailPage({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class CartPageArguments {
  final List<CartItem> cartItems;

  CartPageArguments(this.cartItems);
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int quantityCount = 1;
  double totalPrice = 0.0;
  bool isFavorite = false;
  String selectedSize = 'S';
  List<CartItem> cartItems = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    updateTotalPrice();
  }

  void decrementQuantity() {
    setState(() {
      if (quantityCount > 1) {
        quantityCount--;
        updateTotalPrice();
      }
    });
  }

  void incrementQuantity() {
    setState(() {
      quantityCount++;
      updateTotalPrice();
    });
  }

  // // initialization variable total price
  // double totalPrice = 0.0;

  void updateTotalPrice() {
    setState(() {
      double productPrice = widget.product.newPrice;
      totalPrice = productPrice * quantityCount;
    });
  }
  
  Future<void> addToCartFirestore(CartItem item) async {
    try {
      DocumentReference docRef = await _firestore.collection('Giỏ hàng').add({
        'orderId': item.productId,
        'productImage': item.productImage,
        'productName': item.productName,
        'newPrice': item.newPrice,
        'totalPrice': item.totalPrice,
        'quantity': item.quantity,
        'selectedSize': item.selectedSize,
      });

      item.productId = docRef.id;

      print('Item added to cart collection successfully with ID: ${docRef.id}');
      _showAlert('Thông báo', 'Thêm sản phẩm vào giỏ hàng thành công.');
    } catch (e) {
      print('Error adding item to cart collection: $e');
    }
  }

  void addToCart(String productId, String productImage, String productName,
      double newPrice, double totalPrice, int quantity, String selectedSize) {
    CartItem item = CartItem(
      productId,
      productImage,
      productName,
      newPrice,
      totalPrice,
      quantity,
      selectedSize,
    );

    setState(() {
      cartItems.add(item);
    });

    addToCartFirestore(item);
  }

  void _showAlert(String title, String content) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            title,
            style: GoogleFonts.arsenal(color: blue),
          ),
          content: Text(content),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'OK',
                style: TextStyle(color: blue),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Image.network(
                widget.product.imageDetailPath != null
                    ? widget.product.imageDetailPath
                    : '',
              ),

              //
              Positioned(
                top: 54,
                left: 8,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: white,
                  ),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ),
              //
              Positioned(
                top: 54,
                right: 8,
                child: IconButton(
                  icon: Icon(
                    Icons.shopping_cart,
                    color: white,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CartPage(),
                    ));
                  },
                ),
              ),
            ],
          ),
          Expanded(
              child: Container(
            padding: const EdgeInsets.only(top: 10.0),
            decoration: BoxDecoration(color: white),
            child: Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    widget.product.name,
                    style: GoogleFonts.arsenal(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: blue),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: blue,
                        size: 30,
                      ))
                ]),
                Padding(
                  padding: const EdgeInsets.only(right: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.network(
                        widget.product.imagePath,
                        width: 85,
                        height: 85,
                        fit: BoxFit.cover,
                      ),
                      Expanded(
                        child: Text(
                          widget.product.description,
                          style: GoogleFonts.roboto(fontSize: 17, color: black),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                //product size
                Padding(
                  padding: const EdgeInsets.only(left: 18, right: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Chọn Size',
                        style: GoogleFonts.arsenal(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: black),
                      ),
                      SizeProducts(
                        titleSize: 'S',
                        onSizeSelected: (selectedSize) {
                          setState(() {
                            this.selectedSize = selectedSize;
                          });
                        },
                      ),
                      SizeProducts(
                        titleSize: 'M',
                        onSizeSelected: (selectedSize) {
                          setState(() {
                            this.selectedSize = selectedSize;
                          });
                        },
                      ),
                      SizeProducts(
                        titleSize: 'L',
                        onSizeSelected: (selectedSize) {
                          setState(() {
                            this.selectedSize = selectedSize;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 18, right: 18),
                  child: Row(
                    children: [
                      Text(
                        'Số lượng ',
                        style: GoogleFonts.arsenal(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: black),
                      ),
                      SizedBox(width: 50),
                      Row(
                        children: [
                          Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                  color: light_grey, shape: BoxShape.circle),
                              child: GestureDetector(
                                onTap: decrementQuantity,
                                child: Icon(
                                  Icons.remove,
                                  size: 19,
                                  color: white,
                                ),
                              )),
                          //quantity + count
                          SizedBox(
                            width: 35,
                            child: Center(
                              child: Text(
                                quantityCount.toString(),
                                style: GoogleFonts.roboto(
                                    fontSize: 17, color: black),
                              ),
                            ),
                          ),
                          Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                  color: blue, shape: BoxShape.circle),
                              child: GestureDetector(
                                onTap: incrementQuantity,
                                child: Icon(
                                  Icons.add,
                                  size: 19,
                                  color: white,
                                ),
                              ))
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                //product price
                Padding(
                  padding: const EdgeInsets.only(left: 18, right: 18),
                  child: Row(
                    children: [
                      Text(
                        'Tổng tiền',
                        style: GoogleFonts.arsenal(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: black),
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      Text(
                        totalPrice.toStringAsFixed(3) + 'đ',
                        style: GoogleFonts.roboto(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: blue),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 18, right: 18),
                  child: Row(
                    children: [
                      Text(
                        'Đánh giá ',
                        style: GoogleFonts.arsenal(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: black),
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      Text(
                        widget.product.rating,
                        style: GoogleFonts.roboto(fontSize: 19, color: black),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      //
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: 19,
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: 19,
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: 19,
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: 19,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 18, right: 18),
                  child: IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ButtonAddToCart(
                          text: 'Thêm vào giỏ',
                          onTap: () {
                            addToCart(
                              widget.product.id as String,
                              widget.product.imagePath as String,
                              widget.product.name,
                              widget.product.newPrice,
                              totalPrice,
                              quantityCount,
                              selectedSize,
                            );
                          },
                        ),
                        VerticalDivider(
                          color: light_grey,
                          thickness: 1,
                        ),
                        ButtonBuyNow(text: 'Mua ngay', onTap: () {}),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )),
        ],
      ),
    );
  }
}
