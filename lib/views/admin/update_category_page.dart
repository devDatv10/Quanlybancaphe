import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quan_ly_ban_ca_phe/models/categories.dart';
import 'package:quan_ly_ban_ca_phe/themes/theme.dart';
import 'package:quan_ly_ban_ca_phe/widgets/my_button.dart';

class UpdateCategoryPage extends StatefulWidget {
  static const String routeName = '/update_category_page';
  const UpdateCategoryPage({super.key});

  @override
  State<UpdateCategoryPage> createState() => _UpdateCategoryPageState();
}

class _UpdateCategoryPageState extends State<UpdateCategoryPage> {
  final _textSearchCategoryController = TextEditingController();

  TextEditingController _editIdController = TextEditingController();
  TextEditingController _editNameController = TextEditingController();
  TextEditingController _editDescriptionController = TextEditingController();

  List<Categories> categoryList = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Danh mục').get();

      setState(() {
        categoryList = querySnapshot.docs
            .map((doc) => Categories.fromDocument(doc))
            .toList();
      });
    } catch (e) {
      print('Error getting categories: $e');
    }
  }

  void _showUpdateCategoryForm(BuildContext context, Categories category) {
    _editIdController.text = category.id;
    _editNameController.text = category.name;
    _editDescriptionController.text = category.description;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          height: 400,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(
                left: 18.0, top: 30.0, right: 18.0, bottom: 18.0),
            child: Column(
              children: [
                Text(
                  'Cập nhật danh mục',
                  style: GoogleFonts.arsenal(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                buildTextFieldWithLabel('ID danh mục', _editIdController),
                buildTextFieldWithLabel('Tên danh mục', _editNameController),
                buildTextFieldWithLabel(
                    'Mô tả danh mục', _editDescriptionController),
                SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        String id = _editIdController.text;
                        String name = _editNameController.text;
                        String description = _editDescriptionController.text;

                        updateCategoryInFirestore(
                          category.docId!, // Sử dụng docId để cập nhật
                          name,
                          description,
                        );

                        Navigator.pop(context); // Đóng trang sau khi cập nhật
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      child: Row(
                        children: [
                          Icon(Icons.cloud, color: Colors.white),
                          SizedBox(width: 10),
                          Text('Cập nhật',
                              style: TextStyle(color: Colors.white)),
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

  Future<void> updateCategoryInFirestore(
      String docId, String name, String description) async {
    try {
      await FirebaseFirestore.instance
          .collection('Danh mục')
          .doc(docId)
          .update({
        'name': name,
        'description': description,
      });
      print('Category updated in Firestore successfully');
      _showAlert('Thông báo', 'Cập nhật danh mục thành công.');
      setState(() {
        loadData();
      });
    } catch (e) {
      print('Error updating category in Firestore: $e');
      _showAlert('Thông báo', 'Cập nhật danh mục thất bại, vui lòng thử lại.');
    }
  }

  void _showAlert(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: GoogleFonts.roboto(color: Colors.blue),
          ),
          content: Text(content),
          actions: [
            TextButton(
              child: Text("OK", style: TextStyle(color: Colors.blue)),
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
    return Column(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sửa danh mục',
                  style: GoogleFonts.arsenal(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _textSearchCategoryController,
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm danh mục',
                    contentPadding: EdgeInsets.symmetric(),
                    alignLabelWithHint: true,
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(
                      Icons.search,
                      size: 20,
                    ),
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
                              _textSearchCategoryController.clear();
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
                Text(
                  'Danh sách danh mục',
                  style: GoogleFonts.arsenal(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
                left: 18.0, right: 18.0, bottom: 25.0),
            child: ListView.builder(
              itemCount: categoryList.length,
              itemBuilder: (context, index) {
                Categories category = categoryList[index];
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category.name,
                              style: GoogleFonts.arsenal(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              category.description,
                              style: GoogleFonts.roboto(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            _showUpdateCategoryForm(context, category);
                          },
                        ),
                      ),
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
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0)),
            ),
          ),
        ],
      ),
    );
  }
}
