import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quan_ly_ban_ca_phe/themes/theme.dart';

class AddCategoryPage extends StatefulWidget {
  static const String routeName = '/add_category_page';
  const AddCategoryPage({Key? key}) : super(key: key);

  @override
  State<AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {

  TextEditingController _idController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  Future<void> addCategoryToFirestore(
    String id,
    String name,
    String description,
  ) async {
    // Kiểm tra xem có thông tin bắt buộc nào chưa được nhập không
  if (id.isEmpty ||
      name.isEmpty ||
      description.isEmpty) {
    _showAlert('Thông báo', 'Các field không được để trống, vui lòng thử lại.');
    return;
  }
    try {
      await FirebaseFirestore.instance.collection('Danh mục').add({
        'id': id,
        'name': name,
        'description': description,
      });
      print('Category added to Firestore successfully');
      _showAlert('Thông báo', 'Thêm Danh mục vào Firebase thành công.');
      // Reset text controllers
      _idController.clear();
      _nameController.clear();
      _descriptionController.clear();
    } catch (e) {
      print('Error adding Category to Firestore: $e');
      _showAlert('Thông báo', 'Thêm Danh mục thất bại, vui lòng thử lại.');
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
                'Thêm danh mục',
                style: GoogleFonts.arsenal(
                    fontSize: 30, fontWeight: FontWeight.bold, color: black),
              ),
            ),
            buildTextFieldWithLabel('ID danh mục', _idController),
            buildTextFieldWithLabel('Tên danh mục', _nameController),
            buildTextFieldWithLabel('Mô tả danh mục', _descriptionController),
            SizedBox(height: 20,),            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    String id = _idController.text;
                    String name = _nameController.text;
                    String description = _descriptionController.text;
                    await addCategoryToFirestore(
                      id,
                      name,
                      description
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: green),
                  child: Text(
                    'Thêm vào Firebase',
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
}