import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quan_ly_ban_ca_phe/models/products.dart';
import 'package:quan_ly_ban_ca_phe/themes/theme.dart';
import 'package:quan_ly_ban_ca_phe/widgets/my_button.dart';

class UpdateProductPage extends StatefulWidget {
  static const String routeName = '/update_product_page';
  const UpdateProductPage({super.key});

  @override
  State<UpdateProductPage> createState() => _UpdateProductPageState();
}

class _UpdateProductPageState extends State<UpdateProductPage> {
  //
  final _textSearchProductController = TextEditingController();

  //
  TextEditingController _editIdController = TextEditingController();
  TextEditingController _editNameController = TextEditingController();
  TextEditingController _editDescriptionController = TextEditingController();
  TextEditingController _editOldPriceController = TextEditingController();
  TextEditingController _editNewPriceController = TextEditingController();
  TextEditingController _editRatingController = TextEditingController();

  File? _imagePath;
  File? _imageDetailPath;

  Future<List<Products>> getProductsFromCollection(String collectionName) async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection(collectionName).get();

    return querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Products(
        id: data['id'],
        docId: doc.id, // Lưu trữ docId
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


  Future<List<Products>> getAllProducts() async {
    List<String> collectionNames = [
      'Coffee',
      'Danh sách sản phẩm',
      'Sản phẩm nổi bật',
      'Sản phẩm phổ biến',
      'Trà',
    ];

    List<Future<List<Products>>> futures = [];
    for (String collectionName in collectionNames) {
      futures.add(getProductsFromCollection(collectionName));
    }

    List<List<Products>> results = await Future.wait(futures);
    List<Products> allProducts = results.expand((list) => list).toList();

    return allProducts;
  }

  List<Products> productList = [];

  //

  //
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = File(pickedFile.path);
      });
    }
  }

  //
  //
  Future<void> _pickImageDetail() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageDetailPath = File(pickedFile.path);
      });
    }
  }

  //update product
  void _showUpdateProductForm(BuildContext context, Products product) {
  _editIdController.text = product.id;
  _editNameController.text = product.name;
  _editDescriptionController.text = product.description;
  _editOldPriceController.text = product.oldPrice.toString();
  _editNewPriceController.text = product.newPrice.toString();
  _editRatingController.text = product.rating;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Chiều dài có thể được cuộn
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
    ),
    builder: (BuildContext context) {
      return Container(
        height: 800,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.only(left: 18.0, top: 30.0, right: 18.0, bottom: 18.0),
          child: Column(
            children: [
              Text(
                'Cập nhật sản phẩm',
                style: GoogleFonts.arsenal(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              buildTextFieldWithLabel('ID sản phẩm', _editIdController),
              buildTextFieldWithLabel('Tên sản phẩm', _editNameController),
              buildTextFieldWithLabel('Mô tả sản phẩm', _editDescriptionController),
              buildTextFieldWithLabel('Giá cũ', _editOldPriceController, TextInputType.number),
              buildTextFieldWithLabel('Giá mới', _editNewPriceController, TextInputType.number),
              buildTextFieldWithLabel('Xếp hạng', _editRatingController),
              SizedBox(height: 10),
              buildImagePicker(),
              SizedBox(height: 15.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      String id = _editIdController.text;
                      String name = _editNameController.text;
                      String description = _editDescriptionController.text;
                      double oldPrice = double.tryParse(_editOldPriceController.text) ?? 0;
                      double newPrice = double.tryParse(_editNewPriceController.text) ?? 0;
                      String rating = _editRatingController.text;

                      updateProductInFirestore(
                        product.category,
                        product.docId!, // Sử dụng docId để cập nhật
                        name,
                        description,
                        oldPrice,
                        newPrice,
                        rating,
                        _imagePath?.path ?? product.imagePath,
                        _imageDetailPath?.path ?? product.imageDetailPath,
                      );

                      Navigator.pop(context); // Đóng trang sau khi cập nhật
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: Row(
                      children: [
                        Icon(Icons.cloud, color: Colors.white),
                        SizedBox(width: 10),
                        Text('Cập nhật', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> updateProductInFirestore(
  String categoryCollection,
  String docId,
  String name,
  String description,
  double oldPrice,
  double newPrice,
  String rating,
  String imagePath,
  String imageDetailPath,
) async {
  try {
    await FirebaseFirestore.instance.collection(categoryCollection).doc(docId).update({
      'name': name,
      'description': description,
      'oldPrice': oldPrice,
      'newPrice': newPrice,
      'rating': rating,
      'imagePath': imagePath,
      'imageDetailPath': imageDetailPath,
    });
    print('Product updated in Firestore successfully');
    _showAlert('Thông báo', 'Cập nhật sản phẩm thành công.');
    setState(() {
      loadData();
    });
  } catch (e) {
    print('Error updating product in Firestore: $e');
    _showAlert('Thông báo', 'Cập nhật sản phẩm thất bại, vui lòng thử lại.');
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
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    productList = await getAllProducts();
    setState(() {});
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
                    'Sửa sản phẩm',
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
                          borderSide: BorderSide(color: Colors.white)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28.0),
                          borderSide: BorderSide(color: Colors.white))),
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
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 25.0),
            child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: productList.length,
              itemBuilder: (context, index) {
                Products product = productList[index];
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
                          productList[index].imagePath,
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
                              productList[index].name,
                              style: GoogleFonts.arsenal(
                                  fontSize: 18,
                                  color: blue,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              productList[index].newPrice.toStringAsFixed(3) +
                                  'đ',
                              style: GoogleFonts.roboto(
                                color: blue,
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
                            Icons.edit,
                            color: blue,
                          ),
                          onPressed: () {
                            _showUpdateProductForm(context, product);
                          },
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ),

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

  Widget buildTextFieldWithLabel(String label, TextEditingController controller,
      [TextInputType inputType = TextInputType.text]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 150,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(right: 10),
            child: Text(
              label,
              style: TextStyle(fontSize: 16),
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: inputType,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 10)),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildImagePicker() {
    return Column(
      children: [
        // Hình ảnh sản phẩm
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 150,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hình ảnh sản phẩm',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 35),
                  ElevatedButton(
                    onPressed: _pickImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: light_grey,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Chọn file',
                          style: TextStyle(color: black),
                        ),
                        Icon(
                          Icons.upload,
                          color: black,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: _imagePath != null
                        ? Image.file(
                            _imagePath!,
                            height: 100,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        // Hình ảnh chi tiết sản phẩm
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 150,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hình ảnh chi tiết sản phẩm',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 35),
                  ElevatedButton(
                    onPressed: _pickImageDetail,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: light_grey,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Chọn file',
                          style: TextStyle(color: black),
                        ),
                        Icon(
                          Icons.upload,
                          color: black,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: _imageDetailPath != null
                        ? Image.file(
                            _imageDetailPath!,
                            height: 100,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}