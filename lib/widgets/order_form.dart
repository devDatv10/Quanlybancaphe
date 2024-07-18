import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quan_ly_ban_ca_phe/themes/theme.dart';
import 'package:quan_ly_ban_ca_phe/views/app/cart_page.dart';

class OrderForm extends StatefulWidget {
  final List<CartItem> cartItems;
  const OrderForm({Key? key, required this.cartItems}) : super(key: key);

  @override
  State<OrderForm> createState() => _OrderFormState();
}

class _OrderFormState extends State<OrderForm> {
  void deleteProductFromCart(int index) async {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          "Thông báo",
          style: GoogleFonts.arsenal(
            color: blue,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        content: Text("Bạn có chắc muốn xóa sản phẩm này khỏi giỏ hàng không?"),
        actions: [
          TextButton(
            child: Text("Xóa"),
            onPressed: () async {
              setState(() {
                widget.cartItems.removeAt(index);
              });

              await removeFromFirestore(index);

              Navigator.pop(context);
              _showAlert('Thông báo', 'Xóa sản phẩm khỏi giỏ hàng thành công.');
            },
          ),
          TextButton(
            child: Text(
              "Hủy",
              style: TextStyle(color: blue),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}

Future<void> removeFromFirestore(int index) async {
  try {
    String productId = await getProductId(index);

    await FirebaseFirestore.instance
        .collection('Giỏ hàng')
        .doc(productId)
        .delete();

    print('Product removed from Firestore successfully!');
    
  } catch (e) {
    print('Error removing product from Firestore: $e');
  }
}

Future<String> getProductId(int index) async {
  try {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('Giỏ hàng').get();

    String productId = querySnapshot.docs[index].id;

    return productId;
  } catch (e) {
    print('Error getting product ID from Firestore: $e');
    return '';
  }
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
    return Column(
      children: [
        Container(
          height: 650,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: widget.cartItems.length,
            itemBuilder: (context, index) {
              var item = widget.cartItems[index];
              return Slidable(
                startActionPane: ActionPane(motion: StretchMotion(), children: [
                  SlidableAction(
                    onPressed: ((context) {
                      Get.toNamed('/home_page');
                    }),
                    borderRadius: BorderRadius.circular(18.0),
                    backgroundColor: Colors.transparent,
                    foregroundColor: blue,
                    label: 'Trang chủ',
                    icon: Icons.home,
                  )
                ]),
                endActionPane: ActionPane(motion: StretchMotion(), children: [
                  SlidableAction(
                    onPressed: ((context) {
                      deleteProductFromCart(index);
                    }),
                    borderRadius: BorderRadius.circular(18.0),
                    backgroundColor: Colors.transparent,
                    foregroundColor: red,
                    label: 'Xóa',
                    icon: Icons.delete,
                  ),
                ]),
                child: Container(
                  margin: EdgeInsets.symmetric(
                      vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Image.network(
                          item.productImage,
                          height: 70.0,
                          width: 70.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.productName,
                              style: GoogleFonts.arsenal(
                                  fontSize: 18,
                                  color: blue,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              item.totalPrice.toStringAsFixed(3) + 'đ',
                              style: GoogleFonts.roboto(
                                color: blue,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            // Text('Quantity: ${item.quantity}'),
                            Row(
                              children: [
                                Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        color: blue,
                                        shape: BoxShape.circle),
                                    child: GestureDetector(
                                      onTap: () {
                                      },
                                      child: Icon(
                                        Icons.remove,
                                        size: 15,
                                        color: white,
                                      ),
                                    )),
                                //quantity + count
                                SizedBox(
                                  width: 35,
                                  child: Center(
                                    child: Text(
                                      item.quantity.toString(),
                                      style: GoogleFonts.roboto(
                                          fontSize: 15, color: black),
                                    ),
                                  ),
                                ),
                                Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        color: blue,
                                        shape: BoxShape.circle),
                                    child: GestureDetector(
                                      onTap: () {
                                        // Xử lý khi nhấn nút thêm
                                      },
                                      child: Icon(
                                        Icons.add,
                                        size: 15,
                                        color: white,
                                      ),
                                    ))
                              ],
                            )
                          ],
                        ),
                        Column(
                          children: [
                            // Text('Size: ${item.selectedSize}'),
                            Container(
                              height: 25,
                              width: 50,
                              decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.circular(18.0),
                                border: Border.all(
                                  color: blue,
                                  width: 1,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  item.selectedSize,
                                  style: GoogleFonts.arsenal(
                                      color: blue,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}