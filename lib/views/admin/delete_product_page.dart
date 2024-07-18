import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quan_ly_ban_ca_phe/models/products.dart';
import 'package:quan_ly_ban_ca_phe/themes/theme.dart';
import 'package:quan_ly_ban_ca_phe/widgets/my_button.dart';
import 'package:quan_ly_ban_ca_phe/widgets/notification_dialog.dart';

class DeleteProductPage extends StatefulWidget {
  static const String routeName = '/delete_product_page';

  const DeleteProductPage({Key? key}) : super(key: key);

  @override
  State<DeleteProductPage> createState() => _DeleteProductPageState();
}

class _DeleteProductPageState extends State<DeleteProductPage> {
  final _textSearchProductController = TextEditingController();
  List<String> collectionNames = [
    'Coffee',
    'Trà',
    'Danh sách sản phẩm',
    'Sản phẩm nổi bật',
    'Sản phẩm phổ biến',
  ];

  Map<String, List<Products>> productsMap = {};
  String selectedCategory = '';

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    for (String collectionName in collectionNames) {
      List<Products> products = await getProductsFromCollection(collectionName);
      productsMap[collectionName] = products;
    }
    setState(() {});
  }

  Future<List<Products>> getProductsFromCollection(
      String collectionName) async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection(collectionName).get();

      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Products(
          id: data['id'],
          docId: doc.id,
          name: data['name'],
          description: data['description'],
          imagePath: data['imagePath'],
          imageDetailPath: data['imageDetailPath'],
          oldPrice: data['oldPrice'].toDouble(),
          newPrice: data['newPrice'].toDouble(),
          rating: data['rating'],
          category: collectionName,
        );
      }).toList();
    } catch (e) {
      print('Error getting products from $collectionName: $e');
      return [];
    }
  }

  void updateSelectedProducts(String selectedCollection) {
    setState(() {
      selectedCategory = selectedCollection;
    });
  }

  Future<void> deleteProduct(Products productToDelete) async {

    try {
      setState(() {
        productsMap[selectedCategory]?.remove(productToDelete);
      });

      await FirebaseFirestore.instance
          .collection(productToDelete.category)
          .doc(productToDelete.docId)
          .delete();

      print('Product deleted successfully from ${productToDelete.category}');
      _showAlert('Thông báo', 'Xóa sản phẩm thanh công, vui lòng thử lại.');
    } catch (e) {
      print('Error deleting product from ${productToDelete.category}: $e');
      _showAlert('Thông báo', 'Xóa sản phẩm thất bại, vui lòng thử lại.');
    }
  }

  void _showConfirmDelete(Products productToDelete) {
    notificationDialog(
      context: context,
      title: 'Thông báo',
      message: "Bạn có chắc muốn xóa sản phẩm này không?",
      onConfirm: () {},
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Hủy", style: TextStyle(color: red)),
        ),
        TextButton(
          onPressed: () {
            deleteProduct(productToDelete);
          },
          child: Text("Đồng ý", style: TextStyle(color: blue)),
        ),
      ],
    );
  }

  void _showAlert(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: GoogleFonts.roboto(color: blue),
          ),
          content: Text(content),
          actions: [
            TextButton(
              child: Text("OK", style: TextStyle(color: blue)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(
                left: 18.0, top: 18.0, right: 18.0, bottom: 10),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Xóa sản phẩm',
                    style: GoogleFonts.arsenal(
                      fontSize: 30,
                      color: black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _textSearchProductController,
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
                        child: Center(
                          child: IconButton(
                            icon: const Icon(
                              Icons.clear,
                              size: 10,
                            ),
                            onPressed: () {
                              _textSearchProductController.clear();
                            },
                          ),
                        ),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28.0),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28.0),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Danh sách sản phẩm',
                    style: GoogleFonts.arsenal(
                      fontSize: 20,
                      color: black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Danh sách danh mục sản phẩm
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: collectionNames
                        .map(
                          (category) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                updateSelectedProducts(category);
                              },
                              child: Text(category),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Hiển thị danh sách sản phẩm
        Expanded(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 25.0),
            child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 1,
              itemBuilder: (context, index) {
                List<Products> products = selectedCategory.isNotEmpty
                    ? productsMap[selectedCategory] ?? []
                    : [];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        selectedCategory.isNotEmpty
                            ? selectedCategory
                            : collectionNames[index],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: brown,
                        ),
                      ),
                    ),
                    ...products.map((product) {
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Image.network(
                                product.imagePath,
                                height: 80,
                                width: 80,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: GoogleFonts.arsenal(
                                      fontSize: 18,
                                      color: primaryColors,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    product.newPrice.toStringAsFixed(3) + 'đ',
                                    style: GoogleFonts.roboto(
                                      color: primaryColors,
                                      fontSize: 16,
                                    ),
                                  ),
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
                            Expanded(
                              flex: 1,
                              child: IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: red,
                                ),
                                onPressed: () {
                                  if (selectedCategory.isNotEmpty) {
                                    // Lấy thông tin sản phẩm cần xóa
                                    Products productToDelete = product;

                                    // Gọi hàm xóa sản phẩm
                                    _showConfirmDelete(productToDelete);
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                );
              },
            ),
          ),
        ),
        // Nút hoàn thành
        Padding(
          padding: const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 18.0),
          child: MyButton(
            text: 'Hoàn thành',
            onTap: () {},
            buttonColor: green,
          ),
        )
      ],
    );
  }
}
