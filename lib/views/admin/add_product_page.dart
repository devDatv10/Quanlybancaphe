import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quan_ly_ban_ca_phe/themes/theme.dart';

class AddProductPage extends StatefulWidget {
  static const String routeName = '/add_product_page';
  const AddProductPage({Key? key}) : super(key: key);

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  String _selectedCategory = '';
  List<String> _categories = [];

  TextEditingController _idController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _oldPriceController = TextEditingController();
  TextEditingController _newPriceController = TextEditingController();
  TextEditingController _ratingController = TextEditingController();

  File? _imagePath;
  File? _imageDetailPath;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('Danh mục').get();
    List<String> categories =
        snapshot.docs.map((doc) => doc['name'].toString()).toList();
    setState(() {
      _categories = categories;
      _selectedCategory = categories.isNotEmpty ? categories[0] : '';
    });
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickImageDetail() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageDetailPath = File(pickedFile.path);
      });
    }
  }

  Future<String> uploadImage(File? imageFile) async {
    if (imageFile == null) return '';

    Completer<String> completer = Completer();
    await Future(() async {
      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          throw FirebaseAuthException(
            message: "User is not authenticated",
            code: "user-not-authenticated",
          );
        }

        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference ref =
            FirebaseStorage.instance.ref().child('images/$fileName.jpg');
        await ref.putFile(imageFile);
        String downloadURL = await ref.getDownloadURL();
        completer.complete(downloadURL);
      } catch (e) {
        print('Error uploading image: $e');
        completer.complete('');
      }
    });

    return completer.future;
  }

  Future<void> addProductToFirestore(
    String categoryCollection,
    String id,
    String name,
    String description,
    double oldPrice,
    double newPrice,
    String rating,
    String imagePath,
    String imageDetailPath,
  ) async {
    if (id.isEmpty ||
        name.isEmpty ||
        description.isEmpty ||
        oldPrice <= 0 ||
        newPrice <= 0 ||
        rating.isEmpty ||
        imagePath.isEmpty ||
        imageDetailPath.isEmpty) {
      _showAlert(
          'Thông báo', 'Các field không được để trống, vui lòng thử lại.');
      return;
    }
    try {
      await FirebaseFirestore.instance.collection(categoryCollection).add({
        'id': id,
        'category': categoryCollection,
        'name': name,
        'description': description,
        'oldPrice': oldPrice,
        'newPrice': newPrice,
        'rating': rating,
        'imagePath': imagePath,
        'imageDetailPath': imageDetailPath,
      });
      print('Product added to Firestore successfully');
      _showAlert('Thông báo', 'Thêm sản phẩm vào Firebase thành công.');
      _idController.clear();
      _nameController.clear();
      _descriptionController.clear();
      _oldPriceController.clear();
      _newPriceController.clear();
      _ratingController.clear();

      setState(() {
        _imagePath = null;
        _imageDetailPath = null;
      });
    } catch (e) {
      print('Error adding product to Firestore: $e');
      _showAlert('Thông báo', 'Thêm sản phẩm thất bại, vui lòng thử lại.');
    }
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                'Thêm sản phẩm',
                style: GoogleFonts.arsenal(
                    fontSize: 30, fontWeight: FontWeight.bold, color: black),
              ),
            ),
            buildTextFieldWithLabel('ID sản phẩm', _idController),
            buildTextFieldWithLabel('Tên sản phẩm', _nameController),
            buildCategoryDropdown(),
            buildTextFieldWithLabel('Mô tả sản phẩm', _descriptionController),
            buildTextFieldWithLabel(
                'Giá cũ', _oldPriceController, TextInputType.number),
            buildTextFieldWithLabel(
                'Giá mới', _newPriceController, TextInputType.number),
            buildTextFieldWithLabel('Xếp hạng', _ratingController),
            SizedBox(height: 10),
            buildImagePicker(),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    String id = _idController.text;
                    String name = _nameController.text;
                    String categoryCollection = _selectedCategory;
                    String description = _descriptionController.text;
                    double oldPrice =
                        double.tryParse(_oldPriceController.text) ?? 0;
                    double newPrice =
                        double.tryParse(_newPriceController.text) ?? 0;
                    String rating = _ratingController.text;

                    String imagePath = await uploadImage(_imagePath);
                    String imageDetailPath =
                        await uploadImage(_imageDetailPath);

                    await addProductToFirestore(
                      categoryCollection,
                      id,
                      name,
                      description,
                      oldPrice,
                      newPrice,
                      rating,
                      imagePath,
                      imageDetailPath,
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: green),
                  child: Text(
                    'Thêm sản phẩm',
                    style: TextStyle(color: white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCategoryDropdown() {
    return Container(
      color: background,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 150,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(right: 10),
            child: Text(
              'Chọn danh mục :',
              style: TextStyle(fontSize: 16),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: DropdownButton<String>(
                value: _selectedCategory,
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Tooltip(
                      message: category,
                      child: Container(
                        width: 120,
                        child: Text(
                          category,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _selectedCategory = value ?? '';
                  });
                },
              ),
            ),
          ),
        ],
      ),
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
                          'Tải ảnh',
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
                          'Tải ảnh',
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
